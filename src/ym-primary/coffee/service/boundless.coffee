angular.module 'ahaLuminateApp'
  .factory 'BoundlessService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getLeaderboardRaised: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/points/leaders/school/' + requestData + '/teachers/most-dollars?limit=5'
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/points/leaders/school/' + requestData + '/teachers/most-dollars?limit=5'
        else
          url = 'https://kidsheartchallenge.heart.org/api/points/leaders/school/' + requestData + '/teachers/most-dollars?limit=5'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      getLeaderboardStudents: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/points/leaders/school/' + requestData + '/teachers/most-students?limit=5'
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/points/leaders/school/' + requestData + '/teachers/most-students?limit=5'
        else
          url = 'https://kidsheartchallenge.heart.org/api/points/leaders/school/' + requestData + '/teachers/most-students?limit=5'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      getBadges: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/badges/student/' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/badges/student/' + requestData
        else
          url = 'https://kidsheartchallenge.heart.org/api/badges/student/' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      getPrizes: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/coordinator/students/standard-prizes/' +  + $rootScope.frId + '/' + $rootScope.consId 
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/coordinator/students/standard-prizes/' +  + $rootScope.frId + '/' + $rootScope.consId
        else
          url = 'https://kidsheartchallenge.heart.org/api/coordinator/students/standard-prizes/' +  + $rootScope.frId + '/' + $rootScope.consId
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response

      getRollupTotals: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/schools/totals/'
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/schools/totals/'
        else
          url = 'https://kidsheartchallenge.heart.org/api/schools/totals/'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      logEmailSent: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/webhooks/student/emails-sent/' + $rootScope.frId + '/' + $rootScope.consId
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/webhooks/student/emails-sent/' + $rootScope.frId + '/' + $rootScope.consId
        else
          url = 'https://kidsheartchallenge.heart.org/api/webhooks/student/emails-sent/' + $rootScope.frId + '/' + $rootScope.consId
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      logPersonalPageUpdated: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://khc.staging.ootqa.org/api/webhooks/student/personal-page-updated/' + $rootScope.frId + '/' + $rootScope.consId
        else if $rootScope.tablePrefix is 'heartnew'
          url = 'https://khc.dev.ootqa.org/api/webhooks/student/personal-page-updated/' + $rootScope.frId + '/' + $rootScope.consId
        else
          url = 'https://kidsheartchallenge.heart.org/api/webhooks/student/personal-page-updated/' + $rootScope.frId + '/' + $rootScope.consId
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      defaultStandardGifts: ->
        [
          {
            "id":"WB-20"
            "name":"Worded Wristband"
            "status":0
            "level":""
            "level_desc":""
            "earned_title":"You're Awesome!"
            "earned_subtitle1":"Thanks for registering online!"
            "earned_subtitle2":"a wristband"
          }
          {
            "id":"CLIPPERRIE-20"
            "name":"Perrie"
            "status":0
            "level":"$5"
            "earned_title":"Check, Mate!"
            "earned_subtitle1":"You've raised $5!"
            "earned_subtitle2":"Perrie"
          }
          {
            "id":"CHARMKNOX-20"
            "name":"Knox"
            "status":0
            "level":"$10"
            "earned_title":"Give us 2 high fives!"
            "earned_subtitle1":"You just raised $10 online!"
            "earned_subtitle2":"Knox"
          }
          {
            "id":"JR-20"
            "name":"Jump Rope"
            "status":0
            "level":"$20"
            "earned_title":"Jumping for joy!"
            "earned_subtitle1":"Way to jump in and raise $20!"
            "earned_subtitle2":"a jump rope"
          }
          {
            "id":"CLIPNICO-20"
            "name":"Nico"
            "status":0
            "level":"$25"
            "earned_title":"You're a Super hero!"
            "earned_subtitle1":"You're the best for raising $25!"
            "earned_subtitle2":"Nico"
          }
          {
            "id":"CHARMSOFIE-20"
            "name":"Sophie"
            "status":0
            "level":"$40"
            "earned_title":"Color us happy!"
            "earned_subtitle1":"Nice job raising $40 online!"
            "earned_subtitle2":"Sophie"
          }
          {
            "id":"KHC"
            "name":"T-Shirt"
            "status":0
            "level":"$50"
            "earned_title":"You're a real hero!"
            "earned_subtitle1":"You've raised $50!"
            "earned_subtitle2":"a t-shirt"
          }
          {
            "id":"PBALL-20"
            "name":"Playground Ball"
            "status":0
            "level":"$75"
            "earned_title":"Bouncin' High!"
            "earned_subtitle1":"Way to raise $75!"
            "earned_subtitle2":"a playground ball"
          }
          {
            "id":"CLIPCRUSH-20"
            "name":"Crush"
            "status":0
            "level":"$100"
            "earned_title":"Crushin' It!"
            "earned_subtitle1":"Nice job crusing to $100!"
            "earned_subtitle2":"Crush"
          }
          {
            "id":"CLIPSUNNY-20"
            "name":"Sunny"
            "status":0
            "level":"$200"
            "earned_title":"Jam on!"
            "earned_subtitle1":"You are rockin' it to $200!"
            "earned_subtitle2":"Sunny"
          }
          {
            "id":"MGRIP-20"
            "name":"Monster Grip"
            "status":0
            "level":"$250"
            "earned_title":"You're Grrreat!"
            "earned_subtitle1":"Check you out &mdash $250 raised!"
            "earned_subtitle2":"Stretch"
          }
          {
            "id":"POPPER-20"
            "name":"Popper"
            "status":0
            "level":"$500"
            "earned_title":"You're Poppin'!"
            "earned_subtitle1":"You're amazing for raising $500!"
            "earned_subtitle2":"Stretch"
          }
          {
            "id":"EARBUDS-20"
            "name":"Earbuds"
            "status":0
            "level":"$1,000"
            "earned_title":"You did it!"
            "earned_subtitle1":"You hit $1,000!"
            "earned_subtitle2":"ear pods that rock like you"
          }
        ]

      giftLevels: -> 
        {
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
  ]
