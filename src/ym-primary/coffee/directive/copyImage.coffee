angular.module 'ahaLuminateApp'
  .directive 'copyImage', ->
    (scope, element, attrs) ->
      element.bind 'click', (event) ->
        CopyImageClipboard.copyImageToClipboard attrs.copyImage
        element.html 'Copied!'
      return
