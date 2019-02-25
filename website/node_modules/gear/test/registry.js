var lib = process.env.GEAR_COVER ? '../lib-cov/' : '../lib/',
    Registry = require(lib + 'registry').Registry,
    path = require('path'),
    fixtures = {
        dirname: path.join(process.cwd(), "test/fixtures/test-tasks"),
        filename: path.join(process.cwd(), "test/fixtures/test-tasks/index.js")
    };

describe('Registry', function() {
    describe('load()', function() {
        it('should load modules', function() {
            var registry = new Registry();

            registry.load({module: 'gear-lib'});

            registry.tasks.should.containEql('csslint');
            registry.tasks.should.containEql('jslint');
            registry.tasks.should.containEql('s3');
            registry.tasks.should.containEql('glob');
        });

        it('should load directories', function() {
            var registry = new Registry();

            registry.load({dirname: fixtures.dirname});

            registry.tasks.should.containEql('fooga');
        });


        it('should load files', function() {
            var registry = new Registry();

            registry.load({filename: fixtures.filename});

            registry.tasks.should.containEql('fooga');
        });

        it('should allow for chaining #load', function() {
            var registry = new Registry();

            registry.load({
                tasks : {
                    fooga : function() {}
                }
            }).tasks.should.eql(registry.tasks);
        });
    });
});
