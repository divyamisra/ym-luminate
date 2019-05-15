angular.module 'trPcControllers'
  .controller 'editPersonalViewCtrl', [
    '$rootScope'
    '$scope'
    ($rootScope, $scope) ->
      urlPrefix = ''
      if $scope.tablePrefix is 'heartdev'
        urlPrefix = 'bfstage'
      else
        urlPrefix = 'bfapps1'

      console.log 'this is the personal page edit controller'

  ]