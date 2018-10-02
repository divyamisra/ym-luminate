angular.module 'ahaLuminateApp'
  .factory 'TeamraiserCompanyService', [
    'LuminateRESTService'
    '$http'
    '$filter'
    (LuminateRESTService, $http, $filter) ->
      companyTree = {}
      
      getCompanies = (requestData, callback) ->
        dataString = 'method=getCompaniesByInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, false, true, callback
      
      getCompanyList = (requestData, callback) ->
        dataString = 'method=getCompanyList'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.luminateExtendTeamraiserRequest dataString, false, true, callback
      
      getCompanyTree = (companyId, childCompanies, callback) ->
        if companyTree[companyId]
          callback.success companyTree[companyId]
          return
        getCompanyList 'include_all_companies=true',
          error: ->
            callback.success {}
          success: (response) ->
            companyItems = response.getCompanyListResponse?.companyItem or []
            companyItems = [companyItems] if not angular.isArray companyItems
            hits = []
            hits.push companyId.toString()
            root =
              companyId: null
              companyName: ''
              amountRaised: 0
              teamCount: 0
              participantCount: 0
            angular.forEach childCompanies, (childCompany) ->
              hits.push childCompany.id
            angular.forEach companyItems, (companyItem) ->
              if hits.indexOf(companyItem.companyId) > -1
                root.amountRaised = root.amountRaised + (if companyItem.amountRaised then Number(companyItem.amountRaised) else 0)
                if companyItem.companyId is companyId
                  root.companyId = companyId
                  root.companyName = companyItem.companyName
            getCompanies 'list_sort_column=total&list_ascending=false&list_page_size=500',
              error: ->
                callback.success {}
              success: (response) ->
                companies = response.getCompaniesResponse?.company or []
                companies = [companies] if not angular.isArray companies
                angular.forEach companies, (company) ->
                  if hits.indexOf(company.companyId) > -1
                    root.teamCount = root.teamCount + (if company.teamCount then Number(company.teamCount) else 0)
                    root.participantCount = root.participantCount + (if company.participantCount then Number(company.participantCount) else 0)
                root.amountRaisedFormatted = $filter('currency') root.amountRaised / 100, '$', 0
                companyTree[companyId] = root
                callback.success companyTree[companyId]
      
      {
        getCompanies: getCompanies
        getCompanyList: getCompanyList
        getCompanyTree: getCompanyTree
        getCoordinatorQuestion: (coordinatorId, eventId) ->
          requestUrl = luminateExtend.global.path.nonsecure
          if window.location.protocol == 'https:'
            requestUrl = luminateExtend.global.path.secure + 'S'
          requestUrl += 'PageServer?pagename=ym_coordinator_data&pgwrap=n'
          $http
            method: 'GET'
            url: requestUrl + '&consId=' + coordinatorId + '&frId=' + eventId
          .then (response) ->
            response
      }
  ]
