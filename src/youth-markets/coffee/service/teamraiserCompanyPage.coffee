angular.module 'ahaLuminateApp'
  .factory 'TeamraiserCompanyPageService', [
    '$scope'
    '$rootScope'
    'LuminateRESTService'
    ($scope, $rootScope, LuminateRESTService) ->
      getCompanyPhoto: (callback) ->
        LuminateRESTService.luminateExtendTeamraiserRequest 'method=getCompanyPhoto', true, true, callback
      
      updateCompanyPageInfo: (requestData, callback) ->
        dataString = 'method=updateCompanyPageInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, true, true, callback
        
      getSchoolDates: (requestData) ->
        requestUrl = luminateExtend.global.path.nonsecure
        if window.location.protocol is 'https:'
          requestUrl = luminateExtend.global.path.secure + 'S'
        requestUrl += 'PageServer?pagename=reus_ym_school_dates_csv&evid='+$scope.frId+'&pgwrap=n'
        $http.jsonp($sce.trustAsResourceUrl(requestUrl), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
      

  ]
