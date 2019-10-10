angular.module 'ahaLuminateApp'
  .factory 'SchoolLookupService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getSchoolCompanies: (requestData) ->
        requestUrl = '/system/proxy.jsp?__proxyURL=' + encodeURIComponent(luminateExtend.global.path.secure + 'CRTeamraiserAPI')
        if window.location.href.indexOf(luminateExtend.global.path.secure) is 0
          requestUrl = 'CRTeamraiserAPI'
        $http
          method: 'POST'
          url: $sce.trustAsResourceUrl(requestUrl)
          data: 'v=1.0&api_key=' + $rootScope.apiKey + '&response_format=json&suppress_response_codes=true&method=getCompaniesByInfo&event_type=' + encodeURIComponent('High School') + '&' + requestData
          headers:
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      
      getSchoolData: ->
        requestUrl = luminateExtend.global.path.nonsecure
        if window.location.protocol is 'https:'
          requestUrl = luminateExtend.global.path.secure + 'S'
        requestUrl += 'PageServer?pagename=getHighSchoolSearchData&pgwrap=n'
        $http.jsonp($sce.trustAsResourceUrl(requestUrl), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      
      getCreateTeamData: (requestData) ->
        requestUrl = '/system/proxy.jsp?__proxyURL=' + encodeURIComponent(luminateExtend.global.path.secure + 'SPageServer?pagename=ym_coordinator_data&pgwrap=n' + requestData)
        if window.location.href.indexOf(luminateExtend.global.path.secure) is 0
          requestUrl = 'SPageServer?pagename=ym_coordinator_data&pgwrap=n'
        $http
          method: 'GET'
          url: $sce.trustAsResourceUrl(requestUrl)
          headers:
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
  ]