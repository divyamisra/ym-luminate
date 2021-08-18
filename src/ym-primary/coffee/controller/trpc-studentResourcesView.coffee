angular.module 'trPcControllers'
  .controller 'NgPcStudentResourcesViewCtrl', [
    '$scope'
    'PageBuilderService'
    ($scope, PageBuilderService) ->
      PageBuilderService.getPageContent 'reus_ym_khc_student_resources', ''
        .then (response) ->
          pageContent = response.data
          if pageContent
            $scope.pageContent = pageContent
            
            $scope.showResourcesTab = (sel, block) ->
              jQuery('.selschool').removeClass 'selected'
              jQuery(sel).addClass 'selected'
              jQuery('.items').hide()
              $container2 = jQuery('.' + block)
              $container2.imagesLoaded ->
                $container2.masonry itemSelector: '.box'
                return
              jQuery('.' + block).show()
              return

            jQuery('.selschool').removeClass 'selected'
            jQuery('[sel="elementary"]').addClass 'selected'
            $container1 = jQuery('.elementary')
            $container1.imagesLoaded ->
              $container1.masonry itemSelector: '.box'
              return
]
