angular.module 'ahaLuminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    '$httpParamSerializer'
    'AuthService'
    'TeamraiserParticipantService'
    'TeamraiserRegistrationService'
    '$timeout'
    ($rootScope, $scope, $httpParamSerializer, AuthService, TeamraiserParticipantService, TeamraiserRegistrationService, $timeout) ->
      $dataRoot = angular.element '[data-aha-luminate-root]'
      consId = $dataRoot.data('cons-id') if $dataRoot.data('cons-id') isnt ''
      $scope.regEventId = ''
      $scope.protocol = window.location.protocol
      
      setRegEventId = (numberEvents = 0, regEventId = '') ->
        $scope.numberEvents = numberEvents
        $scope.regEventId = regEventId
        if not $scope.$$phase
          $scope.$apply()
      if not consId or not luminateExtend.global.isParticipant
        setRegEventId()
      else
        TeamraiserParticipantService.getRegisteredTeamraisers 'cons_id=' + consId + '&event_type=%Heart Challenge%',
          error: ->
            setRegEventId()
          success: (response) ->
            teamraisers = response.getRegisteredTeamraisersResponse?.teamraiser
            if not teamraisers
              setRegEventId()
            else
              teamraisers = [teamraisers] if not angular.isArray teamraisers
              numberEvents = 0
              firstTR = '';
              angular.forEach teamraisers, (tr) ->
                if parseInt(tr.status) <= 3
                  numberEvents = numberEvents + 1
                  if firstTR == ''
                    firstTR = tr.id
              regEventId = ''
              if numberEvents is 1
                regEventId = firstTR
              setRegEventId numberEvents, regEventId

      $scope.participationTypes = {}
      TeamraiserRegistrationService.getParticipationTypes
        error: ->
          # TODO
        success: (response) ->
          participationTypes = response.getParticipationTypesResponse.participationType
          participationTypes = [participationTypes] if not angular.isArray participationTypes
          angular.forEach participationTypes, (ptype) ->
            $scope.participationTypes[ptype.id] = ptype.name
            
      $scope.toggleLoginMenu = ->
        if $scope.loginMenuOpen
          delete $scope.loginMenuOpen
        else
          $scope.loginMenuOpen = true
      
      angular.element('body').on 'click', (event) ->
        if $scope.loginMenuOpen and angular.element(event.target).closest('.ym-header-login').length is 0
          $scope.toggleLoginMenu()
        if not $scope.$$phase
          $scope.$apply()
      
      $scope.headerLoginInfo = 
        user_name: ''
        password: ''
      
      $scope.submitHeaderLogin = ->
        AuthService.login $httpParamSerializer($scope.headerLoginInfo), 
          error: ->
            angular.element('.js--default-header-login-form').submit()
          success: ->
            if not $scope.headerLoginInfo.ng_nexturl or $scope.headerLoginInfo.ng_nexturl is ''
#              window.location = window.location.href
              window.location = $rootScope.secureDomain + 'site/SPageServer?pagename=ym_my_events'
            else
              window.location = $scope.headerLoginInfo.ng_nexturl
      
      $scope.toggleWelcomeMenu = ->
        if $scope.welcomeMenuOpen
          angular.element("button.ym-header-welcome-toggle").attr("aria-expanded","false");
          delete $scope.welcomeMenuOpen
        else
          angular.element("button.ym-header-welcome-toggle").attr("aria-expanded","true");
          $scope.welcomeMenuOpen = true
          focusDropdown = ->
            document.getElementById('js--header-welcome-ul').focus()
          $timeout focusDropdown, 100
      
      angular.element('body').on 'click', (event) ->
        if $scope.welcomeMenuOpen and angular.element(event.target).closest('.ym-header-welcome').length is 0
          $scope.toggleWelcomeMenu()
        if not $scope.$$phase
          $scope.$apply()
      
      $scope.toggleSiteMenu = ->
        if $scope.siteMenuOpen
          delete $scope.siteMenuOpen
        else
          $scope.siteMenuOpen = true
      
      angular.element('body').on 'click', (event) ->
        if $scope.siteMenuOpen and angular.element(event.target).closest('.ym-site-menu').length is 0
          $scope.toggleSiteMenu()
        if not $scope.$$phase
          $scope.$apply()
      
  ]
