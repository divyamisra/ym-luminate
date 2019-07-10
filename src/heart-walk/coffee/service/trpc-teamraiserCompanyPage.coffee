angular.module 'trPcApp'
  .factory 'TeamraiserCompanyPageService', [
    '$rootScope'
    'LuminateRESTService'
    ($rootScope, LuminateRESTService) ->      
      getCompanyPhoto: (callback) ->
        LuminateRESTService.luminateExtendTeamraiserRequest 'method=getCompanyPhoto', true, true, callback

      getCompanyPageInfo: (callback) ->
        LuminateRESTService.luminateExtendTeamraiserRequest 'method=getCompanyPageInfo', true, true, callback

      updateCompanyPageInfo: (requestData, callback) ->
        dataString = 'method=updateCompanyPageInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, true, true, callback
  ]