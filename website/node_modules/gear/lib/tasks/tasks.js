/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var async = require('async');

/**
 * Advanced flow execution.
 *
 * @param workflow {Object} Object of tasks to run.
 * @param blobs {Object} Incoming blobs.
 * @param done {Function} Callback on task completion.
 */
var tasks = exports.tasks = function tasks(workflow, blobs, done) {
    var item,
        task,
        name,
        requires,
        fn,
        auto = {},
        self = this;

    function runTask(name, options, requires) {
        return function(callback, result) {
            var new_blobs = requires.length ? [] : blobs;
            result = result || [];

            // Concat dependency blobs in order of requires array
            requires.forEach(function(item) {
                new_blobs = new_blobs.concat(result[item]);
            });

            self._dispatch(name, options, new_blobs, callback);
        };
    }

    for (item in workflow) {
        task = workflow[item].task;

        if (task === undefined) {
            task = ['noop'];
        } else {
            if (!Array.isArray(task)) {
                task = [task];
            }
        }

        requires = workflow[item].requires;

        if (requires === undefined) {
            requires = [];
        } else {
            if (!Array.isArray(requires)) {
                requires = [requires];
            }
        }

        fn = runTask(task[0], task[1], requires);
        auto[item] = requires ? requires.concat(fn) : fn;
    }
    
    async.auto(auto, function(err, results) {
        if (err) {
            done(err);
            return;
        }
        
        done(err, (results && results.join) ? results.join : []);
    });
};
tasks.type = 'collect';