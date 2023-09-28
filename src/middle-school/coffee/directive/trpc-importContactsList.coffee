angular.module 'trPcApp'
  .directive 'pcImportContactsList', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/directive/importContactsList.html'
      restrict: 'E'
      replace: true
      scope:
        contacts: '='
        toggleContact: '='
  ]