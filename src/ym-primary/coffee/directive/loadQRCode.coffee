angular.module 'ahaLuminateApp'
  .directive 'loadQrcode', [
    'APP_INFO'
    '$rootScope'
    '$timeout'
    (APP_INFO, $rootScope, $timeout) ->
      (scope, element, attrs) ->
        $timeout ->
          img = new Image
          img.src = angular.element('.qrcode-logo').attr('src')
          img.onload = ->
            jQuery(element).kjua
              'render': 'canvas'
              'crisp': true
              'ecLevel': 'H'
              'minVersion': 1
              'fill': '#333333'
              'back': '#ffffff'
              'text': attrs.loadQrcode
              'size': 100
              'rounded': 100
              'quiet': 1
              'mode': 'image'
              'mSize': 30
              'mPosX': 0
              'mPosY': 0
              'label': 'KHC'
              'fontname': 'Luckiest Guy'
              'fontcolor': '#c10e21'
              'image': angular.element('.qrcode-logo').get(0)
  ]
