/*
 * Copyright (c) 2011-2012, Yahoo! Inc.  All rights reserved.
 * Copyrights licensed under the New BSD License.
 * See the accompanying LICENSE file for terms.
 */
var async = require('async'),
    Registry = require('./registry').Registry,
    Blob = require('./blob').Blob;

// Zip two arrays together a la Python
function zip(arr1, arr2) {
    var zipped = [];
    for (var i = 0; i < Math.min(arr1.length, arr2.length); i++) {
        zipped.push([arr1[i], arr2[i]]);
    }
    return zipped;
}

function arrayize(arr) {
    return typeof arr === 'undefined' ? [] : Array.prototype.concat(arr);
}

/*
 * Queue - Perform async operations on array of immutable Blobs.
 */
var Queue = exports.Queue = function Queue(options) {
    var self = this;
    options = options || {};
    this._logger = options.logger || console;

    if (typeof options.registry === 'string') {
        this._registry = new Registry({module: options.registry});
    } else {
        this._registry = options.registry || new Registry();
    }

    this._clear();

    // Add registry tasks
    this._registry.tasks.forEach(function(name) {
        self[name] = self.task.bind(self, name);
    });
};

Queue.prototype._clear = function() {
    this._queue = [
        function(callback) {
            callback(null, []);
        }
    ];
};

Queue.prototype._log = function(message) {
    this._logger.log(message);
};

function asTask(queue) {
    return function(result, callback) {
        queue._queue[0]= function(done) {
            done(null, result);
        };
        queue.run(callback);
    };
}

Queue.prototype._dispatch = function(name, options, blobs, done) {
    if (name instanceof Queue) {
        return asTask(name)(blobs, done);
    }

    var task = this._registry.task(name),
        types = { // Allow task type to be inferred based on task params
            2: 'append',
            3: 'map',
            4: 'reduce'
        },
        type = task.type ? task.type : types[task.length];

    // Wrap error with task name and possibly other diagnostics
    function doneWrap(err, res) {
        if (err) {
            err = {task: name, error: err};
        }
        done(err, res);
    }

    switch (type) {
        case 'append': // Concats new blobs to existing queue
            async.map(arrayize(options), task.bind(this), function(err, results) {
                doneWrap(err, blobs.concat(results));
            });
            break;

        case 'prepend': // Prepends new blobs to existing queue
            async.map(arrayize(options), task.bind(this), function(err, results) {
                doneWrap(err, results.concat(blobs));
            });
            break;

        case 'collect': // Task can inspect entire queue
            task.call(this, options, blobs, doneWrap);
            break;

        case 'slice': // Slice options.length blobs from queue
            async.map(zip(arrayize(options), blobs), (function(arr, cb) {
                task.call(this, arr[0], arr[1], cb);
            }).bind(this), doneWrap);
            break;

        case 'each': // Allow task to abort immediately
            async.forEach(blobs, task.bind(this, options), function(err) {
                doneWrap(err, blobs);
            });
            break;

        case 'map': // Task transforms one blob at a time
            async.map(blobs, task.bind(this, options), doneWrap);
            break;

        case 'syncmap': // Task transforms one blob at a time until done is called.
            async.mapSeries(blobs, task.bind(this, options), doneWrap);
            break;

        case 'reduce': // Merges blobs from left to right
            async.reduce(blobs, new Blob(), task.bind(this, options), function(err, results) {
                doneWrap(err, [results]);
            });
            break;

        default:
            throw new Error('Task "' + name + '" has unknown type. Add a type property to the task function.');
    }
};

Queue.prototype.task = function(name, options) {
    this._queue.push(this._dispatch.bind(this, name, options));
    return this;
};

Queue.prototype.series = function(sequence) {
    if (sequence instanceof Queue) {
        sequence = [].slice.call(arguments);
    }
    this._queue = this._queue.concat(sequence.map(asTask));
    return this;
};

Queue.prototype.run = function(callback) {
    var self = this;
    async.waterfall(this._queue, callback || function(err, res) {if (err) {self._log(err);}});
};
