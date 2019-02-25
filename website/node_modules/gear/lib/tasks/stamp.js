/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
/**
 * Stamp blob with prefix or postfix string.
 *
 * @param options {Object} Task options.
 * @param options.prefix {String} Prefix string.
 * @param options.postfix {String} Postfix string.
 * @param options.callback {Function} Callback can return text to injext between pre/postfix.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.stamp = function(options, blob, done) {
    options = options || {};
    options.prefix = options.prefix || '';
    options.postfix = options.postfix || '';

    var result = options.callback ? options.callback(blob) : blob.result,
        stamped = options.prefix + result + options.postfix;

    done(null, new blob.constructor(stamped, blob));
};