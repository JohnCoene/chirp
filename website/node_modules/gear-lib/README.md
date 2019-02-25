# gear-lib

## Collection of common [Gear.js](http://github.com/yahoo/gear) tasks

Useful tasks to lint, minify, and deploy assets.

[![Build Status](https://secure.travis-ci.org/twobit/gear-lib.png)](http://travis-ci.org/twobit/gear-lib)

[![NPM](https://nodei.co/npm/gear-lib.png?downloads=true)](https://nodei.co/npm/gear-lib/)

## Installation

```bash
$ npm install gear-lib
```

## Quick Examples

### Deploy to S3

```javascript
new Queue({registry: 'gear-lib'})
    .read(['foo.js', 'bar.js', 'baz.js'])
    .concat()
    .jslint({config: {nomen: true}})
    .jsminify()
    .s3({name: 'foobarbaz.js', client: {
        key: '<key>',
        secret: '<secret>',
        bucket: 'gearjs'
    }})
    .run();
```

## Documentation

### Tasks

 * [jslint](#jslint)
 * [jshint](#jshint)
 * [jsminify](#jsminify)
 * [csslint](#csslint)
 * [cssminify](#cssminify)
 * [less](#cssminify)
 * [glob](#glob)
 * [s3](#s3)
 * [dest](#dest)

## Tasks

<a name="jslint" />
### jslint()

Lint Javascript files.

__Arguments__

 * options.config - Options for JSLint.

__Example__

```javascript
.jslint({config: {nomen: true}})
```

---------------------------------------

<a name="jshint" />
### jshint()

Lint Javascript files.

__Arguments__

 * options.config - Options for JSHint.

__Example__

```javascript
.jshint({config: {browser: true, eqeqeq: true}})
.jshint({configFile: '.jshintrc'})
```

---------------------------------------

<a name="jsminify" />
### jsminify()

Minify Javascript files.

__Arguments__

 * options.config - Options for uglify-js.

__Example__

```javascript
.jsminify()
```

---------------------------------------

<a name="csslint" />
### csslint()

Lint CSS files.

__Arguments__

 * options.config - Options for CSSLint.

__Example__

```javascript
.csslint({config: {'duplicate-properties': true}})
```

---------------------------------------

<a name="cssminify" />
### cssminify()

Minify CSS files.

__Aliased as less()__

__Example__

```javascript
.cssminify()

// Compile LESS stylesheets without minifying
.less({compress: false})
```

---------------------------------------

<a name="glob" />
### glob()

Read files using wildcards. See [Glob package](https://github.com/isaacs/node-glob)

__Arguments__

 * options.pattern - Glob pattern.
 * options.limit - Limit the amount of concurrently opened files.
 * options.options - Glob options.

__Example__

```javascript
.glob({
    pattern: "*.js"
})
```

---------------------------------------

<a name="s3" />
### s3()

Deploy file to S3.

__Arguments__

 * options.name - Filename to write to S3.
 * options.client.key - S3 key.
 * options.client.secret - S3 secret.
 * options.client.bucket - S3 bucket.

__Example__

```javascript
 .s3({name: 'foobarbaz.js', client: {
    key: '<key>',
    secret: '<secret>',
    bucket: 'gearjs'
 }})
```

---------------------------------------

<a name="dest">
### dest()

Move one or more files to a destination.

__Arguments__

 * options.dir - File destination.
 * options.base - Base path for incoming files.
 * options.encoding - File encoding.

__Example__

```javascript
.dest('path/of/destination')

// With more options
.dest({
  dir: 'path/of/destination',
  base: 'path/of'
})
```
