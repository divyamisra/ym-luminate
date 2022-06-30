angular.module 'ahaLuminateApp'
  .directive 'ngCsv', [
    'CsvDownloadService'
    (CsvDownloadService) ->
      link: (scope, element, attrs) ->
        element.bind 'click', (event) ->
          #CopyImageClipboard.copyImageToClipboard attrs.copyImage
          CsvDownloadService.downloadFile $scope.companyParticipantList.participants, attrs.filename, attrs['csv-header'], attrs['csv-fields'] 
          scope.buildCSVPending = 'done'
        return
  ]
