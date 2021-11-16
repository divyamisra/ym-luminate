angular.module 'ahaLuminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    '$httpParamSerializer'
    'AuthService'
    'CatalogService'
    '$timeout'
    ($rootScope, $scope, $httpParamSerializer, AuthService, CatalogService, $timeout) ->
      $dataRoot = angular.element '[data-aha-luminate-root]'
      consId = $dataRoot.data('cons-id') if $dataRoot.data('cons-id') isnt ''
      $scope.protocol = window.location.protocol

      $scope.productList = []
      $scope.cartProductList = []

      $scope.getSchoolPlan = ->
        CatalogService.schoolPlanData '&method=GetSchoolPlan&CompanyId=' + $scope.participantRegistration.companyInformation.companyId + '&EventId=' + $scope.frId,
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            angular.forEach response.data.company, (school) ->
              $scope.coordinatorPoints = JSON.parse(school.PointsDetail)
              $scope.TotalPointsEarned = school.TotalPointsEarned

      $scope.getProducts = ->
        CatalogService.schoolPlanData '&method=GetSchoolProducts&CompanyId=' + $scope.participantRegistration.companyInformation.companyId + '&EventId=' + $scope.frId,
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            $scope.productList = response.data.company.products

      $scope.addProductToCart = (product) ->
        productExistInCart = $scope.cartProductList.find(name of name: name == product.currentTarget.name)
        if !productExistInCart
          $scope.cartProductList.push
            name: product.currentTarget.name
            points: product.currentTarget.attributes.points.value
            num: 1
          # enhance "porduct" opject with "num" property
          getTotalPoints()
          return
        productExistInCart.num += 1
        productExistInCart.points = productExistInCart.points * productExistInCart.num
        getTotalPoints()

      $scope.removeProduct = (product) ->
        $scope.cartProductList = $scope.cartProductList.filter(name of name: name != product.currentTarget.name)
        getTotalPoints()

      getTotalPoints = ->
        $scope.totalPoints = $scope.cartProductList.map(Number.parseInt(item.points)).reduce((acc + curr of acc) curr of item, 0)
      
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
        CatalogService.getRegistration
          success: (response) ->
            participantRegistration = response.getRegistrationResponse?.registration
            if participantRegistration
              $rootScope.participantRegistration = participantRegistration
                
  ]
