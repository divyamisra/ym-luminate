angular.module('trPcControllers').controller 'NgPcSocialViewCtrl', [
  '$scope'
  '$sce'
  '$rootScope'
  'FacebookFundraiserService'
  'NuclavisService'
  'NgPcTeamraiserShortcutURLService'
  ($scope, $sce, $rootScope, FacebookFundraiserService, NuclavisService, NgPcTeamraiserShortcutURLService) ->
    #facebook fundraising
    webContent.load = 1
    $rootScope.facebookFundraiserConfirmedStatus = ''
    if location.href.indexOf("showfb") > 0
      $scope.facebookFundraisersEnabled = true
    if location.href.indexOf("fbconnected") > 0
      $scope.facebookFundraiserId = 1234
      $scope.facebookFundraiserConfirmedStatus = true
    if $scope.facebookFundraisersEnabled and $rootScope.facebookFundraiserId and $rootScope.facebookFundraiserId isnt ''
      $rootScope.facebookFundraiserConfirmedStatus = 'pending'
      FacebookFundraiserService.confirmFundraiserStatus()
        .then (response) ->
          confirmOrUnlinkFacebookFundraiserResponse = response.data.confirmOrUnlinkFacebookFundraiserResponse
          if typeof response.data.confirmOrUnlinkFacebookFundraiserResponse == 'undefined'
            confirmOrUnlinkFacebookFundraiserResponse = []
            confirmOrUnlinkFacebookFundraiserResponse.active = 'false'
          if confirmOrUnlinkFacebookFundraiserResponse?.active is 'false'
            delete $rootScope.facebookFundraiserId
            $rootScope.facebookFundraiserConfirmedStatus = 'deleted'
          else
            $rootScope.facebookFundraiserConfirmedStatus = 'confirmed'
            NuclavisService.postAction $scope.frId + '/' + $scope.consId + '/facebook_connect_hq'
    
    $scope.getParticipantShortcut = ->
      getParticipantShortcutPromise = NgPcTeamraiserShortcutURLService.getShortcut()
        .then (response) ->
          if response.data.errorResponse
            # TODO
          else
            shortcutItem = response.data.getShortcutResponse.shortcutItem
            if not shortcutItem
              # TODO
            else
              if shortcutItem.prefix
                shortcutItem.prefix = shortcutItem.prefix
              $scope.participantShortcut = shortcutItem
              if shortcutItem.url
                $scope.personalPageUrl = shortcutItem.url
              else
                $scope.personalPageUrl = shortcutItem.defaultUrl.split('/site/')[0] + '/site/TR?fr_id=' + $scope.frId + '&pg=personal&px=' + $scope.consId
              $scope.personalPageUrlEsc = window.encodeURIComponent($scope.personalPageUrl)
          response
    $scope.getParticipantShortcut()
    
    $scope.socialEarnedThankYou = 0
    $scope.putSocialMedia = (event, sel) ->
      NuclavisService.postAction $scope.frId + '/' + $scope.consId + '/opt_out_hq'
        .then (response) ->
          $scope.socialEarnedThankYou = 1

    $scope.socialEarned = -1
    getFinnsMission = ->
      NuclavisService.getBadges $scope.consId + '/' + $scope.frId
      .then (response) ->
        prizes = response.data.missions
        angular.forEach prizes, (prize) ->
          if prize.hq_button == "Go Social"
            if prize.earned != 0
              $scope.socialEarned = 1
            else 
              $scope.socialEarned = 0
    getFinnsMission()
              
    #setup social iframe
    ###
    urlPrefix = ''
    if $scope.tablePrefix is 'heartdev' or $scope.tablePrefix is 'heartnew'
      urlPrefix = 'load'
    else
      urlPrefix = 'loadaha'
    consId = $scope.consId
    frId = $rootScope.frId
    auth = $rootScope.authToken
    jsession = $rootScope.sessionCookie	
    url = 'https://' + urlPrefix + '.boundlessfundraising.com/applications/ahakhc/social/app/ui/#/addsocial/' + consId + '/' + frId + '/' + auth + '/' + jsession + '?source=PCSocial'
    $scope.socialIframeURL = $sce.trustAsResourceUrl url
    return
    ###
  ]
