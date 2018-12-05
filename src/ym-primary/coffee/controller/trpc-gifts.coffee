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
      $scope.gifts = []

      BoundlessService.getStudentDetail 
      .then (response) ->
        students = response.data.student
        angular.forEach students, (student) ->
          prizes = students.prizes
          angular.forEach prizes, (prize) ->
            if prize.status  == 1
              $scope.gifts.push
                id: prize.id
                label: prize.label
                sku: prize.sku
                status: prize.status
                earned: prize.earned_datetime
      , (response) ->
        # TODO

  ]
