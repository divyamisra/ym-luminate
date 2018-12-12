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
      $scope.instantGifts = []
      $scope.standardGifts = []
      
      BoundlessService.getPrizes $scope.consId
      .then (response) ->
        students = response.data.students
        angular.forEach students, (student) ->
          gifts = student.prizes
          angular.forEach gifts, (gift) ->
            switch gift.prize_type
              when "bonus"
                $scope.bonusGifts.push
                  earned_id: gift.earned_id
                  prize_id: gift.prize_id
                  prize_label: gift.prize_label
                  prize_sku: gift.prize_sku
                  prize_type: gift.prize_type
                  prize_colour: gift.prize_colour
                  prize_status: gift.prize_status
                  prize_earned_datetime: gift.prize_earned_datetime
              when "instant"
                $scope.instantGifts.push
                  earned_id: gift.earned_id
                  prize_id: gift.prize_id
                  prize_label: gift.prize_label
                  prize_sku: gift.prize_sku
                  prize_type: gift.prize_type
                  prize_colour: gift.prize_colour
                  prize_status: gift.prize_status
                  prize_earned_datetime: gift.prize_earned_datetime
              when "standard"
                $scope.standardGifts.push
                  earned_id: gift.earned_id
                  prize_id: gift.prize_id
                  prize_label: gift.prize_label
                  prize_sku: gift.prize_sku
                  prize_type: gift.prize_type
                  prize_colour: gift.prize_colour
                  prize_status: gift.prize_status
                  prize_earned_datetime: gift.prize_earned_datetime
      , (response) ->
        # TODO
  ]
