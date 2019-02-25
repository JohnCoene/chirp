# Gear.js

## Build System for Node.js and the Browser

Gear.js is an easy to use, simple to extend, and powerful build system. Chain tasks together to build projects with ease.

Features:

 * Basic building blocks that can be combined to perform complex builds.
 * Tasks are simply defined and keep system internals to a minimum.
 * Asynchronous execution.
 * Extensible task loading via NPM, file, or directory.
 * Advanced flow control for complex task execution.
 * Runs in Node.js and the browser.

[![Build Status](https://secure.travis-ci.org/twobit/gear.png)](http://travis-ci.org/twobit/gear)

[![NPM](https://nodei.co/npm/gear.png?downloads=true)](https://nodei.co/npm/gear/)

## Installation

To get the most out of Gear.js, you will want to install [gear-lib](http://github.com/yahoo/gear-lib) which contains tasks for linting, minifying, and deploying JS/CSS assets.

```bash
$ npm install gear gear-lib
```

## Quick Examples

### Chaining Tasks

```javascript
new Queue()
 .read('foo.js')
 .log('read foo.js')
 .inspect()
 .write('foobarbaz.js')
 .run();
```

### Execute Tasks Using Array Style

```javascript
new Queue()
 .read(['foo.js', {name: 'bar.js'}, 'baz.js'])
 .log('read foo.js')
 .inspect()
 .write(['newfoo.js', 'newbar.js']) // Not writing 'baz.js'
 .run();
```

### Parallel Task Execution

```javascript
new Queue()
 .read('foo.js')
 .log('Parallel Tasks')
 .tasks({
    read:     {task: ['read', ['foo.js', 'bar.js', 'baz.js']]},
    combine:  {requires: 'read', task: 'concat'},
    minify:   {requires: 'combine', task: 'jsminify'},
    print:    {requires: 'minify', task: 'inspect'}, // Runs when read, combine, and minify complete
    parallel: {task: ['log', "Hello Gear.js world!"]} // Run parallel to read
 }).run();
```

 * [Documentation](http://gearjs.org)
 * [Issues](http://github.com/yahoo/gear/issues)
