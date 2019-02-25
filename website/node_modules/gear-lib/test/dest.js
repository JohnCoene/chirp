var fs = require('fs'),
    path = require('path'),
    gear = require('gear'),
    should = require('should'),
    tasks = require('..'),
    Queue = gear.Queue,
    Registry = gear.Registry,
    registry = new Registry({tasks: tasks}),
    fixtures = {
        dest: 'testing',

        file: 'test/fixtures/test1.js',
        expectFile: ['test1.js'],

        files: { pattern: 'test/fixtures/*.{css,js}' },
        expectFiles: ['test1.css', 'test1.js'],

        base: 'test',
        baseDest: 'testing/fixtures'
    };

function remove(file) {
    var filepath = path.join(fixtures.dest, file);
    fs.unlinkSync(filepath);
}

describe('dest()', function() {
    beforeEach(function(done) {
        var files;

        if (fs.existsSync(fixtures.dest)) {
          if (fs.existsSync(fixtures.baseDest)) {
              files = fs.readdirSync(fixtures.baseDest)
                        .map(function(file) {
                            return path.join('fixtures', file);
                        });

              files.forEach(remove);
              fs.rmdirSync(fixtures.baseDest);
          }

          files = fs.readdirSync(fixtures.dest);

          files.forEach(remove);
        }
        done();
    });

    it('should move a single file to a destination', function(done) {
        new Queue({registry: registry})
            .read(fixtures.file)
            .dest(fixtures.dest)
            .run(function(err) {
                fs.readdirSync(fixtures.dest).should.eql(fixtures.expectFile);
                done(err);
            });
    });

    it('should move multiple files to a destination', function(done) {
        new Queue({registry: registry})
            .glob(fixtures.files)
            .dest(fixtures.dest)
            .run(function(err) {
                fs.readdirSync(fixtures.dest).should.eql(fixtures.expectFiles);
                done(err);
            });
    });

    it('should move files to a destination with base dir', function(done) {
        new Queue({registry: registry})
            .glob(fixtures.files)
            .dest({dir: fixtures.dest, base: fixtures.base})
            .run(function(err) {
                fs.readdirSync(fixtures.baseDest).should.eql(fixtures.expectFiles);
                done(err);
            });
    });
});
