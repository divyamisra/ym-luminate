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
    '$sce'
    ($scope, $rootScope, $filter, $timeout, $uibModal, $location, APP_INFO, BoundlessService, PageContentService, $sce) ->

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
        }
        {
          "id":"KSHA-19"
          "name":"Finn"
          "status":0
        }
        {
          "id":"KPAN-19"
          "name":"Ruby"
          "status":0
        }
        {
          "id":"3D"
          "name":"Create Your Own 3D Printed Heart Hero"
          "status":0
        }
      ]
      defaultStandardGifts = [
        {
          "id":"KUNI-19"
          "name":"Echo and Hero Clasp"
          "status":0
        }
        {
          "id":"LVL2JR-19"
          "name":"Jump Rope"
          "status":0
        }
        {
          "id":"KOTT-19"
          "name":"Oscar"
          "status":0
        }
        {
          "id":"KPIG-19"
          "name":"Sprinkles"
          "status":0
        }
        {
          "id":"LVL3"
          "name":"T-Shirt"
          "status":0
        }
        {
          "id":"LVL4BB-19"
          "name":"Basketball"
          "status":0
        }
        {
          "id":"KNAR-19"
          "name":"Splash"
          "status":0
        }
        {
          "id":"LVL5DB-19"
          "name":"Dancing Ball"
          "status":0
        }
        {
          "id":"KDRA-19"
          "name":"Fiery"
          "status":0
        }
        {
          "id":"LVL6ST-19"
          "name":"Slimeball Target"
          "status":0
        }
        {
          "id":"LVL7SR-19"
          "name":"Splash's Racquet Fun"
          "status":0
        }
        {
          "id":"LVL8WH-19"
          "name":"Wireless Headphones"
          "status":0
        }
      ]

      giftLevels = {
        "$5-$14": {
          "products":[
            "KUNI-19"
            "MWB-19"
            "KSHA-19"
          ]
          "desc":
            "Up to $14"
        }
        "$15-$19": {
          "products":[
            "KUNI-19"
            "MWB-19"
            "KSHA-19"
            "LVL2JR-19"
          ]
          "desc":
            "Up to $19"
        }
        "$20-$34": {
          "products":[
            "KUNI-19"
            "MWB-19"
            "KSHA-19"
            "LVL2JR-19"
            "KOTT-19"
          ]
          "desc":
            "Up to $34"
        }
        "$35-$49": {
          "products":[
            "KUNI-19"
            "MWB-19"
            "KSHA-19"
            "LVL2JR-19"
            "KOTT-19"
            "KPIG-19"
          ]
          "desc":
            "Up to $49"
        }
        "$50-$74": {
          "products":[
            "KUNI-19"
            "MWB-19"
            "KSHA-19"
            "KPAN-19"
            "LVL2JR-19"
            "KOTT-19"
            "KPIG-19"
            "LVL3"
          ]
          "desc":
            "Up to $74"
        }
        "Green $75-$99": {
          "products":[
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
          "desc":
            "Up to $99"
        }
        "Blue $100-$149": {
          "products":[
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
          "desc":
            "Up to $149"
        }
        "Purple $150-$199": {
          "products":[
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
          "desc":
            "Up to $199"
        }
        "Red $200-$249": {
          "products":[
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
          "desc":
            "Up to $249"
        }
        "Orange $250-$499": {
          "products":[
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
          "desc":
            "Up to $499"
        }
        "Brown $500-$999": {
          "products":[
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
          "desc":
            "Up to $999"
        }
        "Yellow $1000+": {
          "products":[
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
          "desc":
            "$1000+"
        }
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
            if giftLevels[current_level].products.includes(gift.id) and student.has_bonus != 0
              status = 1
            $scope.bonusGifts.push
              prize_label: gift.name
              prize_sku: gift.id
              prize_status: status
              prize_level: giftLevels[current_level].desc

          prevstatus = 0
          angular.forEach defaultStandardGifts, (gift, key) ->
            status = 0
            lastItem = 0
            if giftLevels[current_level].products.includes(gift.id)
              status = 1
            if prevstatus == 1 and status == 0
              $scope.standardGifts[$scope.standardGifts.length-1].lastItem = 1
            $scope.standardGifts.push
              prize_label: gift.name
              prize_sku: gift.id
              prize_status: status
              lastItem: lastItem
              randomID: getRandomID()
              prize_level: giftLevels[current_level].desc
            $scope.giftStatus = status
            prevstatus = status
        
          if $scope.giftStatus == 1
            $scope.standardGifts[$scope.standardGifts.length-1].lastItem = 1
      , (response) ->
        # TODO
      
]
