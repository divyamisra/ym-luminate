angular.module 'trPcApp'
  .factory 'NgPcTeamraiserReportsService', [
    '$rootScope'
    '$http'
    ($rootScope, $http) ->
      getSchoolDetailReport: (prevFrId, prevCompanyId) ->
        requestUrl = 'SPageServer?pagename=getYmKhcSchoolDetailReport&pgwrap=n&fr_id=' + $rootScope.frId
        if prevFrId
          requestUrl += '&prev_fr_id=' + prevFrId
        if prevCompanyId
          requestUrl += '&prev_company_id=' + prevCompanyId
        requestUrl += '&response_format=json'
        $http
          method: 'GET'
          url: requestUrl
        .then (response) ->
          response
          
      getParticipants: (requestData) ->
        dataString = 'method=getParticipants'
        dataString += '&list_page_size=500&list_record_offset=0&team_name=%25%25%25&list_filter_column=team.company_id&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, false, true
          .then (response) ->
            response
  ]
