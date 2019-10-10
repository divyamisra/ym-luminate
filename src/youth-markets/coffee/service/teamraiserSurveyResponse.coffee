angular.module 'ahaLuminateApp'
  .factory 'TeamraiserSurveyResponseService', [
    'LuminateRESTService'
    (LuminateRESTService) ->
      getSurveyResponses: (requestData) ->
        dataString = 'method=getSurveyResponses&use_filters=true'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      updateSurveyResponses: (requestData) ->
        dataString = 'method=updateSurveyResponses'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, true, true
          .then (response) ->
            response
  ]
