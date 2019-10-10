angular.module 'ahaLuminateControllers'
  .controller 'CmsCtrl', [
    '$scope'
    '$timeout'
    'AriaCarouselService'
    ($scope, $timeout, AriaCarouselService) ->
      initCarousel = ->
        owl = jQuery '.owl-carousel'
        owlStr = '.owl-carousel'
        owl.owlCarousel
          mouseDrag: false
          nav: true
          center: true
          loop: true
          responsive:
            0:
              items: 1
              stagePadding: 35
              margin : 0
            768:
              center: false
              items: 2
              stagePadding: 60
              margin: 30
            992:
              items: 3
              stagePadding: 120
              margin: 60
          navText: [
            '<i class="fa fa-chevron-left" hidden aria-hidden="true" />'
            '<i class="fa fa-chevron-right" hidden aria-hidden="true" />'
          ]
          onInitialized: (event) ->
            AriaCarouselService.init(owlStr)
          onChanged: ->
            AriaCarouselService.onChange(owlStr)
      
      if angular.element('ym-carousel--internal')
        $timeout initCarousel, 1000
      
      $scope.toggleOpen = (id) ->
        angular.element('.panel-heading').removeClass 'active'
        angular.element('#'+id).toggleClass 'active'
  ]