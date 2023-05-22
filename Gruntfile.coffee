module.exports = (grunt) ->
  'use strict'

  require('time-grunt') grunt

  config =
    timestamp: new Date().getTime()
  loadConfig = (path) ->
    glob = require 'glob'
    object = {}
    glob.sync '*',
      cwd: path
    .forEach (option) ->
      key = option.replace /\.js$/, ''
      object[key] = require path + option
      return
    object
  runTargetedTask = (tasks, taskTarget) ->
    if taskTarget
      i = 0
      while i < tasks.length
        if config[tasks[i]][taskTarget]
          tasks[i] += ':' + taskTarget
        i++
    grunt.task.run tasks
    return

  grunt.util._.extend config, loadConfig('./grunt/task/')
  grunt.initConfig config

  require('load-grunt-tasks') grunt

  grunt.registerTask 'css-dist', (taskTarget) ->
    runTargetedTask [
      'sass'
      'postcss'
      'cssmin'
    ], taskTarget
    return
  grunt.registerTask 'js-dist', (taskTarget) ->
    runTargetedTask [
      'coffee'
      'uglify'
    ], taskTarget
    return
  grunt.registerTask 'html-dist', (taskTarget) ->
    runTargetedTask [
      'replace'
      'htmlmin'
    ], taskTarget
    return
  grunt.registerTask 'translation-copy', (taskTarget) ->
    runTargetedTask [
      'copy'
    ], taskTarget
    return
  grunt.registerTask 'img-copy', (taskTarget) ->
    runTargetedTask [
      'copy'
    ], taskTarget
    return
  grunt.registerTask 'img-dist', (taskTarget) ->
    runTargetedTask [
      'imagemin'
    ], taskTarget
    return
  grunt.registerTask 'build', ->
    runTargetedTask [
      'clean'
      'sass'
      'postcss'
      'cssmin'
      'coffee'
      'uglify'
      'replace'
      'htmlmin'
      'imagemin'
    ], 'general'
    runTargetedTask [
      'clean'
      'replace'
      'htmlmin'
      'imagemin'
    ], 'youth-markets'
    runTargetedTask [
      'clean'
      'sass'
      'postcss'
      'cssmin'
      'coffee'
      'uglify'
      'replace'
      'htmlmin'
      'imagemin'
    ], 'ym-primary'
    runTargetedTask [
      'clean'
      'sass'
      'postcss'
      'cssmin'
      'coffee'
      'uglify'
      'replace'
      'htmlmin'
      'imagemin'
    ], 'middle-school'
    runTargetedTask [
      'clean'
      'sass'
      'postcss'
      'cssmin'
      'coffee'
      'uglify'
      'replace'
      'htmlmin'
      'imagemin'
    ], 'ym-rewards'
    return
  grunt.registerTask 'dev', ->
    devTasks = [
      'connect:dev'
    ]
    config.watch['general'].tasks.forEach (task) ->
      if task.indexOf('notify:') is -1
        devTasks.push task
    config.watch['youth-markets'].tasks.forEach (task) ->
      if task.indexOf('notify:') is -1
        devTasks.push task
    config.watch['ym-primary'].tasks.forEach (task) ->
      if task.indexOf('notify:') is -1
        devTasks.push task
    config.watch['middle-school'].tasks.forEach (task) ->
      if task.indexOf('notify:') is -1
        devTasks.push task
    config.watch['ym-rewards'].tasks.forEach (task) ->
      if task.indexOf('notify:') is -1
        devTasks.push task
    devTasks.push 'watch'
    grunt.task.run devTasks
    return
  grunt.registerTask 'default', [
    'dev'
  ]
  return
