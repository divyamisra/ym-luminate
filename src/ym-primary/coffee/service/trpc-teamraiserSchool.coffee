angular.module 'ahaLuminateApp'
  .factory 'NgPcTeamraiserSchoolService', [
    '$rootScope'
    '$http'
    '$sce'
    ($rootScope, $http, $sce) ->
      updateSchoolGoal: (requestData, scope, callback) ->
        $http.get('NTM?tr.ntmgmt=company_edit&mfc_pref=T&action=edit_company&company_id=' + scope.participantRegistration.companyInformation.companyId + '&fr_id=' + $rootScope.frId)
          .then (response) ->
            company_page = jQuery(response.data)
            company_formvars = jQuery(company_page).find('form').serializeArray()
            jQuery.each company_formvars, (i, key) ->
              if key['name'] is 'goalinput'
                company_formvars[i]['value'] = requestData
            
            company_formvars.push
              'name': 'pstep_next'
              'value': 'next'
            
            # jQuery.post 'NTM', company_formvars
            params = ''
            jQuery.each company_formvars, (i) ->
              params += (if i > 0 then '&' else '') + @name + '=' + @value
            $http
              method: 'POST'
              url: 'NTM'
              data: params
              headers:
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'     
  
      getRegistrationQuestions: (requestData) ->
        requestUrl = luminateExtend.global.path.nonsecure
        if window.location.protocol is 'https:'
          requestUrl = luminateExtend.global.path.secure + 'S'
        requestUrl += 'PageServer?pagename=reus_khc_reginfo_js&pgwrap=n' + requestData
        $http.jsonp($sce.trustAsResourceUrl(requestUrl), jsonpCallbackParam: 'callback')
          .then (response) ->
            response
          , (response) ->
            response
  ]
