angular.module 'ahaLuminateControllers'
  .controller 'RegistrationRegCtrl', [
    '$rootScope'
    '$scope'
    '$filter'
    '$timeout'
    'TeamraiserCompanyService'
    'TeamraiserRegistrationService'
    'NuclavisService'
    ($rootScope, $scope, $filter, $timeout, TeamraiserCompanyService, TeamraiserRegistrationService, NuclavisService) ->
      $rootScope.companyName = ''
      regCompanyId = luminateExtend.global.regCompanyId
      setCompanyName = (companyName) ->
        $rootScope.companyName = companyName
        if not $rootScope.$$phase
          $rootScope.$apply()
      TeamraiserCompanyService.getCompanies 'company_id=' + regCompanyId,
        error: ->
          # TODO
        success: (response) ->
          companies = response.getCompaniesResponse.company
          if not companies
            # TODO
          else
            companies = [companies] if not angular.isArray companies
            companyInfo = companies[0]
            setCompanyName companyInfo.companyName
      
      $scope.registrationInfoErrors =
        errors: []
      $fieldErrors = angular.element '.ErrorMessage'
      angular.forEach $fieldErrors, (fieldError) ->
        $fieldError = angular.element fieldError
        $fieldErrorLabel = $fieldError.closest('.form-error').find('label .input-label')
        $fieldErrorText = $fieldError.find('.field-error-text')
        if $fieldErrorText.length > 0
          $fieldErrorText.html $fieldErrorText.html().replace(':&nbsp;is a required field', '&nbsp;is a required field')
          fieldErrorText = jQuery.trim $fieldErrorText.text()
          fieldErrorText = fieldErrorText.replace ': is a required field', ' is a required field'
          if $fieldErrorLabel.length > 0
            fieldErrorLabel = jQuery.trim $fieldErrorLabel.text()
            if fieldErrorLabel and fieldErrorLabel isnt ''
              fieldErrorText = fieldErrorText.replace 'Error: Please enter a valid response.', fieldErrorLabel + ' - Please enter a valid response.'
              fieldErrorText = fieldErrorText.replace ': - Please enter a valid response.', ' - Please enter a valid response.'
          $scope.registrationInfoErrors.errors.push
            text: fieldErrorText
      
      $scope.registrationHiddenFields = 
        fr_cstm_reg: 't'
      $scope.registrationQuestions = {}
      $scope.registrationInfo = {}
      
      $contactInfo = angular.element '.js--registration-reg-contact-info'
      $contactInfoHiddenFields = $contactInfo.find 'input[type="hidden"][name]'
      angular.forEach $contactInfoHiddenFields, (contactInfoHiddenField) ->
        $contactInfoHiddenField = angular.element contactInfoHiddenField
        questionName = $contactInfoHiddenField.attr 'name'
        questionValue = $contactInfoHiddenField.val()
        $scope.registrationHiddenFields[questionName] = questionValue
      $contactInfoQuestions = $contactInfo.find 'input[type="text"], input[type="email"], input[type="tel"], select'
      angular.forEach $contactInfoQuestions, (contactInfoQuestion) ->
        $contactInfoQuestion = angular.element contactInfoQuestion
        questionName = $contactInfoQuestion.attr 'name'
        questionId = $contactInfoQuestion.attr 'id'
        $questionLabel = angular.element 'label[for="' + questionId + '"]'
        questionLabel = undefined
        if $questionLabel.find('.input-label').length > 0
          questionLabel = jQuery.trim $questionLabel.find('.input-label').text()
        questionValue = $contactInfoQuestion.val() or ''
        questionMaxLength = $contactInfoQuestion.attr('maxlength') or ''
        questionHasError = $contactInfoQuestion.is '.form-error *'
        $scope.registrationQuestions[questionName] =
          label: questionLabel
          value: questionValue
          maxLength: questionMaxLength
          hasError: questionHasError
        $scope.registrationInfo[questionName] = questionValue
      
      $optIns = angular.element '.js--registration-reg-opt-ins'
      $optInHiddenFields = $optIns.find 'input[type="hidden"][name]'
      angular.forEach $optInHiddenFields, (optInHiddenField) ->
        $optInHiddenField = angular.element optInHiddenField
        questionName = $optInHiddenField.attr 'name'
        questionValue = $optInHiddenField.val()
        $scope.registrationHiddenFields[questionName] = questionValue
      $optInQuestions = $optIns.find 'input[type="checkbox"]'
      angular.forEach $optInQuestions, (optInQuestion) ->
        $optInQuestion = angular.element optInQuestion
        questionName = $optInQuestion.attr 'name'
        questionId = $optInQuestion.attr 'id'
        questionChecked = $optInQuestion.is '[checked]'
        $questionLabel = angular.element 'label[for="' + questionId + '"]'
        questionLabel = undefined
        if $questionLabel.find('.input-label').length > 0
          questionLabel = jQuery.trim $questionLabel.find('.input-label').text()
        $scope.registrationQuestions[questionName] =
          label: questionLabel
        $scope.registrationInfo[questionName] = questionChecked
      
      $loginInfo = angular.element '.js--registration-reg-login-info'
      $loginInfoHiddenFields = $loginInfo.find 'input[type="hidden"][name]'
      angular.forEach $loginInfoHiddenFields, (loginInfoHiddenField) ->
        $loginInfoHiddenField = angular.element loginInfoHiddenField
        questionName = $loginInfoHiddenField.attr 'name'
        questionValue = $loginInfoHiddenField.val()
        $scope.registrationHiddenFields[questionName] = questionValue
      $loginInfoQuestions = $loginInfo.find 'input[type="text"], input[type="password"]'
      angular.forEach $loginInfoQuestions, (loginInfoQuestion) ->
        $loginInfoQuestion = angular.element loginInfoQuestion
        questionName = $loginInfoQuestion.attr 'name'
        questionId = $loginInfoQuestion.attr 'id'
        $questionLabel = angular.element 'label[for="' + questionId + '"]'
        questionLabel = undefined
        if $questionLabel.find('.input-label').length > 0
          questionLabel = jQuery.trim $questionLabel.find('.input-label').text()
        questionValue = $loginInfoQuestion.val() or ''
        questionMaxLength = $loginInfoQuestion.attr('maxlength') or ''
        questionHasError = $loginInfoQuestion.is '.form-error *'
        $scope.registrationQuestions[questionName] =
          label: questionLabel
          value: questionValue
          maxLength: questionMaxLength
          hasError: questionHasError
        $scope.registrationInfo[questionName] = questionValue
      
      $additionalInfo = angular.element '.js--registration-reg-additional-info'
      $additionalInfoHiddenFields = $additionalInfo.find 'input[type="hidden"][name]'
      angular.forEach $additionalInfoHiddenFields, (additionalInfoHiddenField) ->
        $additionalInfoHiddenField = angular.element additionalInfoHiddenField
        questionName = $additionalInfoHiddenField.attr 'name'
        questionValue = $additionalInfoHiddenField.val()
        $scope.registrationHiddenFields[questionName] = questionValue
      $additionalInfoQuestions = $additionalInfo.find 'input[type="text"], input[type="number"], textarea, select'
      angular.forEach $additionalInfoQuestions, (additionalInfoQuestion) ->
        $additionalInfoQuestion = angular.element additionalInfoQuestion
        questionType = $additionalInfoQuestion.prop('tagName').toLowerCase()
        questionName = $additionalInfoQuestion.attr 'name'
        questionId = $additionalInfoQuestion.attr 'id'
        $questionLabel = angular.element 'label[for="' + questionId + '"]'
        questionLegend = undefined
        if $additionalInfoQuestion.is '[class*="survey-date-"] select'
          $questionLegend = $additionalInfoQuestion.closest('fieldset').find 'legend'
          if $questionLegend.find('.input-label').length > 0
            questionLegend = jQuery.trim $questionLegend.find('.input-label').text()
        questionLabel = undefined
        if $questionLabel.find('.input-label').length > 0
          questionLabel = jQuery.trim $questionLabel.find('.input-label').text()
        questionOptions = []
        if questionType is 'select'
          $questionOptions = $additionalInfoQuestion.find 'option'
          angular.forEach $questionOptions, (questionOption) ->
            $questionOption = angular.element questionOption
            questionOptionValue = $questionOption.attr 'value'
            questionOptionText = jQuery.trim $questionOption.text()
            questionOptions.push
              value: questionOptionValue
              text: questionOptionText
        questionValue = $additionalInfoQuestion.val() or ''
        questionMaxLength = $additionalInfoQuestion.attr('maxlength') or ''
        questionHasError = $additionalInfoQuestion.is '.form-error *'
        $scope.registrationQuestions[questionName] =
          type: questionType
          legend: questionLegend
          label: questionLabel
          options: questionOptions
          value: questionValue
          maxLength: questionMaxLength
          hasError: questionHasError
        $scope.registrationInfo[questionName] = questionValue
      
      $scope.participationType = {}
      setParticipationType = (participationType) ->
        $scope.participationType = participationType
        if not $scope.$$phase
          $scope.$apply()
      TeamraiserRegistrationService.getParticipationTypes
        error: ->
          # TODO
        success: (response) ->
          participationTypes = response.getParticipationTypesResponse.participationType
          participationTypes = [participationTypes] if not angular.isArray participationTypes
          participationType = participationTypes[0]
          waiverContent = participationType.waiver?.content
          if waiverContent
            participationType.waiver.content = waiverContent.replace /(?:\r\n|\r|\n)/g, '<br />'
          setParticipationType participationType
      $scope.$watch 'participationType.id', (newValue) ->
        if newValue
          initCustomQuestions = ->
            if not $scope.registrationCustomQuestions
              $scope.registrationCustomQuestions = {}
            if not $scope.$$phase
              $scope.$apply()
          setRegistrationQuestionSurveyKey = (questionName, surveyKey) ->
            $scope.registrationQuestions[questionName].surveyKey = surveyKey
            questionLegend = $scope.registrationQuestions[questionName].legend
            if surveyKey is 'ym_middle_school_email_type' or surveyKey is 'ym_middle_school_grade' or surveyKey is 'ym_middle_school_school' or surveyKey is 'ym_middle_school_teacher_name' or surveyKey is 'ym_middle_school_school_city' or surveyKey is 'ym_middle_school_school_state' or surveyKey is 'ym_middle_school_participated_ly'  or surveyKey is 'ym_ahc_student_state' or surveyKey is 'ahc_cell_phone'
              initCustomQuestions()
              $scope.registrationCustomQuestions[surveyKey] = questionName
            else if questionLegend isnt 'Event Date' and surveyKey isnt 'ym_middle_school_challenge_info' and surveyKey isnt 'ym_middle_school_ecards_sent' and surveyKey isnt 'ym_middle_school_ecards_shared' and surveyKey isnt 'ym_middle_school_ecards_open' and surveyKey isnt 'ym_middle_school_ecards_clicked' and surveyKey isnt 'ym_middle_school_survivor' and surveyKey isnt 'ym_middle_school_survival_story' and surveyKey isnt 'bb_facebook_connector_id'
              if not $scope.registrationAdditionalQuestions
                $scope.registrationAdditionalQuestions = {}
              #$scope.registrationAdditionalQuestions[questionName] = questionName
              $scope.registrationAdditionalQuestions[surveyKey] = questionName
              if surveyKey == 'ym_middle_school_survivor'
                $scope.studentTreated = questionName              
            if not $scope.$$phase
              $scope.$apply()
          TeamraiserRegistrationService.getRegistrationDocument 'participation_id=' + newValue,
            error: ->
              # TODO
            success: (response) ->
              registrationQuestions = response.processRegistrationRequest?.primaryRegistration?.question
              if registrationQuestions
                registrationQuestions = [registrationQuestions] if not angular.isArray registrationQuestions
                angular.forEach registrationQuestions, (registrationQuestion, registrationQuestionIndex) ->
                  registrationQuestionKey = registrationQuestion.key
                  registrationQuestionId = registrationQuestion.id
                  angular.forEach $scope.registrationQuestions, (questionObj, questionName) ->
                    if questionName.match('_' + registrationQuestionId + '$')
                      registrationQuestions[registrationQuestionIndex].ng_questionName = questionName
                registrationQuestions = $filter('orderBy') registrationQuestions, 'ng_questionName', false
                angular.forEach registrationQuestions, (registrationQuestion) ->
                  if registrationQuestion.ng_questionName
                    setRegistrationQuestionSurveyKey registrationQuestion.ng_questionName, registrationQuestion.key
              initCustomQuestions()


      prevTrId = angular.element(document).find('.prev-tr-id').text()

      $scope.getPrevSurveyResponses = ()->
        TeamraiserRegistrationService.getSurveyResponses 'fr_id=' + prevTrId,
            error: ->
              # TODO
            success: (response) ->
              surveyResponses = response.getSurveyResponsesResponse.responses
              if surveyResponses
                surveyResponses = [surveyResponses] if not angular.isArray surveyResponses
                console.log('got survey responses')
                console.log('are fields here? ' + angular.element(document).find('.ym_middle_school_grade').length)

                findFields = () ->
                  if angular.element(document).find('.ym_middle_school_grade').length > 0
                    console.log('found fields')
                    angular.forEach surveyResponses, (surveyResponse, serveyResponseIndex) ->
                      surveyResponseKey = surveyResponse.key
                      surveyResponseAnswer = surveyResponse.responseValue 

                      if surveyResponseKey == 'ym_middle_school_grade'
                        newGrade
                        if surveyResponseAnswer == 'Pre-School'
                          newGrade = 'Kindergarten'
                        if surveyResponseAnswer ==  'Kindergarten'
                          newGrade = '1st'
                        if surveyResponseAnswer ==  '2nd'
                          newGrade = '3rd'
                        if surveyResponseAnswer ==  '3rd'
                          newGrade = '4th'
                        if surveyResponseAnswer == '4th' || surveyResponseAnswer == '5th' || surveyResponseAnswer ==  '6th'|| surveyResponseAnswer == '7th' || surveyResponseAnswer == '8th' || surveyResponseAnswer == '9th' || surveyResponseAnswer == '10th' || surveyResponseAnswer == '11th'
                          newGrade = Number(surveyResponseAnswer.split('th')[0]) + 1
                          newGrade = newGrade+'th'
                        if surveyResponseAnswer ==  '12th'
                          newGrade = 'College'
                        if surveyResponseAnswer ==  'College' || surveyResponseAnswer == 'Other'
                          newGrade = 'Other'
                        angular.element(document).find('.ym_middle_school_grade').val(newGrade).trigger('change')
                  else
                    window.setTimeout(findFields,50);
                findFields();

      if $fieldErrors.length == 0
        $scope.getPrevSurveyResponses()

      $scope.toggleAcceptWaiver = (acceptWaiver) ->
        $scope.acceptWaiver = acceptWaiver
      
      $scope.previousStep = ->
        $scope.ng_go_back = true
        $timeout ->
          $scope.submitReg()
        , 500
        false
      
      $scope.submitReg = ->
        if $scope.acceptWaiver isnt 'yes' and not $scope.ng_go_back
          window.scrollTo 0, 0
          $scope.registrationInfoErrors.errors = [
            {
              text: 'You must agree to the waiver.'
            }
          ]
        else
          angular.element('.js--default-reg-form').submit()
        false

      $scope.getTeacherList = () ->
        if typeof $scope.registrationCustomQuestions != 'undefined'
          $scope.teacherList = []
          teacherList = []
          teachersFound = []
          angular.forEach $scope.teachers, (teacher) ->
            if not teachersFound[teacher]
              teacherList.push teacher
            teachersFound[teacher] = teacher
          $scope.teacherList = teacherList

      if $rootScope.classroomChallenge
        NuclavisService.getTeachers $scope.companyId + "/" + $rootScope.frId
        .then (response) ->
          $scope.teachers = response.data.teachers
          $scope.getTeacherList()
        
      setCompanyCity = (companyCity) ->
        $rootScope.companyCity = companyCity
        if not $rootScope.$$phase
          $rootScope.$apply()
          
      setCompanyState = (companyState) ->
        $rootScope.companyState = companyState
        if not $rootScope.$$phase
          $rootScope.$apply()
          
      if localStorage.companyCity != undefined
        setCompanyCity localStorage.companyCity
        setCompanyState localStorage.companyState
        
  ]
