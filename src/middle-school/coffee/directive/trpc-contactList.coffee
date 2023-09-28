angular.module 'trPcApp'
  .directive 'pcContactList', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/directive/contactList.html'
      restrict: 'E'
      replace: true
      scope:
        contacts: '='
        toggleContact: '='
        selectContact: '='
        deleteContact: '='
  ]