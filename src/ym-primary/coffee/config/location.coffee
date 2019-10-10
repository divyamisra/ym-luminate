angular.module 'ahaLuminateApp'
  .config [
    '$locationProvider'
    ($locationProvider) ->
      $locationProvider.hashPrefix ''
  ]