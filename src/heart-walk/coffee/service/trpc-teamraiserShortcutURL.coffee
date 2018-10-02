angular.module 'trPcApp'
  .factory 'TeamraiserShortcutURLService', [
    '$rootScope'
    'LuminateRESTService'
    ($rootScope, LuminateRESTService) ->
      updateShortcut: (requestData,frid) ->
        dataString = 'method=updateShortcut'
        if frid
          dataString = dataString + "&fr_id=" + frid
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, !frid
          .then (response) ->
            response
      
      getShortcut: (frid)->
        dataString = 'method=getShortcut'
        if frid
          dataString = dataString + "&fr_id=" + frid
        LuminateRESTService.teamraiserRequest dataString, true, !frid
          .then (response) ->
            response
      
      updateTeamShortcut: (requestData,frid) ->
        dataString = 'method=updateTeamShortcut'
        if frid
          dataString = dataString + "&fr_id=" + frid
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getTeamShortcut: (frid)->
        dataString='method=getTeamShortcut'
        if frid
          dataString = dataString + "&fr_id=" + frid
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response

      updateCompanyShortcut: (requestData) ->
        dataString = 'method=updateCompanyShortcut&company_id=' + $rootScope.participantRegistration.companyInformation.companyId
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getCompanyShortcut: ->
        dataString = 'method=getCompanyShortcut&company_id=' + $rootScope.participantRegistration.companyInformation.companyId
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
  ]