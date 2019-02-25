var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    should = require('should'),
    read = require(lib + 'tasks/read').read,
    fixtures = {
        filename: 'test/fixtures/test1.js',
        file: {name: 'test/fixtures/test1.js'},
        missing_file: {name: 'test/fixtures/missing_file.js'}
    };

describe('read()', function() {
    it('should handle filenames instead of objects', function(done) {
        read(fixtures.filename, function(err, blob) {
            done(err);
        });
    });

    it('should read files', function(done) {
        read(fixtures.file, function(err, blob) {
            done(err);
        });
    });

    it('should handle missing files', function(done) {
        read(fixtures.missing_file, function(err, blob) {
            should.exist(err);
            done();
        });
    });
});