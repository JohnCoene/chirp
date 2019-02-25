var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    should = require('should'),
    path = require('path'),
    gear = require('..'),
    fixtures = {
        file: {name: 'test/fixtures/test1.js'},
        files: [{name: 'test/fixtures/test1.js'}, {name: 'test/fixtures/test2.js'}],
        missing_file: {name: 'test/fixtures/missing_file.js'},
        sentinel: 'ABOOORT',
        missing_module: '!@&#*^&@'
    };

describe('Queue', function() {
    describe('run()', function() {
        it('should handle append tasks', function(done) {
            new gear.Queue()
                .read(fixtures.files)
                .read(fixtures.file)
                .run(function(err, results) {
                    results.should.have.length(3);
                    done(err);
                });
        });

        it('should handle tasks called with array options', function(done) {
            new gear.Queue()
                .read(fixtures.files)
                .concat()
                .run(function(err, results) {
                    done(err);
                });
        });

        it('should execute chained tasks', function(done) {
            new gear.Queue()
                .read(fixtures.file)
                .concat()
                .run(function(err, results) {
                    done(err);
                });
        });

        it('should handle errors', function(done) {
            new gear.Queue()
                .read(fixtures.missing_file)
                .concat()
                .run(function(err, results) {
                    should.exist(err);
                    done();
                });
        });

        it('should be able to abort', function(done) {
            new gear.Queue()
                .read(fixtures.files)
                .test({callback: function(blob) {
                    return fixtures.sentinel;
                }})
                .concat()
                .run(function(err, results) {
                    err.error.should.equal(fixtures.sentinel);
                    done();
                });
        });

        it('should allow registry objects to be passed', function(done) {
            var tasks = {
                registryTest: function(options, blob, done) {
                    done(null, blob);
                }
            };

            new gear.Queue({registry: new gear.Registry({tasks: tasks})})
                .read(fixtures.files)
                .registryTest()
                .run(function(err, results) {
                    done(err);
                });
        });

        it('should allow registry strings to be passed', function(done) {
            new gear.Queue({registry: 'gear-lib'})
                .read(fixtures.files)
                .jslint()
                .run(function(err, results) {
                    done(err);
                });
        });

        it('should allow registry strings to be passed', function(done) {
            new gear.Queue({registry: 'gear-lib'})
                .read(fixtures.files)
                .jslint()
                .run(function(err, results) {
                    done(err);
                });
        });

        it('should throw an exception for registry error', function(done) {
            try {
                new gear.Queue({registry: fixtures.missing_module})
                    .read(fixtures.files)
                    .jslint()
                    .run(function(err, results) {});
            } catch(err) {
                err.message.should.equal('Module ' + fixtures.missing_module + ' doesn\'t exist');
                done();
            }
        });

        it('should allow queues to be run in sequence', function(done) {
            var q1 = new gear.Queue()
                        .append('hello')
                        .append('world!');
            var q2 = new gear.Queue()
                        .append('HELLO')
                        .append('WORLD!');
            new gear.Queue()
                .series(q1, q2)
                .run(function(err, results) {
                    results.should.have.length(4);
                    results[0].result.should.equal('hello');
                    results[1].result.should.equal('world!');
                    results[2].result.should.equal('HELLO');
                    results[3].result.should.equal('WORLD!');
                    done(err);
                });
        });

    });

    describe('run', function() {
        it('should run empty queues', function(done) {
            new gear.Queue()
                .run(function(err, results) {
                    done(err);
                });
        });
    });

    // it('should execute task callback');
});