angular.module 'trPcControllers'
  .controller 'NgPcGiftsViewCtrl', [
    '$scope'
    '$rootScope'
    '$location'
    'APP_INFO'
    'BoundlessService'
    'PageContentService'
    '$sce'
    ($scope, $rootScope, $location, APP_INFO, BoundlessService, PageContentService, $sce) ->
      $scope.bonusGifts = []
      $scope.standardGifts = []

      BoundlessService.getBonusGifts $scope.participantId
      .then (response) ->
        prizes = response.data.prizes
        angular.forEach prizes, (prize) ->
          if prize.status  == 1
            $scope.bonusGifts.push
              id: prize.id
              label: prize.label
              sku: prize.sku
              status: prize.status
              earned: prize.earned_datetime
      , (response) ->
        # TODO

      BoundlessService.getStandardGifts $scope.participantId
      .then (response) ->
        prizes = response.data.prizes
        angular.forEach prizes, (prize) ->
          if prize.status  == 1
            $scope.standardGifts.push
              id: prize.id
              label: prize.label
              sku: prize.sku
              status: prize.status
              earned: prize.earned_datetime
      , (response) ->
        # TODO

  ]
