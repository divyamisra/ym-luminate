angular.module 'ahaLuminateControllers'
  .controller 'GreetingPageCtrl', [
    '$scope'
    '$http'
    '$timeout'
    '$filter'
    'TeamraiserParticipantService'
    'TeamraiserTeamService'
    'TeamraiserCompanyService'
    ($scope, $http, $timeout, $filter, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) ->
      $http.get 'SPageServer?pagename=getTeamraiserInfo&fr_id=' + $scope.frId + '&response_format=json&pgwrap=n'
        .then (response) ->
          teamraiserInfo = response.data.getTeamraiserInfo
          if not teamraiserInfo
            $scope.eventProgress = 
              amountRaised: 0
              goal: 0
          else
            $scope.eventProgress = 
              amountRaised: teamraiserInfo.amountRaised
              goal: teamraiserInfo.goal
          $scope.eventProgress.percent = 2
          $timeout ->
            percent = $scope.eventProgress.percent
            if $scope.eventProgress.goal isnt 0
              percent = Math.ceil(($scope.eventProgress.amountRaised / $scope.eventProgress.goal) * 100)
            if percent < 2
              percent = 2
            if percent > 98
              percent = 98
            $scope.eventProgress.percent = percent
          , 500
      
      $scope.topParticipants = {}
      setTopParticipants = (participants) ->
        $scope.topParticipants.participants = participants
        if not $scope.$$phase
          $scope.$apply()
      TeamraiserParticipantService.getParticipants 'first_name=' + encodeURIComponent('%%%') + '&list_sort_column=total&list_ascending=false', 
        error: ->
          setTopParticipants []
        success: (response) ->
          participants = response.getParticipantsResponse?.participant or []
          if not participants
            setTopParticipants []
          else
            participants = [participants] if not angular.isArray participants
            topParticipants = []
            # TODO: don't include participants with $0 raised
            angular.forEach participants, (participant) ->
              if participant.name?.first
                participant.amountRaised = Number participant.amountRaised
                participant.amountRaisedFormatted = $filter('currency') participant.amountRaised / 100, '$', 0
                topParticipants.push participant
            setTopParticipants topParticipants
      
      $scope.topTeams = {}
      setTopTeams = (teams) ->
        $scope.topTeams.teams = teams
        if not $scope.$$phase
          $scope.$apply()
      TeamraiserTeamService.getTeams 'list_sort_column=total&list_ascending=false', 
        error: ->
          setTopTeams []
        success: (response) ->
          teams = response.getTeamSearchByInfoResponse?.team or []
          if not teams
            setTopTeams []
          else
            teams = [teams] if not angular.isArray teams
            topTeams = []
            # TODO: don't include teams with $0 raised
            angular.forEach teams, (team) ->
              team.amountRaised = Number team.amountRaised
              team.amountRaisedFormatted = $filter('currency') team.amountRaised / 100, '$', 0
              topTeams.push team
            setTopTeams topTeams
      
      $scope.topCompanies = {}
      setTopCompanies = (companies) ->
        $scope.topCompanies.companies = companies
        if not $scope.$$phase
          $scope.$apply()
      TeamraiserCompanyService.getCompanyList 'include_all_companies=true', 
        error: ->
          setTopCompanies []
        success: (response) ->
          companyItems = response.getCompanyListResponse?.companyItem or []
          companyItems = [companyItems] if not angular.isArray companyItems
          rootAncestorCompanies = []
          childCompanyIdMap = {}
          # TODO: don't include companies with $0 raised
          angular.forEach companyItems, (companyItem) ->
            if companyItem.parentOrgEventId is '0'
              rootAncestorCompany =
                eventId: $scope.frId
                companyId: companyItem.companyId
                companyName: companyItem.companyName
                amountRaised: if companyItem.amountRaised then Number(companyItem.amountRaised) else 0
              rootAncestorCompanies.push rootAncestorCompany
          angular.forEach companyItems, (companyItem) ->
            parentOrgEventId = companyItem.parentOrgEventId
            if parentOrgEventId isnt '0'
              childCompanyIdMap['company-' + companyItem.companyId] = parentOrgEventId
          angular.forEach childCompanyIdMap, (value, key) ->
            if childCompanyIdMap['company-' + value]
              childCompanyIdMap[key] = childCompanyIdMap['company-' + value]
          angular.forEach childCompanyIdMap, (value, key) ->
            if childCompanyIdMap['company-' + value]
              childCompanyIdMap[key] = childCompanyIdMap['company-' + value]
          angular.forEach companyItems, (companyItem) ->
            if companyItem.parentOrgEventId isnt '0'
              rootParentCompanyId = childCompanyIdMap['company-' + companyItem.companyId]
              childCompanyAmountRaised = if companyItem.amountRaised then Number(companyItem.amountRaised) else 0
              angular.forEach rootAncestorCompanies, (rootAncestorCompany, rootAncestorCompanyIndex) ->
                if rootAncestorCompany.companyId is rootParentCompanyId
                  rootAncestorCompanies[rootAncestorCompanyIndex].amountRaised = rootAncestorCompanies[rootAncestorCompanyIndex].amountRaised + childCompanyAmountRaised
          angular.forEach rootAncestorCompanies, (rootAncestorCompany, rootAncestorCompanyIndex) ->
            rootAncestorCompanies[rootAncestorCompanyIndex].amountRaisedFormatted = $filter('currency') rootAncestorCompany.amountRaised / 100, '$', 0
          setTopCompanies $filter('orderBy') rootAncestorCompanies, 'amountRaised', true
  ]