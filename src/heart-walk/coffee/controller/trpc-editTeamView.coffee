angular.module 'trPcControllers'
  .controller 'editTeamViewCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    '$compile'
    '$sce'
    '$uibModal'
    'APP_INFO'
    'TeamraiserTeamPageService'
    ($rootScope, $scope, $location, $compile, $sce, $uibModal, APP_INFO, TeamraiserTeamPageService) ->

      console.log "this is the new team controller"

      $scope.teamraiserAPIPath = $sce.trustAsResourceUrl $rootScope.securePath + 'CRTeamraiserAPI'

      $scope.textEditorToolbar = [
        [
          'h1'
          'h2'
          'h3'
          'p'
          'bold'
          'italics'
          'underline'
        ]
        [
          'ul'
          'ol'
          'justifyLeft'
          'justifyCenter'
          'justifyRight'
          'justifyFull'
          'indent'
          'outdent'
        ]
        [
          'insertImage'
          'insertLink'
          'undo'
          'redo'
        ]
      ]

      $teamPhoto1 = angular.element '.page_team_photo_container'

      # make photo dynamic
      $scope.setTeamPhoto1Url = (photoUrl) ->
        $scope.teamPhoto1Url = photoUrl
        if not $scope.$$phase
          $scope.$apply()

      angular.forEach $teamPhoto1, (photoContainer) ->
        $teamPhoto = angular.element(photoContainer).find('img')
        $teamPhotoSrc = $teamPhoto.attr 'src'
        if $teamPhotoSrc and $teamPhotoSrc isnt ''
          $scope.setTeamPhoto1Url $teamPhotoSrc
        $teamPhoto.replaceWith $compile($teamPhoto.clone().attr('ng-src', '{{teamPhoto1Url}}'))($scope)

      # photo edit
        $scope.editTeamPhoto1 = ->
          $scope.editTeamPhoto1Modal = $uibModal.open
            scope: $scope
            templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/page-edit/modal/editTeamPhoto1.html'
        $scope.closeTeamPhoto1Modal = ->
          if $scope.editTeamPhoto1Modal
            $scope.editTeamPhoto1Modal.close()
          $scope.setTeamPhoto1Error()
          if not $scope.$$phase
            $scope.$apply()
        $scope.deleteTeamPhoto1 = ($event) ->
          if $event
            $event.preventDefault()
          angular.element('.js--delete-team-photo-1-form').submit()
          $scope.setTeamPhoto1Url angular.element('.page_team_photo_inner[data-defaultphoto]').attr('data-defaultphoto')
          false
        $scope.cancelEditTeamPhoto1 = ->
          $scope.closeTeamPhoto1Modal()
        $scope.setTeamPhoto1Error = (errorMessage) ->
          if not errorMessage and $scope.updateTeamPhoto1Error
            delete $scope.updateTeamPhoto1Error
          $scope.updateTeamPhoto1Error =
            message: errorMessage
          if not $scope.$$phase
            $scope.$apply()
      
      $scope.getTeamPhotoUrl = ->
        console.log 'running Get Team Page Photo (1)'
        TeamraiserTeamPageService.getTeamPhoto
          error: (response) ->
            # TODO
          success: (response) ->
            photoItems = response.getTeamPhotoResponse?.photoItem
            if photoItems
              photoItems = [photoItems] if not angular.isArray photoItems
              angular.forEach photoItems, (photoItem) ->
                photoUrl = photoItem.customUrl
                if photoItem.id is '1' and photoUrl
                  $scope.setTeamPhoto1Url photoUrl
                else if photoItem.id is '1'
                  console.log "no URL image"
                  $scope.setTeamPhoto1Url angular.element('.page_team_photo_inner[data-defaultphoto]').attr('data-defaultphoto')
      $scope.getTeamPhotoUrl()

      #Teamm Page Text
      $teamPageTextContainer = angular.element '.page_team_story_container #fr_rich_text_container'

      $scope.getTeamPageRichText = ->
        TeamraiserTeamPageService.getTeamPageInfo
          error: (response) ->
            # TODO
          success: (response) ->
            $scope.teamContent = response.getTeamPageResponse.teamPage?.richText
            $scope.ng_teamContent = response.getTeamPageResponse.teamPage?.richText
      $scope.getTeamPageRichText()

      # insert content edit button
      $scope.editTeamContent = ->
        $scope.prevTeamContent = $scope.teamContent
        $scope.teamContentOpen = true

      # insert content form
      closeTeamContent = ->
        $scope.teamContentOpen = false
        if not $scope.$$phase
          $scope.$apply()
      $scope.cancelEditTeamContent = ->
        $scope.teamContent = $scope.prevTeamContent
        closeTeamContent()
        $scope.ng_teamContent = $scope.prevTeamContent
      $scope.updateTeamContent = ->
        richText = $scope.ng_teamContent
        $richText = jQuery '<div />',
          html: richText
        richText = $richText.html()
        richText = richText.replace /<\/?[A-Z]+.*?>/g, (m) ->
          m.toLowerCase()
        .replace(/<font>/g, '<span>').replace(/<font /g, '<span ').replace /<\/font>/g, '</span>'
        .replace(/<b>/g, '<strong>').replace(/<b /g, '<strong ').replace /<\/b>/g, '</strong>'
        .replace(/<i>/g, '<em>').replace(/<i /g, '<em ').replace /<\/i>/g, '</em>'
        .replace(/<u>/g, '<span style="text-decoration: underline;">').replace(/<u /g, '<span style="text-decoration: underline;" ').replace /<\/u>/g, '</span>'
        .replace /[\u00A0-\u9999\&]/gm, (i) ->
          '&#' + i.charCodeAt(0) + ';'
        .replace /&#38;/g, '&'
        .replace /<!--[\s\S]*?-->/g, ''
        TeamraiserTeamPageService.updateTeamPageInfo 'rich_text=' + encodeURIComponent(richText),
          error: (response) ->
            # TODO
          success: (response) ->
            success = response.updateTeamPageResponse?.success
            if not success or success isnt 'true'
              # TODO
            else
              $scope.teamContent = richText
              closeTeamContent()
              
      window.trPageEdit =
        uploadPhotoError: (response) ->
          errorResponse = response.errorResponse
          photoType = errorResponse.photoType
          photoNumber = errorResponse.photoNumber
          errorCode = errorResponse.code
          errorMessage = errorResponse.message

          $scope.setTeamPhoto1Error errorMessage

        uploadPhotoSuccess: (response) ->
          successResponse = response.successResponse
          photoType = successResponse.photoType
          photoNumber = successResponse.photoNumber

          TeamraiserTeamPageService.getTeamPhoto
            error: (response) ->
              # TODO
            success: (response) ->
              photoItems = response.getTeamPhotoResponse?.photoItem
              if photoItems
                photoItems = [photoItems] if not angular.isArray photoItems
                angular.forEach photoItems, (photoItem) ->
                  photoUrl = photoItem.customUrl
                  if photoItem.id is '1'
                    $scope.setTeamPhoto1Url photoUrl
              $scope.closeTeamPhoto1Modal()

  ]