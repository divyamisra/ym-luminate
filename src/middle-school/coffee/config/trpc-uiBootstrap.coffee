if window.location.href.indexOf('pagename=ym_khc_participant_center') isnt -1
  angular.module 'trPcApp'
    .config [
      '$uibModalProvider'
      ($uibModalProvider) ->
        angular.extend $uibModalProvider.options, 
          windowClass: 'ng-pc-modal'
    ]