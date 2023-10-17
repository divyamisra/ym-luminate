angular.module 'trPcControllers'
  .controller 'NgPcTeacherResourcesViewCtrl', [
    '$scope'
    'PageBuilderService'
    '$sce'
    ($scope, PageBuilderService, $sce) ->
      $scope.trustHtml = (html) ->
        return $sce.trustAsHtml(html)
      PageBuilderService.getPageContent 'ym_school_resources', 'tab=AHC'
        .then (response) ->
          pageContent = response.data
          if pageContent
            $scope.pageContent = pageContent
  ]
