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
    'NgPcTeamraiserProgressService'
    '$sce'
    ($scope, $rootScope, $filter, $timeout, $uibModal, $location, APP_INFO, BoundlessService, PageContentService, NgPcTeamraiserProgressService, $sce) ->

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

      defaultStandardGifts = [
        {
          "id":"WB-20"
          "name":"Worded Wristband"
          "status":0
          "level":""
          "level_desc":""
        }
        {
          "id":"CLIPPERRIE-20"
          "name":"Perrie"
          "status":0
          "level":"$5"
        }
        {
          "id":"CHARMKNOX-20"
          "name":"Knox"
          "status":0
          "level":"$10"
        }
        {
          "id":"JR-20"
          "name":"Jump Rope"
          "status":0
          "level":"$20"
        }
        {
          "id":"CLIPNICO-20"
          "name":"Nico"
          "status":0
          "level":"$25"
        }
        {
          "id":"CHARMSOFIE-20"
          "name":"Sophie"
          "status":0
          "level":"$40"
        }
        {
          "id":"KHC"
          "name":"T-Shirt"
          "status":0
          "level":"$50"
        }
        {
          "id":"PBALL-20"
          "name":"Playground Ball"
          "status":0
          "level":"$75"
        }
        {
          "id":"CLIPCRUSH-20"
          "name":"Crush"
          "status":0
          "level":"$100"
        }
        {
          "id":"CLIPSUNNY-20"
          "name":"Sunny"
          "status":0
          "level":"$200"
        }
        {
          "id":"MGRIP-20"
          "name":"Monster Grip"
          "status":0
          "level":"$250"
        }
        {
          "id":"POPPER-20"
          "name":"Popper"
          "status":0
          "level":"$500"
        }
        {
          "id":"EARBUDS-20"
          "name":"Earbuds"
          "status":0
          "level":"$1,000"
        }
      ]

      giftLevels = {
        "$0": [
          "WB-20"
        ]
        "$5-$9": [
          "WB-20"
          "CLIPPERIE-20"
        ]
        "$10-$14":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
        ]
        "$15-$24":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
        ]
        "$25-$39":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
        ]
        "$40-$49":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
        ]
        "$50-$74":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
        ]
        "Green $75-$99":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
          "PBALL-20"
        ]
        "Blue $100-$199":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
          "PBALL-20"
          "CLIPCRUSH-20"
        ]
        "Purple $200-$249":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
          "PBALL-20"
          "CLIPCRUSH-20"
          "CLIPSUNNY-20"
        ]
        "Red $250-$499":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
          "PBALL-20"
          "CLIPCRUSH-20"
          "CLIPSUNNY-20"
          "MGRIP-20"
        ]
        "Orange $500-$999":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
          "PBALL-20"
          "CLIPCRUSH-20"
          "CLIPSUNNY-20"
          "MGRIP-20"
          "POPPER-20"
        ]
        "Yellow $1000+":[
          "WB-20"
          "CLIPPERIE-20"
          "CHARMKNOX-20"
          "JR-20"
          "CLIPNICO-20"
          "CHARMSOFIE-20"
          "KHC"
          "PBALL-20"
          "CLIPCRUSH-20"
          "CLIPSUNNY-20"
          "MGRIP-20"
          "POPPER-20"
          "EARBUDS-20"
        ]
      }
      
      $scope.standardGifts = []
      
      BoundlessService.getPrizes $scope.consId
      .then (response) ->
        students = response.data.student
        angular.forEach students, (student) ->
          current_level = if student.current_level != null then student.current_level else '$0'
          prevstatus = 0
          angular.forEach defaultStandardGifts, (gift, key) ->
            status = 0
            lastItem = 0
            if jQuery.inArray(gift.id,giftLevels[current_level]) isnt -1
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
]
