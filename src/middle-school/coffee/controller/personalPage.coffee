angular.module 'ahaLuminateControllers'
  .controller 'PersonalPageCtrl', [
    '$scope'
    '$rootScope'
    '$location'
    '$sce'
    '$filter'
    '$timeout'
    '$uibModal'
    'APP_INFO'
    'TeamraiserParticipantService'
    'TeamraiserCompanyService'
    'ZuriService'
    'NuclavisService'
    'TeamraiserParticipantPageService'
    ($scope, $rootScope, $location, $sce, $filter, $timeout, $uibModal, APP_INFO, TeamraiserParticipantService, TeamraiserCompanyService, ZuriService, NuclavisService, TeamraiserParticipantPageService) ->
      $dataRoot = angular.element '[data-aha-luminate-root]'
      $scope.participantId = $location.absUrl().split('px=')[1].split('&')[0].split('#')[0]
      $scope.companyId = $dataRoot.data('company-id') if $dataRoot.data('company-id') isnt ''
      $scope.teamId = $dataRoot.data('team-id') if $dataRoot.data('team-id') isnt ''
      $scope.eventDate =''
      $scope.schoolProgress = {}
      $scope.schoolProgress.amountRaised = 0
      $rootScope.numTeams = ''
      $rootScope.survivor = false
      $scope.companyProgress = {}
      
      $scope.prizes = {}
      $scope.prizesEarned = 0
      $scope.totalPrizes = 0
      $scope.studentChallengeBadge = false
      $scope.schoolChallengeBadge = false
      $scope.returningStudent = false
      timestamp = new Date().getTime() 
      
      NuclavisService.getBadges $scope.participantId + '/' + $scope.frId
      .then (response) ->
        prizes = response.data.missions
        angular.forEach prizes, (prize) ->
          $scope.prizes[prize.mission_id] = 
            id: prize.mission_id
            label: prize.hq_name
            status: prize.earned
          $scope.totalPrizes++
          
          if prize.earned isnt 0
            $scope.prizesEarned++

        prize = response.data.overall_mission_status
        $scope.prizes['trophy'] = 
          id: 99
          label: prize.hq_name
          status: prize.completed
          mission_url: prize.hq_action_url
          mission_url_type: prize.hq_action_type
          hover_msg: prize.hq_hover
          button_label: prize.hq_button
        $scope.totalPrizes++
        if prize.completed isnt 0
          $scope.prizesEarned++
        $scope.loadingBadges = false
      , (response) ->
        # TODO

      $scope.getSchoolPlan = () ->
        ZuriService.schoolPlanData '&method=GetSchoolPlan&CompanyId=' + $scope.companyId + '&EventId=' + $scope.frId,
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            $scope.schoolPlan = response.data.company[0]
            if $scope.schoolPlan.EventStartDate != undefined
              if $scope.schoolPlan.EventStartDate != '0000-00-00'
                $scope.schoolPlan.EventStartDate = new Date($scope.schoolPlan.EventStartDate.replace(/-/g, "/") + ' 00:01')
              if $scope.schoolPlan.EventEndDate != '0000-00-00'
                $scope.schoolPlan.EventEndDate = new Date($scope.schoolPlan.EventEndDate.replace(/-/g, "/") + ' 00:01')
              if $scope.schoolPlan.DonationDueDate != '0000-00-00'
                $scope.schoolPlan.DonationDueDate = new Date($scope.schoolPlan.DonationDueDate.replace(/-/g, "/") + ' 00:01')
              if $scope.schoolPlan.KickOffDate != '0000-00-00'
                $scope.schoolPlan.KickOffDate = new Date($scope.schoolPlan.KickOffDate.replace(/-/g, "/") + ' 00:01')
              $scope.coordinatorPoints = JSON.parse($scope.schoolPlan.PointsDetail)
            else
              $scope.schoolPlan.EventStartDate = ''
              $scope.schoolPlan.DonationDueDate = ''
              $scope.schoolPlan.KickOffDate = ''
      $scope.getSchoolPlan()
      ###
      checkSchoolChallenges = (amountRaised) ->
        amt = amountRaised / 100
        ZuriService.getSchoolData $scope.companyId,
          failure: (response) ->
            $scope.companyProgress.schoolYears = 0
            $scope.companyProgress.schoolChallenge = ''
            $scope.companyProgress.schoolChallengeLevel = ''
          error: (response) ->
            $scope.companyProgress.schoolYears = 0
            $scope.companyProgress.schoolChallenge = ''
            $scope.companyProgress.schoolChallengeLevel = ''
          success: (response) ->
            if typeof response.data.data != 'undefined'
              if response.data.data.length > 0
                angular.forEach response.data.data, (meta, key) ->
                  if meta.name == 'years-participated'
                    $scope.companyProgress.schoolYears = meta.value
                  if meta.name == 'school-challenge'
                    $scope.companyProgress.schoolChallenge = meta.value
                  if meta.name == 'school-goal'
                    $scope.companyProgress.schoolChallengeLevel = meta.value
                if amt >= Number(($scope.companyProgress.schoolChallengeLevel).replace('$', '').replace(/,/g, ''))
                  $scope.studentChallengeBadge = true
            else
              $scope.companyProgress.schoolYears = 0
              $scope.companyProgress.schoolChallenge = ''
              $scope.companyProgress.schoolChallengeLevel = ''
              
      ZuriService.getStudent $scope.frId + '/' + $scope.participantId,
        error: (response) ->
          $scope.challengeName = null
          $scope.challengeId = null
          $scope.challengeCompleted = 0
          $rootScope.survivor = false
        success: (response) ->
          if response.data.challenges.current is '0'
            $scope.challengeId = null
          else
            $scope.challengeId = response.data.challenges.current
          $scope.challengeName = response.data.challenges.text
          $scope.challengeCompleted = response.data.challenges.completed
          $rootScope.survivor = response.data.show_banner
      ###

      ZuriService.getStudentDetail '&cons_id=' + $scope.participantId,
        failure: (response) ->
        error: (response) ->
        success: (response) ->
          if response.data.company[0] != "" and response.data.company[0] != null
            if response.data.company[0].PriorYearEventId > 0
              $scope.returningStudent = true
                  
      TeamraiserCompanyService.getCompanies 'company_id=' + $scope.companyId,
        success: (response) ->
          coordinatorId = response.getCompaniesResponse?.company?.coordinatorId
          eventId = response.getCompaniesResponse?.company?.eventId
          amountRaised = Number response.getCompaniesResponse?.company?.amountRaised
          goal = Number response.getCompaniesResponse?.company?.goal
          $scope.schoolProgress.amountRaised = amountRaised / 100
          $rootScope.numTeams = response.getCompaniesResponse.company?.teamCount
          
          if coordinatorId and coordinatorId isnt '0' and eventId          
            TeamraiserCompanyService.getCoordinatorQuestion coordinatorId, eventId
              .then (response) ->
                $scope.eventDate = response.data.coordinator?.event_date
                
          ###
          if amountRaised >= goal 
            $scope.schoolChallenges.push
              id: 'school'
              label: 'School Challenge Completed'
              earned: true
          ###    
      setParticipantProgress = (amountRaised, goal) ->
        $scope.personalProgress = 
          amountRaised: if amountRaised then Number(amountRaised) else 0
          goal: if goal then Number(goal) else 0
        $scope.personalProgress.amountRaisedFormatted = $filter('currency')($scope.personalProgress.amountRaised / 100, '$')
        $scope.personalProgress.goalFormatted = $filter('currency')($scope.personalProgress.goal / 100, '$')
        $scope.personalProgress.percent = 0
        if not $scope.$$phase
          $scope.$apply()
        $timeout ->
          percent = $scope.personalProgress.percent
          if $scope.personalProgress.goal isnt 0
            percent = Math.ceil(($scope.personalProgress.amountRaised / $scope.personalProgress.goal) * 100)
          if percent > 100
            percent = 100
          $scope.personalProgress.percent = percent
          if not $scope.$$phase
            $scope.$apply()
        , 100
      
      TeamraiserParticipantService.getParticipants 'fr_id=' + $scope.frId + '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.participantId,
        error: ->
          setParticipantProgress()
        success: (response) ->
          participantInfo = response.getParticipantsResponse?.participant
          if not participantInfo
            setParticipantProgress()
          else
            setParticipantProgress Number(participantInfo.amountRaised), Number(participantInfo.goal)
          #checkSchoolChallenges Number(participantInfo.amountRaised)
          
      $scope.personalDonors = 
        page: 1
      $defaultResponsivePersonalDonors = angular.element '.js--personal-donors .team-honor-list-row'
      if $defaultResponsivePersonalDonors and $defaultResponsivePersonalDonors.length isnt 0
        if $defaultResponsivePersonalDonors.length is 1 and $defaultResponsivePersonalDonors.eq(0).find('.team-honor-list-name').length is 0
          $scope.personalDonors.donors = []
          $scope.personalDonors.totalNumber = 0
        else
          angular.forEach $defaultResponsivePersonalDonors, (personalDonor, personalDonorIndex) ->
            donorName = angular.element(personalDonor).find('.team-honor-list-name').text()
            donorAmount = angular.element(personalDonor).find('.team-honor-list-value').text()
            if not donorAmount or donorAmount.indexOf('$') is -1
              donorAmount = -1
            else
              donorAmount = Number(donorAmount.replace('$', '').replace(/,/g, '')) * 100
            if not $scope.personalDonors.donors
              $scope.personalDonors.donors = []
            $scope.personalDonors.donors.push 
              name: donorName
              amount: donorAmount
              amountFormatted: if donorAmount is -1 then '' else $filter('currency')(donorAmount / 100, '$', 2)
          $scope.personalDonors.totalNumber = $defaultResponsivePersonalDonors.length
      else
        $defaultPersonalDonors = angular.element '.js--personal-donors .scrollContent p'
        if not $defaultPersonalDonors or $defaultPersonalDonors.length is 0
          $scope.personalDonors.donors = []
          $scope.personalDonors.totalNumber = 0
        else
          angular.forEach $defaultPersonalDonors, (personalDonor, personalDonorIndex) ->
            donorName = jQuery.trim angular.element(personalDonor).html().split('<')[0]
            donorAmount = jQuery.trim angular.element(personalDonor).html().split('>')[1]
            if not donorAmount or donorAmount.indexOf('$') is -1
              donorAmount = -1
            else
              donorAmount = Number(donorAmount.replace('$', '').replace(/,/g, '')) * 100
            if not $scope.personalDonors.donors
              $scope.personalDonors.donors = []
            $scope.personalDonors.donors.push 
              name: donorName
              amount: donorAmount
              amountFormatted: if donorAmount is -1 then '' else $filter('currency')(donorAmount / 100, '$', 2)
          $scope.personalDonors.totalNumber = $defaultPersonalDonors.length
      
      $scope.personalPagePhoto1 =
        defaultUrl: APP_INFO.rootPath + 'dist/middle-school/image/fy23/personal-default.jpg'
      
      $scope.editPersonalPhoto1 = ->
        delete $scope.updatePersonalPhoto1Error
        $scope.editPersonalPhoto1Modal = $uibModal.open
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/middle-school/html/modal/editPersonalPhoto1.html'
      
      $scope.closePersonalPhoto1Modal = ->
        delete $scope.updatePersonalPhoto1Error
        $scope.editPersonalPhoto1Modal.close()
      
      $scope.cancelEditPersonalPhoto1 = ->
        $scope.closePersonalPhoto1Modal()
      
      $scope.deletePersonalPhoto1 = (e) ->
        if e
          e.preventDefault()
        angular.element('.js--delete-personal-photo-1-form').submit()
        false
      
      window.trPageEdit =
        uploadPhotoError: (response) ->
          errorResponse = response.errorResponse
          photoNumber = errorResponse.photoNumber
          errorCode = errorResponse.code
          errorMessage = errorResponse.message
          
          if errorCode is '5'
            window.location = luminateExtend.global.path.secure + 'UserLogin?NEXTURL=' + encodeURIComponent('TR?fr_id=' + $scope.frId + '&pg=personal&px=' + $scope.participantId)
          else
            if photoNumber is '1'
              $scope.updatePersonalPhoto1Error =
                message: errorMessage
            if not $scope.$$phase
              $scope.$apply()
        uploadPhotoSuccess: (response) ->
          delete $scope.updatePersonalPhoto1Error
          if not $scope.$$phase
            $scope.$apply()
          NuclavisService.postAction $scope.frId + '/' + $scope.participantId + '/personal_page_update_hq'
          successResponse = response.successResponse
          photoNumber = successResponse.photoNumber
          
          TeamraiserParticipantPageService.getPersonalPhotos
            error: (response) ->
              # TODO
            success: (response) ->
              photoItems = response.getPersonalPhotosResponse?.photoItem
              if photoItems
                photoItems = [photoItems] if not angular.isArray photoItems
                angular.forEach photoItems, (photoItem) ->
                  photoUrl = photoItem.customUrl
                  photoCaption = photoItem.caption
                  if not photoCaption or not angular.isString(photoCaption)
                    photoCaption = ''
                  if photoItem.id is '1'
                    $scope.personalPagePhoto1.customUrl = photoUrl
                    $scope.personalPagePhoto1.caption = photoCaption
              if not $scope.$$phase
                $scope.$apply()
              $scope.closePersonalPhoto1Modal()
      
      $scope.personalPageContent =
        mode: 'view'
        serial: new Date().getTime()
        textEditorToolbar: [
          [
            'bold'
            'italics'
            'underline'
          ]
          [
            'ul'
            'ol'
          ]
          [
            'undo'
            'redo'
          ]
        ]
        rich_text: angular.element('.js--default-page-content').html()
        ng_rich_text: angular.element('.js--default-page-content').html()
      
      $scope.editPersonalPageContent = ->
        richText = $scope.personalPageContent.ng_rich_text
        $richText = jQuery '<div />',
          html: richText
        richText = $richText.html()
        richText = richText.replace(/<strong>/g, '<b>').replace(/<strong /g, '<b ').replace /<\/strong>/g, '</b>'
        .replace(/<em>/g, '<i>').replace(/<em /g, '<i ').replace /<\/em>/g, '</i>'
        $scope.personalPageContent.ng_rich_text = richText
        $scope.personalPageContent.mode = 'edit'
        $timeout ->
          angular.element('[ta-bind][contenteditable]').focus()
        , 500
      
      $scope.resetPersonalPageContent = ->
        $scope.personalPageContent.ng_rich_text = $scope.personalPageContent.rich_text
        $scope.personalPageContent.mode = 'view'
      
      $scope.savePersonalPageContent = (isRetry) ->
        richText = $scope.personalPageContent.ng_rich_text
        $richText = jQuery '<div />', 
          html: richText
        richText = $richText.html()
        richText = richText.replace /<\/?[A-Z]+.*?>/g, (m) ->
          m.toLowerCase()
        .replace(/<font>/g, '<span>').replace(/<font /g, '<span ').replace /<\/font>/g, '</span>'
        .replace(/<b>/g, '<strong>').replace(/<b /g, '<strong ').replace /<\/b>/g, '</strong>'
        .replace(/<i>/g, '<em>').replace(/<i /g, '<em ').replace /<\/i>/g, '</em>'
        .replace(/<u>/g, '<span style="text-decoration: underline;">').replace(/<u /g, '<span style="text-decoration: underline;" ').replace /<\/u>/g, '</span>'
        .replace /[\u00A0-\u9999\&]/gm, (i) ->
          '&#' + i.charCodeAt(0) + ';'
        .replace /&#38;/g, '&'
        .replace /<!--[\s\S]*?-->/g, ''
        TeamraiserParticipantPageService.updatePersonalPageInfo 'rich_text=' + encodeURIComponent(richText),
          error: ->
            # TODO
          success: (response) ->
            if response.teamraiserErrorResponse
              errorCode = response.teamraiserErrorResponse.code
              if errorCode is '2647' and not isRetry
                $scope.personalPageContent.ng_rich_text = response.teamraiserErrorResponse.body
                $scope.savePageContent true
            else
              isSuccess = response.updatePersonalPageResponse?.success is 'true'
              if not isSuccess
                # TODO
              else
                $scope.personalPageContent.rich_text = richText
                $scope.personalPageContent.ng_rich_text = richText
                $scope.personalPageContent.mode = 'view'
                NuclavisService.postAction $scope.frId + '/' + $scope.participantId + '/personal_page_update_hq'
                if not $scope.$$phase
                  $scope.$apply()
  ]
