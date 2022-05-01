angular.module 'ahaLuminateApp'
  .directive 'loadQrcode', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      (scope, element, attrs) ->
        if $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true'
          jQuery(element).kjua
            'render': 'canvas'
            'crisp': true
            'ecLevel': 'H'
            'minVersion': 1
            'fill': '#333333'
            'back': '#ffffff'
            'text': $rootScope.secureDomain + '/site/TR?pg=company&fr_id=' + $scope.frId + '&company_id=' + $scope.participantRegistration.companyInformation.companyId
            'size': 400
            'rounded': 100
            'quiet': 1
            'mode': 'label'
            'mSize': 20
            'mPosX': 50
            'mPosY': 50
            'label': 'KHC'
            'fontname': 'Ubuntu Mono'
            'fontcolor': '#c10e21'
            'image': {}
  ]
