/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var linter = require('csslint').CSSLint;

/**
 * Lint CSS.
 *
 * @param options {Object} Task options.
 * @param options.config {Object} CSSLint options.
 * @param options.callback {Function} Callback on lint status.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.csslint = function(options, blob, done) {
    options = options || {};

    var result = linter.verify(blob.result, options.config || null), // Cast buffer to string
        linted = result.messages.length ? new blob.constructor(blob, {csslint: result.messages}) : blob;

    done(options.callback ? options.callback(linted) : null, linted);
};
