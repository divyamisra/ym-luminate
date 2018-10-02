angular.module 'trPcControllers'
  .controller 'EmailMessageListViewCtrl', [
    '$scope'
    '$routeParams'
    '$location'
    '$translate'
    '$uibModal'
    'APP_INFO'
    'TeamraiserEmailService'
    'ContactService'
    ($scope, $routeParams, $location, $translate, $uibModal, APP_INFO, TeamraiserEmailService, ContactService) ->
      $scope.messageType = $routeParams.messageType
      $scope.refreshContactsNav = 0
      
      $scope.emailPromises = []
      
      $scope.messageCounts = {}
      $scope.emailMessages = 
        page: 1
      $scope.getEmailMessages = ->
        messageTypes = [
          'draft'
          'sentMessage'
        ]
        angular.forEach messageTypes, (messageType) ->
          apiMethod = 'get' + messageType.charAt(0).toUpperCase() + messageType.slice(1) + 's'
          sortColumn = if messageType is 'draft' then 'modify_date' else 'log.date_sent'
          pageSize = if $scope.messageType is messageType then '10' else '1'
          pageNumber = if $scope.messageType is messageType then $scope.emailMessages.page - 1 else 0
          messageListPromise = TeamraiserEmailService[apiMethod] 'list_sort_column=' + sortColumn + '&list_ascending=false&list_page_size=' + pageSize + '&list_page_offset=' + pageNumber
            .then (response) ->
              $scope.messageCounts[messageType + 's'] = response.data[apiMethod + 'Response'].totalNumberResults
              if $scope.messageType is messageType
                messageItems = response.data[apiMethod + 'Response'].messageItem
                messageItems = [messageItems] if not angular.isArray messageItems
                $scope.emailMessages.messages = messageItems
                $scope.emailMessages.totalNumber = response.data[apiMethod + 'Response'].totalNumberResults
              response
          $scope.emailPromises.push messageListPromise
      $scope.getEmailMessages()
      
      $scope.contactCounts = {}
      contactFilters = [
        'email_rpt_show_all'
        'email_rpt_show_never_emailed'
        'email_rpt_show_nondonors_followup'
        'email_rpt_show_unthanked_donors'
        'email_rpt_show_donors'
        'email_rpt_show_nondonors'
        'email_rpt_show_teammates'
        'email_rpt_show_lybunt_teammates'
        'email_rpt_show_ly_donors'
      ]
      angular.forEach contactFilters, (filter) ->
        contactCountPromise = ContactService.getTeamraiserAddressBookContacts 'tr_ab_filter=' + filter + '&skip_groups=true&list_page_size=1'
          .then (response) ->
            $scope.contactCounts[filter] = response.data.getTeamraiserAddressBookContactsResponse.totalNumberResults
            response
        $scope.emailPromises.push contactCountPromise
      
      $translate ['drafts_drafts_label', 'sent_sent_message_label']
        .then (translations) ->
          messageTypeNames = 
            draft: translations.drafts_drafts_label
            sentMessage: 'Sent Mail'
          $scope.messageTypeName = messageTypeNames[$scope.messageType]
        , (translationIds) ->
          messageTypeNames = 
            draft: translationIds.drafts_drafts_label
            sentMessage: 'Sent Mail'
          $scope.messageTypeName = messageTypeNames[$scope.messageType]
      
      $scope.selectMessage = (messageId) ->
        if $scope.messageType is 'draft'
          $location.path '/email/compose/draft/' + messageId
        else
          TeamraiserEmailService.getSentMessage 'message_id=' + messageId
            .then (response) ->
              if response.data.errorResponse
                # TODO
              else
                messageInfo = response.data.getSentMessageResponse?.messageInfo
                if not messageInfo
                  # TODO
                else
                  recipients = messageInfo.recipient
                  recipients = [recipients] if not angular.isArray recipients
                  messageInfo.recipient = recipients
                  $scope.sentMessage = messageInfo
          $scope.viewSentMessageModal = $uibModal.open 
            scope: $scope
            templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/participant-center/modal/viewSentMessage.html'
            size: 'lg'
      
      closeSentMessageModal = ->
        $scope.viewSentMessageModal.close()
      
      $scope.cancelViewSentMessage = ->
        closeSentMessageModal()
      
      $scope.copySentMessage = (messageId) ->
        closeSentMessageModal()
        $location.path '/email/compose/copy/' + messageId
      
      $scope.deleteMessage = (messageId) ->
        $scope.deleteMessageId = messageId
        $scope.deleteMessageModal = $uibModal.open 
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/heart-walk/html/participant-center/modal/deleteEmailMessage.html'
      
      closeDeleteMessageModal = ->
        delete $scope.deleteMessageId
        $scope.deleteMessageModal.close()
      
      $scope.cancelDeleteMessage = ->
        closeDeleteMessageModal()
      
      $scope.confirmDeleteMessage = ->
        if $scope.messageType is 'draft'
          TeamraiserEmailService.deleteDraft 'message_id=' + $scope.deleteMessageId
            .then (response) ->
              closeDeleteMessageModal()
              $scope.getEmailMessages()
        else 
          TeamraiserEmailService.deleteSentMessage 'message_id=' + $scope.deleteMessageId
            .then (response) ->
              closeDeleteMessageModal()
              $scope.getEmailMessages()
  ]