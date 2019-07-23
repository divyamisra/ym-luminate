angular.module 'trPcApp'
  .factory 'NgPcTeamraiserCompanyService', [
    '$rootScope'
    'NgPcLuminateRESTService'
    ($rootScope, NgPcLuminateRESTService) ->
      getCompanyList: (requestData, callback) ->
        dataString = 'method=getCompanyList'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, false, true
          .then (response) ->
            response
      
      getCompanies: (requestData) ->
        dataString = 'method=getCompaniesByInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        NgPcLuminateRESTService.teamraiserRequest dataString, false, false
          .then (response) ->
            response
      
      getCompany: ->
        this.getCompanies 'fr_id=' + $rootScope.frId + '&company_id=' + $rootScope.participantRegistration.companyInformation.companyId
          .then (response) ->
            companies = response.data.getCompaniesResponse?.company
            if not companies
              $rootScope.companyInfo = -1
            else
              companies = [companies] if not angular.isArray companies
              company = companies[0]
              participantCount = company.participantCount
              if participantCount and participantCount isnt ''
                company.participantCount = Number participantCount
              teamCount = company.teamCount
              if teamCount and teamCount isnt ''
                company.teamCount = Number teamCount
              $rootScope.companyInfo = company
            response
 
      getSchoolDates: (requestData) ->
        requestUrl = luminateExtend.global.path.nonsecure
        if window.location.protocol is 'https:'
          requestUrl = luminateExtend.global.path.secure + 'S'
        requestUrl += 'PageServer?pagename=reus_ym_school_dates_csv&evid='+$rootScope.frId+'&pgwrap=n'
        $http.jsonp($sce.trustAsResourceUrl(requestUrl), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
  ]
