var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    fs = require('fs'),
    path = require('path'),
    nodeExistsSync = fs.existsSync || path.existsSync,
    Blob = require(lib + 'blob').Blob,
    write = require(lib + 'tasks/write').write,
    fixtures = {
        filename: 'testing/write.txt',
        filename2: 'testing/write2.txt',
        checksum: 'testing/write_{checksum}.txt',
        checksum_replaced: 'testing/write_900150983cd24fb0d6963f7d28e17f72.txt',
        blob: new Blob('abc')
    };

function remove(filename) {
    if (nodeExistsSync(filename)) {
        fs.unlinkSync(filename);
    }
}

describe('write()', function() {
    it('should write file', function(done) {
        remove(fixtures.filename);
        write(fixtures.filename, fixtures.blob, function(err, blob) {
            nodeExistsSync(fixtures.filename).should.equal(true);
            done(err);
        });
    });

    it('should write file with options', function(done) {
        remove(fixtures.filename);
        write({name: fixtures.filename2}, fixtures.blob, function(err, blob) {
            nodeExistsSync(fixtures.filename2).should.equal(true);
            done(err);
        });
    });

    it('should replace {checksum} in filename', function(done) {
        remove(fixtures.checksum_replaced);
        write({name: fixtures.checksum}, fixtures.blob, function(err, blob) {
            nodeExistsSync(fixtures.checksum_replaced).should.equal(true);
            done(err);
        });
    });
});