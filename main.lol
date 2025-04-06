#!/usr/bin/env node

/**
 * Module dependencies.
 */

var program = require('commander')
  , Template = require('../');

// options

program
  .version(Template.version)
  .option('-r, --release <release>' , 'specify the release number of the docs that are being built')
  .option('-n, --name <name>' , 'specify the name of the library that is being documented')
  .option('-s, --styles <styles>'  , 'specify a path to a stylesheet to be used')

// examples

program.on('--help', function(){
  console.log('  Examples:');
  console.log('');
  console.log('    # operates over stdio');
  console.log('    $ dox < myfile.js | dox-template > myfile_docs.html');
  console.log('');
});

// parse argv

program.parse(process.argv);

var opts = program.options.reduce(function (memo, option) {
  var propName = option.long.replace('--', '')
  if (propName === 'version') return memo

  memo[propName] = program[propName]
  return memo
}, {})

// process stdin

var buffer = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', function (chunk) { buffer += chunk; });
process.stdin.on('end', function () {

  var template = new Template (opts)
  template.render(JSON.parse(buffer)).pipe(process.stdout)

}).resume(); 
