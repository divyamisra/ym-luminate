angular.module 'trPcControllers'
  .controller 'NgPcEmailContactsListViewCtrl', [
    '$rootScope'
    '$scope'
    '$window'
    '$routeParams'
    '$location'
    '$timeout'
    '$httpParamSerializer'
    '$uibModal'
    'APP_INFO'
    'NgPcTeamraiserEmailService'
    'NgPcContactService'
    'NgPcTeamraiserCompanyService'
    'NgPcTeamraiserReportsService'
    'ZuriService'
    ($rootScope, $scope, $window, $routeParams, $location, $timeout, $httpParamSerializer, $uibModal, APP_INFO, NgPcTeamraiserEmailService, NgPcContactService, NgPcTeamraiserCompanyService, NgPcTeamraiserReportsService, ZuriService) ->
      $scope.filter = $routeParams.filter
      
      $scope.emailPromises = []
      $scope.schoolChallengeAmount = '0'

      # $scope.messageCounts = {}
      # messageTypes = [
      #   'draft'
      #   'sentMessage'
      # ]
      # angular.forEach messageTypes, (messageType) ->
      #   apiMethod = 'get' + messageType.charAt(0).toUpperCase() + messageType.slice(1) + 's'
      #   messageCountPromise = NgPcTeamraiserEmailService[apiMethod] 'list_page_size=1'
      #     .then (response) ->
      #       $scope.messageCounts[messageType + 's'] = response.data[apiMethod + 'Response'].totalNumberResults
      #       response
      #   $scope.emailPromises.push messageCountPromise
      
      $scope.focusPanel = ->
        $elem = angular.element '.contacts-list__actions-selected .btn'
        if $elem.length is 0
          $timeout $scope.focusPanel, 500
        else
          $elem[0].focus()
        false
      $scope.focusPanel()
      
      getContactString = (contact) ->
        contactData = ''
        if contact?.firstName
          contactData += '"' + contact.firstName.replace(/,/g, '')
        if contact?.lastName
          if contactData is ''
            contactData += '"'
          else
            contactData += ' '
          contactData += contact.lastName.replace(/,/g, '')
        if contactData isnt ''
          contactData += '"'
        if contactData isnt ''
          contactData += ' '
        contactData += '<'
        if contact?.email
          contactData += contact.email
        contactData += '>'
        contactData
      
      isContactSelected = (contact) ->
        contactData = getContactString contact
        contactIndex = $rootScope.selectedContacts.contacts.indexOf contactData
        contactIndex isnt -1
      
      countContactSelected = (contacts) ->
        count = 0
        angular.forEach contacts, (contact) ->
          if contact?.selected
            count = count + 1
        count
      
      isAllContactsSelected = ->
        $scope.addressBookContacts.allContacts.length > 0 and $scope.addressBookContacts.allContacts.length is countContactSelected($scope.addressBookContacts.allContacts)
      
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

        contactFilters.push 'email_custom_rpt_show_company_coordinator_mission_partial'
        contactFilters.push 'email_custom_rpt_show_company_coordinator_mission_complete'
        contactFilters.push 'email_custom_rpt_show_company_coordinator_challenge_half'
        contactFilters.push 'email_custom_rpt_show_company_coordinator_challenge_complete'
        
        contactFilters.push 'email_custom_rpt_show_past_company_coordinator_participants'
      $scope.addressBookContacts = 
        page: 1
        allContactsSelected: false
      angular.forEach contactFilters, (filter) ->
        console.log('contact filters each function')
        if filter is $scope.filter
          $scope.getContacts = ->
            pageNumber = $scope.addressBookContacts.page - 1
            if pageNumber > 0
              window.scrollTo 0, 0
            if filter is 'email_custom_rpt_show_company_coordinator_new_participants' or filter is 'email_custom_rpt_show_past_company_coordinator_participants'
              if $scope.participantRegistration.companyInformation?.isCompanyCoordinator isnt 'true'
                $scope.addressBookContacts.contacts = []
                $scope.addressBookContacts.totalNumber = 0
                $scope.addressBookContacts.allContacts = []
                $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
              else if not $scope.prev1FrId or $scope.prev1FrId is ''
                $scope.addressBookContacts.contacts = []
                $scope.addressBookContacts.totalNumber = 0
                $scope.addressBookContacts.allContacts = []
                $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
              else
                if $scope.addressBookContacts.contacts
                  delete $scope.addressBookContacts.contacts
                NgPcTeamraiserCompanyService.getCompanies 'fr_id=' + $scope.prev1FrId + '&company_name=' + encodeURIComponent('org_for_company_id=' + $scope.participantRegistration.companyInformation.companyId)
                  .then (response) ->
                    participants = []
                    totalNumberResults = 0
                    setAddressBookContacts = ->
                      $scope.addressBookContacts.contacts = participants
                      $scope.addressBookContacts.totalNumber = totalNumberResults
                      $scope.addressBookContacts.allContacts = participants
                      $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
                    getCurrentContacts = ->
                      NgPcTeamraiserReportsService.getSchoolDetailReport $rootScope.frId, $scope.participantRegistration.companyInformation.companyId
                        .then (response) ->
                          reportCurrentData = response.data.getSchoolDetailReport?.reportData
                          handleReportData reportCurrentData, true
                          setAddressBookContacts()
                    getPrev2Contacts = ->
                      companyId = prev1CompanyId or $scope.participantRegistration.companyInformation.companyId
                      NgPcTeamraiserCompanyService.getCompanies 'fr_id=' + $scope.prev2FrId + '&company_name=' + encodeURIComponent('org_for_company_id=' + companyId)
                        .then (response) ->
                          prev2Companies = response.data.getCompaniesResponse?.company
                          if not prev2Companies
                            if filter is 'email_custom_rpt_show_past_company_coordinator_participants'
                              setAddressBookContacts()
                            else
                              getCurrentContacts()
                          else
                            prev2Companies = [prev2Companies] if not angular.isArray prev2Companies
                            prev2Company = prev2Companies[0]
                            prev2CompanyId = prev2Company.companyId
                            NgPcTeamraiserReportsService.getSchoolDetailReport $scope.prev2FrId, prev2CompanyId
                              .then (response) ->
                                report2Data = response.data.getSchoolDetailReport?.reportData
                                handleReportData report2Data
                                if filter is 'email_custom_rpt_show_past_company_coordinator_participants'
                                  setAddressBookContacts()
                                else
                                  getCurrentContacts()
                    handleReportData = (reportData, newOnly) ->
                      if reportData
                        if newOnly
                          newParticipants = []
                          totalNumberNewResults = 0
                        reportDataRows = []
                        angular.forEach reportData, (reportDataRow) ->
                          if reportDataRow.length > 1
                            reportDataRows.push reportDataRow
                        if reportDataRows.length > 1
                          reportDataColumnIndexMap = {}
                          angular.forEach reportDataRows[0], (reportDataHeader, reportDataHeaderIndex) ->
                            reportDataColumnIndexMap[reportDataHeader] = reportDataHeaderIndex
                          angular.forEach reportDataRows, (reportDataRow, reportDataRowIndex) ->
                            if reportDataRowIndex > 0
                              firstName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_FIRST_NAME]
                              lastName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_LAST_NAME]
                              email = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_EMAIL]
                              grade = jQuery.trim reportDataRow[reportDataColumnIndexMap.GRADE_LEVEL]
                              contact =
                                firstName: firstName
                                lastName: lastName
                                email: email
                                grade: grade
                              contact.selected = isContactSelected contact
                              contactIsUnique = true
                              if reportDataRow[reportDataColumnIndexMap.PARTICIPANT_TYPE_NAME]
                                console.log('found the part type name column')
                                partTypeName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_TYPE_NAME]
                              angular.forEach participants, (participant) ->
                                console.log('partTypeName ' + partTypeName)
                                contactString = firstName.toLowerCase() + ' ' + lastName.toLowerCase() + ' <' + email.toLowerCase() + '>'
                                participantString = participant.firstName.toLowerCase() + ' ' + participant.lastName.toLowerCase() + ' <' + participant.email.toLowerCase() + '>'
                                if contactString is participantString
                                  contactIsUnique = false
                              if partTypeName is 'Participant' || partTypeName is ''
                                if contactIsUnique
                                  totalNumberResults++
                                  participants.push contact
                                  if newOnly
                                    totalNumberNewResults++
                                    newParticipants.push contact
                        if newOnly
                          participants = newParticipants
                          totalNumberResults = totalNumberNewResults
                        participants.sort (a, b) ->
                          aFullName = a.firstName.toLowerCase() + ' ' + a.lastName.toLowerCase()
                          bFullName = b.firstName.toLowerCase() + ' ' + b.lastName.toLowerCase()
                          if aFullName < bFullName
                            return -1
                          else if aFullName > bFullName
                            return 1
                          else
                            return 0
                    prev1Companies = response.data.getCompaniesResponse?.company
                    prev1CompanyId = null
                    if prev1Companies
                      prev1Companies = [prev1Companies] if not angular.isArray prev1Companies
                      prev1Company = prev1Companies[0]
                      prev1CompanyId = prev1Company.companyId
                    if not prev1CompanyId
                      if not $scope.prev2FrId or $scope.prev2FrId is ''
                        if filter is 'email_custom_rpt_show_past_company_coordinator_participants'
                          setAddressBookContacts()
                        else
                          getCurrentContacts()
                      else
                        getPrev2Contacts()
                    else
                      NgPcTeamraiserReportsService.getSchoolDetailReport $scope.prev1FrId, prev1CompanyId
                        .then (response) ->
                          report1Data = response.data.getSchoolDetailReport?.reportData
                          handleReportData report1Data
                          if not $scope.prev2FrId or $scope.prev2FrId is ''
                            if filter is 'email_custom_rpt_show_past_company_coordinator_participants'
                              setAddressBookContacts()
                            else
                              getCurrentContacts()
                          else
                            getPrev2Contacts()
            else if filter is 'email_custom_rpt_show_company_coordinator_weekly_participants' or filter is 'email_custom_rpt_show_company_coordinator_0_dollar_participants' or filter is 'email_custom_rpt_show_company_coordinator_250_dollar_participants'
              if $scope.participantRegistration.companyInformation?.isCompanyCoordinator isnt 'true'
                $scope.addressBookContacts.contacts = []
                $scope.addressBookContacts.totalNumber = 0
                $scope.addressBookContacts.allContacts = []
                $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
              else
                if $scope.addressBookContacts.contacts
                  delete $scope.addressBookContacts.contacts
                filteredParticipants = []
                totalNumberResults = 0
                NgPcTeamraiserReportsService.getSchoolDetailReport()
                  .then (response) ->
                    reportData = response.data.getSchoolDetailReport?.reportData
                    handleReportData reportData
                    $scope.addressBookContacts.contacts = filteredParticipants
                    $scope.addressBookContacts.totalNumber = totalNumberResults
                    $scope.addressBookContacts.allContacts = filteredParticipants
                    $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
                handleReportData = (reportData) ->
                  if reportData
                    reportDataRows = []
                    angular.forEach reportData, (reportDataRow) ->
                      if reportDataRow.length > 1
                        reportDataRows.push reportDataRow
                    if reportDataRows.length > 1
                      reportDataColumnIndexMap = {}
                      angular.forEach reportDataRows[0], (reportDataHeader, reportDataHeaderIndex) ->
                        reportDataColumnIndexMap[reportDataHeader] = reportDataHeaderIndex
                      angular.forEach reportDataRows, (reportDataRow, reportDataRowIndex) ->
                        if reportDataRowIndex > 0
                          firstName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_FIRST_NAME]
                          lastName = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_LAST_NAME]
                          email = jQuery.trim reportDataRow[reportDataColumnIndexMap.PARTICIPANT_EMAIL]
                          grade = jQuery.trim reportDataRow[reportDataColumnIndexMap.GRADE_LEVEL]
                          amountRaised = Number reportDataRow[reportDataColumnIndexMap.TRX_AMT]
                          registrationDateFormatted = reportDataRow[reportDataColumnIndexMap.REGISTRATION_DATE]
                          registrationDate = null
                          if registrationDateFormatted and registrationDateFormatted.split('/').length is 3
                            registrationDate = new Date(registrationDateFormatted.split('/')[2], Number(registrationDateFormatted.split('/')[0]) - 1, registrationDateFormatted.split('/')[1])
                          contact =
                            firstName: firstName
                            lastName: lastName
                            email: email
                            grade: grade
                            amountRaised: amountRaised
                            registrationDateFormatted: registrationDateFormatted
                          contact.selected = isContactSelected contact
                          contactIsUnique = true
                          angular.forEach filteredParticipants, (filteredParticipant) ->
                            contactString = firstName.toLowerCase() + ' ' + lastName.toLowerCase() + ' <' + email.toLowerCase() + '>'
                            filteredParticipantString = filteredParticipant.firstName.toLowerCase() + ' ' + filteredParticipant.lastName.toLowerCase() + ' <' + filteredParticipant.email.toLowerCase() + '>'
                            if contactString is filteredParticipantString
                              contactIsUnique = false
                          contactMeetsCustomFilter = false
                          if filter is 'email_custom_rpt_show_company_coordinator_weekly_participants' and registrationDate and moment(registrationDate).isBetween(moment().startOf('isoweek'), moment().endOf('isoweek'), null, '[]')
                            contactMeetsCustomFilter = true
                          else if filter is 'email_custom_rpt_show_company_coordinator_0_dollar_participants' and amountRaised is 0
                            contactMeetsCustomFilter = true
                          else if filter is 'email_custom_rpt_show_company_coordinator_250_dollar_participants' and amountRaised >= 250
                            contactMeetsCustomFilter = true
                          if contactIsUnique and contactMeetsCustomFilter
                            totalNumberResults++
                            filteredParticipants.push contact
                      filteredParticipants.sort (a, b) ->
                        aFullName = a.firstName.toLowerCase() + ' ' + a.lastName.toLowerCase()
                        bFullName = b.firstName.toLowerCase() + ' ' + b.lastName.toLowerCase()
                        if aFullName < bFullName
                          return -1
                        else if aFullName > bFullName
                          return 1
                        else
                          return 0

            else if filter is 'email_custom_rpt_show_company_coordinator_mission_partial' or filter is 'email_custom_rpt_show_company_coordinator_mission_complete' or filter is 'email_custom_rpt_show_company_coordinator_challenge_half' or filter is 'email_custom_rpt_show_company_coordinator_challenge_complete'
              if $scope.participantRegistration.companyInformation?.isCompanyCoordinator isnt 'true'
                $scope.addressBookContacts.contacts = []
                $scope.addressBookContacts.totalNumber = 0
                $scope.addressBookContacts.allContacts = []
                $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
              else
                if $scope.addressBookContacts.contacts
                  delete $scope.addressBookContacts.contacts
                filteredParticipants = []
                totalNumberResults = 0
                ZuriService.getSchoolContacts '&SchoolId=' + $scope.participantRegistration.companyInformation.companyId + '&EventId=' + $scope.frId,
                  failure: (response) ->
                  error: (response) ->
                  success: (response) ->
                    if response.data.company[0] != "" and response.data.company[0] != null
                      reportData = response.data.company[0]
                      ZuriService.getSchoolData $scope.participantRegistration.companyInformation.companyId,
                        failure: (response) ->
                        error: (response) ->
                        success: (response) ->
                          if typeof response.data.data != 'undefined'
                            if response.data.data.length > 0
                              angular.forEach response.data.data, (meta, key) ->
                                if meta.name == 'school-goal'
                                  $scope.schoolChallengeAmount = meta.value                      
                          handleReportData reportData
                          $scope.addressBookContacts.contacts = filteredParticipants
                          $scope.addressBookContacts.totalNumber = totalNumberResults
                          $scope.addressBookContacts.allContacts = filteredParticipants
                          $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
                handleReportData = (reportData) ->
                  if reportData
                    reportDataRows = []
                    angular.forEach reportData, (reportDataRow) ->
                      if reportDataRow.length > 1
                        reportDataRows.push reportDataRow
                    if reportDataRows.length > 1
                      reportDataColumnIndexMap = {}
                      angular.forEach reportDataRows[0], (reportDataHeader, reportDataHeaderIndex) ->
                        reportDataColumnIndexMap[reportDataHeader] = reportDataHeaderIndex
                      angular.forEach reportDataRows, (reportDataRow, reportDataRowIndex) ->
                        if reportDataRowIndex > 0
                          firstName = jQuery.trim reportDataRow[reportDataColumnIndexMap.StudentFirstName]
                          lastName = jQuery.trim reportDataRow[reportDataColumnIndexMap.StudentLastName]
                          email = jQuery.trim reportDataRow[reportDataColumnIndexMap.StudentEmail]
                          challengeAmount = $scope.schoolChallengeAmount
                          challengeAmount = Number(challengeAmount.split('$')[1])
                          console.log('challengeAmount ' + challengeAmount + typeof challengeAmount)
                          amountRaised = Number reportDataRow[reportDataColumnIndexMap.AmountRaised]
                          console.log('amountRaised ' + amountRaised)
                          challengePercent = (amountRaised/challengeAmount) * 100
                          console.log('challengePercent ' + challengePercent)
                          finnsMission = reportDataRow[reportDataColumnIndexMap.FinnsMission]
                          console.log('finnsMission ' + finnsMission + typeof finnsMission)
                          #registrationDate = null
                          # if registrationDateFormatted and registrationDateFormatted.split('/').length is 3
                          #   registrationDate = new Date(registrationDateFormatted.split('/')[2], Number(registrationDateFormatted.split('/')[0]) - 1, registrationDateFormatted.split('/')[1])
                          contact =
                            firstName: firstName
                            lastName: lastName
                            email: email
                            challengeAmount: challengeAmount
                            amountRaised: amountRaised
                            finnsMission: finnsMission
                          contact.selected = isContactSelected contact
                          contactIsUnique = true
                          angular.forEach filteredParticipants, (filteredParticipant) ->
                            contactString = firstName.toLowerCase() + ' ' + lastName.toLowerCase() + ' <' + email.toLowerCase() + '>'
                            filteredParticipantString = filteredParticipant.firstName.toLowerCase() + ' ' + filteredParticipant.lastName.toLowerCase() + ' <' + filteredParticipant.email.toLowerCase() + '>'
                            if contactString is filteredParticipantString
                              contactIsUnique = false
                          contactMeetsCustomFilter = false
                          if filter is 'email_custom_rpt_show_company_coordinator_mission_partial' and finnsMission is 'NO'
                            contactMeetsCustomFilter = true
                          else if filter is 'email_custom_rpt_show_company_coordinator_mission_complete' and finnsMission is 'YES'
                            contactMeetsCustomFilter = true
                          else if filter is 'email_custom_rpt_show_company_coordinator_challenge_half' and challengePercent >= 50 and challengePercent < 100 
                            contactMeetsCustomFilter = true
                          else if filter is 'email_custom_rpt_show_company_coordinator_challenge_complete' and amountRaised >= challengeAmount
                            contactMeetsCustomFilter = true

                          if contactIsUnique and contactMeetsCustomFilter
                            totalNumberResults++
                            filteredParticipants.push contact
                      filteredParticipants.sort (a, b) ->
                        aFullName = a.firstName.toLowerCase() + ' ' + a.lastName.toLowerCase()
                        bFullName = b.firstName.toLowerCase() + ' ' + b.lastName.toLowerCase()
                        if aFullName < bFullName
                          return -1
                        else if aFullName > bFullName
                          return 1
                        else
                          return 0







            else
              contactsPromise = NgPcContactService.getTeamraiserAddressBookContacts 'tr_ab_filter=' + filter + '&skip_groups=true&list_page_size=10&list_page_offset=' + pageNumber
                .then (response) ->
                  # $scope.contactCounts[filter] = $scope.addressBookContacts.totalNumber = response.data.getTeamraiserAddressBookContactsResponse?.totalNumberResults or '0'
                  $scope.addressBookContacts.totalNumber = response.data.getTeamraiserAddressBookContactsResponse?.totalNumberResults or '0'
                  addressBookContacts = response.data.getTeamraiserAddressBookContactsResponse?.addressBookContact or []
                  addressBookContacts = [addressBookContacts] if not angular.isArray addressBookContacts
                  contacts = []
                  angular.forEach addressBookContacts, (contact) ->
                    if contact
                      if contact.firstName
                        contact.firstName = jQuery('<div>' + contact.firstName.replace(/&amp;/g, '&') + '</div>').text()
                      if contact.lastName
                        contact.lastName = jQuery('<div>' + contact.lastName.replace(/&amp;/g, '&') + '</div>').text()
                      contact.selected = isContactSelected contact
                      contacts.push contact
                  $scope.addressBookContacts.contacts = contacts
                  response
              $scope.emailPromises.push contactsPromise
          $scope.getContacts()
          $scope.getAllContacts = ->
            if not $scope.addressBookContacts.getAllPage
              $scope.addressBookContacts.allContacts = []
              $scope.addressBookContacts.getAllPage = 0
            pageNumber = $scope.addressBookContacts.getAllPage
            if filter is 'email_custom_rpt_show_company_coordinator_new_participants' or filter is 'email_custom_rpt_show_company_coordinator_weekly_participants' or filter is 'email_custom_rpt_show_company_coordinator_0_dollar_participants' or filter is 'email_custom_rpt_show_company_coordinator_250_dollar_participants' or filter is 'email_custom_rpt_show_past_company_coordinator_participants' or filter is 'email_custom_rpt_show_company_coordinator_mission_partial' or filter is 'email_custom_rpt_show_company_coordinator_mission_complete' or filter is 'email_custom_rpt_show_company_coordinator_challenge_half' or filter is 'email_custom_rpt_show_company_coordinator_challenge_complete'
              delete $scope.addressBookContacts.getAllPage
            else
              allContactsPromise = NgPcContactService.getTeamraiserAddressBookContacts 'tr_ab_filter=' + filter + '&skip_groups=true&list_page_size=200&list_page_offset=' + pageNumber
                .then (response) ->
                  totalNumber = response.data.getTeamraiserAddressBookContactsResponse?.totalNumberResults or '0'
                  addressBookContacts = response.data.getTeamraiserAddressBookContactsResponse?.addressBookContact or []
                  addressBookContacts = [addressBookContacts] if not angular.isArray addressBookContacts
                  contacts = []
                  angular.forEach addressBookContacts, (contact) ->
                    if contact
                      if contact.firstName
                        contact.firstName = jQuery('<div>' + contact.firstName.replace(/&amp;/g, '&') + '</div>').text()
                      if contact.lastName
                        contact.lastName = jQuery('<div>' + contact.lastName.replace(/&amp;/g, '&') + '</div>').text()
                      contact.selected = isContactSelected contact
                      $scope.addressBookContacts.allContacts.push contact
                  if $scope.addressBookContacts.allContacts.length < totalNumber
                    $scope.addressBookContacts.getAllPage = $scope.addressBookContacts.getAllPage + 1
                    $scope.getAllContacts()
                  else
                    delete $scope.addressBookContacts.getAllPage
                    $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
                    response
              $scope.emailPromises.push allContactsPromise
          $scope.getAllContacts()
        else
          if filter is 'email_custom_rpt_show_company_coordinator_new_participants' or filter is 'email_custom_rpt_show_company_coordinator_weekly_participants' or filter is 'email_custom_rpt_show_company_coordinator_0_dollar_participants' or filter is 'email_custom_rpt_show_company_coordinator_250_dollar_participants' or filter is 'email_custom_rpt_show_past_company_coordinator_participants' or filter is 'email_custom_rpt_show_company_coordinator_mission_partial' or filter is 'email_custom_rpt_show_company_coordinator_mission_complete' or filter is 'email_custom_rpt_show_company_coordinator_challenge_half' or filter is 'email_custom_rpt_show_company_coordinator_challenge_complete'
            $scope.contactCounts[filter] = ''
          else
            # contactCountPromise = NgPcContactService.getTeamraiserAddressBookContacts 'tr_ab_filter=' + filter + '&skip_groups=true&list_page_size=1'
              # .then (response) ->
                # $scope.contactCounts[filter] = response.data.getTeamraiserAddressBookContactsResponse?.totalNumberResults or '0'
                # response
            # $scope.emailPromises.push contactCountPromise
            $scope.contactCounts[filter] = ''
      
      filterNames = 
        email_rpt_show_all: 'All Contacts'
        email_rpt_show_never_emailed: 'Never Emailed'
        email_rpt_show_nondonors_followup: 'Needs Follow-Up'
        email_rpt_show_unthanked_donors: 'Unthanked Donors'
        email_rpt_show_donors: 'Donors'
        email_rpt_show_nondonors: 'Non-Donors'
        email_rpt_show_company_coordinator_participants: 'School Participants'
        email_custom_rpt_show_company_coordinator_new_participants: 'New to Kids Heart Challenge'
        email_custom_rpt_show_company_coordinator_weekly_participants: 'New Registrations'
        email_custom_rpt_show_company_coordinator_0_dollar_participants: '$0 Participants'
        email_custom_rpt_show_company_coordinator_250_dollar_participants: '$250 Participants'
        email_custom_rpt_show_company_coordinator_mission_partial: 'Finn\'s Mission Not Complete'
        email_custom_rpt_show_company_coordinator_mission_complete: 'Completed Finn\'s Mission'
        email_custom_rpt_show_company_coordinator_challenge_half: '50% of School Challenge'
        email_custom_rpt_show_company_coordinator_challenge_complete: 'Met School Challenge'
        email_custom_rpt_show_past_company_coordinator_participants: 'Past School Participants'


      $scope.filterName = filterNames[$scope.filter]
      
      $scope.clearAllContactAlerts = ->
        $scope.clearAddContactAlerts()
        $scope.clearImportContactsAlerts()
        $scope.clearEditContactAlerts()
        $scope.clearDeleteContactAlerts()
      
      $scope.clearAddContactAlerts = ->
        if $scope.addContactError
          delete $scope.addContactError
        if $scope.addContactSuccess
          delete $scope.addContactSuccess
      
      $scope.resetNewContact = ->
        $scope.newContact =
          first_name: ''
          last_name: ''
          email: ''
      
      $scope.addContact = ->
        $scope.clearAllContactAlerts()
        $scope.resetNewContact()
        $scope.addContactModal = $uibModal.open 
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/addContact.html'
      
      closeAddContactModal = ->
        $scope.addContactModal.close()
      
      $scope.cancelAddContact = ->
        $scope.clearAddContactAlerts()
        closeAddContactModal()
      
      $scope.addNewContact = ->
        $scope.clearAddContactAlerts()
        if this.addNewContactForm.$valid
          addContactPromise = NgPcContactService.addAddressBookContact $httpParamSerializer($scope.newContact)
            .then (response) ->
              if response.data.errorResponse
                $scope.addContactError = response.data.errorResponse.message
              else
                $scope.addContactSuccess = ''
                closeAddContactModal()
                $scope.getContacts()
                $scope.getAllContacts()
              response
          $scope.emailPromises.push addContactPromise
      
      $scope.clearImportContactsAlerts = ->
        if $scope.importContactsError
          delete $scope.importContactsError
        if $scope.importContactsSuccess
          delete $scope.importContactsSuccess
      
      $scope.resetImportContacts = ->
        $scope.contactImport = 
          step: 'choose-type'
          import_type: ''
          jobEvents: [
            {
              message: '1. Waiting for your consent ...'
            }
          ]
          contactsToAdd: []
      
      $scope.importContacts = ->
        $scope.clearAllContactAlerts()
        $scope.resetImportContacts()
        $scope.importContactsModal = $uibModal.open 
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/importContacts.html'
      
      closeImportContactsModal = ->
        $scope.importContactsModal.close()
      
      $scope.cancelImportContacts = ->
        $scope.clearImportContactsAlerts()
        closeImportContactsModal()
      
      $scope.chooseImportContactType = ->
        importType = $scope.contactImport.import_type
        if not importType or importType is ''
          # TODO: error message
        else
          if importType is 'csv'
            $scope.contactImport.step = 'csv-upload'
          else
            $scope.contactImport.step = 'online-consent'
            $window.open APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/popup/address-book-import.html?import_source=' + $scope.contactImport.import_type, 'startimport', 'location=no,menubar=no,toolbar=no,height=400'
            false
      
      window.trPcContactImport = 
        buildAddressBookImport: (importJobId) ->
          NgPcContactService.getAddressBookImportJobStatus 'import_job_id=' + importJobId
            .then (response) ->
              if response.data.errorResponse
                # TODO
              else
                jobStatus = response.data.getAddressBookImportJobStatusResponse?.jobStatus
                if not jobStatus
                  # TODO
                else
                  if jobStatus is 'PENDING' or jobStatus is 'FAILURE'
                    events = response.data.getAddressBookImportJobStatusResponse.events?.event
                    if not events
                      $scope.updateImportJobEvents()
                    else
                      events = [events] if not angular.isArray events
                      jobEvents = []
                      angular.forEach events, (event) ->
                        jobEvents.push 
                          message: event
                      $scope.updateImportJobEvents jobEvents
                    if jobStatus is 'PENDING'
                      trPcContactImport.buildAddressBookImport importJobId
                  else if jobStatus is 'SUCCESS'
                    NgPcContactService.getAddressBookImportContacts 'import_job_id=' + importJobId
                      .then (response) ->
                        if response.data.errorResponse
                          # TODO
                        else
                          contacts = response.data.getAddressBookImportContactsResponse?.contact
                          if not contacts
                            $scope.setContactsAvailableForImport()
                          else
                            contacts = [contacts] if not angular.isArray contacts
                            contactsAvailableForImport = []
                            angular.forEach contacts, (contact) ->
                              if contact
                                firstName = contact.firstName
                                lastName = contact.lastName
                                email = contact.email
                                if firstName and not angular.isString firstName
                                  delete contact.firstName
                                  firstName = undefined
                                if lastName and not angular.isString lastName
                                  delete contact.lastName
                                if email and not angular.isString email
                                  delete contact.email
                                  email = undefined
                                if firstName or email
                                  contactsAvailableForImport.push contact
                            $scope.setContactsAvailableForImport contactsAvailableForImport
      
      $scope.updateImportJobEvents = (jobEvents) ->
        if jobEvents and jobEvents.length isnt 0
          $scope.contactImport.jobEvents = jobEvents
        if not $scope.$$phase
          $scope.$apply()
      
      $scope.setContactsAvailableForImport = (contactsAvailableForImport) ->
        $scope.contactImport.step = 'contacts-available-for-import'
        $scope.contactsAvailableForImport = contactsAvailableForImport or []
        if not $scope.$$phase
          $scope.$apply()
      
      $scope.selectAllContactsToAdd = ($event) ->
        if $event
          $event.preventDefault()
        contactsAvailableForImport = []
        $scope.contactImport.contactsToAdd = []
        angular.forEach $scope.contactsAvailableForImport, (contactAvailableForImport) ->
          contactAvailableForImport.selected = true
          contactsAvailableForImport.push contactAvailableForImport
          contactData = ''
          if contactAvailableForImport.firstName
            contactData += '"' + contactAvailableForImport.firstName + '"'
          contactData += ', '
          if contactAvailableForImport.lastName
            contactData += '"' + contactAvailableForImport.lastName + '"'
          contactData += ', '
          if contactAvailableForImport.email
            contactData += '"' + contactAvailableForImport.email + '"'
          $scope.contactImport.contactsToAdd.push contactData
        $scope.contactsAvailableForImport = contactsAvailableForImport
      
      $scope.deselectAllContactsToAdd = ($event) ->
        if $event
          $event.preventDefault()
        contactsAvailableForImport = []
        angular.forEach $scope.contactsAvailableForImport, (contactAvailableForImport) ->
          contactAvailableForImport.selected = false
          contactsAvailableForImport.push contactAvailableForImport
        $scope.contactsAvailableForImport = contactsAvailableForImport
        $scope.contactImport.contactsToAdd = []
      
      $scope.toggleContactToAdd = (contact) ->
        contactData = ''
        if contact.firstName
          contactData += '"' + contact.firstName + '"'
        contactData += ', '
        if contact.lastName
          contactData += '"' + contact.lastName + '"'
        contactData += ', '
        if contact.email
          contactData += '"' + contact.email + '"'
        contactToAddIndex = $scope.contactImport.contactsToAdd.indexOf contactData
        if contactToAddIndex is -1
          $scope.contactImport.contactsToAdd.push contactData
        else
          $scope.contactImport.contactsToAdd.splice contactToAddIndex, 1
        angular.forEach $scope.contactsAvailableForImport, (contactAvailableForImport) ->
          contactAvailableForImportData = ''
          if contactAvailableForImport.firstName
            contactAvailableForImportData += '"' + contactAvailableForImport.firstName + '"'
          contactAvailableForImportData += ', '
          if contactAvailableForImport.lastName
            contactAvailableForImportData += '"' + contactAvailableForImport.lastName + '"'
          contactAvailableForImportData += ', '
          if contactAvailableForImport.email
            contactAvailableForImportData += '"' + contactAvailableForImport.email + '"'
          if contactData is contactAvailableForImportData
            contactAvailableForImport.selected = contactToAddIndex is -1
      
      $scope.chooseContactsToImport = ->
        $scope.clearImportContactsAlerts()
        if $scope.contactImport.contactsToAdd.length is 0
          $scope.importContactsError = 'You must select at least one contact to continue this process.'
        else
          NgPcContactService.importAddressBookContacts 'contacts_to_add=' + encodeURIComponent($scope.contactImport.contactsToAdd.join('\n'))
            .then (response) ->
              if response.data.errorResponse
                $scope.importContactsError = response.data.errorResponse.message
              else
                errorContacts = response.data.importAddressBookContactsResponse?.errorContact
                if errorContacts
                  errorContacts = [errorContacts] if not angular.isArray errorContacts
                potentialDuplicateContacts = response.data.importAddressBookContactsResponse?.potentialDuplicateContact
                if potentialDuplicateContacts
                  potentialDuplicateContacts = [potentialDuplicateContacts] if not angular.isArray potentialDuplicateContacts
                duplicateContacts = response.data.importAddressBookContactsResponse?.duplicateContact
                if duplicateContacts
                  duplicateContacts = [duplicateContacts] if not angular.isArray duplicateContacts
                savedContacts = response.data.importAddressBookContactsResponse?.savedContact
                if savedContacts
                  savedContacts = [savedContacts] if not angular.isArray savedContacts
                # TODO: handle errorContacts, potentialDuplicateContacts, and duplicateContacts
                $scope.importContactsSuccess = true
                closeImportContactsModal()
                $scope.getContacts()
                $scope.getAllContacts()
      
      $scope.uploadContactsCSV = ->
        angular.element('.js--import-contacts-csv-form').submit()
        false
      
      $scope.handleContactsCSV = (csvIframe) ->
        csvIframeContent = jQuery(csvIframe).contents().text()
        if csvIframeContent
          csvIframeJSON = jQuery.parseJSON csvIframeContent
          if csvIframeJSON.errorResponse
            # TODO
          else
            confidenceLevel = csvIframeJSON.parseCsvContactsResponse?.confidenceLevel
            # TODO: confidenceLevel
            proposedMapping = csvIframeJSON.parseCsvContactsResponse?.proposedMapping
            if proposedMapping
              firstNameColumnIndex = Number proposedMapping.firstNameColumnIndex
              lastNameColumnIndex = Number proposedMapping.lastNameColumnIndex
              emailColumnIndex = Number proposedMapping.emailColumnIndex
              csvDataRows = csvIframeJSON.parseCsvContactsResponse?.csvDataRows?.csvDataRow
              if not csvDataRows
                # TODO
              else
                csvDataRows = [csvDataRows] if not angular.isArray csvDataRows
                contactsAvailableForImport = []
                angular.forEach csvDataRows, (csvDataRow) ->
                  if csvDataRow
                    csvValue = csvDataRow.csvValue
                    firstName = csvValue[firstNameColumnIndex]
                    lastName = csvValue[lastNameColumnIndex]
                    email = csvValue[emailColumnIndex]
                    contact =
                      firstName: firstName
                      lastName: lastName
                      email: email
                    if firstName and not angular.isString firstName
                      delete contact.firstName
                      firstName = undefined
                    if lastName and not angular.isString lastName
                      delete contact.lastName
                    if email and not angular.isString email
                      delete contact.email
                      email = undefined
                    if firstName or email
                      contactsAvailableForImport.push contact
                $scope.setContactsAvailableForImport contactsAvailableForImport
      
      $scope.resetSelectedContacts = ->
        $rootScope.selectedContacts = 
          contacts: []
      if not $rootScope.selectedContacts?.contacts
        $scope.resetSelectedContacts()
      
      $scope.toggleContact = (contact) ->
        contactData = getContactString contact
        contactIndex = $rootScope.selectedContacts.contacts.indexOf contactData
        if contactIndex is -1
          $rootScope.selectedContacts.contacts.push contactData
        else
          $rootScope.selectedContacts.contacts.splice contactIndex, 1
        angular.forEach $scope.addressBookContacts.allContacts, (aContact) ->
          if contactData is getContactString aContact
            aContact.selected = contactIndex is -1
        angular.forEach $scope.addressBookContacts.contacts, (aContact) ->
          if contactData is getContactString aContact
            aContact.selected = contactIndex is -1
        $scope.addressBookContacts.allContactsSelected = isAllContactsSelected()
        $scope.addressBookContacts.allContactsSelected
      
      $scope.toggleAllContacts = ->
        selected = not $scope.addressBookContacts.allContactsSelected
        angular.forEach $scope.addressBookContacts.contacts, (contact) ->
          contact.selected = selected
        angular.forEach $scope.addressBookContacts.allContacts, (contact) ->
          contact.selected = selected
          if selected isnt isContactSelected contact
            $scope.toggleContact contact
        $scope.addressBookContacts.allContactsSelected = selected
        $scope.addressBookContacts.allContactsSelected
      
      $scope.clearEditContactAlerts = ->
        if $scope.editContactError
          delete $scope.editContactError
        if $scope.editContactSuccess
          delete $scope.editContactSuccess
      
      $scope.selectContact = (contact) ->
        $scope.clearAllContactAlerts()
        $scope.selectedContact = contact
        $scope.updatedContact = 
          contact_id: $scope.selectedContact.id
          first_name: $scope.selectedContact.firstName
          last_name: $scope.selectedContact.lastName
          email: $scope.selectedContact.email
        $scope.editContactModal = $uibModal.open
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/editContact.html'
      
      closeEditContactModal = ->
        $scope.editContactModal.close()
      
      $scope.cancelEditContact = ->
        delete $scope.selectedContact
        $scope.clearEditContactAlerts()
        closeEditContactModal()
      
      $scope.saveUpdatedContact = ->
        $scope.clearEditContactAlerts()
        if not $scope.selectedContact
          # TODO
        else
          updateContactPromise = NgPcContactService.updateTeamraiserAddressBookContact $httpParamSerializer($scope.updatedContact)
            .then (response) ->
              if response.data.errorResponse
                $scope.editContactError = response.data.errorResponse.message
              else
                $scope.editContactSuccess = ''
                closeEditContactModal()
                window.scrollTo 0, 0
                # TODO: update selected contacts
                $scope.getContacts()
                $scope.getAllContacts()
              response
          $scope.emailPromises.push updateContactPromise
      
      $scope.clearDeleteContactAlerts = ->
        if $scope.deleteContactError
          delete $scope.deleteContactError
        if $scope.deleteContactSuccess
          delete $scope.deleteContactSuccess
      
      $scope.deleteContact = (contactId) ->
        $scope.clearAllContactAlerts()
        $scope.deleteContactId = contactId
        $scope.deleteContactModal = $uibModal.open 
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/deleteContact.html'
      
      $scope.deleteContacts = ->
        contacts = []
        for i in [0..$scope.addressBookContacts.allContacts.length]
          contact = $scope.addressBookContacts.allContacts[i]
          if contact?.selected
            contacts.push contact.id
        $scope.contactsToDelete = contacts.join ','
        $scope.clearAllContactAlerts()
        $scope.deleteContactsModal = $uibModal.open 
          scope: $scope
          templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/participant-center/modal/deleteContacts.html'
      
      closeDeleteContactModal = ->
        delete $scope.deleteContactId
        $scope.deleteContactModal.close()
      
      closeDeleteContactsModal = ->
        $scope.deleteContactsModal.close()
      
      $scope.cancelDeleteContact = ->
        closeDeleteContactModal()
      
      $scope.cancelDeleteContacts = ->
        closeDeleteContactsModal()
      
      $scope.confirmDeleteContact = ->
        if not $scope.deleteContactId
          # TODO
        else
          deleteContactPromise = NgPcContactService.deleteTeamraiserAddressBookContacts 'contact_ids=' + $scope.deleteContactId
            .then (response) ->
              if response.data.errorResponse
                $scope.deleteContactError = response.data.errorResponse.message
              else
                $scope.deleteContactSuccess = ''
              closeDeleteContactModal()
              window.scrollTo 0, 0
              # TODO: update selected contacts
              $scope.getContacts()
              $scope.getAllContacts()
              response
          $scope.emailPromises.push deleteContactPromise
      
      deselectAllContacts = ->
        for i in [0..$scope.addressBookContacts.allContacts.length]
          contact=$scope.addressBookContacts.allContacts[i]
          contact?.selected=false;        
      
      $scope.confirmDeleteContacts = ->
        dataStr = '&contact_ids=' + $scope.contactsToDelete
        deleteContactsPromise = NgPcContactService.deleteTeamraiserAddressBookContacts dataStr
          .then (response) ->
            if response.data?.errorResponse?
              # TODO: error message
            else
              $scope.cancelDeleteContacts()
              $scope.getContacts(true)
              deselectAllContacts()
            response
        $scope.emailPromises.push deleteContactsPromise
      $scope.emailSelectedContacts = ->
        if localStorage.emailView != 'classic'
          $location.path '/email/compose'
        else
          $location.path '/email/classic'
  ]
