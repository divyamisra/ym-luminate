angular.module 'ahaLuminateApp'
  .directive 'ngCsv', [
    'CsvDownloadService'
    (CsvDownloadService) ->
      link: (scope, element, attrs) ->
        element.bind 'click', (event) ->
          #CopyImageClipboard.copyImageToClipboard attrs.copyImage
          CsvDownloadService.downloadFile $scope.companyParticipantList.participants attrs.filename attrs['csv-header'] attrs['csv-fields'] 
          element.after '<div class="clipboard-copy text-center small" role="alert" aria-atomic="true">QR Code copied to clipboard</div>'
        return
  ]
