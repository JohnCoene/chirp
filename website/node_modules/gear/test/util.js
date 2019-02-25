var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    Util = require(lib + 'util'),
    should = require('should');

describe('Util', function() {
    describe('readJSON', function() {
        it('should read JSON', function() {
            var res = Util.readJSON('./test/fixtures/test.json');
            res.x.should.equal(12);
        });

        it('should not read JSONC', function() {
            should(function() {
                Util.readJSON('./test/fixtures/test.jsonc');
            }).throw();
        });
    });

    describe('readJSONC', function() {
        it('should read JSON', function() {
            var res = Util.readJSONC('./test/fixtures/test.json');
            res.x.should.equal(12);
        });

        it('should read JSONC', function() {
            var res = Util.readJSONC('./test/fixtures/test.jsonc');
            res.x.should.equal(12);
        });
    });
});
