angular.module 'trPcControllers'
  .controller 'NgPcSchoolPlanViewCtrl', [
    '$rootScope'
    '$scope'
    '$filter'
    '$location'
    '$uibModal'
    'APP_INFO'
    ($rootScope, $scope, $filter, $location, $uibModal, APP_INFO) ->
      
      if $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true'
        setTimeout (->
          ahaWebSMT.ssoInitialize $rootScope.consId, $rootScope.frId, '' + $rootScope.authToken, '' + $rootScope.sessionCookie
          ahaWebSMT.schoolPage.setup()
        ), 2000
      
  ]
