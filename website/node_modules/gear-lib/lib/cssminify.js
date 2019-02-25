/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var less = require('less'),
    dirname = typeof module === 'undefined' ? function(s) {return s;} : require('path').dirname; // Browser compat

/**
 * Minify CSS. Also compiles LESS stylesheets.
 *
 * @param options {Object} Ignored.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.cssminify = exports.less = function(options, blob, done) {
    options = options || {};

    var parser = new less.Parser({paths: [dirname(blob.name)]});

    // Need to make sure to compress since we pass options directly through to Less
    if (options.compress === undefined && options.yuicompress === undefined) {
        options.compress = true;
    }

    parser.parse(blob.result, function(err, tree) {
        if (err) {
            done(err);
        } else {
            try {
                done(null, new blob.constructor(tree.toCSS(options), blob));
            } catch (exc) {
                done(exc);
            }
        }
    });
};
