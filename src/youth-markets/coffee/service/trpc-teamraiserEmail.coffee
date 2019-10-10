angular.module 'trPcApp'
  .factory 'NgPcTeamraiserEmailService', [
    '$rootScope'
    'NgPcLuminateRESTService'
    ($rootScope, NgPcLuminateRESTService) ->
      addDraft: (requestData) ->
        dataString = 'method=addDraft'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      updateDraft: (requestData) ->
        dataString = 'method=updateDraft'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      deleteDraft: (requestData) ->
        dataString = 'method=deleteDraft'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getDrafts: (requestData) ->
        dataString = 'method=getDrafts'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getDraft: (requestData) ->
        dataString = 'method=getDraft'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      deleteSentMessage: (requestData) ->
        dataString = 'method=deleteSentMessage'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getSentMessages: (requestData) ->
        dataString = 'method=getSentMessages'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getSentMessage: (requestData) ->
        dataString = 'method=getSentMessage'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getMessageLayouts: ->
        NgPcLuminateRESTService.teamraiserRequest 'method=getMessageLayouts', true, true
          .then (response) ->
            response
      
      getSuggestedMessages: ->
        NgPcLuminateRESTService.teamraiserRequest 'method=getSuggestedMessages', true, true
          .then (response) ->
            response
      
      getSuggestedMessage: (requestData) ->
        dataString = 'method=getSuggestedMessage'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      previewMessage: (requestData) ->
        dataString = 'method=previewMessage&s_trID=' + $rootScope.frId + '&s_participantConsID=' + $rootScope.consId
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      sendMessage: (requestData) ->
        dataString = 'method=sendTafMessage&s_trID=' + $rootScope.frId + '&s_participantConsID=' + $rootScope.consId
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
  ]