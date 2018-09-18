angular.module 'trPcControllers'
  .controller 'NgPcTeacherResourcesViewCtrl', [
    '$scope'
    'PageBuilderService'
    ($scope, PageBuilderService) ->
      PageBuilderService.getPageContent 'reus_ym_khc_student_resources', ''
        .then (response) ->
          pageContent = response.data.pageContent
          if pageContent
            $scope.pageContent = pageContent
  ]
