angular.module 'ahaLuminateApp'
  .factory 'BoundlessService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getBadges: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://dhc.staging.ootqa.org/api/badges/student/' + requestData) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        else
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://districtheartchallenge.heart.org/api/badges/student/' + requestData) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        $http
          method: 'GET'
          url: url
          headers:
            'Content-Type': 'application/json'
      
      getRollupTotals: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '/system/proxy.jsp?__proxyURL=' + encodeURIComponent('https://dhc.staging.ootqa.org/api/schools/totals')
        else
          url = '/system/proxy.jsp?__proxyURL=' + encodeURIComponent('https://districtheartchallenge.heart.org/api/schools/totals')
        $http
          method: 'GET'
          url: url
          headers:
            'Content-Type': 'application/json'
      
      getRollupTotals: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'https://dhc.staging.ootqa.org/api/schools/totals'
        else
          url = 'https://districtheartchallenge.heart.org/api/schools/totals'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      getDistrictRollupTotals: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://dhc.staging.ootqa.org/api/schools/totals/' + requestData) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        else
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://districtheartchallenge.heart.org/api/schools/totals/' + requestData) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        $http
          method: 'GET'
          url: url
          headers:
            'Content-Type': 'application/json'
      
      logEmailSent: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://dhc.staging.ootqa.org/api/webhooks/student/emails-sent/' + $rootScope.frId + '/' + $rootScope.consId) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        else
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://districtheartchallenge.heart.org/api/webhooks/student/emails-sent/' + $rootScope.frId + '/' + $rootScope.consId) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        $http
          url: url
          headers:
            'Content-Type': 'application/json'
      
      logPersonalPageUpdated: ->
        if $rootScope.tablePrefix is 'heartdev'
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://dhc.staging.ootqa.org/api/webhooks/student/personal-page-updated/' + $rootScope.frId + '/' + $rootScope.consId) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        else
          url = 'AjaxProxy?cnv_url=' + encodeURIComponent('https://districtheartchallenge.heart.org/api/webhooks/student/personal-page-updated/' + $rootScope.frId + '/' + $rootScope.consId) + '&auth=' + luminateExtend.global.ajaxProxyAuth
        $http
          url: url
          headers:
            'Content-Type': 'application/json'
  ]
