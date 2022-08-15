angular.module('trPcControllers').controller 'NgPcVolunteerViewCtrl', [
  '$scope'
  '$rootScope'
  'ZuriService'
  ($scope, $rootScope, ZuriService) ->

      $scope.volunteerData = []
      getVolunteerism = ->
        ZuriService.getVolunteerData $scope.frId + '/' + $scope.consId,
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            if typeof response.data.data != 'undefined'
              if response.data.total_hours > 0
                totalTimeInMinutes = response.data.total_hours
                hours = Math.floor(totalTimeInMinutes / 60)
                minutes = totalTimeInMinutes - (hours * 60)
                minutes = if minutes < 10 then '0' + minutes else minutes
                $scope.volunteerTotal =
                  'hours': hours
                  'minutes': minutes
                $scope.volunteerData = response.data.data
      getVolunteerism()
      
      createVolunteerism = ->
        ZuriService.createVolunteerData {
          'consituent_id':$scope.consId
          'school_id':$scope.participantRegistration.companyInformation.companyId
          'event_id':$scope.frId
          'event_year': 'fy23'
          'activity_type_id': angular.element('activityId').val()
          'activity_date':angular.element('activityDate').val()
          'hours':angular.element('activityHours').val()
          },
          failure: (response) ->
          error: (response) ->
          success: (response) ->
            if response.data.status == 'success'
              $scope.volunteerProcess = response.data
  ]
