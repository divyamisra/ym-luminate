angular.module 'ahaLuminateApp'
  .factory 'ZuriService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getChallenges: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/student/challenges/' + requestData + '?key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/student/challenges/' + requestData + '?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      updateChallenge: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/student/challenge/' + requestData + '&key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/student/challenge/' + requestData + '&key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')

          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      logChallenge: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/student/' + requestData + '?key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/student/' + requestData + '?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      getStudent: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/student/' + requestData + '?key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/student/' + requestData + '?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getSchool: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/program/school/' + requestData + '?key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/program/school/' + requestData + '?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getTeam: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/program/team/' + requestData + '?key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/program/team/' + requestData + '?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getProgram: (callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/api/program?key=k7wvZXDpmDpenVcp'
        else
          url = '//hearttools.heart.org/aha_ym19/api/program?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      eCardTracking: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym19_dev/visitlink_record.php?ecard_linktrack=' + requestData
        else
          url = '//hearttools.heart.org/aha_ym19/visitlink_record.php?ecard_linktrack=' + requestData
        $http
          method: 'POST'
          url: $sce.trustAsResourceUrl(url)

      getAvatar: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//khc.staging.ootqa.org/api/student/' + requestData + '/monster-designer'
        else
          url = '//kidsheartchallenge.heart.org/api/student/' + requestData + '/monster-designer'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
  ]
