var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    should = require('should'),
    path = require('path'),
    gear = require('..'),
    tasks = require(lib + 'tasks/tasks').tasks,
    fixtures = {
        files: [{name: 'test/fixtures/test1.js'}],
        missing_files: [{name: 'test/fixtures/missing_file.js'}],
        parallel_files: [{name: 'test/fixtures/test2.js'}]
    };

describe('Queue()', function() {
    it('should wrap task correctly', function() {
        new gear.Queue().tasks({
            read_files:       {task: ['read', fixtures.files]},
            concat_files:     {requires: 'read_files', task: 'concat'},
            read_files2:      {task: ['read', fixtures.parallel_files]},
            done:  {requires: ['read_files2', 'concat_files']}
        }).run();
    });
});

describe('tasks()', function() {
    it('should handle err', function(done) {
        var queue = new gear.Queue();

        tasks.call(queue, {
            read_files:      {task: ['read', fixtures.missing_files]}
        }, [], function(err, results) {
            should.exist(err);
            done();
        });
    });

    it('should execute complex tasks', function(done) {
        var queue = new gear.Queue();

        tasks.call(queue, {
            read_files:       {task: ['read', fixtures.files]},
            concat_files:     {requires: 'read_files', task: 'concat'},
            read_files2:      {task: ['read', fixtures.parallel_files]},
            inspect_1_and_2:  {requires: ['concat_files', 'read_files2']}
        }, [], function(err, results) {
            done(err);
        });
    });

    it('should handle empty object', function() {
        new gear.Queue().tasks({}).run();
    });
});