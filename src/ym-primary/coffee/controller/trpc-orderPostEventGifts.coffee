angular.module 'trPcControllers'
  .controller 'NgPcOrderGiftsViewCtrl', [
    '$rootScope'
    '$scope'
    '$filter'
    '$location'
    '$uibModal'
    'APP_INFO'
    ($rootScope, $scope, $filter, $location, $uibModal, APP_INFO) ->

      if $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true'
        ahaWebContent.ssoInitialize $rootScope.consId, $rootScope.frId, '' + $rootScope.authToken, '' + $rootScope.sessionCookie
      
  ]
