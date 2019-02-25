var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    should = require('should'),
    Blob = require(lib + 'blob').Blob,
    test = require(lib + 'tasks/core').test,
    fixtures = {
        blob: new Blob('HELLO'),
        result: 'HELLO'
    };

describe('test()', function() {
    it('should test blobs', function(done) {
        test({callback: function(blob) {
            return blob.result;
        }}, fixtures.blob, function(err) {
            err.should.equal(fixtures.result);
            done();
        });
    });
});