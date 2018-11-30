angular.module 'trPcApp'
  .factory 'FacebookFundraiserService', [
    '$rootScope'
    '$filter'
    '$http'
    ($rootScope, $filter, $http) ->
      createFundraiser: (coverPhoto = '', fundraiserName = '', fundraiserDescription = '') ->
        eventDate = $rootScope.eventInfo.event_date
        endDate = $rootScope.facebookFundraisersEndDate
        endTime = null
        endTimeOffset = null
        if endDate and not isNaN endDate
          endTimeOffset = Number(endDate) * 86400
        else
          endDateParts = endDate.split '/'
          endTime = Math.floor new Date(Number($filter('date')(eventDate, 'yyyy')), Number($filter('date')(eventDate, 'M')) - 1, Number($filter('date')(eventDate, 'd'))) / 1000
          if endDateParts.length is 3 and Number(endDateParts[0]) < 13 and Number(endDateParts[1]) < 32 and Number(endDateParts[2]) > 999
            endTime = Math.floor new Date(Number(endDate.split('/')[2]), Number(endDate.split('/')[0]) - 1, Number(endDate.split('/')[1])) / 1000
        requestData =
          is_dev: $rootScope.tablePrefix is 'heartdev'
          external_id: 'lotrp:' + $rootScope.frId + '-' + $rootScope.consId
          charity_id: $rootScope.facebookCharityId
          fundraiser_name: fundraiserName
          fundraiser_description: fundraiserDescription
          default_goal_amount: '250.00'
          cover_photo: coverPhoto
          default_cover_photo: coverPhoto
          facebook_user_id: $rootScope.facebookFundraiserUserId
          access_token: $rootScope.facebookFundraiserAccessToken
        if endTimeOffset
          requestData.end_time_offset = endTimeOffset
        else if endTime
          requestData.end_time = endTime
        $http.post 'https://facebookfundraiser.sky.blackbaud.com/create_fundraiser', requestData
      
      syncDonations: ->
        requestData =
          is_dev: $rootScope.tablePrefix is 'heartdev'
          external_id: 'lotrp:' + $rootScope.frId + '-' + $rootScope.consId
          charity_id: $rootScope.facebookCharityId
        $http.post 'https://facebookfundraiser.sky.blackbaud.com/sync_donations', requestData
      
      confirmFundraiserStatus: ->
        requestData =
          is_dev: $rootScope.tablePrefix is 'heartdev'
          external_id: 'lotrp:' + $rootScope.frId + '-' + $rootScope.consId
          charity_id: $rootScope.facebookCharityId
        $http.post 'https://facebookfundraiser.sky.blackbaud.com/confirm_fundraiser_status', requestData
      
      updateFundraiser: ->
        eventDate = $rootScope.eventInfo.event_date
        endDate = $rootScope.facebookFundraisersEndDate
        endDateParts = endDate.split '/'
        endTime = Math.floor new Date(Number($filter('date')(eventDate, 'yyyy')), Number($filter('date')(eventDate, 'M')) - 1, Number($filter('date')(eventDate, 'd'))) / 1000
        if endDateParts.length is 3 and Number(endDateParts[0]) < 13 and Number(endDateParts[1]) < 32 and Number(endDateParts[2]) > 999
          endTime = Math.floor new Date(Number(endDate.split('/')[2]), Number(endDate.split('/')[0]) - 1, Number(endDate.split('/')[1])) / 1000
        requestData =
          is_dev: $rootScope.tablePrefix is 'heartdev'
          external_id: 'lotrp:' + $rootScope.frId + '-' + $rootScope.consId
          charity_id: $rootScope.facebookCharityId
          end_time: endTime
        $http.post 'https://facebookfundraiser.sky.blackbaud.com/update_fundraiser', requestData
  ]