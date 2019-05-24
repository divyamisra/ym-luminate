angular.module 'trPcControllers'
  .controller 'editCompanyViewCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    '$compile'
    '$sce'
    '$uibModal'
    'APP_INFO'
    'TeamraiserParticipantPageService'
    ($rootScope, $scope, $location, $compile, $sce, $uibModal, APP_INFO, TeamraiserParticipantPageService) ->

      console.log 'this is the company page edit controller'

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

      $scope.companyId = $location.absUrl().split('company_id=')[1].split('&')[0]

      TeamraiserRegistrationService.getRegistration
        error: ->
          # TODO
        success: (response) ->
          registration = response.getRegistrationResponse?.registration
          console.log registration
          if registration
            companyInformation = registration?.companyInformation
            console.log companyInformation
            if companyInformation?.companyId is $scope.companyId and companyInformation?.isCompanyCoordinator is 'true'
              $companyPhoto1 = angular.element '.heart-user-image-wrap--company'

              # make photo dynamic
              $scope.setCompanyPhoto1Url = (photoUrl) ->
                $scope.companyPhoto1Url = photoUrl
                if not $scope.$$phase
                  $scope.$apply()
              angular.forEach $companyPhoto1, (photoContainer) ->
                $companyPhoto = angular.element(photoContainer).find('img')
                $companyPhotoSrc = $companyPhoto.attr 'src'
                if $companyPhotoSrc and $companyPhotoSrc isnt ''
                  $scope.setCompanyPhoto1Url $companyPhotoSrc
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
              

              #Company Page Text
              $companyPageTextContainer = angular.element '.page_company_story_container #fr_rich_text_container'

              $scope.getCompanyPageRichText = ->
                console.log 'runnning2'
                TeamraiserParticipantPageService.getPersonalPageInfo
                  error: (response) ->
                    # TODO
                  success: (response) ->
                    console.log response.getPersonalPageResponse.personalPage?.richText
                    $scope.pagePersonalContent  = response.getPersonalPageResponse.personalPage?.richText
                    $scope.ng_pagePersonalContent  = response.getPersonalPageResponse.personalPage?.richText
              # TEMP TEMP TEMP TEMP TEMP TEMP
              #$scope.getPCompanyPageRichText()

              # make content dynamic
              # $scope.companyContent = $companyPageTextContainer.html()
              # $scope.ng_companyContent = $companyPageTextContainer.html()
              # $companyPageTextContainer.html $compile('<div ng-class="{\'hidden\': companyContentOpen}" ng-bind-html="companyContent"></div>')($scope)

              # insert content edit button
              $scope.editCompanyContent = ->
                $scope.prevCompanyContent = $scope.companyContent
                $scope.companyContentOpen = true
              #$companyPageTextContainer.prepend $compile('<div class="form-group"><button type="button" class="btn btn-primary btn-raised" ng-class="{\'hidden\': companyContentOpen}" ng-click="editCompanyContent()" id="edit_company_story"><span class="glyphicon glyphicon-pencil"></span> Edit Story</button></div>')($scope)

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

          $scope.setPagePersonalPhotoError errorMessage

        uploadPhotoSuccess: (response) ->
          successResponse = response.successResponse
          photoType = successResponse.photoType
          photoNumber = successResponse.photoNumber

          if photoType is 'company'
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