angular.module 'ahaLuminateApp'
  .filter 'urlencode', ->
    return return window.encodeURIComponent
