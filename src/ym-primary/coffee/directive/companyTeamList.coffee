angular.module 'ahaLuminateApp'
  .directive 'companyTeamList', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'dist/ym-primary/html/directive/companyTeamList.html'
      restrict: 'E'
      replace: true
      scope:
        companyName: '='
        companyId: '='
        frId: '='
        teams: '='
      controller: [
        '$scope'
        '$filter'
        ($scope, $filter) ->
          $scope.teamListSetting =
            totalNumber: $scope.teams.length
            currentPage: 1
            paginationItemsPerPage: 4
            paginationMaxSize: 4
          
          $scope.paginateTeams = (value) ->
            begin = ($scope.teamListSetting.currentPage - 1) * $scope.teamListSetting.paginationItemsPerPage
            end = begin + $scope.teamListSetting.paginationItemsPerPage
            index = $scope.teams.indexOf value
            begin <= index and index < end
      ]
  ]
