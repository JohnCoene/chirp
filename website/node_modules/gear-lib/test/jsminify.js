var should = require('should'),
    Blob = require('gear').Blob,
    jsminify = require('..').jsminify,
    fixtures = {
        invalid_js: '1=',
        js: new Blob('function   test(  x )  {console.log(x);;;;}'),
        min: 'function test(o){console.log(o)}',
        license: new Blob('/** @license\n* Copyright (C) 2012\n*/\nfunction foo() {}'),
        license_min: '/** @license\n* Copyright (C) 2012\n*/\nfunction foo(){}',
        ender_license: new Blob('/*!\n* Copyright (C) 2012\n*/\nfunction foo() {}'),
        ender_license_min: '/*!\n* Copyright (C) 2012\n*/\nfunction foo(){}',
        comment: new Blob('/*\n* Copyright (C) 2012\n*/\nfunction foo() {}'),
        comment_min: 'function foo(){}'
    };

describe('jsminify()', function() {
    it('should not minify invalid js', function(done) {
        jsminify({}, fixtures.invalid_js, function(err, res) {
            should.exist(err);
            done();
        });
    });

    it('should minify js', function(done) {
        jsminify({}, fixtures.js, function(err, res) {
            res.result.should.equal(fixtures.min);
            done(err);
        });
    });

    it('should preserve licenses', function(done) {
        jsminify({}, fixtures.license, function(err, res) {
            res.result.should.equal(fixtures.license_min);
            done(err);
        });
    });

    it('should preserve licenses (ender workaround)', function(done) {
        jsminify({}, fixtures.ender_license, function(err, res) {
            res.result.should.equal(fixtures.ender_license_min);
            done(err);
        });
    });

    it('should strip comments', function(done) {
        jsminify({}, fixtures.comment, function(err, res) {
            res.result.should.equal(fixtures.comment_min);
            done(err);
        });
    });
});