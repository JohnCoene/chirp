/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var Blob = require('../blob').Blob;

function readfn() {
    return function(options, done) {
        options = (typeof options === 'string') ? {name: options} : options;
        var encoding = options.encoding || 'utf8';
        Blob.readFile(options.name, encoding, done, options.sync);
    };
}

/**
 * Appends file contents onto queue.
 *
 * @param options {Object} File options or filename.
 * @param options.name {String} Filename to read.
 * @param options.encoding {String} File encoding.
 * @param done {Function} Callback on task completion.
 */
exports.read = readfn();

/**
 * Prepends file contents to the queue.
 *
 * @param options {Object} File options or filename.
 * @param options.name {String} Filename to read.
 * @param options.encoding {String} File encoding.
 * @param done {Function} Callback on task completion.
 */
var readBefore = exports.readBefore = readfn();
readBefore.type = 'prepend';