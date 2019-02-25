/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var knox = require('knox'),
    mime = require('mime');

/**
 * Send blob to S3.
 *
 * @param options {Object} S3 task options.
 * @param options.name {String} Resource name.
 * @param options.client {Object} S3 client (key, secret, bucket).
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
var s3 = exports.s3 = function s3(options, blob, done) {
    var self = this,
        name = options.name,
        result,
        client,
        req;

    result = blob.result;
    client = knox.createClient(options.client);

    req = client.put(name, {'Content-Length': result.length, 'Content-Type': mime.lookup(name)});

    req.on('response', function (res) {
        if (res.statusCode === 200) {
            done(null, new blob.constructor(result, {name: name, url: req.url}));
        } else {
            done('Failed to write to S3');
        }
    });
    
    req.end(result);
};
s3.type = 'slice';