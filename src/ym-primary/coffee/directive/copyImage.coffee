angular.module 'ahaLuminateApp'
  .directive 'copyImage', ->
    (scope, element, attrs) ->
      element.bind 'click', (event) ->
        CopyImageClipboard.copyImageToClipboard attrs.pngImage
      return
