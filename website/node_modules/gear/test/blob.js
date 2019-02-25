var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    Blob = require(lib + 'blob').Blob,
    fs = require('fs'),
    path = require('path'),
    nodeExistsSync = fs.existsSync || path.existsSync,
    Crypto = require('crypto'),
    fixtures = {
        input: 'test/fixtures/image.png',
        output: 'testing/image_{checksum}.png'
    };

describe('Blob', function() {
    describe('constructor()', function() {
        it('should accept mixed input', function() {
            (new Blob('abcdef')).result.should.equal('abcdef');
            (new Blob(['abc', 'def'])).result.should.equal('abcdef');
            (new Blob(['abc', new Blob('def')])).result.should.equal('abcdef');
        });

        it('should preserve encoding', function(done) {
            var checksum = Crypto.createHash('md5');
            checksum.update(fs.readFileSync(fixtures.input));

            Blob.readFile(fixtures.input, 'bin', function(err, blob) {
                Blob.writeFile(fixtures.output, blob, 'bin', function() {
                    var file = fixtures.output.replace('{checksum}', checksum.digest('hex'));
                    nodeExistsSync(file).should.equal(true);
                    done();
                });
            });
        });

        it('should merge properties', function() {
            var res = new Blob([
                new Blob('abc', {name: 'foo', b1: true, arr: [1], result: 'xyz'}),
                new Blob('def', {name: 'bar', b2: false, arr: [2]})
            ]);

            res.result.should.equal('abcdef');
            res.name.should.equal('bar');
            res.b1.should.equal(true);
            res.b2.should.equal(false);
        });
    });
});