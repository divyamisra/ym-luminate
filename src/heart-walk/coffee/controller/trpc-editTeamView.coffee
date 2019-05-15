angular.module 'trPcControllers'
  .controller 'editTeamViewCtrl', [
    '$rootScope'
    '$scope'
    ($rootScope, $scope) ->
      urlPrefix = ''
      if $scope.tablePrefix is 'heartdev'
        urlPrefix = 'bfstage'
      else
        urlPrefix = 'bfapps1'

      console.log 'this is the team page edit controller'

  ]