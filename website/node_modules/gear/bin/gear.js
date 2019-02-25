#!/usr/bin/env node
'use strict';

/* Gear task runner. Executes Gearfile using a tasks workflow.
 * See http://gearjs.org/#tasks.tasks
 *
 * Usage:
 * > gear [options]
 *
 * Available options:
 * --cwd <dir>        change working directory
 * --Gearfile <path>  execute a specific gearfile
 */
var Liftoff = require('liftoff'),
    vm = require('vm'),
    path = require('path'),
    fs = require('fs'),
    filename = 'Gearfile',
    existsSync = fs.existsSync,
    argv = require('minimist')(process.argv.slice(2));

var GearCLI = new Liftoff({
    name: 'Gear',
    configName: filename,
    extensions: {
        '': null,
        '.js': null
    }
});

function stripStartingComments(s) {
    var s2;
    while (s2 !== s) {
        s2 = s;
        s = s2.replace(/^(\s+|\/\/.*|\/\*[^]*?\*\/)/, '');
    }
    return s;
}

GearCLI.launch({
        cwd: argv.cwd,
        configPath: argv.Gearfile
    }, function(env) {
    // Loads a local install of gear. Falls back to the global install.
    var gear = require(env.modulePath || '../index');
    if(process.cwd() !== env.configBase) {
        process.chdir(env.configBase);
    }

    if (argv.v || argv.version) {
        var pkg = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../package.json')) + '');
        console.log('gear version ' + pkg.version);
    }

    if (!env.configPath) {
        notify(filename + ' not found');
        process.exit(1);
    }

    var tasks;
    var gearfile = fs.readFileSync(env.configPath) + '';

    try {
        // workaround for a bug which makes runInNewContext unable to evaluate an object literal.
        var script = (stripStartingComments(gearfile).charAt(0) === '{') ?
            '(' + gearfile + ')' :
            gearfile;
        tasks = vm.runInNewContext(script, {
            require: require,
            process: process,
            console: console,
            gear: gear
        }, env.configPath, true);
    } catch(e) {
        notify(e);
        process.exit(1);
    }

    if (tasks) {
        new gear.Queue({registry: new gear.Registry({module: 'gear-lib'})})
            .tasks(tasks)
            .run(function(err, res) {
                if (err) {
                    notify(err);
                }
            });
    }
});

function notify(msg) {
    console.error('gear: ', msg);
}
