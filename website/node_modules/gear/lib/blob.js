/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */

/*
 * Blob - Immutable data object. Contains a property bag as well as a private result property.
 * Any properties in the property bag are merged, while result is concatenated. Result can be
 * Buffer or String. Immutability is necessary due to Blobs being able to be parallel
 * processed.
 *
 * Loosely based on W3C Blob:
 * http://www.w3.org/TR/FileAPI/#dfn-Blob
 * https://developer.mozilla.org/en/DOM/Blob
 *
 * @param parts {Buffer|String|Blob|Array} Create new Blob from Buffer/String/Blob or Array of Buffer/String/Blob.
 */

var Blob = exports.Blob = function Blob(parts, properties) {
    parts = typeof parts === 'undefined' ? [] : Array.prototype.concat(parts);
    properties = properties || {};

    function mergeProps(object, props) {
        Object.keys(props).forEach(function(prop) {
            object[prop] = props[prop];
        });
    }

    var result = parts.length ? parts.shift() : '',
        props = {},
        self = this;

    if (result instanceof Blob) {
        mergeProps(props, result);
        result = result.result;
    }

    parts.forEach(function(part) {
        if (part instanceof Blob) {
            mergeProps(props, part);
            result += part.result;
        } else {
            result += part;
        }
    });

    mergeProps(props, properties);

    // Define immutable properties
    Object.keys(props).forEach(function(prop) {
        if (prop !== 'result') {
            Object.defineProperty(self, prop, {enumerable: true, value: props[prop]});
        }
    });
    Object.defineProperty(this, 'result', {value: result});
    // v8 performance of seal is not good :(
    // http://jsperf.com/freeze-vs-seal-vs-normal/3
    // Object.seal(this);
};

Blob.prototype.toString = function() {
    return this.result;
};

var readFile = {
    server: function(name, encoding, callback, sync) {
        var fs = require('fs');

        if (sync) {
            readFile.serverSync(name, encoding, callback);
        } else {
            fs.readFile(name, encoding === 'bin' ? undefined : encoding, function(err, data) {
                if (err) {
                    callback(err);
                } else {
                    callback(null, new Blob(data, {name: name}));
                }
            });
        }
    },

    // readFileSync added due to some strange async behavior with readFile
    serverSync: function(name, encoding, callback) {
        var fs = require('fs'),
            data;

        try {
            data = fs.readFileSync(name, encoding === 'bin' ? undefined : encoding);
            callback(null, new Blob(data, {name: name}));
        } catch(e) {
            callback(e);
        }
    },

    client: function(name, encoding, callback) {
        if (name in localStorage) {
            callback(null, new Blob(localStorage[name], {name: name}));
        } else {
            callback('localStorage has no item ' + name);
        }
    }
};

Blob.readFile = Blob.prototype.readFile = process.browser ? readFile.client : readFile.server;

var writeFile = {
    server: function(name, blob, encoding, callback) {
        var fs = require('fs'),
            path = require('path'),
            nodeExists = fs.exists || path.exists,
            mkdirp = require('mkdirp').mkdirp,
            Crypto = require('crypto');

        function writeFile(filename, b) {
            fs.writeFile(filename, b.result, encoding === 'bin' ? undefined : encoding, function(err) {
                callback(err, new Blob(b, {name: filename}));
            });
        }

        var dirname = path.resolve(path.dirname(name)),
            checksum;

        if (name.indexOf('{checksum}') > -1) {  // Replace {checksum} with md5 string
            checksum = Crypto.createHash('md5');
            checksum.update(blob.result);
            name = name.replace('{checksum}', checksum.digest('hex'));
        }

        nodeExists(dirname, function(exists) {
            if (!exists) {
                mkdirp(dirname, '0755', function(err) {
                    if (err) {
                        callback(err);
                    } else {
                        writeFile(name, blob);
                    }
                });
            }
            else {
                writeFile(name, blob);
            }
        });
    },

    client: function(name, blob, encoding, callback) {
        localStorage[name] = blob.result;
        callback(null, new blob.constructor(blob, {name: name}));
    }
};

Blob.writeFile = Blob.prototype.writeFile = process.browser ? writeFile.client : writeFile.server;
