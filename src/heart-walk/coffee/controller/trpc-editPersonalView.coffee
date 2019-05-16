angular.module 'trPcControllers'
  .controller 'editPersonalViewCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    '$compile'
    '$sce'
    '$uibModal'
    'APP_INFO'
    'TeamraiserRegistrationService'
    'TeamraiserSurveyResponseService'
    ($rootScope, $scope, $location, $compile, $sce, $uibModal, APP_INFO, TeamraiserRegistrationService, TeamraiserSurveyResponseService) ->
      luminateExtend.api.getAuth()

      $scope.teamraiserAPIPath = $sce.trustAsResourceUrl $rootScope.securePath + 'CRTeamraiserAPI'

      console.log $scope.teamraiserAPIPath

      console.log 'this is the personal page edit controller'

      $personalPagePhoto = angular.element 'h1'

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
        angular.element('.js--delete-personal-photo-1-form').submit()
        $scope.setPagePersonalPhotoUrl angular.element('.heart-user-image-wrap-inner[data-defaultphoto]').attr('data-defaultphoto')
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
      #$personalPagePhoto.append $compile('<button type="button" class="btn btn-primary-inverted btn-raised" ng-click="editPagePersonalPhoto()" id="edit_personal_photo"><span class="glyphicon glyphicon-camera"></span> Edit Photo</button>')($scope)

      window.trPageEditCD =
        uploadPhotoError: (response) ->
          errorResponse = response.errorResponse
          photoType = errorResponse.photoType
          photoNumber = errorResponse.photoNumber
          errorCode = errorResponse.code
          errorMessage = errorResponse.message

          $scope.setPagePersonalPhotoError errorMessage

        uploadPhotoSuccess: (response) ->
          console.log 'succes'
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
                    else if photoItem.id is '2'
                      $scope.setPersonalPhoto2Url photoUrl
                $scope.closePagePersonalPhotoModal()
                $scope.closePersonalVideoModal()

  ]