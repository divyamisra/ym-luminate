angular.module 'trPcApp'
  .factory 'TeamraiserFundraisingResultsService', [
    'LuminateRESTService'
    (LuminateRESTService) ->
      getFundraisingResults: ->
        LuminateRESTService.teamraiserRequest 'method=getFundraisingResults', false, true
          .then (response) ->
            response
  ]
