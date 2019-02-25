/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */

/**
 * Write the blob to disk with an optional checksum in the filename.
 *
 * @param options {Object} Write options or filename.
 * @param options.file {String} Filename to write.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
var write = exports.write = function write(options, blob, done) {
    options = (typeof options === 'string') ? {name: options} : options;
    var encoding = options.encoding || 'utf8';
    blob.writeFile(options.name, blob, encoding, done);
};
write.type = 'slice';