angular.module 'trPcControllers'
  .controller 'NgPcMainCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    '$timeout'
    'APP_INFO'
    'FacebookFundraiserService'
    'BoundlessService'
    ($rootScope, $scope, $location, $timeout, APP_INFO, FacebookFundraiserService, BoundlessService) ->
      $rootScope.$location = $location
      $rootScope.baseUrl = $location.absUrl().split('#')[0]
      
      $scope.location = $location.path()
      $rootScope.$on '$routeChangeSuccess', ->
        $scope.location = $location.path()
        return
      
      $scope.$on '$viewContentLoaded', ->
        if $rootScope.clipboard
          $rootScope.clipboard.destroy()
          delete $rootScope.clipboard
        $rootScope.clipboard = new ClipboardJS '[data-clipboard-target]'
      
      if $rootScope.facebookFundraisersEnabled
        toggleFacebookFundraiserStatus = ->
          if not $rootScope.$$phase
            $rootScope.$apply()
        $rootScope.loginToFacebook = ->
          $rootScope.facebookFundraiserLoginStatus = 'pending'
          toggleFacebookFundraiserStatus()
          FB.login (response) ->
            authResponse = response.authResponse
            if not authResponse
              $rootScope.facebookFundraiserLoginStatus = 'login_error'
              toggleFacebookFundraiserStatus()
            else
              facebookUserId = response.authResponse.userID
              accessToken = response.authResponse.accessToken
              if not facebookUserId or not accessToken
                $rootScope.facebookFundraiserLoginStatus = 'login_error'
              else
                FB.api '/me/permissions', (response) ->
                  manageFundraisersPermisson = null
                  angular.forEach response.data, (permissionObject) ->
                    if permissionObject.permission is 'manage_fundraisers'
                      manageFundraisersPermisson = permissionObject
                  if not manageFundraisersPermisson
                    $rootScope.facebookFundraiserLoginStatus = 'permission_error'
                  else if manageFundraisersPermisson.status is 'declined'
                    $rootScope.facebookFundraiserLoginStatus = 'declined_manage_fundraisers'
                  else
                    $rootScope.facebookFundraiserLoginStatus = 'complete'
                    $rootScope.facebookFundraiserUserId = facebookUserId
                    $rootScope.facebookFundraiserAccessToken = accessToken
                    $rootScope.facebookFundraiserCreateStatus = 'pending'
                    fundraiserName = 'Help Keep Hearts Beating'
                    FacebookFundraiserService.createFundraiser $rootScope.secureDomain + 'images/content/pagebuilder/ym-facebook-cover.png', fundraiserName
                      .then (response) ->
                        facebookFundraiserId = if response.data.error?.code is '105' then response.data.error.debug?.fundraiserId else if response.data.error?.code is '107' then response.data.error.debug?.fundraiserId else response.data.fundraiser?.id
                        if not facebookFundraiserId
                          if response.data.error?.debug.error.error_user_title is 'Duplicate Fundraiser'
                            $rootScope.facebookFundraiserCreateStatus = 'create_fundraiser_duplicate'
                          else
                            $rootScope.facebookFundraiserCreateStatus = 'create_fundraiser_error'
                        else
                          $rootScope.facebookFundraiserCreateStatus = 'complete'
                          $rootScope.facebookFundraiserId = facebookFundraiserId
                          $rootScope.facebookFundraiserUrl =
                            url: 'https://www.facebook.com/donate/' + $rootScope.facebookFundraiserId + '/'
                          FacebookFundraiserService.syncDonations()
                          $rootScope.facebookFundraiserConfirmedStatus = 'confirmed'
                          $timeout ->
                            if jQuery('.js--facebook-fundraiser-completed-section').length > 0
                              jQuery('html, body').animate
                                scrollTop: jQuery('.js--facebook-fundraiser-completed-section').offset().top - 150
                              , 250
                          BoundlessService.logFundraiserCreated()
                  toggleFacebookFundraiserStatus()
          , scope: 'manage_fundraisers'
  ]
