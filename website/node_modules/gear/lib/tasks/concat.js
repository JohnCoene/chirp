/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */

/**
 * Concatenates blobs.
 *
 * @param options {Object} Concat options.
 * @param options.callback {Function} Callback on each blob.
 * @param blobs {Array} Incoming blobs.
 * @param done {Function} Callback on task completion.
 */
exports.concat = function(options, prev, blob, done) {
    options = options || {};
    done(null, new blob.constructor([prev, options.callback ? options.callback(blob) : blob]));
};