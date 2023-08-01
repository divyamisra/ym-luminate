angular.module 'trPcControllers'
  .controller 'NgPcGiftsViewCtrl', [
    '$scope'
    '$rootScope'
    '$filter'
    '$timeout'
    '$uibModal'
    '$location'
    'APP_INFO'
    'NuclavisService'
    'PageContentService'
    'NgPcTeamraiserProgressService'
    '$sce'
    ($scope, $rootScope, $filter, $timeout, $uibModal, $location, APP_INFO, NuclavisService, PageContentService, NgPcTeamraiserProgressService, $sce) ->

      $scope.showPrize = (sku, label, earned, video) ->
        $scope.prize_sku = sku
        $scope.prize_label = label
        $scope.prize_status = earned
        $scope.prize_video = video
        $scope.viewPrizeModal = $uibModal.open
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/viewPrize.html'

      $scope.cancelShowPrize = ->
        $scope.viewPrizeModal.close()

      getRandomID = ->
        return Math.floor((Math.random()*3)+1);

      #defaultStandardGifts = BoundlessService.defaultStandardGifts()
      
      $scope.gifts = []
      $scope.giftsEarned = 0

      #get prizes earned count for Finns Prize
      $scope.badges = []
      $scope.badgesEarned = 0
      NuclavisService.getBadges $scope.consId + '/' + $scope.frId
      .then (response) ->
        $scope.badges = response.data.missions
        angular.forEach $scope.badges, (badge) ->
          if badge.earned != 0
            $scope.badgesEarned++
        badge = response.data.overall_mission_status
        if badge.completed != 0
          $scope.badgesEarned++
        
        #get all prizes
        NuclavisService.getGifts $scope.consId + '/' + $scope.frId
        .then (response) ->
          $scope.gifts = response.data.gifts
          angular.forEach $scope.gifts, (gift) ->
            if gift.earned != 0
              $scope.giftsEarned++

      $scope.participantProgress =
        raised: 0
        raisedFormatted: '$0'
        goal: 0
        goalFormatted: '$0'
        percent: 0
      $scope.getParticipantProgress = ->
        fundraisingProgressPromise = NgPcTeamraiserProgressService.getProgress()
          .then (response) ->
            participantProgress = response.data.getParticipantProgressResponse?.personalProgress
            if participantProgress
              participantProgress.raised = Number participantProgress.raised
              participantProgress.raisedFormatted = if participantProgress.raised then $filter('currency')(participantProgress.raised / 100, '$', 0) else '$0'
              participantProgress.goal = Number participantProgress.goal
              participantProgress.goalFormatted = if participantProgress.goal then $filter('currency')(participantProgress.goal / 100, '$', 0) else '$0'
              $scope.participantProgress = participantProgress
            response
      $scope.getParticipantProgress()
      
      #get prizes earned count for Finns Prize
      ###
      $scope.prizes = []
      $scope.prizesEarned = 0
      BoundlessService.getBadges $scope.frId + '/' + $scope.consId
        .then (response) ->
          prizes = response.data.prizes
          angular.forEach prizes, (prize) ->
            if prize.status != 0
              $scope.prizesEarned++
      ###
]
