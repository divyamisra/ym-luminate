angular.module 'ahaLuminateApp'
  .factory 'CatalogService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getSchoolData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ym22_dev/api/school/' + requestData + '/meta?key=k7wvZXDpmDpenVcp'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ym22_testing/api/school/' + requestData + '/meta?key=k7wvZXDpmDpenVcp'
        else
          url = '//tools.heart.org/aha_ym22/api/school/' + requestData + '/meta?key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response

      updateSchoolData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ym22_dev/api/school/' + requestData + '&key=k7wvZXDpmDpenVcp'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ym22_testing/api/school/' + requestData + '&key=k7wvZXDpmDpenVcp'
        else
          url = '//tools.heart.org/aha_ym22/api/school/' + requestData + '&key=XgUnZxvFcjZ4jEMT'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
            
  ]
