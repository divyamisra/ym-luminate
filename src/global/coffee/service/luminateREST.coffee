angular.module 'ahaLuminateApp'
  .factory 'LuminateRESTService', [
    '$rootScope'
    '$http'
    'APP_INFO'
    ($rootScope, $http, APP_INFO) ->
      request: (apiServlet, requestData, includeAuth, includeFrId) ->
        if not requestData
          # TODO
        else
          if not $rootScope.apiKey
            # TODO
          else
            requestData += '&v=1.0&api_key=' + $rootScope.apiKey + '&response_format=json&suppress_response_codes=true'
            if includeAuth and not $rootScope.authToken
              # TODO
            else
              if includeAuth
                requestData += '&auth=' + $rootScope.authToken
              if includeFrId and $rootScope.frId and $rootScope.frId isnt ''
                requestData += '&fr_id=' + $rootScope.frId + '&s_trID=' + $rootScope.frId
              $http
                method: 'POST'
                url: apiServlet
                data: requestData
                headers:
                  'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
              .then (response) ->
                response
      
      luminateExtendRequest: (apiServlet, requestData, includeAuth, includeFrId, callback) ->
        if not luminateExtend
          # TODO
        else
          if not requestData
            # TODO
          else
            if includeFrId and $rootScope.frId
              requestData += '&fr_id=' + $rootScope.frId + '&s_trID=' + $rootScope.frId
            luminateExtend.api 
              api: apiServlet
              data: requestData
              requiresAuth: includeAuth
              callback: callback or angular.noop
      
      teamraiserRequest: (requestData, includeAuth, includeFrId) ->
        this.request 'CRTeamraiserAPI', requestData, includeAuth, includeFrId
      
      luminateExtendTeamraiserRequest: (requestData, includeAuth, includeFrId, callback) ->
        this.luminateExtendRequest 'teamraiser', requestData, includeAuth, includeFrId, callback
      
      consRequest: (requestData, includeAuth) ->
        this.request 'CRConsAPI', requestData, includeAuth, false

      donationRequest: (requestData) ->
        this.request 'CRDonationAPI', requestData
      
      luminateExtendConsRequest: (requestData, includeAuth, callback) ->
        this.luminateExtendRequest 'cons', requestData, includeAuth, false, callback
  ]