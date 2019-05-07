angular.module 'trPcControllers'
  .controller 'socialViewCtrl', [
    '$rootScope'
    '$scope'
    '$sce'
    ($rootScope, $scope, $sce) ->
      urlPrefix = ''
      if $scope.tablePrefix is 'heartdev'
        urlPrefix = 'bfstage'
      else
        urlPrefix = 'bfapps1'
      consId = $scope.consId
      frId = $scope.frId
      auth = $rootScope.authToken
      jsession = $rootScope.sessionCookie	
      url = 'https://' + urlPrefix + '.boundlessfundraising.com/applications/ahahw/social/app/ui/#/addsocial/' + consId + '/' + frId + '/' + auth + '/' + jsession + '?source=PCSocial'
      $scope.socialURL = $sce.trustAsResourceUrl url
  ]