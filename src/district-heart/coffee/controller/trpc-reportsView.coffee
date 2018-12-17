angular.module 'trPcControllers'
  .controller 'NgPcReportsViewCtrl', [
    '$rootScope'
    '$scope'
    '$filter'
    '$location'
    'NgPcTeamraiserEmailService'
    'NgPcTeamraiserGiftService'
    'NgPcTeamraiserReportsService'
    ($rootScope, $scope, $filter, $location, NgPcTeamraiserEmailService, NgPcTeamraiserGiftService, NgPcTeamraiserReportsService) ->
      $scope.reportPromises = []
      
      $scope.activeReportTab = if $scope.participantRegistration.aTeamCaptain is 'true' or $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true' then 0 else 1
      
      NgPcTeamraiserEmailService.getSuggestedMessages()
        .then (response) ->
          suggestedMessages = response.data.getSuggestedMessagesResponse.suggestedMessage
          suggestedMessages = [suggestedMessages] if not angular.isArray suggestedMessages
          $scope.suggestedMessages = []
          angular.forEach suggestedMessages, (message) ->
            if message.active is 'true'
              if $scope.participantRegistration.companyInformation?.isCompanyCoordinator isnt 'true'
                if message.name.indexOf('Coordinator:') is -1
                  if $scope.participantRegistration.aTeamCaptain isnt 'true'
                    if message.name.indexOf('Captain:') is -1
                      message.name = message.name.split('Participant: ')[1] or message.name
                      $scope.suggestedMessages.push message
                  else
                    if message.name.indexOf('Participant:') isnt -1
                      message.name = message.name.split('Participant: ')[1]
                      $scope.suggestedMessages.push message
                    else if message.name.indexOf('Captain:') isnt -1
                      message.name = message.name.split('Captain: ')[1]
                      $scope.suggestedMessages.push message
                    else
                      $scope.suggestedMessages.push message
              else
                if message.name.indexOf('Participant:') is -1
                  message.name = message.name.split('Coordinator: ')[1] or message.name
                  $scope.suggestedMessages.push message
          angular.forEach $scope.suggestedMessages, (suggestedMessage) ->
            messageType = suggestedMessage.messageType
            if messageType
              if messageType.toLowerCase() is 'thanks' and not $scope.thankYouMessageId
                $scope.thankYouMessageId = suggestedMessage.messageId
      
      $scope.participantGifts =
        sortColumn: 'date_recorded'
        sortAscending: false
        page: 1
      $scope.getGifts = ->
        pageNumber = $scope.participantGifts.page - 1
        personalGiftsPromise = NgPcTeamraiserGiftService.getGifts 'list_sort_column=' + $scope.participantGifts.sortColumn + '&list_ascending=' + $scope.participantGifts.sortAscending + '&list_page_size=500&list_page_offset=' + pageNumber
          .then (response) ->
            if response.data.errorResponse
              $scope.participantGifts.gifts = []
              $scope.participantGifts.totalNumber = 0
            else
              gifts = response.data.getGiftsResponse.gift
              if not gifts
                $scope.participantGifts.gifts = []
              else
                gifts = [gifts] if not angular.isArray gifts
                participantGifts = []
                angular.forEach gifts, (gift) ->
                  gift.contact =
                    firstName: gift.name.first
                    lastName: gift.name.last
                    email: gift.email
                  gift.giftAmountFormatted = $filter('currency') gift.giftAmount / 100, '$', 0
                  if gift.giftMessage
                    gift.showMessage = false
                  participantGifts.push gift
                $scope.participantGifts.gifts = participantGifts
              $scope.participantGifts.totalNumber = if response.data.getGiftsResponse.totalNumberResults then Number(response.data.getGiftsResponse.totalNumberResults) else 0
            response
        $scope.reportPromises.push personalGiftsPromise
      $scope.getGifts()
      
      $scope.orderParticipantGifts = (sortColumn) ->
        $scope.participantGifts.sortAscending = !$scope.participantGifts.sortAscending
        if $scope.participantGifts.sortColumn isnt sortColumn
          $scope.participantGifts.sortAscending = false
        $scope.participantGifts.sortColumn = sortColumn
        $scope.participantGifts.page = 1
        $scope.getGifts()
      
      $scope.thankParticipantDonor = (participantGift) ->
        if not $rootScope.selectedContacts
          $rootScope.selectedContacts = {}
        $rootScope.selectedContacts.contacts = []
        if participantGift
          giftContact = null
          if participantGift.contact.firstName
            giftContact = participantGift.contact.firstName
            if participantGift.contact.lastName
              giftContact += ' ' + participantGift.contact.lastName
          if participantGift.contact.email and participantGift.contact.email isnt ''
            if not giftContact
              giftContact = '<'
            else
              giftContact += ' <'
            giftContact += participantGift.contact.email + '>'
          if giftContact
            $rootScope.selectedContacts.contacts = [giftContact]
        if $scope.thankYouMessageId
          $location.path '/email/compose/suggestedMessage/' + $scope.thankYouMessageId
        else
          $location.path '/email/compose/'
      
      $scope.thankAllParticipantDonors = ->
        if not $rootScope.selectedContacts
          $rootScope.selectedContacts = {}
        $rootScope.selectedContacts.contacts = []
        if $scope.participantGifts.gifts.length > 0
          angular.forEach $scope.participantGifts.gifts, (participantGift) ->
            giftContact = null
            if participantGift.contact.firstName
              giftContact = participantGift.contact.firstName
              if participantGift.contact.lastName
                giftContact += ' ' + participantGift.contact.lastName
            if participantGift.contact.email and participantGift.contact.email isnt ''
              if not giftContact
                giftContact = '<'
              else
                giftContact += ' <'
              giftContact += participantGift.contact.email + '>'
            if giftContact
              $rootScope.selectedContacts.contacts.push giftContact
        if $scope.thankYouMessageId
          $location.path '/email/compose/suggestedMessage/' + $scope.thankYouMessageId
        else
          $location.path '/email/compose/'
      
      if $scope.participantRegistration.aTeamCaptain is 'true'
        $scope.teamGifts =
          sortColumn: 'date_recorded'
          sortAscending: false
          page: 1
        $scope.getTeamGifts = ->
          pageNumber = $scope.teamGifts.page - 1
          personalGiftsPromise = NgPcTeamraiserGiftService.getTeamGifts 'list_sort_column=' + $scope.teamGifts.sortColumn + '&list_ascending=' + $scope.teamGifts.sortAscending + '&list_page_size=500&list_page_offset=' + pageNumber
            .then (response) ->
              if response.data.errorResponse
                $scope.teamGifts.gifts = []
                $scope.teamGifts.totalNumber = 0
              else
                gifts = response.data.getGiftsResponse.gift
                if not gifts
                  $scope.teamGifts.gifts = []
                else
                  gifts = [gifts] if not angular.isArray gifts
                  teamGifts = []
                  angular.forEach gifts, (gift) ->
                    gift.contact =
                      firstName: gift.name.first
                      lastName: gift.name.last
                      email: gift.email
                    gift.giftAmountFormatted = $filter('currency') gift.giftAmount / 100, '$', 0
                    teamGifts.push gift
                  $scope.teamGifts.gifts = teamGifts
                $scope.teamGifts.totalNumber = if response.data.getGiftsResponse.totalNumberResults then Number(response.data.getGiftsResponse.totalNumberResults) else 0
              response
          $scope.reportPromises.push personalGiftsPromise
        $scope.getTeamGifts()
        
        $scope.orderTeamGifts = (sortColumn) ->
          $scope.teamGifts.sortAscending = !$scope.teamGifts.sortAscending
          if $scope.teamGifts.sortColumn isnt sortColumn
            $scope.teamGifts.sortAscending = false
          $scope.teamGifts.sortColumn = sortColumn
          $scope.teamGifts.page = 1
          $scope.getTeamGifts()
        
        $scope.thankTeamDonor = (teamGift) ->
          if not $rootScope.selectedContacts
            $rootScope.selectedContacts = {}
          $rootScope.selectedContacts.contacts = []
          if teamGift
            giftContact = null
            if teamGift.contact.firstName
              giftContact = teamGift.contact.firstName
              if teamGift.contact.lastName
                giftContact += ' ' + teamGift.contact.lastName
            if teamGift.contact.email and teamGift.contact.email isnt ''
              if not giftContact
                giftContact = '<'
              else
                giftContact += ' <'
              giftContact += teamGift.contact.email + '>'
            if giftContact
              $rootScope.selectedContacts.contacts = [giftContact]
          if $scope.thankYouMessageId
            $location.path '/email/compose/suggestedMessage/' + $scope.thankYouMessageId
          else
            $location.path '/email/compose/'
        
        $scope.thankAllTeamDonors = ->
          if not $rootScope.selectedContacts
            $rootScope.selectedContacts = {}
          $rootScope.selectedContacts.contacts = []
          if $scope.teamGifts.gifts.length > 0
            angular.forEach $scope.teamGifts.gifts, (teamGift) ->
              giftContact = null
              if teamGift.contact.firstName
                giftContact = teamGift.contact.firstName
                if teamGift.contact.lastName
                  giftContact += ' ' + teamGift.contact.lastName
              if teamGift.contact.email and teamGift.contact.email isnt ''
                if not giftContact
                  giftContact = '<'
                else
                  giftContact += ' <'
                giftContact += teamGift.contact.email + '>'
              if giftContact
                $rootScope.selectedContacts.contacts.push giftContact
          if $scope.thankYouMessageId
            $location.path '/email/compose/suggestedMessage/' + $scope.thankYouMessageId
          else
            $location.path '/email/compose/'

      
      if $scope.participantRegistration.aTeamCaptain is 'true' or $scope.participantRegistration.companyInformation?.isCompanyCoordinator is 'true'
        $scope.districtDetailParticipants =
          downloadHeaders: [
            'Team Name'
            'Name'
            'Email Address'
            'Amount'
            'Emails Sent'
            'T-shirt'
            'Blood Pressure Checked'
            'Min. of Activity'
          ]
          sortColumn: 'teamName'
          sortAscending: true
        districtDetailReportPromise = NgPcTeamraiserReportsService.getDistrictDetailReport()
          .then (response) ->
            if response.data.errorResponse
              $scope.districtDetailParticipants.participants = []
              $scope.districtDetailParticipants.downloadData = []
            else
              reportData = response.data.getSchoolDetailReport?.reportData
              if not reportData
                $scope.districtDetailParticipants.participants = []
                $scope.districtDetailParticipants.downloadData = []
              else
                reportDataRows = []
                angular.forEach reportData, (reportDataRow) ->
                  if reportDataRow.length > 1
                    reportDataRows.push reportDataRow
                if reportDataRows.length <= 1
                  $scope.districtDetailParticipants.participants = []
                  $scope.districtDetailParticipants.downloadData = []
                else
                  reportDataColumnIndexMap = {}
                  angular.forEach reportDataRows[0], (reportDataHeader, reportDataHeaderIndex) ->
                    reportDataColumnIndexMap[reportDataHeader] = reportDataHeaderIndex
                  districtDetailParticipants = []
                  districtDetailDownloadData = []
                  angular.forEach reportDataRows, (reportDataRow, reportDataRowIndex) ->
                    if reportDataRowIndex > 0
                      teamName = jQuery.trim reportDataRow[reportDataColumnIndexMap.TEAM_NAME]
                      firstName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_FIRST_NAME]
                      lastName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_LAST_NAME]
                      email = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_EMAIL]
                      amount = Number reportDataRow[reportDataColumnIndexMap.TRX_AMT]
                      amountFormatted = $filter('currency') jQuery.trim(reportDataRow[reportDataColumnIndexMap.TRX_AMT]), '$'
                      ecardsSent = Number reportDataRow[reportDataColumnIndexMap.ECARDS_SENT_CNT]
                      emailsSent = Number reportDataRow[reportDataColumnIndexMap.EMAILS_SENT_CNT]
                      tshirtSize = jQuery.trim reportDataRow[reportDataColumnIndexMap.TSHIRT_SIZE]
                      challenge2 = jQuery.trim reportDataRow[reportDataColumnIndexMap.CHALLENGE2]
                      bloodPressureCheck = ''
                      if challenge2?.toLowerCase() is 'true'
                        bloodPressureCheck = 'Yes'
                      else
                        bloodPressureCheck = 'No'
                      challenge1 = reportDataRow[reportDataColumnIndexMap.CHALLENGE1]
                      minsActivity = ''
                      if not challenge1 or challenge1 is ''
                        minsActivity = '0'
                      else
                        minsActivity = challenge1
                      districtDetailParticipants.push
                        teamName: teamName
                        firstName: firstName
                        lastName: lastName
                        email: email
                        amount: amount
                        amountFormatted: amountFormatted.replace '.00', ''
                        ecardsSent: ecardsSent
                        emailsSent: emailsSent
                        tshirtSize: tshirtSize
                        bloodPressureCheck: bloodPressureCheck
                        minsActivity: minsActivity
                      districtDetailDownloadData.push [
                        teamName
                        firstName + ' ' + lastName
                        email
                        amountFormatted.replace('$', '').replace /,/g, ''
                        emailsSent
                        tshirtSize
                        bloodPressureCheck
                        minsActivity
                      ]
                  $scope.districtDetailParticipants.participants = districtDetailParticipants
                  $scope.districtDetailParticipants.downloadData = districtDetailDownloadData
            response
        $scope.reportPromises.push districtDetailReportPromise
        
        $scope.orderDistrictDetailParticipants = (sortColumn) ->
          $scope.districtDetailParticipants.sortAscending = !$scope.districtDetailParticipants.sortAscending
          if $scope.districtDetailParticipants.sortColumn isnt sortColumn
            $scope.districtDetailParticipants.sortAscending = false
          $scope.districtDetailParticipants.sortColumn = sortColumn
          orderBy = $filter 'orderBy'
          $scope.districtDetailParticipants.participants = orderBy $scope.districtDetailParticipants.participants, sortColumn, !$scope.districtDetailParticipants.sortAscending
        
        $scope.emailAllCompanyParticipants = ->
          if not $rootScope.selectedContacts
            $rootScope.selectedContacts = {}
          $rootScope.selectedContacts.contacts = []
          if $scope.districtDetailParticipants.participants.length > 0
            angular.forEach $scope.districtDetailParticipants.participants, (companyParticipant) ->
              companyParticipantContact = null
              if companyParticipant.firstName
                companyParticipantContact = companyParticipant.firstName
                if companyParticipant.lastName
                  companyParticipantContact += ' ' + companyParticipant.lastName
              if companyParticipant.email and companyParticipant.email isnt ''
                if not companyParticipantContact
                  companyParticipantContact = '<'
                else
                  companyParticipantContact += ' <'
                companyParticipantContact += companyParticipant.email + '>'
              if companyParticipantContact
                $rootScope.selectedContacts.contacts.push companyParticipantContact
          $location.path '/email/compose/'
  ]