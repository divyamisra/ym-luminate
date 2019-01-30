angular.module 'trPageEditApp', [
  'ngSanitize'
  'ui.bootstrap'
  'pascalprecht.translate'
  'textAngular'
  'trPageEditControllers'
]

angular.module 'trPageEditControllers', []

angular.module 'trPageEditApp'
  .constant 'NgPageEdit_APP_INFO', 
    version: '0.1.0'

angular.module 'trPageEditApp'
  .run [
    '$rootScope'
    'NgPageEdit_APP_INFO'
    ($rootScope, NgPageEdit_APP_INFO) ->
      # get data from embed container
      $embedRoot = angular.element '[data-embed-root]'
      appVersion = $embedRoot.data('app-version') if $embedRoot.data('app-version') isnt ''
      if appVersion isnt NgPageEdit_APP_INFO.version
        console.warn 'TeamRaiser Inline Page Edit: App version in HTML and JavaScript differ. Please confirm all files are up-to-date.'
      $rootScope.nonsecurePath = luminateExtend.global.path.nonsecure
      $rootScope.securePath = luminateExtend.global.path.secure
      $rootScope.apiKey = $embedRoot.data('api-key') if $embedRoot.data('api-key') isnt ''
      if not $rootScope.apiKey
        new Error 'TeamRaiser Inline Page Edit: No Luminate Online API Key is defined.'
      $rootScope.frId = $embedRoot.data('fr-id') if $embedRoot.data('fr-id') isnt ''
      if not $rootScope.frId
        new Error 'TeamRaiser Inline Page Edit: No TeamRaiser ID is defined.'
      $rootScope.locale = $embedRoot.data('locale') if $embedRoot.data('locale') isnt ''
      if not $rootScope.locale
        $rootScope.locale = 'en_US'
      $rootScope.consId = $embedRoot.data('cons-id') if $embedRoot.data('cons-id') isnt ''
      $rootScope.firstName = $embedRoot.data('first-name') if $embedRoot.data('first-name') isnt ''
      $rootScope.email = $embedRoot.data('email') if $embedRoot.data('email') isnt ''
#      $rootScope.vidyardId = $embedRoot.data('vidyard-id') if $embedRoot.data('vidyard-id') isnt ''
      $rootScope.authToken = $embedRoot.data('auth-token') if $embedRoot.data('auth-token') isnt ''
      $rootScope.sessionCookie = $embedRoot.data('session-cookie') if $embedRoot.data('session-cookie') isnt ''
  ]