angular.module 'ahaLuminateApp'
  .filter 'urlencode', ->
    return window.encodeURIComponent
