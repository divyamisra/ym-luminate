angular.module 'trPcApp'
  .directive 'giftList', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/participant-center/directive/giftList.html'
      restrict: 'E'
      replace: true
      scope:
        listType: '='
        gifts: '='
        sortColumn: '='
        sortAscending: '='
        sortGifts: '='
        deleteGift: '='
        acknowledgeGift: '='
        thankDonor: '='
      controller: [
        '$rootScope'
        '$scope'
        ($rootScope, $scope) ->
          $scope.device = $rootScope.device
          
          $rootScope.$watch 'device', ->
            $scope.device = $rootScope.device
      ]
  ]