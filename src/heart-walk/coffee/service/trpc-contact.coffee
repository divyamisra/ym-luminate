angular.module 'trPcApp'
  .factory 'ContactService', [
    'LuminateRESTService'
    (LuminateRESTService) ->
      addAddressBookContact: (requestData) ->
        dataString = 'method=addAddressBookContact'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true
          .then (response) ->
            response
      
      getAddressBookImportJobStatus: (requestData) ->
        dataString = 'method=getAddressBookImportJobStatus'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true, true
          .then (response) ->
            response
      
      getAddressBookImportContacts: (requestData) ->
        dataString = 'method=getAddressBookImportContacts'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true, true
          .then (response) ->
            response
      
      importAddressBookContacts: (requestData) ->
        dataString = 'method=importAddressBookContacts'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true, true
          .then (response) ->
            response
      
      addAddressBookGroup: (requestData) ->
        dataString = 'method=addAddressBookGroup'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true
          .then (response) ->
            response
      
      addContactsToGroup: (requestData) ->
        dataString = 'method=addContactsToGroup'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true
          .then (response) ->
            response

      deleteAddressBookGroups: (requestData) ->
        dataString = 'method=deleteAddressBookGroups'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true
          .then (response) ->
            response
      
      deleteTeamraiserAddressBookContacts: (requestData) ->
        dataString = 'method=deleteTeamraiserAddressBookContacts'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      updateTeamraiserAddressBookContact: (requestData) ->
        dataString = 'method=updateTeamraiserAddressBookContact'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getAddressBookGroups: (requestData) ->
        dataString = 'method=getAddressBookGroups'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.addressBookRequest dataString, true
          .then (response) ->
            response

      getTeamraiserAddressBookFilters: (requestData) ->
        dataString = 'method=getTeamraiserAddressBookFilters'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getTeamraiserAddressBookContacts: (requestData) ->
        dataString = 'method=getTeamraiserAddressBookContacts'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
      
      getTeamraiserAddressBookContact: (requestData) ->
        dataString = 'method=getTeamraiserAddressBookContact'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response

      getTeamraiserAddressBookGroupContacts: (requestData) ->
        dataString = 'method=getTeamraiserAddressBookGroupContacts'
        dataString += '&' + requestData if requestData and requestData isnt ''
        LuminateRESTService.teamraiserRequest dataString, true, true
          .then (response) ->
            response
  ]