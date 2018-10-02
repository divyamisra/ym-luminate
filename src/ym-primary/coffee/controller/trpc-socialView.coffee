angular.module('trPcControllers').controller 'NgPcSocialViewCtrl', [
  '$scope'
  '$sce'
  '$rootScope'
  ($scope, $sce, $rootScope) ->
    urlPrefix = ''
    if $scope.tablePrefix == 'heartdev'
      urlPrefix = 'bfstage'
    else
      urlPrefix = 'bfapps1'
    consId = $scope.consId
    frId = $rootScope.frId
    url = 'https://' + urlPrefix + '.boundlessfundraising.com/applications/ahakhc/social/app/ui/#/addsocial/' + consId + '/' + frId + '?source=PCSocial'
    $scope.socialIframeURL = $sce.trustAsResourceUrl(url)
    return
]
