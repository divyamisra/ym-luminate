angular.module 'ahaLuminateApp'
  .factory 'ZuriService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getChallenges: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym18_dev/api/student/challenges/' + requestData + '?key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/student/challenges/' + requestData + '?key=6Mwqh5dFV39HLDq7'
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
          url = '//hearttools.heart.org/aha_ym18_dev/api/student/challenge/' + requestData + '&key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/student/challenge/' + requestData + '&key=6Mwqh5dFV39HLDq7'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')

          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      logChallenge: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym18_dev/api/student/' + requestData + '?key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/student/' + requestData + '?key=6Mwqh5dFV39HLDq7'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      getStudent: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_ym18_dev/api/student/' + requestData + '?key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/student/' + requestData + '?key=6Mwqh5dFV39HLDq7'
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
          url = '//hearttools.heart.org/aha_ym18_dev/api/program/school/' + requestData + '?key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/program/school/' + requestData + '?key=6Mwqh5dFV39HLDq7'
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
          url = '//hearttools.heart.org/aha_ym18_dev/api/program/team/' + requestData + '?key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/program/team/' + requestData + '?key=6Mwqh5dFV39HLDq7'
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
          url = '//hearttools.heart.org/aha_ym18_dev/api/program?key=6Mwqh5dFV39HLDq7'
        else
          url = '//hearttools.heart.org/aha_ym18/api/program?key=6Mwqh5dFV39HLDq7'
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
          url = '//hearttools.heart.org/aha_ym18_dev/visitlink_record.php?ecard_linktrack=' + requestData
        else
          url = '//hearttools.heart.org/aha_ym18/visitlink_record.php?ecard_linktrack=' + requestData
        $http
          method: 'POST'
          url: $sce.trustAsResourceUrl url

      getAvatar: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//jumphoopsstaging.boundlessnetwork.com/api/student/' + requestData + '/monster-designer'
        else
          url = '//jumphoops.heart.org/api/student/' + requestData + '/monster-designer'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
  ]