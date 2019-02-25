/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var fs = require('fs'),
    path = __dirname + (process.env.GEARLIB_COVER ? '/lib-cov/' : '/lib/'),
    tasks = fs.readdirSync(path).filter(function(file) {return file.substr(-3) === '.js';});

tasks.forEach(function(task) {
    var mod = require(path + task),
        name;

    for (name in mod) {
        exports[name] = mod[name];
    }
});
