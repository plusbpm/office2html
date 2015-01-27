fs            = require 'fs'
which         = require 'which'
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

pkg = JSON.parse fs.readFileSync('./package.json')

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# Compiles src/*.coffee directory to the app directory
build = (callback) ->
  options = ['-c','-b', '-o', 'app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0

# mocha test
test = (callback) ->
  options = [
    '--globals'
    'hasCert,res'
    '--reporter'
    'spec'
    '--compilers'
    'coffee:coffee-script'
    '--colors'
    '--require'
    'should'
    '--require'
    './server'
  ]
  try
    cmd = which.sync 'mocha' 
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout 
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red


task 'build', ->
  build -> log ":)", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log ":)", green



  