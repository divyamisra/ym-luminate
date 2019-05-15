angular.module 'trPcControllers'
  .controller 'editCompanyViewCtrl', [
    '$rootScope'
    '$scope'
    ($rootScope, $scope) ->
      urlPrefix = ''
      if $scope.tablePrefix is 'heartdev'
        urlPrefix = 'bfstage'
      else
        urlPrefix = 'bfapps1'

      console.log 'this is the company page edit controller'

  ]