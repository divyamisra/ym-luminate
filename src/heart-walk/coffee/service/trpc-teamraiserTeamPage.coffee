angular.module 'trPcApp'
  .factory 'TeamraiserTeamPageService', [
    '$rootScope'
    'LuminateRESTService'
    ($rootScope, LuminateRESTService) -> 
      getTeamPhoto: (callback) ->
        LuminateRESTService.luminateExtendTeamraiserRequest 'method=getTeamPhoto', true, true, callback
      
      getTeamPageInfo: (callback) ->
        LuminateRESTService.luminateExtendTeamraiserRequest 'method=getTeamPageInfo', true, true, callback

      updateTeamPageInfo: (requestData, callback) ->
        dataString = 'method=updateTeamPageInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, true, true, callback
  ]