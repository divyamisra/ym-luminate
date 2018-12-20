angular.module 'trPcControllers'
  .controller 'NgPcGiftsViewCtrl', [
    '$scope'
    '$rootScope'
    '$filter'
    '$timeout'
    '$uibModal'
    '$location'
    'APP_INFO'
    'BoundlessService'
    'PageContentService'
    'TeamraiserProgressService'
    '$sce'
    ($scope, $rootScope, $filter, $timeout, $uibModal, $location, APP_INFO, BoundlessService, PageContentService, TeamraiserProgressService, $sce) ->

      $scope.showPrize = (sku, label, earned) ->
        $scope.prize_sku = sku
        $scope.prize_label = label
        $scope.prize_status = earned
        $scope.viewPrizeModal = $uibModal.open
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/viewPrize.html'

      $scope.cancelShowPrize = ->
        $scope.viewPrizeModal.close()

      getRandomID = ->
        return Math.floor((Math.random()*3)+1);

      defaultInstantGifts = [
        {
          "id":"MWB-19"
          "name":"Heart Heroes Wristband"
          "status":0
          "level":"$5"
        }
        {
          "id":"KSHA-19"
          "name":"Finn"
          "status":0
          "level":"$1"
        }
        {
          "id":"KPAN-19"
          "name":"Ruby"
          "status":0
          "level":"$40"
        }
        {
          "id":"3D"
          "name":"Create Your Own 3D Printed Heart Hero"
          "status":0
          "level":"$1,000"
        }
      ]
      defaultStandardGifts = [
        {
          "id":"KUNI-19"
          "name":"Echo and Hero Clasp"
          "status":0
          "level":"$5"
        }
        {
          "id":"LVL2JR-19"
          "name":"Jump Rope"
          "status":0
          "level":"$15"
        }
        {
          "id":"KOTT-19"
          "name":"Oscar"
          "status":0
          "level":"$20"
        }
        {
          "id":"KPIG-19"
          "name":"Sprinkles"
          "status":0
          "level":"$35"
        }
        {
          "id":"LVL3"
          "name":"T-Shirt"
          "status":0
          "level":"$50"
        }
        {
          "id":"LVL4BB-19"
          "name":"Basketball"
          "status":0
          "level":"$75"
        }
        {
          "id":"KNAR-19"
          "name":"Splash"
          "status":0
          "level":"$100"
        }
        {
          "id":"LVL5DB-19"
          "name":"Dancing Ball"
          "status":0
          "level":"$150"
        }
        {
          "id":"KDRA-19"
          "name":"Fiery"
          "status":0
          "level":"$200"
        }
        {
          "id":"LVL6ST-19"
          "name":"Slimeball Target"
          "status":0
          "level":"$250"
        }
        {
          "id":"LVL7SR-19"
          "name":"Splash's Racquet Fun"
          "status":0
          "level":"$500"
        }
        {
          "id":"LVL8WH-19"
          "name":"Wireless Headphones"
          "status":0
          "level":"$1,000"
        }
      ]

      giftLevels = {
        "$5-$14": [
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
        ]
        "$15-$19":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "LVL2JR-19"
        ]
        "$20-$34":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "LVL2JR-19"
          "KOTT-19"
        ]
        "$35-$49":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
        ]
        "$50-$74":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
        ]
        "Green $75-$99":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
        ]
        "Blue $100-$149":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
          "KNAR-19"
        ]
        "Purple $150-$199":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
          "KNAR-19"
          "LVL5DB-19"
        ]
        "Red $200-$249":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
          "KNAR-19"
          "LVL5DB-19"
          "KDRA-19"
        ]
        "Orange $250-$499":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
          "KNAR-19"
          "LVL5DB-19"
          "KDRA-19"
          "LVL6ST-19"
        ]
        "Brown $500-$999":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
          "KNAR-19"
          "LVL5DB-19"
          "KDRA-19"
          "LVL6ST-19"
          "LVL7SR-19"
        ]
        "Yellow $1000+":[
          "KUNI-19"
          "MWB-19"
          "KSHA-19"
          "KPAN-19"
          "LVL2JR-19"
          "KOTT-19"
          "KPIG-19"
          "LVL3"
          "LVL4BB-19"
          "KNAR-19"
          "LVL5DB-19"
          "KDRA-19"
          "LVL6ST-19"
          "LVL7SR-19"
          "LVL8WH-19"
          "3D"
        ]
      }
      
      $scope.bonusGifts = []
      $scope.standardGifts = []
      
      BoundlessService.getPrizes $scope.consId
      .then (response) ->
        students = response.data.student
        angular.forEach students, (student) ->
          current_level = student.current_level
          angular.forEach defaultInstantGifts, (gift) ->
            status = 0
            if giftLevels[current_level].includes(gift.id) and student.has_bonus != 0
              status = 1
            $scope.bonusGifts.push
              prize_label: gift.name
              prize_sku: gift.id
              prize_status: status
              prize_level: gift.level

          prevstatus = 0
          angular.forEach defaultStandardGifts, (gift, key) ->
            status = 0
            lastItem = 0
            if giftLevels[current_level].includes(gift.id)
              status = 1
            if prevstatus == 1 and status == 0
              $scope.standardGifts[$scope.standardGifts.length-1].lastItem = 1
            $scope.standardGifts.push
              prize_label: gift.name
              prize_sku: gift.id
              prize_status: status
              lastItem: lastItem
              randomID: getRandomID()
              prize_level: gift.level
            $scope.giftStatus = status
            prevstatus = status
        
          if $scope.giftStatus == 1
            $scope.standardGifts[$scope.standardGifts.length-1].lastItem = 1
      , (response) ->
        # TODO

      $scope.participantProgress =
        raised: 0
        raisedFormatted: '$0'
        goal: 0
        goalFormatted: '$0'
        percent: 0
      $scope.getParticipantProgress = ->
        fundraisingProgressPromise = TeamraiserProgressService.getProgress()
          .then (response) ->
            participantProgress = response.data.getParticipantProgressResponse?.personalProgress
            if participantProgress
              participantProgress.raised = Number participantProgress.raised
              participantProgress.raisedFormatted = if participantProgress.raised then $filter('currency')(participantProgress.raised / 100, '$', 0) else '$0'
              participantProgress.goal = Number participantProgress.goal
              participantProgress.goalFormatted = if participantProgress.goal then $filter('currency')(participantProgress.goal / 100, '$', 0) else '$0'
              participantProgress.percent = 0
              $scope.participantProgress = participantProgress
              $timeout ->
                percent = $scope.participantProgress.percent
                if $scope.participantProgress.goal isnt 0
                  percent = Math.ceil(($scope.participantProgress.raised / $scope.participantProgress.goal) * 100)
                if percent > 100
                  percent = 100
                $scope.participantProgress.percent = percent
              , 500
            response
      $scope.getParticipantProgress()
]
