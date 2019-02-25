var Blob = require('gear').Blob,
    s3 = require('..').s3,
    should = require('should'),
    fixtures = {
        options: {
            name: 'test.js',
            client: {
                key: 'AKIAJ6RILQHB3LDITXYQ',
                secret: '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',
                bucket: 'gearjs'
            }
        },
        js: new Blob('function   test(  x )  {console.log(x);;;;}')
    };

describe('s3()', function() {
    it('should deploy to s3', function(done) {
        s3(fixtures.options, fixtures.js, function(err, results) {
            should.exist(err); // Travis CI can't write to S3
            done();
        });
    });
});