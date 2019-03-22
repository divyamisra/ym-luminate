angular.module('trPcControllers').controller 'NgPcSocialViewCtrl', [
  '$scope'
  '$sce'
  '$rootScope'
  ($scope, $sce, $rootScope) ->
    urlPrefix = ''
    if $scope.tablePrefix is 'heartdev'
      urlPrefix = 'bfstage'
    else
      urlPrefix = 'bfapps1'
    consId = $scope.consId
    frId = $rootScope.frId
    auth = $rootScope.authToken
    jsession = $rootScope.sessionCookie
    console.log "distict heart"
    url = 'https://' + urlPrefix + '.boundlessfundraising.com/applications/ahadhc/social/app/ui/#/addsocial/' + consId + '/' + frId + '/' + auth + '/' + jsession + '?source=PCSocial'
    $scope.socialIframeURL = $sce.trustAsResourceUrl url
    return
  ]
