angular.module 'ahaLuminateApp'
  .factory 'NuclavisService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      login: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://smt.nuclavis.com/client/login'
        else
          url = 'https://smt-api.heart.org/client/login'
        $http.post($sce.trustAsResourceUrl(url), JSON.stringify({"username": "aha_api","password": "AgP*09g8Iuqr","client": "khc"}))
          .then (response) ->
            response.data.data.jwt
          , (response) ->
            response

      getBadges: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev'
            url = 'https://smt.nuclavis.com/khc/student/missions/' + requestData
          else
            url = 'https://smt-api.heart.org/khc/student/missions/' + requestData
          reqHeader = 
            'Content-Type': 'application/json'
            'Authorization': 'Bearer ' + $rootScope.NuclavisAPIToken
          $http.get($sce.trustAsResourceUrl(url), {headers: reqHeader})
            .then (response) ->
              response.data
            , (response) ->
              response
        , (response) ->
          $rootScope.NuclavisAPIToken = 0;

      getGifts: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev'
            url = 'https://smt.nuclavis.com/khc/student/gifts/' + requestData
          else
            url = 'https://smt-api.heart.org/khc/student/gifts/' + requestData
          reqHeader = 
            'Content-Type': 'application/json'
            'Authorization': 'Bearer ' + $rootScope.NuclavisAPIToken
          $http.get($sce.trustAsResourceUrl(url), {headers: reqHeader})
            .then (response) ->
              response.data
            , (response) ->
              response
        , (response) ->
          $rootScope.NuclavisAPIToken = 0;

      postAction: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev'
            url = 'https://smt.nuclavis.com/khc/student/actions/' + requestData
          else
            url = 'https://smt-api.heart.org/khc/student/actions/' + requestData
          reqHeader = 
            'Content-Type': 'application/json'
            'Authorization': 'Bearer ' + $rootScope.NuclavisAPIToken
          $http.post($sce.trustAsResourceUrl(url), {}, {headers: reqHeader})
            .then (response) ->
              response.data
            , (response) ->
              response
        , (response) ->
          $rootScope.NuclavisAPIToken = 0;
      defaultStandardGifts: ->
        [
          {
            "id":"KTWB-23"
            "name":"Wristband"
            "status":0
            "level":"Wristband"
            "msg_earned":"Registration Completed"
            "msg_unearned":"Complete Registration"
            "instant": 1
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 0
          }
          {
            "id":"HEARTY-23"
            "name":"Hearty"
            "status":0
            "level":"$5"
            "msg_earned":"$5 Raised"
            "msg_unearned":"Raise $5"
            "instant": 1
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"LVL1WB-18"
            "name":"Water Bottle"
            "status":0
            "level":"$5"
            "msg_earned":"$5 Raised"
            "msg_unearned":"Raise $5"
            "instant": 0
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 0
          }
          {
            "id":"BREEZE-23"
            "name":"Breeze"
            "status":0
            "level":"$10"
            "msg_earned":"$10 Raised"
            "msg_unearned":"Raise $10"
            "instant": 1
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"JR-23"
            "name":"Jump Rope"
            "status":0
            "level":"$15"
            "msg_earned":"$15 Raised"
            "msg_unearned":"Raise $15"
            "instant": 1
            "online_only":0
            "video": ""
            "post_event":1
            "vucheck": 0
          }
          {
            "id":"HYDRO-23"
            "name":"Hydro"
            "status":0
            "level":"$25"
            "msg_earned":"$25 Raised"
            "msg_unearned":"Raise $25"
            "instant": 1
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"DREAM-23"
            "name":"Dream"
            "status":0
            "level":"$40"
            "msg_earned":"$40 Raised"
            "msg_unearned":"Raise $40"
            "instant": 1
            "online_only":0
            "video": "https://vimeo.com/americanheartassociation/review/453777085/ab8611f4ce"
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"KHC"
            "name":"T-Shirt"
            "status":0
            "level":"$50"
            "msg_earned":"$50 Raised"
            "msg_unearned":"Raise $50"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":1
            "vucheck": 0
          }
          {
            "id":"PBALL-23"
            "name":"Playground Ball"
            "status":0
            "level":"$75"
            "msg_earned":"$75 Raised"
            "msg_unearned":"Raise $75"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":1
            "vucheck": 0
          }
          {
            "id":"MARLEY-23"
            "name":"Marley"
            "status":0
            "level":"$100"
            "msg_earned":"$100 Raised"
            "msg_unearned":"Raise $100"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"FRANKIE-23"
            "name":"Frankie"
            "status":0
            "level":"$150"
            "msg_earned":"$150 Raised"
            "msg_unearned":"Raise $150"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"BAXTER-23"
            "name":"Baxter"
            "status":0
            "level":"$200"
            "msg_earned":"$200 Raised"
            "msg_unearned":"Raise $200"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"SOCKS-23"
            "name":"Socks"
            "status":0
            "level":"$250"
            "msg_earned":"$250 Raised"
            "msg_unearned":"Raise $250"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":1
            "vucheck": 0
          }
          {
            "id":"FP-23"
            "name":"Mystery Popper"
            "status":0
            "level":"$500"
            "msg_earned":"$500 Raised"
            "msg_unearned":"Raise $500"
            "instant": 2
            "online_only":0
            "video": "https://vimeo.com/americanheartassociation/review/453776957/cde52d6c23"
            "post_event":1
            "vucheck": 0
          }
          {
            "id":"WATCH-23"
            "name":"Watch"
            "status":0
            "level":"$1,000"
            "msg_earned":"$1,000 Raised"
            "msg_unearned":"Raise $1,000"
            "instant": 2
            "online_only":0
            "video": "https://video.link/w/On7X"
            "post_event":1
            "vucheck": 0
          }
          {
            "id":"FINN-23"
            "name":"Finn's Lifesaver Award"
            "status":0
            "level":"Complete Finn's Mission"
            "msg_earned":"Finn's Mission Completed"
            "msg_unearned":"Complete Finn's Mission"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 1
          }
          {
            "id":"CHARM-23"
            "name":"Mystery Gift"
            "status":0
            "level":"Every $50"
            "msg_earned":"Every $50 Raised<br/><em>Students can earn up to 20 Mystery Gifts</em>"
            "msg_unearned":"Every $50 Raised<br/><em>Students can earn up to 20 Mystery Gifts</em>"
            "instant": 2
            "online_only":0
            "video": ""
            "post_event":0
            "vucheck": 0
          }
        ]

      giftLevels_instant: -> 
        [
          "KTWB-23"
          "HEARTY-23"
          "BREEZE-23"
          "JR-23"
          "HYDRO-23"
          "DREAM-23"
          "KHC"
          "PBALL-23"
          "MARLEY-23"
          "BAXTER-23"         
          "SOCKS-23"
          "FP-23"
          "WATCH-23"
          "FINN-23"
          "CHARM-23"
        ]

      giftLevels_noninstant: -> 
        [
          "LVL1WB-18"
          "JR-23"
          "KHC"
          "SOCKS-23"
          "FP-23"
          "WATCH-23"
        ]

      giftLevels_instant_earned: -> 
        {
          "$0": [
            "KTWB-23"
          ]
          "$5-$14":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
          ]
          "$15-$24":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
          ]
          "$25-$39":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
          ]
          "$40-$49":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
          ]
          "$50-$74":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "CHARM-23"
          ]
          "Green $75-$99":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "PBALL-23"
            "CHARM-23"
          ]
          "Blue $100-$199":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "PBALL-23"
            "MARLEY-23"
            "CHARM-23"
          ]
          "Red $200-$249":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "PBALL-23"
            "MARLEY-23"
            "BAXTER-23"
            "CHARM-23"
          ]
          "Orange $250-$499":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "PBALL-23"
            "MARLEY-23"
            "BAXTER-23"
            "SOCKS-23"
            "CHARM-23"
          ]
          "Brown $500-$999":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "PBALL-23"
            "MARLEY-23"
            "BAXTER-23"
            "SOCKS-23"
            "FP-23"
            "CHARM-23"
          ]
          "Yellow $1000+":[
            "KTWB-23"
            "HEARTY-23"
            "BREEZE-23"
            "JR-23"
            "HYDRO-23"
            "DREAM-23"
            "KHC"
            "PBALL-23"
            "MARLEY-23"
            "BAXTER-23"
            "SOCKS-23"
            "FP-23"
            "WATCH-23"
            "CHARM-23"
          ]
        }
      giftLevels_noninstant_earned: -> 
        {
          "$0": [
          ]
          "$5-$14":[
            "LVL1WB-18"
          ]
          "$15-$24":[
            "LVL1WB-18"
            "JR-23"
          ]
          "$25-$39":[
            "LVL1WB-18"
            "JR-23"
          ]
          "$40-$49":[
            "LVL1WB-18"
            "JR-23"
          ]
          "$50-$74":[
            "LVL1WB-18"
            "JR-23"
            "KHC"
          ]
          "Green $75-$99":[
            "LVL1WB-18"
            "JR-23"
            "KHC"
            "PBALL-23"
          ]
          "Blue $100-$199":[
            "LVL1WB-18"
            "JR-23"
            "KHC"
          ]
          "Red $200-$249":[
            "LVL1WB-18"
            "JR-23"
            "KHC"
          ]
          "Orange $250-$499":[
            "LVL1WB-18"
            "JR-23"
            "KHC"
            "SOCKS-23"
          ]
          "Brown $500-$999":[
            "LVL1WB-18"
            "JR-23"
            "KHC"
            "SOCKS-23"
            "FP-23"
          ]
          "Yellow $1000+":[
            "LVL1WB-18"
            "JR-22"
            "KHC"
            "SOCKS-23"
            "FP-23"
            "WATCH-23"
          ]
        }
  ]
