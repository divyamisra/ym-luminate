angular.module 'ahaLuminateApp'
  .factory 'ZuriService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getMinutes: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_dhc19_dev/participant/minutes/' + requestData + '?key=C33us10laQtdgmao'
        else
          url = '//hearttools.heart.org/aha_dhc19/participant/minutes/' + requestData + '?key=0IdYItgsFqhpFyEG'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      logMinutes: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_dhc19_dev/participant/update/' + requestData + '&key=C33us10laQtdgmao'
        else
          url = '//hearttools.heart.org/aha_dhc19/participant/update/' + requestData + '&key=0IdYItgsFqhpFyEG'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      getDistrictTeams: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_dhc19_dev/group/company/' + requestData + '?key=C33us10laQtdgmao'
        else
          url = '//hearttools.heart.org/aha_dhc19/group/company/' + requestData + '?key=0IdYItgsFqhpFyEG'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getDistrictParticipants: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_dhc19_dev/group/company/' + requestData + '?group_by=constituent&key=C33us10laQtdgmao'
        else
          url = '//hearttools.heart.org/aha_dhc19/group/company/' + requestData + '?group_by=constituent&key=0IdYItgsFqhpFyEG'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getTeamParticipants: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//hearttools.heart.org/aha_dhc19_dev/group/team/' + requestData + '?group_by=constituent&key=C33us10laQtdgmao'
        else
          url = '//hearttools.heart.org/aha_dhc19/group/team/' + requestData + '?group_by=constituent&key=0IdYItgsFqhpFyEG'
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
          url = '//hearttools.heart.org/aha_dhc19_dev/group/?key=C33us10laQtdgmao'
        else
          url = '//hearttools.heart.org/aha_dhc19/group/?key=0IdYItgsFqhpFyEG'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
  ]
