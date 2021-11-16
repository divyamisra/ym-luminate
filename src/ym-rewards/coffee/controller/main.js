angular.module 'ahaLuminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    '$httpParamSerializer'
    'AuthService'
    'TeamraiserParticipantService'
    '$timeout'
    ($rootScope, $scope, $httpParamSerializer, AuthService, TeamraiserParticipantService, $timeout) ->
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
        TeamraiserParticipantService.getRegisteredTeamraisers 'cons_id=' + consId + '&event_type=' + encodeURIComponent('YM Kids Heart Challenge 2022'),
          error: ->
            setRegEventId()
          success: (response) ->
            teamraisers = response.getRegisteredTeamraisersResponse?.teamraiser
            if not teamraisers
              setRegEventId()
            else
              teamraisers = [teamraisers] if not angular.isArray teamraisers
              numberEvents = teamraisers.length
              regEventId = ''
              if numberEvents is 1
                regEventId = teamraisers[0].id
              setRegEventId numberEvents, regEventId
     
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
              window.location = $rootScope.secureDomain + 'site/SPageServer?pagename=ym_khc_my_events'
            else
              window.location = $scope.headerLoginInfo.ng_nexturl
            
  ]
