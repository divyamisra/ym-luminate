angular.module 'trPcControllers'
  .controller 'editCompanyViewCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    '$compile'
    '$sce'
    '$uibModal'
    'APP_INFO'
    'TeamraiserCompanyPageService'
    ($rootScope, $scope, $location, $compile, $sce, $uibModal, APP_INFO, TeamraiserCompanyPageService) ->

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

      #$scope.companyId = $location.absUrl().split('company_id=')[1].split('&')[0]
      # console.log "pre get reg"
      # TeamraiserRegistrationService.getRegistration
      #   error: ->
      #     console.log "there was an error with the getReg service"
      #   success: (response) ->
      #     console.log "hello"
      #     registration = response.getRegistrationResponse?.registration
      #     if registration
      #       companyInformation = registration?.companyInformation
      #       console.log companyInformation
      #       if companyInformation?.companyId is $scope.companyId and companyInformation?.isCompanyCoordinator is 'true'
      #         $companyPhoto1 = angular.element '.heart-user-image-wrap--company'

      $companyPhoto1 = angular.element '.page_company_photo_container'

      # make photo dynamic
      $scope.setCompanyPhoto1Url = (photoUrl) ->
        $scope.companyPhoto1Url = photoUrl
        if not $scope.$$phase
          $scope.$apply()

      angular.forEach $companyPhoto1, (photoContainer) ->
        $companyPhoto = angular.element(photoContainer).find('img')
        $companyPhotoSrc = $companyPhoto.attr 'src'
        console.log $companyPhotoSrc,"src go 1"
        if $companyPhotoSrc and $companyPhotoSrc isnt ''
          $scope.setCompanyPhoto1Url $companyPhotoSrc
          console.log $companyPhotoSrc,"not blank"
        $companyPhoto.replaceWith $compile($companyPhoto.clone().attr('ng-src', '{{companyPhoto1Url}}'))($scope)

      # insert photo edit button
      $scope.editCompanyPhoto1 = ->
        $scope.editCompanyPhoto1Modal = $uibModal.open
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/page-edit/modal/editCompanyPhoto1.html'
      $scope.closeCompanyPhoto1Modal = ->
        if $scope.editCompanyPhoto1Modal
          $scope.editCompanyPhoto1Modal.close()
        $scope.setCompanyPhoto1Error()
        if not $scope.$$phase
          $scope.$apply()
      $scope.deleteCompanyPhoto1 = ($event) ->
        if $event
          $event.preventDefault()
        angular.element('.js--delete-company-photo-1-form').submit()
        $scope.setCompanyPhoto1Url angular.element('.page_company_photo_inner[data-defaultphoto]').attr('data-defaultphoto')
        false
      $scope.cancelEditCompanyPhoto1 = ->
        $scope.closeCompanyPhoto1Modal()
      $scope.setCompanyPhoto1Error = (errorMessage) ->
        if not errorMessage and $scope.updateCompanyPhoto1Error
          delete $scope.updateCompanyPhoto1Error
        $scope.updateCompanyPhoto1Error =
          message: errorMessage
        if not $scope.$$phase
          $scope.$apply()
      
      $scope.getCompanyPhotoUrl = ->
        console.log 'running Get Company Page Photo (3)'
        TeamraiserCompanyPageService.getCompanyPhoto
          error: (response) ->
            # TODO
          success: (response) ->
            photoItems = response.getCompanyPhotoResponse?.photoItem
            if photoItems
              photoItems = [photoItems] if not angular.isArray photoItems
              angular.forEach photoItems, (photoItem) ->
                photoUrl = photoItem.customUrl
                if photoItem.id is '1' and photoUrl
                  $scope.setCompanyPhoto1Url photoUrl
                else if photoItem.id is '1'
                  console.log "no URL image"
                  $scope.setCompanyPhoto1Url angular.element('.page_company_photo_inner[data-defaultphoto]').attr('data-defaultphoto')
      $scope.getCompanyPhotoUrl()

      #Company Page Text
      $companyPageTextContainer = angular.element '.page_company_story_container #fr_rich_text_container'

      $scope.getCompanyPageRichText = ->
        TeamraiserCompanyPageService.getCompanyPageInfo
          error: (response) ->
            # TODO
          success: (response) ->
            $scope.companyContent = response.getCompanyPageResponse.companyPage?.richText
            $scope.ng_companyContent = response.getCompanyPageResponse.companyPage?.richText
      $scope.getCompanyPageRichText()


      # insert content edit button
      $scope.editCompanyContent = ->
        $scope.prevCompanyContent = $scope.companyContent
        $scope.companyContentOpen = true

      # insert content form
      closeCompanyContent = ->
        $scope.companyContentOpen = false
        if not $scope.$$phase
          $scope.$apply()
      $scope.cancelEditCompanyContent = ->
        $scope.companyContent = $scope.prevCompanyContent
        closeCompanyContent()
        $scope.ng_companyContent = $scope.prevCompanyContent
      $scope.updateCompanyContent = ->
        richText = $scope.ng_companyContent
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
        TeamraiserCompanyPageService.updateCompanyPageInfo 'rich_text=' + encodeURIComponent(richText),
          error: (response) ->
            # TODO
          success: (response) ->
            success = response.updateCompanyPageResponse?.success
            if not success or success isnt 'true'
              # TODO
            else
              $scope.companyContent = richText
              closeCompanyContent()
              
      window.trPageEdit =
        uploadPhotoError: (response) ->
          errorResponse = response.errorResponse
          photoType = errorResponse.photoType
          photoNumber = errorResponse.photoNumber
          errorCode = errorResponse.code
          errorMessage = errorResponse.message

          $scope.setCompanyPhoto1Error errorMessage

        uploadPhotoSuccess: (response) ->
          successResponse = response.successResponse
          photoType = successResponse.photoType
          photoNumber = successResponse.photoNumber

          TeamraiserCompanyPageService.getCompanyPhoto
            error: (response) ->
              # TODO
            success: (response) ->
              photoItems = response.getCompanyPhotoResponse?.photoItem
              if photoItems
                photoItems = [photoItems] if not angular.isArray photoItems
                angular.forEach photoItems, (photoItem) ->
                  photoUrl = photoItem.customUrl
                  if photoItem.id is '1'
                    $scope.setCompanyPhoto1Url photoUrl
              $scope.closeCompanyPhoto1Modal()

  ]