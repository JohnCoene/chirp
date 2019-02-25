var should = require('should'),
    Blob = require('gear').Blob,
    jshint = require('..').jshint,
    fixtures = {
        invalid: new Blob('^^^^'),
        options: new Blob('if(1==2)a="1";')
    };

describe('jshint()', function() {
    it('should lint js', function(done) {
        jshint({}, fixtures.invalid, function(err, results) {
			err.length.should.be.above(0);
			results.jshint.length.should.be.above(0);
            done();
        });
    });
});

describe('jshint()', function() {
    it('should report no errors on valid JS', function(done) {
        jshint({}, fixtures.options, function(err, results) {
			should.not.exist(err);
			should.not.exist(results.jshint);
            done();
        });
    });
});

describe('jshint()', function() {
    it('should accept options', function(done) {
        jshint({config: { eqeqeq: true, undef: true }}, fixtures.options, function(err, results) {
			err.length.should.be.exactly(2);
			results.jshint.length.should.be.exactly(2);
            done();
        });
    });
});

describe('jshint()', function() {
    it('should accept a config file', function(done) {
        jshint({ configFile: 'test/fixtures/.jshintrc' }, fixtures.options, function(err, results) {
			err.length.should.be.exactly(3);
			results.jshint.length.should.be.exactly(3);
            done();
        });
    });
});
