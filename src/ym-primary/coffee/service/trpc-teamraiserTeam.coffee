angular.module 'trPcApp'
  .factory 'NgPcTeamraiserTeamService', [
    '$rootScope'
    'NgPcLuminateRESTService'
    ($rootScope, NgPcLuminateRESTService) ->
      getTeams: (requestData) ->
        dataString = 'method=getTeamsByInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, false, true
          .then (response) ->
            response
      
      getTeam: ->
        this.getTeams 'team_id=' + $rootScope.participantRegistration.teamId
      
      joinTeam: (requestData) ->
        dataString = 'method=joinTeam'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      leaveTeam: ->
        NgPcLuminateRESTService.teamraiserRequest 'method=leaveTeam', true, true
          .then (response) ->
            response
      
      updateTeamInformation: (requestData) ->
        dataString = 'method=updateTeamInformation'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      setTeamCaptains: ->
        NgPcLuminateRESTService.teamraiserRequest 'method=setTeamCaptains', true, true
          .then (response) ->
            response
      
      getTeamCaptains: ->
        NgPcLuminateRESTService.teamraiserRequest 'method=getTeamCaptains', false, true
          .then (response) ->
            response
      
      updateCaptainsMessage: (requestData) ->
        dataString = 'method=updateCaptainsMessage'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
  ]