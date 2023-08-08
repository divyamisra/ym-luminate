angular.module('ahaLuminateApp').directive 'copyField', [
  'NuclavisService'
  (NuclavisService) -> {
    link: (scope, element, attrs) ->
      element.bind 'click', (event) ->
        fieldtype = angular.element(this).data('field-type')
        field = angular.element('#' + angular.element(this).data('field'))
        div = document.createElement('div')
        div.innerHTML = field.html()
        div.contentEditable = true
        angular.element(this).append div
        div.focus()
        window.getSelection().selectAllChildren div
        document.execCommand 'Copy'
        angular.element(div).remove()
        element.html 'Copied!'
        angular.element('.clipboard-copy').remove()
        element.after '<div class="clipboard-copy text-center small" role="alert" aria-atomic="true">' + fieldtype + ' copied to clipboard</div>'
        if fieldtype == 'Personal URL'
          NuclavisService.postAction($scope.frId + '/' + $scope.consId + '/page_share_hq')
 }
]
