angular.module 'trPcControllers'
  .controller 'editPersonalViewCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    '$compile'
    '$sce'
    '$uibModal'
    'APP_INFO'
    'TeamraiserParticipantPageService'
    ($rootScope, $scope, $location, $compile, $sce, $uibModal, APP_INFO, TeamraiserParticipantPageService) ->
      #luminateExtend.api.getAuth()

      $scope.personalPagePromises = []

      $scope.teamraiserAPIPath = $sce.trustAsResourceUrl $rootScope.securePath + 'CRTeamraiserAPI'

      console.log 'this is the personal page edit controller'


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

      $pagePersonalPhoto = angular.element '.page_personal_photo_container'

      # make photo dynamic
      $scope.setPagePersonalPhotoUrl = (photoUrl) ->
        $scope.pagePersonalPhotoUrl = photoUrl
        if not $scope.$$phase
          $scope.$apply()
      angular.forEach $pagePersonalPhoto, (photoContainer) ->
        $personalPhoto = angular.element(photoContainer).find('img')
        $personalPhotoSrc = $personalPhoto.attr 'src'
        if $personalPhotoSrc and $personalPhotoSrc isnt ''
          $scope.setPagePersonalPhotoUrl $personalPhotoSrc
        $personalPhoto.replaceWith $compile($personalPhoto.clone().attr('ng-src', '{{pagePersonalPhotoUrl}}'))($scope)

      # insert photo edit button
      $scope.editPagePersonalPhoto = ->
        $scope.editPagePersonalPhotoModal = $uibModal.open
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/page-edit/modal/editPagePersonalPhoto.html'
      $scope.closePagePersonalPhotoModal = ->
        if $scope.editPagePersonalPhotoModal
          $scope.editPagePersonalPhotoModal.close()
        $scope.setPagePersonalPhotoError()
        if not $scope.$$phase
          $scope.$apply()
      $scope.deletePagePersonalPhoto = ($event) ->
        if $event
          $event.preventDefault()
        angular.element('.js--delete-page-personal-photo-form').submit()
        $scope.setPagePersonalPhotoUrl angular.element('.page_personal_photo_inner[data-defaultphoto]').attr('data-defaultphoto')
        false
      $scope.cancelEditPagePersonalPhoto = ->
        $scope.closePagePersonalPhotoModal()
      $scope.setPagePersonalPhotoError = (errorMessage) ->
        if not errorMessage and $scope.updatePagePersonalPhotoError
          delete $scope.updatePagePersonalPhotoError
        $scope.updatePagePersonalPhotoError =
          message: errorMessage
        if not $scope.$$phase
          $scope.$apply()

      $scope.getPagePersonalPhotoUrl = ->
        console.log 'runnning'
        TeamraiserParticipantPageService.getPersonalPhotos
          error: (response) ->
            # TODO
          success: (response) ->
            photoItems = response.getPersonalPhotosResponse?.photoItem
            if photoItems
              photoItems = [photoItems] if not angular.isArray photoItems
              angular.forEach photoItems, (photoItem) ->
                photoUrl = photoItem.customUrl
                if photoItem.id is '1' and photoUrl
                  $scope.setPagePersonalPhotoUrl photoUrl
                else if photoItem.id is '1'
                  $scope.setPagePersonalPhotoUrl angular.element('.page_personal_photo_inner[data-defaultphoto]').attr('data-defaultphoto')
      $scope.getPagePersonalPhotoUrl()



      #Personal page text
      $personalTextContainer = angular.element '.page_personal_story_container #fr_rich_text_container'

      # $scope.getPersonalPageRichText = ->
      #   getPersonalPageRichTextPromise = TeamraiserParticipantPageService.getPersonalPageInfo()
      #     .then(response) ->
      #       if response.data.errorResponse
      #         # TODO
      #       else
      #         console.log response
      #       response
      #   $scope.personalPagePromises.push getPersonalPageRichTextPromise
      # $scope.getPersonalPageRichText()


      $scope.getPersonalPageRichText = ->
        console.log 'runnning2'
        TeamraiserParticipantPageService.getPersonalPageInfo
          error: (response) ->
            # TODO
          success: (response) ->
            console.log response.getPersonalPageResponse.personalPage?.richText
            $scope.pagePersonalContent  = response.getPersonalPageResponse.personalPage?.richText
            $scope.ng_pagePersonalContent  = response.getPersonalPageResponse.personalPage?.richText
            #$personalTextContainer.html $compile($retrievedPersonalPageText)($scope)
      $scope.getPersonalPageRichText()

      # make content dynamic
      #$scope.pagePersonalContent = $personalTextContainer.html()
      #$scope.ng_pagePersonalContent = $personalTextContainer.html()
      #$personalTextContainer.html $compile('<div ng-class="{\'hidden\': pagePersonalContentOpen}" ng-bind-html="pagePersonalContent"></div>')($scope)

      # insert content edit button
      $scope.editPagePersonalContent = ->
        $scope.prevPersonalContent = $scope.pagePersonalContent
        $scope.pagePersonalContentOpen = true
      #$personalTextContainer.prepend $compile('<div class="form-group"><button type="button" class="btn btn-primary btn-raised" ng-class="{\'hidden\': pagePersonalContentOpen}" ng-click="editPagePersonalContent()" id="edit_personal_story"><span class="glyphicon glyphicon-pencil"></span> Edit Story</button></div>')($scope)

      # insert content form
      closePersonalContent = ->
        $scope.pagePersonalContentOpen = false
        if not $scope.$$phase
          $scope.$apply()
      $scope.cancelEditPagePersonalContent = ->
        $scope.pagePersonalContent = $scope.prevPersonalContent
        closePersonalContent()
        $scope.ng_pagePersonalContent = $scope.prevPersonalContent
      $scope.updatePagePersonalContent = ->
        richText = $scope.ng_pagePersonalContent
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
        TeamraiserParticipantPageService.updatePersonalPageInfo 'rich_text=' + encodeURIComponent(richText),
          error: (response) ->
            # TODO
          success: (response) ->
            success = response.updatePersonalPageResponse?.success
            if not success or success isnt 'true'
              # TODO
            else
              $scope.pagePersonalContent = richText
              closePersonalContent()
      #$personalTextContainer.append $compile('<form method="POST" novalidate ng-class="{\'hidden\': !pagePersonalContentOpen}" ng-submit="updatePagePersonalContent()"><div class="form-group"><button type="button" class="btn btn-primary-inverted btn-raised" ng-click="cancelEditPagePersonalContent()">Cancel</button> <button type="submit" class="btn btn-primary btn-raised">Save</button></div><div class="form-group"><div text-angular ng-model="ng_pagePersonalContent" ta-toolbar="{{textEditorToolbar}}" ta-text-editor-class="border-around" ta-html-editor-class="border-around"></div></div></form>')($scope)


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

          if photoType is 'personal'
            TeamraiserParticipantPageService.getPersonalPhotos
              error: (response) ->
                # TODO
              success: (response) ->
                photoItems = response.getPersonalPhotosResponse?.photoItem
                if photoItems
                  photoItems = [photoItems] if not angular.isArray photoItems
                  angular.forEach photoItems, (photoItem) ->
                    photoUrl = photoItem.customUrl
                    if photoItem.id is '1'
                      $scope.setPagePersonalPhotoUrl photoUrl
                $scope.closePagePersonalPhotoModal()
                #$scope.closePersonalVideoModal()

  ]