angular.module 'ahaLuminateApp'
  .factory 'ZuriService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      getSchoolChallenges: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/program/school/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/program/school/' + requestData + '?key=XgUnZxvFcjZ4jEMT'
        else
          url = '//tools.heart.org/aha_ahc24/api/program/school/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      getChallenges: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/student/challenges/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/student/challenges/' + requestData + '?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/student/challenges/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      updateChallenge: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/student/challenge/' + requestData + '&key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/student/challenge/' + requestData + '&key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/student/challenge/' + requestData + '&key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')

          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      logChallenge: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/student/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/student/' + requestData + '?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/student/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
      
      getStudent: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/student/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/student/' + requestData + '?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/student/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getSchoolActivity: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/program/school/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/program/school/' + requestData + '?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/program/school/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getTeam: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/program/team/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/program/team/' + requestData + '?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/program/team/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      getProgram: (callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/program?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/program?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/program?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
      
      eCardTracking: (requestData) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/visitlink_record.php?ecard_linktrack=' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/visitlink_record.php?ecard_linktrack=' + requestData
        else
          url = '//tools.heart.org/aha_ahc24/visitlink_record.php?ecard_linktrack=' + requestData
        $http
          method: 'POST'
          url: $sce.trustAsResourceUrl(url)
      
      getAvatar: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//middleschool.staging.ootqa.org/api/points/student/' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//middleschool.staging.ootqa.org/api/points/student/' + requestData
        else
          url = '//kidsheartchallenge.heart.org/api/points/student/' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response

      getSchoolData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/school/' + requestData + '/meta?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/school/' + requestData + '/meta?key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/school/' + requestData + '/meta?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response

      getSchoolInfo: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&method=GetSchoolInfo&companyId=' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&method=GetSchoolInfo&companyId=' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?method=GetSchoolInfo&companyId=' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      updateSchoolData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/school/' + requestData + '&key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/school/' + requestData + '&key=RByQUbXzYLBchS3n'
        else
          url = '//tools.heart.org/aha_ahc24/api/school/' + requestData + '&key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
            
      getSchools: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&method=GetSchools&EventProgram=AHC' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&method=GetSchools&EventProgram=AHC' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?method=GetSchools&EventProgram=AHC' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      getSchoolsNew: (requestData, callback) ->
        url = '//tools.heart.org/ym-school-plan/schoolPlan.php?method=GetSchoolsNew' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      getSchoolContacts: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&EventProgram=AHC&method=GetSchoolContacts' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&EventProgram=AHC&method=GetSchoolContacts' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?EventProgram=AHC&method=GetSchoolContacts' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      getSchoolDetail: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&EventProgram=AHC&method=GetSchoolDetail' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&EventProgram=AHC&method=GetSchoolDetail' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?EventProgram=AHC&method=GetSchoolDetail' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      schoolPlanData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&EventProgram=AHC' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&EventProgram=AHC' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?EventProgram=AHC' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response

      schoolTop15: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&EventProgram=AHC&method=GetTop15Schools' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&EventProgram=AHC&method=GetTop15Schools' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?EventProgram=AHC&method=GetTop15Schools' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      getStudentDetail: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_dev&EventProgram=AHC&method=GetStudentDetail' + requestData
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?env=_new&EventProgram=AHC&method=GetStudentDetail' + requestData
        else
          url = '//tools.heart.org/ym-school-plan/schoolPlan.php?EventProgram=AHC&method=GetStudentDetail' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
  
              
      getVolunteerData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/volunteerism/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/volunteerism/' + requestData + '?key=B78AEYxzbU9br6Cq'
        else
          url = '//tools.heart.org/aha_ahc24/api/volunteerism/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
            
      getVolunteerAdminData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/volunteer/volunteer-admin-report.php?env=_dev&school_id=' + requestData
        else
          url = '//tools.heart.org/volunteer/volunteer-admin-report.php?school_id=' + requestData
        $http.jsonp($sce.trustAsResourceUrl(url), jsonpCallbackParam: 'callback')
          .then (response) ->
            if response.data.success is false
              callback.error response
            else
              callback.success response
          , (response) ->
            callback.failure response
            
      createVolunteerData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/volunteerism?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/volunteerism?key=B78AEYxzbU9br6Cq'
        else
          url = '//tools.heart.org/aha_ahc24/api/volunteerism?key=B78AEYxzbU9br6Cq'
        $http({method: 'POST', url: $sce.trustAsResourceUrl(url), data: requestData})
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response

      saveVolunteerData: (id, requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/volunteerism/' + id + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/volunteerism/' + id + '?key=B78AEYxzbU9br6Cq'
        else
          url = '//tools.heart.org/aha_ahc24/api/volunteerism/' + id + '?key=B78AEYxzbU9br6Cq'
        $http({method: 'PUT', url: $sce.trustAsResourceUrl(url), data: JSON.stringify(requestData)})
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response
            
      deleteVolunteerData: (requestData, callback) ->
        if $rootScope.tablePrefix is 'heartdev'
          url = '//tools.heart.org/aha_ahc24_dev/api/volunteerism/' + requestData + '?key=RByQUbXzYLBchS3n'
        else if $rootScope.tablePrefix is 'heartnew'
          url = '//tools.heart.org/aha_ahc24_testing/api/volunteerism/' + requestData + '?key=B78AEYxzbU9br6Cq'
        else
          url = '//tools.heart.org/aha_ahc24/api/volunteerism/' + requestData + '?key=B78AEYxzbU9br6Cq'
        $http({method: 'DELETE', url: $sce.trustAsResourceUrl(url)})
          .then (response) ->
            callback.success response
          , (response) ->
            callback.failure response

  ]
