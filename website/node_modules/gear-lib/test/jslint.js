var Blob = require('gear').Blob,
    jslint = require('..').jslint,
    fixtures = {
        invalid: new Blob('^^^^'),
        options: new Blob('function _blah() {return 1; }')
    };

describe('jslint()', function() {
    it('should lint js', function(done) {
        jslint({}, fixtures.invalid, function(err, results) {
            results.jslint.length.should.be.above(0);
            done(err);
        });
    });
});

describe('jslint()', function() {
    it('should accept options', function(done) {
        jslint({config: {nomen: true, sloppy: true}}, fixtures.options, function(err, results) {
            results.jslint.length.should.equal(0);
            done(err);
        });
    });
});