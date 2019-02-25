/*
 * Copyright (c) 2011-2014, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var path = require('path');

/**
 * Move one or more files to a destination.
 *
 * @param options {Object} Dest options or file destination.
 * @param options.dir {String} File destination.
 * @param options.base {String} Base path for incoming files.
 * @param options.encoding {String} File encoding.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.dest = function(options, blob, done) {
    options = (typeof options === 'string') ? {dir: options} : options;

    var basename = options.base ? path.relative(options.base, blob.name)
                                : path.basename(blob.name),
        output   = path.join(options.dir, basename),
        encoding = options.encoding || 'utf8';

    blob.writeFile(output, blob, encoding, done);
};
