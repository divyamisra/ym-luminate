angular.module 'ahaLuminateApp'
  .factory 'NuclavisService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      login: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
          url = 'https://smt.nuclavis.com/client/login'
          loginParams = {"username": "aha_api","password": "AgP*09g8Iuqr","client": "ahc"}
        else
          url = 'https://smt-api.heart.org/client/login'
          loginParams = {"username": "hq_api","password": "IzRVR1#cdsxWm48%","client": "ahc"}
        $http.post($sce.trustAsResourceUrl(url), JSON.stringify(loginParams))
          .then (response) ->
            response.data.data.jwt
          , (response) ->
            response

      getBadges: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/missions/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/missions/' + requestData
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
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/gifts/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/gifts/' + requestData
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

      getTeachers: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/teachers/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/teachers/' + requestData
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

      getMissionCount: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/missionCount/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/missionCount/' + requestData
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

      getReRegister: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/reregister/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/reregister/' + requestData
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

      postReRegister: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/reregister/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/reregister/' + requestData
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

      deleteReRegister: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/reregister/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/reregister/' + requestData
          reqHeader = 
            'Content-Type': 'application/json'
            'Authorization': 'Bearer ' + $rootScope.NuclavisAPIToken
          $http.delete($sce.trustAsResourceUrl(url), {data: {}, headers: reqHeader})
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
          if $rootScope.tablePrefix is 'heartdev' or $rootScope.tablePrefix is 'heartnew'
            url = 'https://smt.nuclavis.com/ahc/student/actions/' + requestData
          else
            url = 'https://smt-api.heart.org/ahc/student/actions/' + requestData
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
  ]
