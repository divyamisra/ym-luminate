angular.module 'trPcApp'
  .factory 'NgPcConstituentService', [
    'NgPcLuminateRESTService'
    (NgPcLuminateRESTService) ->
      updateUserRecord: (requestData) ->
        dataString = 'method=update'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.consRequest dataString, true
          .then (response) ->
            response

  ]
