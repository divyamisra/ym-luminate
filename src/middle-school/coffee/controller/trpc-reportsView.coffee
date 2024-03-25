angular.module 'trPcControllers'
  .controller 'NgPcReportsViewCtrl', [
    '$rootScope'
    '$scope'
    '$filter'
    '$location'
    ($rootScope, $scope, $filter, $location) ->
      $scope.reportPromises = []

      if $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true'
        setTimeout (->
          ahaWebContent.ssoInitialize $rootScope.consId, $rootScope.frId, '' + $rootScope.authToken, '' + $rootScope.sessionCookie
        ), 3000
  ]
