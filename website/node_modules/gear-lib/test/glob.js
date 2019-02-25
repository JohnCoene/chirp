var should = require('should'),
    Queue = require('gear').Queue,
    Registry = require('gear').Registry,
    glob = require('..').glob,
    fixtures = {
        options: {pattern: 'ind*.js'},
        expected: 'index.js'
    };

describe('glob()', function() {
    it('should glob files', function(done) {
        glob(fixtures.options, [], function(err, results) {
            results[0].name.should.equal(fixtures.expected);
            done(err);
        });
    });
    
    it('should add Blobs to queue', function(done) {
        new Queue({registry: new Registry({tasks: {glob: glob}})})
            .glob(fixtures.options)
            .run(function(err, results) {
                results[0].name.should.equal(fixtures.expected);
                done();
            });
    });
    
    it('should support the `cwd` option', function(done) {
        glob({ pattern : '**/*.js', options : { cwd : './test/fixtures' } }, [], function(err, results) {
            results[0].name.should.match(/test1.js$/);
            done(err);
        });
    });
});
