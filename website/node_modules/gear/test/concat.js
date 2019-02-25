var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    should = require('should'),
    Blob = require(lib + 'blob').Blob,
    concat = require(lib + 'tasks/concat').concat,
    fixtures = {
        prev: new Blob('abc'),
        cur: new Blob('def')
    };

describe('concat()', function() {
    it('should concat blobs', function(done) {
        concat(null, fixtures.prev, fixtures.cur, function(err, blob) {
            blob.result.should.equal('abcdef');
            done(err);
        });
    });
});