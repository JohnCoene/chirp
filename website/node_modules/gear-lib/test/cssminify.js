var Blob = require('gear').Blob,
    cssminify = require('..').cssminify,
    less = require('..').less,
    fixtures = {
        css: new Blob(' .bar { display: none;  } '),
        min: '.bar{display:none}',
        cleancssmin: '.bar{display:none}',
        less: new Blob('@color: #FF0;\ndiv { color: @color; }'),
        compiled: 'div {\n  color: #ffff00;\n}\n'
    };

describe('cssminify()', function() {
    it('should minify css', function(done) {
        cssminify({}, fixtures.css, function(err, res) {
            res.result.should.equal(fixtures.min);
            done(err);
        });
    });
});

describe('cssminify()', function() {
    it('should minify css with options', function(done) {
        cssminify({compress: true, yuicompress: false}, fixtures.css, function(err, res) {
            res.result.should.equal(fixtures.min);
            done(err);
        });
    });
});

describe('cssminify()', function() {
    it('should minify css using cleancss', function(done) {
        cssminify({cleancss: true}, fixtures.css, function(err, res) {
            res.result.should.equal(fixtures.cleancssmin);
            done(err);
        });
    });
});

describe('less()', function() {
    it('should compile LESS stylesheets', function(done) {
        less({compress: false}, fixtures.less, function(err, res) {
            res.result.should.equal(fixtures.compiled);
            done(err);
        });
    });
});