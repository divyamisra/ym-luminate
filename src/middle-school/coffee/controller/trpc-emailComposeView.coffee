angular.module 'trPcControllers'
  .controller 'NgPcEmailComposeViewCtrl', [
    '$rootScope'
    '$scope'
    '$routeParams'
    '$timeout'
    '$sce'
    '$httpParamSerializer'
    '$uibModal'
    'APP_INFO'
    'BoundlessService'
    'NgPcTeamraiserEventService'
    'NgPcTeamraiserEmailService'
    'NgPcContactService'
    ($rootScope, $scope, $routeParams, $timeout, $sce, $httpParamSerializer, $uibModal, APP_INFO, BoundlessService, NgPcTeamraiserEventService, NgPcTeamraiserEmailService, NgPcContactService) ->
      $scope.messageType = $routeParams.messageType
      $scope.messageId = $routeParams.messageId
      
      $scope.emailPromises = []
      
      # $scope.getMessageCounts = (refresh) ->
      #   $scope.messageCounts = {}
      #   messageTypes = [
      #     'draft'
      #     'sentMessage'
      #   ]
      #   angular.forEach messageTypes, (messageType) ->
      #     apiMethod = 'get' + messageType.charAt(0).toUpperCase() + messageType.slice(1) + 's'
      #     messageCountPromise = NgPcTeamraiserEmailService[apiMethod] 'list_page_size=1'
      #       .then (response) ->
      #         $scope.messageCounts[messageType + 's'] = response.data[apiMethod + 'Response'].totalNumberResults
      #         response
      #     if not refresh
      #       $scope.emailPromises.push messageCountPromise
      # $scope.getMessageCounts()
      
      $scope.getContactCounts = ->
        $scope.contactCounts = {}
        contactFilters = [
          'email_rpt_show_all'
          'email_rpt_show_never_emailed'
          'email_rpt_show_nondonors_followup'
          'email_rpt_show_unthanked_donors'
          'email_rpt_show_donors'
          'email_rpt_show_nondonors'
        ]
        if $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true'
          contactFilters.push 'email_rpt_show_company_coordinator_participants'
          contactFilters.push 'email_custom_rpt_show_company_coordinator_new_participants'
          contactFilters.push 'email_custom_rpt_show_company_coordinator_weekly_participants'
          contactFilters.push 'email_custom_rpt_show_company_coordinator_0_dollar_participants'
          contactFilters.push 'email_custom_rpt_show_company_coordinator_250_dollar_participants'
          contactFilters.push 'email_custom_rpt_show_past_company_coordinator_participants'
        angular.forEach contactFilters, (filter) ->
          if filter is 'email_custom_rpt_show_company_coordinator_new_participants' or filter is 'email_custom_rpt_show_company_coordinator_weekly_participants' or filter is 'email_custom_rpt_show_company_coordinator_0_dollar_participants' or filter is 'email_custom_rpt_show_company_coordinator_250_dollar_participants' or filter is 'email_custom_rpt_show_past_company_coordinator_participants'
            $scope.contactCounts[filter] = ''
          else
            # contactCountPromise = NgPcContactService.getTeamraiserAddressBookContacts 'tr_ab_filter=' + filter + '&skip_groups=true&list_page_size=1'
              # .then (response) ->
                # $scope.contactCounts[filter] = response.data.getTeamraiserAddressBookContactsResponse?.totalNumberResults or '0'
                # response
            # $scope.emailPromises.push contactCountPromise
            $scope.contactCounts[filter] = ''
      $scope.getContactCounts()
      
      $scope.resetSelectedContacts = ->
        $rootScope.selectedContacts = 
          contacts: []
      if not $rootScope.selectedContacts?.contacts
        $scope.resetSelectedContacts()
      
      setEmailComposerDefaults = ->
        defaultStationeryId = $scope.teamraiserConfig.defaultStationeryId
        selectedContacts = $rootScope.selectedContacts.contacts
        recipients = []
        if selectedContacts.length > 0
          angular.forEach selectedContacts, (selectedContact) ->
            if selectedContact.lastIndexOf('<>') isnt (selectedContact.length - 2)
              recipients.push selectedContact
        $scope.emailComposer =
          serial: new Date().getTime()
          message_id: ''
          ng_recipients: recipients.join ', '
          suggested_message_id: ''
          subject: ''
          prepend_salutation: false
          message_body: ''
          layout_id: if defaultStationeryId isnt '-1' then defaultStationeryId else ''
      setEmailComposerDefaults()
      
      setEmailMessageBody = (messageBody = '') ->
        if not messageBody or not angular.isString(messageBody)
          messageBody = ''
        $scope.emailComposer.message_body = messageBody
      
      getEmailMessageBody = ->
        messageBody = $scope.emailComposer.message_body
        messageBody
      
      if $scope.messageType is 'suggestedMessage' and $scope.messageId
        NgPcTeamraiserEmailService.getSuggestedMessage 'message_id=' + $scope.messageId
          .then (response) ->
            if response.data.errorResponse
              # TODO
            else
              messageInfo = response.data.getSuggestedMessageResponse?.messageInfo
              if messageInfo
                $scope.emailComposer.suggested_message_id = $scope.messageId
                $scope.emailComposer.subject = messageInfo.subject
                messageBody = messageInfo.messageBody
                setEmailMessageBody messageBody
      else if $scope.messageType is 'draft' and $scope.messageId
        NgPcTeamraiserEmailService.getDraft 'message_id=' + $scope.messageId
          .then (response) ->
            if response.data.errorResponse
              # TODO
            else
              messageInfo = response.data.getDraftResponse?.messageInfo
              if messageInfo
                $scope.emailComposer.message_id = $scope.messageId
                # TODO: recipients
                $scope.emailComposer.subject = messageInfo.subject
                # $scope.emailComposer.prepend_salutation = messageInfo.prependsalutation is 'true'
                messageBody = messageInfo.messageBody
                setEmailMessageBody messageBody
      else if $scope.messageType is 'copy' and $scope.messageId
        NgPcTeamraiserEmailService.getSentMessage 'message_id=' + $scope.messageId
          .then (response) ->
            if response.data.errorResponse
              # TODO
            else
              messageInfo = response.data.getSentMessageResponse?.messageInfo
              if messageInfo
                $scope.emailComposer.subject = messageInfo.subject
                messageBody = messageInfo.messageBody
                setEmailMessageBody messageBody

      sortOrder = {
        #"Registration - Past Participants Email (Prepare for Kickoff and Sign-Up)": 0,
        "Step 1: Ask Students to Join": 1,
        "Registration - Past Participants Email (Prepare for Kickoff and Sign-Up)": 0,
        "Staff Announcement Email": 2,
        "Email 1  THANK YOU FOR JOINING OUR TEAM (Post Kickoff Next Steps)": 3, 
        "Email 2  Midway Point to Event": 4,
        "Email 3 - 1 Week Left": 5,
        "Email 4 - Two Days Before Event": 6,
        "Email 5-Post Event Wrap-Up": 7,
        "Donation Thank You": 8,
        "THANK YOU to Students": 9,
        "ASK 1: Donation Request": 10,
        "Ask 2: Donation Reminder": 11,
        "Ask 3: Help Me Reach my Goal": 12,
        "Ask 4: Stepping Up for Health Equity": 13,
        "Ask 5: Email to Past Donors": 14,
        "ASK 6: Thank You for your Donation": 15,
        "ASK 7: Recruit your Friends!": 16
      }

      $scope.suggestedMessageCountByType = {}
      suggestedMessagesPromise = NgPcTeamraiserEmailService.getSuggestedMessages()
        .then (response) ->
          suggestedMessages = response.data.getSuggestedMessagesResponse.suggestedMessage
          suggestedMessages = [suggestedMessages] if not angular.isArray suggestedMessages
          $scope.suggestedMessages = []
          angular.forEach suggestedMessages, (message) ->
            if message.active is 'true'
              if $scope.participantRegistration.companyInformation?.isCompanyCoordinator isnt 'true'
                if message.name.indexOf('Coordinator:') is -1
                  # if not $scope.suggestedMessageCountByType[message.messageType]
                  #   $scope.suggestedMessageCountByType[message.messageType] = 0
                  # $scope.suggestedMessageCountByType[message.messageType] = $scope.suggestedMessageCountByType[message.messageType] + 1
                  message.name = message.name.split('Student: ')[1] or message.name
                  console.log('message.name x' + message.name + 'x')
                  message.name = message.name.trim()
                  console.log('message.name x' + message.name + 'x')
                  if sortOrder[message.name]
                    message.sortOrder = sortOrder[message.name]
                    console.log('message.sortOrder ' + message.sortOrder + typeof message.sortOrder)
                  $scope.suggestedMessages.push message
              else
                if message.name.indexOf('Student:') is -1
                  # if not $scope.suggestedMessageCountByType[message.messageType]
                  #   $scope.suggestedMessageCountByType[message.messageType] = 0
                  # $scope.suggestedMessageCountByType[message.messageType] = $scope.suggestedMessageCountByType[message.messageType] + 1
                  message.name = message.name.split('Coordinator: ')[1] or message.name
                  message.name = message.name.trim()
                  message.name = message.name.replace(/\r?\n|\r/g)
                  console.log('message.name x' + message.name + 'x')
                  if sortOrder[message.name]
                    message.sortOrder = sortOrder[message.name]
                    console.log('message.sortOrder ' + message.sortOrder)
                  $scope.suggestedMessages.push message
          response
      $scope.emailPromises.push suggestedMessagesPromise
      
      personalizedGreetingEnabledPromise = NgPcTeamraiserEventService.getEventDataParameter 'edp_type=boolean&edp_name=F2F_CENTER_TAF_PERSONALIZED_SALUTATION_ENABLED'
        .then (response) ->
          $scope.personalizedSalutationEnabled = response.data.getEventDataParameterResponse.booleanValue is 'true'
          response
      $scope.emailPromises.push personalizedGreetingEnabledPromise
      
      $scope.loadSuggestedMessage = ->
        suggested_message_id = $scope.emailComposer.suggested_message_id
        if suggested_message_id is ''
          $scope.emailComposer.subject = ''
          setEmailMessageBody()
        else
          NgPcTeamraiserEmailService.getSuggestedMessage 'message_id=' + suggested_message_id
            .then (response) ->
              if response.data.errorResponse
                # TODO
              else
                messageInfo = response.data.getSuggestedMessageResponse.messageInfo
                if messageInfo
                  $scope.emailComposer.subject = messageInfo.subject
                  messageBody = messageInfo.messageBody
                  setEmailMessageBody messageBody
                  if messageInfo.layoutId
                    $scope.emailComposer.layout_id = messageInfo.layoutId
      
      $scope.textEditorToolbar = [
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
          'insertImage'
          'insertLink'
        ]
        [
          'undo'
          'redo'
        ]
      ]
      
      $scope.$watchGroup ['emailComposer.subject', 'emailComposer.message_body'], ->
        subject = $scope.emailComposer.subject
        messageBody = getEmailMessageBody()
        cancelDraftPollTimeout = ->
          if $scope.draftPollTimeout
            $timeout.cancel $scope.draftPollTimeout
            delete $scope.draftPollTimeout
        if subject is '' and messageBody is ''
          cancelDraftPollTimeout()
        else
          cancelDraftPollTimeout()
          saveDraft = ->
            # TODO: show saving message to user
            requestData = $httpParamSerializer $scope.emailComposer
            if $scope.emailComposer.message_id is ''
              NgPcTeamraiserEmailService.addDraft requestData
                .then (response) ->
                  draftMessage = response.data.addDraftResponse?.message
                  if draftMessage
                    # $scope.getMessageCounts true
                    messageId = draftMessage.messageId
                    $scope.messageId = messageId
                    # TODO: add draftId to URL
                    $scope.emailComposer.message_id = messageId
                    # TODO: show saved message to user
            else
              NgPcTeamraiserEmailService.updateDraft requestData
                .then (response) ->
                  # TODO: show saved message to user
          $scope.draftPollTimeout = $timeout saveDraft, 3000
      
      $scope.emailPreview = 
        body: ''
      
      NgPcTeamraiserEmailService.getMessageLayouts()
        .then (response) ->
          if response.data.errorResponse
            # TODO
          else
            layouts = response.data.getMessageLayoutsResponse?.layout
            if layouts
              layouts = [layouts] if not angular.isArray layouts
              $scope.stationeryChoices = layouts
      
      $scope.clearEmailAlerts = ->
        if $scope.sendEmailError
          delete $scope.sendEmailError
        if $scope.sendEmailSuccess
          delete $scope.sendEmailSuccess
      
      $scope.previewEmail = ->
        $scope.clearEmailAlerts()
        recipients = $scope.emailComposer.ng_recipients.replace />;/g, '>,'
        NgPcTeamraiserEmailService.previewMessage($httpParamSerializer($scope.emailComposer) + '&recipients=' + encodeURIComponent(recipients))
          .then (response) ->
            if response.data.errorResponse
              $scope.sendEmailError = response.data.errorResponse.message
            else if response.data.teamraiserErrorResponse
              # TODO
            else
              messageBody = response.data.getMessagePreviewResponse?.message or ''
              $scope.emailPreview.body = $sce.trustAsHtml messageBody
              $scope.emailPreviewModal = $uibModal.open 
                scope: $scope
                controller: [
                  '$scope'
                  ($scope) ->
                    angular.element('html').addClass 'ym-modal-is-open'
                    $scope.$on 'modal.closing', ->
                      angular.element('html').removeClass 'ym-modal-is-open'
                ]
                templateUrl: APP_INFO.rootPath + 'dist/middle-school/html/participant-center/modal/emailPreview.html'
                size: 'lg'
                windowClass: 'ng-pc-modal ym-modal-full-screen'
      
      $scope.selectStationery = ->
        NgPcTeamraiserEmailService.previewMessage $httpParamSerializer($scope.emailComposer)
          .then (response) ->
            if response.data.errorResponse
              # TODO
            else if response.data.teamraiserErrorResponse
              # TODO
            else
              messageBody = response.data.getMessagePreviewResponse?.message or ''
              $scope.emailPreview.body = $sce.trustAsHtml messageBody
      
      closeEmailPreviewModal = ->
        $scope.emailPreviewModal.close()
      
      $scope.cancelEmailPreview = ->
        closeEmailPreviewModal()
      
      $scope.sendEmail = ->
        if not $rootScope.sendEmailPending
          $rootScope.sendEmailPending = true
          $scope.sendEmailPending = true
          recipients = $scope.emailComposer.ng_recipients.replace />;/g, '>,'
          NgPcTeamraiserEmailService.sendMessage($httpParamSerializer($scope.emailComposer) + '&recipients=' + encodeURIComponent(recipients))
            .then (response) ->
              delete $rootScope.sendEmailPending
              delete $scope.sendEmailPending
              closeEmailPreviewModal()
              window.scrollTo 0, 0
              if response.data.errorResponse
                $scope.sendEmailError = response.data.errorResponse.message
              else if response.data.teamraiserErrorResponse
                # TODO
              else
                # TODO: remove messageType and messageId from URL
                if $scope.messageId
                  deleteDraftPromise = NgPcTeamraiserEmailService.deleteDraft 'message_id=' + $scope.messageId
                    .then (response) ->
                      # $scope.getMessageCounts()
                  $scope.emailPromises.push deleteDraftPromise
                else
                  # $scope.getMessageCounts()
                $scope.getContactCounts()
                $scope.sendEmailSuccess = true
                $scope.resetSelectedContacts()
                setEmailComposerDefaults()
                window.scrollTo 0, 0
                angular.element('#emailComposer-recipients').focus()
                BoundlessService.logEmailSent()
  ]