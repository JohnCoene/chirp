/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var UglifyJS = require('uglify-js');

/**
 * Minify JS.
 *
 * @param options {Object} Task options.
 * @param options.config {Object} Minify options.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.jsminify = function (options, blob, done) {
    options = options || {};

    var config = options.config || {},
        source = blob.result;
    
    config.fromString = true;

    if (config.output === undefined) {
        config.output = {};
    }

    // We need to preserve license comments which is still not crystal-clear in uglify-js doc:
    // https://github.com/mishoo/UglifyJS2/issues/82
    if (config.output.comments === undefined) {
        config.output.comments = /@license|@preserve|@cc_on|^!\n/i;
    }

    try {
        source = UglifyJS.minify(source, config).code;
        done(null, new blob.constructor(source, blob));

    } catch (e) {
        if (options.callback) {
            options.callback(e);
        }

        done('Minify failed, ' + (blob.name || 'file') + ' unparseable.\nException:\n' + JSON.stringify(e));
    }
};
