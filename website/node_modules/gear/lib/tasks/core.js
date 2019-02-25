/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */

var Blob = require('../blob').Blob;

function loadfn() {
    return function(string, done) {
        done(null, new Blob(string));
    };
}

/**
 * Append a blob string.
 *
 * @param index {Integer} Index of blobs.
 * @param blobs {Array} Incoming blobs.
 * @param done {Function} Callback on task completion.
 */
exports.append = exports.load = loadfn();

/**
 * Prepend a blob string before all other blobs.
 *
 * @param string {String} the string to prepend.
 * @param done {Function} Callback on task completion.
 */
var prepend = exports.prepend = loadfn();
prepend.type = 'prepend';

/**
 * Test Blobs, abort if callback returns non-null.
 *
 * @param options {Object} Options for task.
 * @param options.callback {Function} Callback for testing blob
 * @param blob {Object} Current blob.
 * @param done {Function} Callback on task completion.
 */
var test = exports.test = function(options, blob, done) {
    options = options || {};
    done(options.callback ? options.callback(blob) : null);
};
test.type = 'each';

/**
 * Gets a blob.
 *
 * @param index {Integer} Index of blobs.
 * @param blobs {Array} Incoming blobs.
 * @param done {Function} Callback on task completion.
 */
var get = exports.get = function get(index, blobs, done) {
    done(null, blobs.slice(index, index + 1));
};
get.type = 'collect';

/**
 * Log a string.
 *
 * @param string {String} String to log.
 * @param blob {Array} Incoming blobs.
 * @param done {Function} Callback on task completion.
 */
var log = exports.log = function log(string, blobs, done) {
    this._log(string);
    done(null, blobs);
};
log.type = 'collect';

/**
 * Inspects blobs.
 *
 * @param options {Object} Ignored.
 * @param blob {Object} Incoming blobs.
 * @param done {Function} Callback on task completion.
 */
var inspect = exports.inspect = function inspect(options, blobs, done) {
    var self = this;

    blobs.forEach(function(blob, index) {
        var obj = {result: blob.result};
        Object.keys(blob).forEach(function(attr) {obj[attr] = blob[attr];});
        self._log('blob ' + (index + 1) + ': ' + JSON.stringify(obj, null, ' '));
    });

    done(null, blobs);
};
inspect.type = 'collect';

/**
 * Do nothing.
 *
 * @param dummy {N/A} N/A.
 * @param blob {Array} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.noop = function(dummy, blob, done) {
    done(null, blob);
};
