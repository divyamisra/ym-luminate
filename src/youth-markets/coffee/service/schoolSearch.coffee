angular.module 'ahaLuminateApp'
  .factory 'SchoolSearchService', [
    '$filter'
    'TeamraiserCompanyService'
    'SchoolLookupService'
    'ZuriService'
    ($filter, TeamraiserCompanyService, SchoolLookupService, ZuriService) ->
      init: ($scope, eventType, getLoc) ->
        $scope.schoolList =
          searchSubmitted: false
          searchPending: false
          searchByLocation: false
          geoLocationEnabled: false
          sortProp: 'SCHOOL_NAME'
          sortDesc: false
          totalItems: 0
          currentPage: 1
          paginationItemsPerPage: 5
          paginationMaxSize: 5
          nameFilter: ''
          ng_nameFilter: ''
          stateFilter: ''
          showHelp: false
        $scope.schoolListByState = {}
        $scope.schoolDataMap = {}
        $scope.schoolDataMapByState = {}
        $scope.searchError = false;
        
        #
        # New Geo Locate code for KHC
        filterGeoSchoolData = (e) ->
          SchoolLookupService.getStateByLocation e,
            failure: (response) ->
            success: (response) ->
              delete $scope.schoolList.schools
              if response.data.company.schoolData != null
                $scope.schoolList.stateFilter = response.data.company.schoolData.state
                $scope.schoolList.searchPending = true
                $scope.schoolList.searchSubmitted = true
                $scope.schoolList.searchByLocation = true
                $scope.schoolList.geoLocationEnabled = true
                $scope.getSchoolSearchResults(true)
                #SchoolLookupService.getGeoSchoolData e,
                #  failure: (response) ->
                #  success: (response) ->
                #    showSchoolSearchResults(response)
              else
                $scope.schoolList.searchPending = false
                $scope.schoolList.searchErrorMessage = 'No schools found matching the specified search criteria.'
  
        # gelocate call error
        showGEOError = (e) ->
          $scope.schoolList.searchPending = false
          switch e.code
            when e.PERMISSION_DENIED
              $scope.schoolList.searchErrorMessage = 'User denied the request for Geolocation or not in https. Try Again.'
            when e.POSITION_UNAVAILABLE
              $scope.schoolList.searchErrorMessage = 'Location information is currently unavailable. Try Again.'
            when e.TIMEOUT
              $scope.schoolList.searchErrorMessage = 'The request to get location timed out. Please refresh the page to use this feature.'
            when e.UNKNOWN_ERROR
              $scope.schoolList.searchErrorMessage = 'An unknown error occurred. Try Again.'
          return

        # ask or retrieve current lat/long
        $scope.getLocation = ->
          e = 
            enableHighAccuracy: !0
            timeout: 1e4
            maximumAge: 'infinity'
          if navigator.geolocation then navigator.geolocation.getCurrentPosition(filterGeoSchoolData, showGEOError, e) else console.log('Geolocation is not supported by this browser.')
          return

        # if getLoc is passed as true
        # ask for geolocation and load all schools within 10 miles of geolocation
        if getLoc is true
           $scope.schoolList.geoLocationEnabled = true
        #  $scope.getLocation()
        
        $scope.filterByLocation = ->
          nameFilter = jQuery.trim $scope.schoolList.ng_nameFilter
          $scope.schoolList.nameFilter = nameFilter
          if not nameFilter
            $scope.schoolList.searchErrorMessage = 'Please specify a search criteria before initiating a search.'
          else
            delete $scope.schoolList.searchErrorMessage
            $scope.schoolList.searchPending = true
            $scope.schoolList.searchSubmitted = true
            $scope.schoolList.searchByLocation = true
            getLocation()
        
        #get school data with getSchoolDataNew service call
        $scope.getSchoolSearchResultsNew = ->
          delete $scope.schoolList.schools
          $scope.schoolList.searchPending = true
          $scope.schoolList.currentPage = 1
          nameFilter = $scope.schoolList.nameFilter or '%'
          stateFilter = ''
          if $scope.schoolList.stateFilter isnt ''
            stateFilter = $scope.schoolList.stateFilter
          SchoolLookupService.getSchoolDataNew '&name=' + encodeURIComponent(nameFilter) + '&state=' + encodeURIComponent(stateFilter),
            failure: (response) ->
            success: (response) ->
              showSchoolSearchResults(response)

        #display school date retrieved
        showSchoolSearchResults = (response) ->
              totalNumberResults = 0
              schoolDataRows = response.data.company.schoolData
              schools = []
              angular.forEach schoolDataRows, (schoolDataRow, schoolDataRowIndex) ->
                totalNumberResults++
                schools.push
                  FR_ID: schoolDataRow['fr_id']
                  SCHOOL_NAME: schoolDataRow['name']
                  SCHOOL_ID: schoolDataRow['school_id']
                  COMPANY_ID: schoolDataRow['school_id']
                  SCHOOL_CITY: schoolDataRow['city']
                  SCHOOL_STATE: schoolDataRow['state']
                  COORDINATOR_FIRST_NAME: schoolDataRow['coord_first']
                  COORDINATOR_LAST_NAME: schoolDataRow['coord_last']
              $scope.schoolList.totalNumberResults = totalNumberResults
              $scope.schoolList.totalItems = totalNumberResults
              $scope.schoolList.schools = schools
              # setResults()
              $scope.schoolList.searchSubmitted = true
              delete $scope.schoolList.searchPending
              updateCompanyData()

        # run search when submit button clicked
        $scope.submitSchoolSearchNew = ->
          nameFilter = jQuery.trim $scope.schoolList.ng_nameFilter
          $scope.schoolList.nameFilter = nameFilter
          $scope.schoolList.stateFilter = ''
          $scope.schoolList.searchSubmitted = true
          $scope.schoolList.searchByLocation = false
          # if not nameFilter or nameFilter.length < 3
          if false
            $scope.schoolList.searchErrorMessage = 'Please enter at least 3 characters to search for.'
          else
            delete $scope.schoolList.searchErrorMessage
            $scope.getSchoolSearchResultsNew()
        # END new Geo locate code for KHC

        # ask or retrieve current lat/long
        $scope.getLocationAlt = ->
          $scope.schoolList.searchSubmitted = true
          nameFilter = jQuery.trim $scope.schoolList.ng_nameFilter
          $scope.schoolList.nameFilter = nameFilter
          if not nameFilter
            $scope.schoolList.searchErrorMessage = 'Please specify a search criteria before initiating a search.'
          else
            delete $scope.schoolList.searchErrorMessage
            $scope.schoolList.searchPending = true
            $scope.schoolList.searchByLocation = true
            e = 
              enableHighAccuracy: !0
              timeout: 1e4
              maximumAge: 'infinity'
            if navigator.geolocation then navigator.geolocation.getCurrentPosition(filterGeoSchoolData, showGEOError, e) else console.log('Geolocation is not supported by this browser.')
            return

        $scope.submitSchoolSearch = ->
          nameFilter = jQuery.trim $scope.schoolList.ng_nameFilter
          $scope.schoolList.nameFilter = nameFilter
          #$scope.schoolList.stateFilter = ''
          $scope.schoolList.searchSubmitted = true
          if not nameFilter
            $scope.schoolList.searchErrorMessage = 'Please specify a search criteria before initiating a search.'
          else
            delete $scope.schoolList.searchErrorMessage
            if $scope.tablePrefix is 'heartdev' and location.href.indexOf("showprod") is -1
              $scope.getSchoolSearchResultsDEV()
            else
              $scope.getSchoolSearchResults()
        
        $scope.orderSchools = (sortProp, keepSortOrder) ->
          schools = $scope.schoolList.schools
          if schools.length > 0
            if not keepSortOrder
              $scope.schoolList.sortDesc = !$scope.schoolList.sortDesc
            if $scope.schoolList.sortProp isnt sortProp
              $scope.schoolList.sortProp = sortProp
              $scope.schoolList.sortDesc = true
            schools = $filter('orderBy') schools, sortProp, $scope.schoolList.sortDesc
            $scope.schoolList.schools = schools
            $scope.schoolList.currentPage = 1
        
        $scope.paginate = (value) ->
          begin = ($scope.schoolList.currentPage - 1) * $scope.schoolList.paginationItemsPerPage
          end = begin + $scope.schoolList.paginationItemsPerPage
          index = $scope.schoolList.schools.indexOf value
          begin <= index and index < end
        
        setSchools = (companies) ->
          schools = []
          angular.forEach companies, (company) ->
            if company.coordinatorId and company.coordinatorId isnt '0'
              if company.hasOwnProperty("EVENT_PROGRAM")
                event_program = company.EVENT_PROGRAM
              else
                event_program = ''
              schools.push
                FR_ID: company.eventId
                COMPANY_ID: company.companyId
                SCHOOL_NAME: company.companyName
                COORDINATOR_ID: company.coordinatorId
                SCHOOL_CITY: company.SCHOOL_CITY
                SCHOOL_STATE: company.SCHOOL_STATE
                COORDINATOR_FIRST_NAME: company.COORDINATOR_FIRST_NAME
                COORDINATOR_LAST_NAME: company.COORDINATOR_LAST_NAME
                EVENT_PROGRAM: event_program
          schools
          
        setSchoolsData = (schools) ->
          angular.forEach schools, (school, schoolIndex) ->
            schoolData = $scope.schoolDataMap['id' + school.COMPANY_ID]
            if schoolData
              if schoolData.hasOwnProperty("EVENT_PROGRAM")
                event_program = schoolData.EVENT_PROGRAM
              else
                event_program = ''
              schools[schoolIndex].SCHOOL_CITY = schoolData.SCHOOL_CITY
              schools[schoolIndex].SCHOOL_STATE = schoolData.SCHOOL_STATE
              schools[schoolIndex].COORDINATOR_FIRST_NAME = schoolData.COORDINATOR_FIRST_NAME
              schools[schoolIndex].COORDINATOR_LAST_NAME = schoolData.COORDINATOR_LAST_NAME
              schools[schoolIndex].EVENT_PROGRAM = event_program
          schools
          
        searchOverridesMap = [
          {
            original: 'Saint', 
            overrides: ['St', 'St.']
          },
          {
            original: 'St', 
            overrides: ['Saint', 'St.']
          },
          {
            original: 'St.', 
            overrides: ['Saint', 'St']
          },
          {
            original: 'and',
            overrides: ['&']
          },
          {
            original: '&',
            overrides: ['and']
          },
          {
            original: 'Ft',
            overrides: ['Fort', 'Ft.']
          },
          {
            original: 'Ft.',
            overrides: ['Fort', 'Ft']
          },
          {
            original: 'Fort',
            overrides: ['Ft', 'Ft.']
          },
          {
            original: 'Mt',
            overrides: ['Mount', 'Mt.']
          },
          {
            original: 'Mt.',
            overrides: ['Mount', 'Mt']
          },
          {
            original: 'Mount',
            overrides: ['Mt', 'Mt.']
          }
        ]
        
        findOverrides = (param) ->
          searchOverridesMap.filter((i) ->
            if param.indexOf(i.original) is -1
              return false
            else
              return true
          )
        
        updateCompanyData = ->
          if not $scope.$$phase
            $scope.$apply()

        $scope.getSchoolSearchResults = (bystate) ->
          delete $scope.schoolList.schools
          $scope.schoolList.searchPending = true
          nameFilter = $scope.schoolList.nameFilter or '%'
          nameFilter = nameFilter.toLowerCase().replace(' elementary', '')
          nameFilter = nameFilter.toLowerCase().replace(' school', '')
          nameFilter = nameFilter.replace("'","\\'")
          companies = []
          #isOverride = findOverrides(nameFilter)
          #if isOverride.length > 0
          #  angular.forEach override.overrides, (replace) ->
          #  nameFilterReplace = nameFilter.replace(override.original, replace)
          #  if nameFilterReplace.indexOf('..') == -1
          #    nameFilter = nameFilter + '|' + nameFilterReplace

          ZuriService.getSchools '&school_name=' + encodeURIComponent(nameFilter) + '&school_state=' + encodeURIComponent($scope.schoolList.stateFilter),
            failure: (response) ->
            error: (response) ->
            success: (response) ->
              $scope.schoolList.totalNumberResults = response.data.company[0].length
              companies = response.data.company[0]
              schools = []
              updateCompanyData()

              setResults = ->
                if companies.length > 0
                  schools = setSchools(companies)
                  $scope.schoolList.totalItems = schools.length
                  $scope.schoolList.totalNumberResults = schools.length
                  $scope.schoolList.schools = schools
                  $scope.orderSchools $scope.schoolList.sortProp, true
                  if nameFilter != 'zz'
                    schools = $filter('filter')(schools, ((value) ->
                      value.SCHOOL_NAME.toLowerCase().indexOf('zz') != 0
                    ), false)
                    $scope.schoolList.schools = schools
                    $scope.schoolList.totalItems = schools.length
                    $scope.schoolList.totalNumberResults = schools.length
                  if $scope.schoolList.stateFilter != ''
                    schools = $filter('filter')(schools, SCHOOL_STATE: $scope.schoolList.stateFilter)
                    $scope.schoolList.schools = schools
                    $scope.schoolList.totalItems = schools.length
                    $scope.schoolList.totalNumberResults = schools.length
                else
                  $scope.schoolList.schools = []
                  $scope.schoolList.totalItems = 0
                  $scope.schoolList.totalNumberResults = 0

              setResults()
              delete $scope.schoolList.searchPending
              updateCompanyData()

        $scope.getSchoolSearchResultsDEV = (bystate) ->
          delete $scope.schoolList.schools
          $scope.schoolList.searchPending = true
          $scope.schoolList.currentPage = 1
          nameFilter = $scope.schoolList.nameFilter or '%'
          companies = []
          TeamraiserCompanyService.getCompanies 'event_type=' + encodeURIComponent(eventType) + '&company_name=' + encodeURIComponent(nameFilter) + '&list_sort_column=company_name&list_page_size=500', (response) ->
            if response.getCompaniesResponse?.company
              if response.getCompaniesResponse?.totalNumberResults is '1'
                companies.push response.getCompaniesResponse.company
              else
                companies = response.getCompaniesResponse.company
            
            totalNumberResults = response.getCompaniesResponse?.totalNumberResults or '0'
            totalNumberResults = Number totalNumberResults
            $scope.schoolList.totalNumberResults = totalNumberResults
            schools = []
            updateCompanyData()

            setResults = ->
              if companies.length > 0
                schools = setSchools companies
                #if bystate is true
                #  schools = setSchoolsDataByState schools
                #else
                schools = setSchoolsData schools
                $scope.schoolList.totalItems = schools.length
                $scope.schoolList.totalNumberResults = schools.length
                $scope.schoolList.schools = schools
                $scope.orderSchools $scope.schoolList.sortProp, true
                if nameFilter isnt 'zz'
                  # filter off zz schools
                  schools = $filter('filter')(schools, ((value) -> value.SCHOOL_NAME.toLowerCase().indexOf('zz') isnt 0), false)
                  $scope.schoolList.schools = schools
                  $scope.schoolList.totalItems = schools.length
                  $scope.schoolList.totalNumberResults = schools.length
                if $scope.schoolList.stateFilter isnt ''
                  #schools = $filter('filter') schools, SCHOOL_STATE: $scope.schoolList.stateFilter
                  $scope.schoolList.schools = schools
                  $scope.schoolList.totalItems = schools.length
                  $scope.schoolList.totalNumberResults = schools.length
              else
                $scope.schoolList.schools = []
                $scope.schoolList.totalItems = 0
                $scope.schoolList.totalNumberResults = 0
            
            getAdditionalPages = (filter, totalNumber) ->
              additionalPages = []
              angular.forEach [1, 2, 3], (additionalPage) ->
                if totalNumber > additionalPage * 500
                  additionalPages.push additionalPage
              additionalPagesComplete = 0
              angular.forEach additionalPages, (additionalPage) ->
                TeamraiserCompanyService.getCompanies 'event_type=' + encodeURIComponent(eventType) + '&company_name=' + encodeURIComponent(filter) + '&list_sort_column=company_name&list_page_size=500&list_page_offset=' + additionalPage, (response) ->
                  moreCompanies = response.getCompaniesResponse?.company
                  moreSchools = []
                  if moreCompanies
                    moreCompanies = [moreCompanies] if not angular.isArray moreCompanies
                    if moreCompanies.length > 0
                      moreSchools = setSchools moreCompanies
                      if bystate is true
                        moreSchools = setSchoolsDataByState moreSchools
                      else
                        moreSchools = setSchoolsData moreSchools
                      if $scope.schoolList.stateFilter isnt ''
                        moreSchools = $filter('filter') moreSchools, SCHOOL_STATE: $scope.schoolList.stateFilter
                  schools = schools.concat moreSchools
                  additionalPagesComplete++
                  if additionalPagesComplete is additionalPages.length
                    setResults()
                    delete $scope.schoolList.searchPending
                    updateCompanyData()
            
            isOverride = findOverrides nameFilter
            if isOverride.length > 0
              setOverride = (response, nameFilterReplace) ->
                totalNumberOverrides = response.getCompaniesResponse?.totalNumberResults
                
                if response.getCompaniesResponse.totalNumberResults is '1'
                  companies.push response.getCompaniesResponse.company
                else
                  angular.forEach response.getCompaniesResponse?.company, (comp) ->
                    companies.push comp
                totalNumberResults += Number response.getCompaniesResponse?.totalNumberResults
                
                if totalNumberOverrides > 500
                  getAdditionalPages nameFilterReplace, totalNumberOverrides
                else
                  setResults()
                  delete $scope.schoolList.searchPending
                  updateCompanyData()
              
              angular.forEach isOverride, (override) ->
                angular.forEach override.overrides, (replace) ->
                  nameFilterReplace = nameFilter.replace override.original, replace
                  if nameFilterReplace.indexOf('..') is -1
                    TeamraiserCompanyService.getCompanies 'event_type=' + encodeURIComponent(eventType) + '&company_name=' + encodeURIComponent(nameFilterReplace) + '&list_sort_column=company_name&list_page_size=500', (response) ->
                      if response.errorResponse
                        # adding additional call due to occasional error returns
                        # SchoolLookupService.getSchoolCompanies 'company_name=' + encodeURIComponent(nameFilterReplace) + '&list_sort_column=company_name&list_page_size=500'
                          # .then (response) ->
                            # if response.data.errorResponse
                              # console.log 'error'
                            # else
                              # setOverride response, nameFilterReplace
                        angular.noop()
                      else
                        setOverride response, nameFilterReplace
            else
              if totalNumberResults > 500
                getAdditionalPages nameFilter, totalNumberResults
              else
                setResults()
                delete $scope.schoolList.searchPending
                updateCompanyData()

  ]
