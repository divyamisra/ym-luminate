angular.module 'trPcApp'
  .directive 'pcQrcode', [
    'APP_INFO'
    (APP_INFO) ->
      {
        restrict: 'E'
        template: ''
        scope: image: '='
        link: (scope, elem, attr) ->
          qrImage = angular.element(scope.image)
          elem.append qrImage
          return
     }
  ]
