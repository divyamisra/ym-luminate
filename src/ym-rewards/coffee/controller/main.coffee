angular.module 'ahaLuminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    '$httpParamSerializer'
    'AuthService'
    'CatalogService'
    'TeamraiserRegistrationService'
    '$timeout'
    ($rootScope, $scope, $httpParamSerializer, AuthService, CatalogService, TeamraiserRegistrationService, $timeout) ->
      $dataRoot = angular.element '[data-aha-luminate-root]'
      consId = $dataRoot.data('cons-id') if $dataRoot.data('cons-id') isnt ''
      $scope.protocol = window.location.protocol

      $scope.productList = []
      $scope.cartProductList = []
      $scope.TotalPoints = 0
      
      $scope.getSchoolPlan = ->
        CatalogService.schoolPlanData '&method=GetSchoolPlan&CompanyId=' + $scope.participantRegistration.companyInformation.companyId + '&EventId=' + $scope.frId,
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            angular.forEach response.data.company, (school) ->
              $scope.coordinatorPoints = JSON.parse(school.PointsDetail)
              $scope.TotalPointsEarned = school.TotalPointsEarned
              $scope.TotalPointsAvailable = school.TotalPointsEarned

      $scope.getSchoolProducts = ->
        CatalogService.schoolPlanData '&method=GetSchoolProducts&CompanyId=' + $scope.participantRegistration.companyInformation.companyId + '&EventId=' + $scope.frId,
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            $scope.productList = response.data.company[0]

      $scope.addProductToCart = (product) ->
        if product.currentTarget.attributes.points.value <= $scope.TotalPointsAvailable
          productExistInCart = $scope.cartProductList.find((element) ->
            return element.productName == product.currentTarget.name
          )
          if !productExistInCart
            $scope.cartProductList.push
              productName: product.currentTarget.name
              points: product.currentTarget.attributes.points.value
              num: 1
          else
            productExistInCart.num += 1
            productExistInCart.points = productExistInCart.points * productExistInCart.num
          getTotalPoints()
        else
          alert "Not enough points available"

      $scope.removeProduct = (product) ->
        $scope.cartProductList = $scope.cartProductList.filter((element) ->
          return element.productName != product.currentTarget.name
        )
        getTotalPoints()

      getTotalPoints = ->
        $scope.TotalPoints = $scope.cartProductList.map((item) ->
          Number.parseInt item.points
        ).reduce(((acc, curr) ->
          acc + curr
        ), 0)
        $scope.TotalPointsAvailable = $scope.TotalPointsEarned - $scope.TotalPoints
      
      $scope.headerLoginInfo = 
        user_name: ''
        password: ''
      
      $scope.submitHeaderLogin = ->
        AuthService.login $httpParamSerializer($scope.headerLoginInfo), 
          error: ->
            angular.element('.js--default-header-login-form').submit()
          success: ->
            if not $scope.headerLoginInfo.ng_nexturl or $scope.headerLoginInfo.ng_nexturl is ''
              window.location = $rootScope.secureDomain + 'site/SPageServer?pagename=ym_coordinator_reward_center'
            else
              window.location = $scope.headerLoginInfo.ng_nexturl
      
      if $scope.consId
        TeamraiserRegistrationService.getRegistration
          success: (response) ->
            participantRegistration = response.getRegistrationResponse?.registration
            if participantRegistration
              $rootScope.participantRegistration = participantRegistration
              $scope.getSchoolPlan()
              $scope.getSchoolProducts()
  ]
