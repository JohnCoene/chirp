var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    vm = require('vm'),
    Blob = require(lib + 'blob').Blob,
    replace = require(lib + 'tasks/replace').replace,
    fixtures = {
        js: new Blob("function (x) { Y.log('REMOVEME');Y.log('REMOVEME');}"),
        replaced: "function (x) { }",
        replacedNoFlags: "function (x) { Y.log('REMOVEME');}",
        string: {
			regex: "Y.log\\(.+?\\);?",
			replace: '',
			flags: 'mg'
        },
        stringNoFlags: {
			regex: "Y.log\\(.+?\\);?",
			replace: '',
			flags: ''
        },
        object:  {
            regex: /Y.log\(.+?\);?/mg,
            replace: ''
        },
		vmObject: {
		    regex: vm.runInNewContext('/Y.log\\(.+?\\);?/mg'),
            replace: ''
		}
    };

describe('replace()', function() {
    it('should use regexp objects', function(done) {
        replace(fixtures.object, fixtures.js, function(err, res) {
            res.result.should.equal(fixtures.replaced);
            done(err);
        });
    });

    it('should use regexp strings', function(done) {
        replace(fixtures.string, fixtures.js, function(err, res) {
            res.result.should.equal(fixtures.replaced);
            done(err);
        });
    });

    it('should use regexp strings without flags', function(done) {
        replace(fixtures.stringNoFlags, fixtures.js, function(err, res) {
            res.result.should.equal(fixtures.replacedNoFlags);
            done(err);
        });
    });

    it('should use regexp objects in command line mode', function(done) {
        replace(fixtures.vmObject, fixtures.js, function(err, res) {
            res.result.should.equal(fixtures.replaced);
            done(err);
        });
    });

});
