/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var Blob = require('gear').Blob,
    Glob = require('glob'),
    async = require('async'),
    path  = require('path');

/**
 * Glob files. See https://github.com/isaacs/node-glob
 *
 * @param options {Object} Options object.
 * @param options.pattern {Object} Glob pattern.
 * @param options.limit {Number} Concurrency limit.
 * @param options.options {Object} Glob options.
 * @param done {Function} Callback on task completion.
 */
var glob = exports.glob = function(options, blobs, done) {
    options = options || {};
    var pattern = options.pattern,
        globoptions = options.options || {},
        encoding = options.encoding || 'utf8';

    Glob(pattern, globoptions, function(err, matches) {
        if (err) {
            done(err);
            return;
        }

        function onMatch(match, matchcb) {
            var filename = globoptions.cwd ? path.join(globoptions.cwd, match) : match;
            Blob.readFile(filename, encoding, matchcb);
        }

        function onFinish(err, results) {
            done(err, blobs.concat(results));
        }

        if (options.limit) {
            async.mapLimit(matches, options.limit, onMatch, onFinish);
        } else {
            async.map(matches, onMatch, onFinish);
        }
    });
};

glob.type = 'collect';
