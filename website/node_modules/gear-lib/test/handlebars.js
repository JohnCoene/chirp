var Blob = require('gear').Blob,
    handlebars = require('..').handlebars,
    fixtures = {
        tmpl: new Blob('test:{{test}}')
    };

describe('handlebars()', function() {
    it('should replace vars', function(done) {
        handlebars({test: true}, fixtures.tmpl, function(err, result) {
            result.result.should.equal('test:true');
            done(err);
        });
    });
});