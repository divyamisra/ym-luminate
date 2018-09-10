angular.module 'trPcControllers'
  .controller 'EditPageViewCtrl', [
    '$scope'
    '$timeout'
    '$uibModal'
    'APP_INFO'
    'TeamraiserShortcutURLService'
    ($scope, $timeout, $uibModal, APP_INFO, TeamraiserShortcutURLService) ->
      $scope.editPagePromises = []
      
      $scope.viewOptions = 
        viewType: 'participant'
      
      $scope.getParticipantShortcut = ->
        getParticipantShortcutPromise = TeamraiserShortcutURLService.getShortcut()
          .then (response) ->
            shortcutItem = response.data.getShortcutResponse?.shortcutItem
            if shortcutItem
              if shortcutItem.prefix
                shortcutItem.prefix = shortcutItem.prefix.replace 'www.', ''
              $scope.participantShortcut = shortcutItem
              if shortcutItem.url
                $scope.personalPageUrl = shortcutItem.url.replace 'www.', ''
              else
                $scope.personalPageUrl = shortcutItem.defaultUrl.replace('www.', '').split('/site/')[0] + '/site/TR?fr_id=' + $scope.frId + '&pg=personal&px=' + $scope.consId
        $scope.editPagePromises.push getParticipantShortcutPromise
      $scope.getParticipantShortcut()

      $scope.getPrevShortcut = ()->
        getPrevShortcutPromise = NgPcTeamraiserShortcutURLService.getShortcut(frid)
          .then (response) ->
            if response.data.errorResponse
              # TODO
            else
              shortcutItem = response.data.getShortcutResponse.shortcutItem
              if not shortcutItem
                # TODO
              else
                if shortcutItem.prefix
                  shortcutItem.prefix = shortcutItem.prefix
                $scope.participantShortcut = shortcutItem
                if shortcutItem.url
                  $scope.personalPageUrl = shortcutItem.url
                else
                  $scope.personalPageUrl = shortcutItem.defaultUrl.split('/site/')[0] + '/site/TR?fr_id=' + $scope.frId + '&pg=personal&px=' + $scope.consId
            response
        $scope.dashboardPromises.push getPrevShortcutPromise
      $scope.getPrevShortcut()      

      $scope.editPageUrlOptions =
        updateUrlFailure: false
        updateUrlFailureMessage: ''
        updateUrlInput: ''
      
      $scope.closeUrlAlerts = (closeModal) ->
        $scope.editPageUrlOptions.updateUrlFailure = false
        $scope.editPageUrlOptions.updateUrlFailureMessage = ''
        if closeModal
          $scope.editPageUrlModal.close()
      
      $scope.editPageUrl = (urlType) ->
        $scope.closeUrlAlerts false
        switch urlType
          when 'Participant' then $scope.editPageUrlOptions.updateUrlInput = $scope.participantShortcut?.text or ''
          when 'Team' then $scope.editPageUrlOptions.updateUrlInput = $scope.teamShortcut?.text or ''
        $scope.editPageUrlModal = $uibModal.open 
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/participant-center/modal/edit' + urlType + 'PageUrl.html'
      
      $scope.cancelEditPageUrl = ->
        $scope.editPageUrlModal.close()
      
      $scope.updatePageUrl = (urlType) ->
        $scope.closeUrlAlerts false
        dataStr = 'text=' + $scope.editPageUrlOptions.updateUrlInput
        switch urlType
          when 'Participant'
            updateUrlPromise = TeamraiserShortcutURLService.updateShortcut dataStr
              .then (response) ->
                if response.data.errorResponse
                  if $scope.editPageUrlOptions.updateUrlInput != $scope.prevShortcut.text
                    $scope.editPageUrlOptions.updateUrlFailure = true;
                    return $scope.editPageUrlOptions.updateUrlFailureMessage = response.data.errorResponse.message || 'An unexpected error occurred while updating your personal page URL.';
                  else 
                    updateUrlPromise = TeamraiserShortcutURLService.updateShortcut("text=",$rootScope.prevFrIdForShortcut)
                      .then(response) ->
                        if (response.data.errorResponse)
                          $scope.editPageUrlOptions.updateUrlFailure = true
                          return $scope.editPageUrlOptions.updateUrlFailureMessage = response.data.errorResponse.message || 'An unexpected error occurred while updating your personal page URL.';
                        else 
                          $scope.updatePageUrl("Participant")
                else
                  $scope.editPageUrlModal.close()
                  $scope.getParticipantShortcut()
            $scope.editPagePromises.push updateUrlPromise
          when 'Team'
            updateUrlPromise = TeamraiserShortcutURLService.updateTeamShortcut dataStr
              .then (response) ->
                if response.data.errorResponse
                  if $scope.editPageUrlOptions.updateUrlInput isnt $scope.prevTeamShortcut.text
                    $scope.editPageUrlOptions.updateUrlFailure = true;
                    return $scope.editPageUrlOptions.updateUrlFailureMessage = response.data.errorResponse.message or 'An unexpected error occurred while updating your personal page URL.';
                  else
                    updateUrlPromise = TeamraiserShortcutURLService.updateTeamShortcut("text=",$rootScope.prevFrIdForShortcut)
                      .then (response) ->
                        if (response.data.errorResponse)
                          $scope.editPageUrlOptions.updateUrlFailure = true
                          return $scope.editPageUrlOptions.updateUrlFailureMessage = response.data.errorResponse.message or 'An unexpected error occurred while updating your personal page URL.';
                        else
                          $scope.updatePageUrl("Team")
                else
                  $scope.editPageUrlModal.close()
                  $scope.getParticipantTeamShortcut()
            $scope.dashboardPromises.push updateUrlPromise
      
      if $scope.participantRegistration.teamId and $scope.participantRegistration.teamId isnt '-1' and $scope.participantRegistration.aTeamCaptain is 'true'
        $scope.getTeamShortcut = ->
          getTeamShortcutPromise = TeamraiserShortcutURLService.getTeamShortcut()
            .then (response) ->
              shortcutItem = response.data.getTeamShortcutResponse?.shortcutItem
              if shortcutItem
                if shortcutItem.prefix
                  shortcutItem.prefix = shortcutItem.prefix.replace 'www.', ''
                $scope.teamShortcut = shortcutItem
                if shortcutItem.url
                  $scope.teamPageUrl = shortcutItem.url.replace 'www.', ''
                else
                  $scope.teamPageUrl = shortcutItem.defaultUrl.replace('www.', '').split('/site/')[0] + '/site/TR?fr_id=' + $scope.frId + '&pg=team&team_id=' + $scope.participantRegistration.teamId
          $scope.editPagePromises.push getTeamShortcutPromise
        $scope.getTeamShortcut()
  ]