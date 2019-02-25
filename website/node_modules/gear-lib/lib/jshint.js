/*jslint unparam: true, regexp: true */
/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */

var JSHINT = require("jshint").JSHINT;
var fs = require('fs');

/**
 * JSHint
 *
 * @param options {Object} Task options.
 * @param options.configFile {String} Path to a JSHint options file (typically '.jshintrc')
 * @param options.config {Object} JSHint options.
 * @param options.callback {Function} Callback on lint status. Callback can return non-null to end queue.
 * @param blob {Object} Incoming blob.
 * @param done {Function} Callback on task completion.
 */
exports.jshint = function (options, blob, done) {

	function lint() {
		JSHINT(blob.result, options.config || {});
		if(JSHINT.errors.length) {
			var linted = new blob.constructor(blob, {jshint: JSHINT.errors});
			var errors = JSHINT.errors.map(function(err) {
				return 'Line ' + err.line + ' char ' + err.character + ': ' + err.reason + '\n    ' + err.evidence + '\n';
			});
			done(options.callback ? options.callback(JSHINT.errors) : errors, linted);
		}
		else {
			done(null, blob);
		}
	}

	options = options || {};

	if(options.configFile) {
		fs.readFile(options.configFile, function(err, result) {
			var json = String(result)
						.replace(/\/\/.*/g, '')
						.replace(/\/\*[\d\D]*?\*\//g, '');
			options.config = JSON.parse(json);
			lint();
		});
	}
	else {
		lint();
	}
};
