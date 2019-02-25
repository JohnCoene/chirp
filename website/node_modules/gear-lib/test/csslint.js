var should = require('should'),
    Blob = require('gear').Blob,
    csslint = require('..').csslint,
    fixtures = {
        invalid: new Blob('%%%%'),
        options: new Blob('.foo {width: 0; width: 0;}')
    };

describe('csslint()', function() {
    it('should lint css', function(done) {
        csslint({}, fixtures.invalid, function(err, res) {
            res.csslint.length.should.be.above(0);
            done(err);
        });
    });

    it('should accept options', function(done) {
        csslint({config: {'duplicate-properties': true}}, fixtures.options, function(err, res) {
            res.csslint.length.should.be.above(0);
            done(err);
        });
    });
});