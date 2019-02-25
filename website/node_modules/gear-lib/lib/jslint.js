/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var linter = require('jslint/lib/linter');

/**
 * Lint JS.
 *
 * @param options {Object} Task options.
 * @param options.config {Object} JSLint options.
 * @param options.callback {Function} Callback on lint status. Callback can return non-null to end queue.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.jslint = function (options, blob, done) {
    options = options || {};

    var result = linter.lint(blob.result, options.config || {}),
        linted = result.errors ? new blob.constructor(blob, {jslint: result.errors}) : blob;

    done(options.callback ? options.callback(linted) : null, linted);
};
