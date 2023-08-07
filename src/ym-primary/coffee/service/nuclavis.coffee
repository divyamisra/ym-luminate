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

      getTeachers: (requestData) ->
        this.login()
        .then (response) ->
          $rootScope.NuclavisAPIToken = response
          if $rootScope.tablePrefix is 'heartdev'
            url = 'https://smt.nuclavis.com/khc/student/teachers/' + requestData
          else
            url = 'https://smt-api.heart.org/khc/student/teachers/' + requestData
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
  ]
