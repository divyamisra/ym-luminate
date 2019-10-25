'use strict';
(function($) {
    $(document).ready(function() {
        // Heart Walk 2020 Registration JS
        var fr_id = $('input[name=fr_id]').val();

        if (fr_id == 3476) {
            jQuery('#fr_goal').val('$625');
            jQuery('#suggested_goal_container').html("Suggested Goal: $625.00<br>In honor of our 25th anniversary, we invite you to set a goal of $625. That's 25 donations of $25!");
        }

        if ($('#user_type_page').length > 0) {
            $('.custom-progress-bar').hide();

            console.log('doc ready fired');
            console.log('Current Application ID: 27');
            var evID = $('#f2fSendUserNameForm input[name="fr_id"]').val();
            var evID2 = $('#F2fRegPartType input[name="fr_id"]').val();
            var evID3 = $('form[name="FriendraiserFind"] input[name="fr_id"]').val();
            console.log('evid 1 = '+evID);
            console.log('evid 2 = '+evID2);
            console.log('evid 3 = '+evID3);

            //Uptype customization
            /*$('#user_type_page #utype-login .show-login').click(function(){
                $('#user_type_page #f2fLoginForm, #user_type_page .show-login-container-2').show();
                $('#user_type_page #f2fSendUserNameForm, #user_type_page .show-login-container, #user_type_page .error-show-login-container, #user_type_page .updated-tech').hide();
            });*/

            cd.consLogin = function (userName, password) {
                luminateExtend.api({
                  api: 'cons',
                  form: '.js__login-form',
                  requestType: 'POST',
                  data: 'method=login&user_name=' +
                    userName +
                    '&password=' +
                    password +
                    '&source=' +
                    trLoginSourceCode +
                    '&sub_source=' +
                    trLoginSubSourceCode +
                    '&send_user_name=true',
                  useHTTPS: true,
                  requiresAuth: true,
                  callback: {
                    success: function (response) {
                      console.log(
                        'login success. show reg options to proceed to next step.'
                      );
                      cd.logInteraction(trLoginInteractionID, evID);
                      window.location = window.location.href + '&s_regType=';
                    },
                    error: function (response) {
                      if (response.errorResponse.code === '22') {
                        /* invalid email */
                        $('.js__login-error-message').html(
                          'Oops! You entered an invalid email address.'
                        );
                      } else if (response.errorResponse.code === '202') {
                        /* invalid email */
                        $('.js__login-error-message').html(
                          'You have entered an invalid username or password. Please re-enter your credentials below.'
                        );
                      } else {
                        $('.js__login-error-message').html(
                          response.errorResponse.message
                        );
                      }
                      $('.js__login-error-container').removeClass('d-none');
                    }
                  }
                });
            };

            cd.consSignup = function (userName, password, email) {
                luminateExtend.api({
                  api: 'cons',
                  form: '.js__signup-form',
                  data: 'method=create&user_name=' + userName + '&password=' + password + '&primary_email=' + email + '&source=' + trSignupSourceCode + '&sub_source=' + trSignupSubSourceCode + '&teamraiser_registration=true',
                  useHTTPS: true,
                  requestType: 'POST',
                  requiresAuth: true,
                  callback: {
                    success: function (response) {
                      console.log('signup success');
                      cd.logInteraction(trRegInteractionID, evID);
                      var domainName = window.location.hostname,
                        domainNameParts = domainName.split('.');
                      if (domainNameParts.length > 2) {
                        domainName = domainNameParts[domainNameParts.length - 2] + '.' + domainNameParts[domainNameParts.length - 1];
                      }
                      domainName = '.' + domainName;
                      document.cookie = 'gtm_tr_reg_page_success_' + evID + '=true; domain=' + domainName + '; path=/';
                      window.location = window.location.href + '&s_regType=';
                    },
                    error: function (response) {
                      console.log('signup error: ' + JSON.stringify(response));
                      if (response.errorResponse.code === '11') {
                        /* email already exists */
                        cd.consRetrieveLogin(email, false);
                        $('.js__signup-error-message').html('Oops! An account already exists with matching information. A password reset has been sent to ' + email + '.');
                      } else if (response.errorResponse.code === '22') {
                        $('.js__signup-error-message').html("One or more attributes failed validation: \"Biographical Information/User Name\" Invalid characters in User Name (valid characters are letters, digits, '-', '_', '@', '.', '%', and ':')");

                      } else {
                        $('.js__signup-error-message').html(response.errorResponse.message);
                      }
                      $('.js__signup-error-container').removeClass('d-none');
                    }
                  }
                });
            };

            cd.consRetrieveLogin = function (accountToRetrieve, displayMsg) {
                luminateExtend.api({
                  api: 'cons',
                  form: '.js__retrieve-login-form',
                  requestType: 'POST',
                  data: 'method=login&send_user_name=true&email=' + accountToRetrieve,
                  useHTTPS: true,
                  requiresAuth: true,
                  callback: {
                    success: function (response) {
                      if (displayMsg === true) {
                        console.log('account retrieval success. show log in page again.');
                        $('.js__retrieve-login-container').addClass('d-none');
                        $('.js__login-container').removeClass('d-none');
                        $('.js__login-success-message').html('A password reset has been sent to ' + accountToRetrieve + '.');

                        $('.js__login-success-container').removeClass('d-none');
                      }

                    },
                    error: function (response) {
                      if (displayMsg === true) {
                        console.log('account retrieval error: ' + JSON.stringify(response));
                        $('.js__retrieve-login-error-message').html(response.errorResponse.message);
                        $('.js__retrieve-login-error-container').removeClass('d-none');
                      }
                    }
                  }
                });
            };

            var parsleyOptions = {
                successClass: 'has-success',
                errorClass: 'has-error',
                classHandler: function (_el) {
                  return _el.$element.closest('.form-group');
                }
            };

            // add front end validation
            $('.js__login-form').parsley(parsleyOptions);
            $('.js__signup-form').parsley(parsleyOptions);
            $('.js__retrieve-login-form').parsley(parsleyOptions);

            cd.resetValidation = function () {
                $('.js__login-form').parsley().reset();
            }
            // manage form submissions
            $('.js__login-form').on('submit', function (e) {
                e.preventDefault();
                var form = $(this);
                form.parsley().validate();
                if (form.parsley().isValid()) {
                  var consUsername = $('#loginUsername').val();
                  var consPassword = $('#loginPassword').val();
                  cd.consLogin(consUsername, consPassword);
                  cd.resetValidation();
                } else {
                  $('.js__signup-error-message').html('Please fix the errors below.');
                  $('.js__signup-error-container').removeClass('d-none');
                }
            });

            $('.js__signup-form').on('submit', function (e) {
                e.preventDefault();
                var form = $(this);
                form.parsley().validate();
                if (form.parsley().isValid()) {
                  var consUsername = $('#signupUsername').val();
                  var consPassword = $('#signupPassword').val();
                  var consEmail = $('#signupEmail').val();
                  cd.consSignup(consUsername, consPassword, consEmail);
                  cd.resetValidation();
                } else {
                  $('.js__signup-error-message').html('Please fix the errors below.');
                  $('.js__signup-error-container').removeClass('d-none');
                }
            });

            $('.js__retrieve-login-form').on('submit', function (e) {
                e.preventDefault();
                var form = $(this);
                form.parsley().validate();
                if (form.parsley().isValid()) {
                  var consEmail = $('#retrieveLoginEmail').val();
                  cd.consRetrieveLogin(consEmail, true);
                  cd.resetValidation();
                } else {
                  $('.js__retrieve-login-error-message').html('Please fix the errors below.');
                  $('.js__retrieve-login-error-container').removeClass('d-none');
                }
            });

            // show login retrieval form
            $('.js__show-retrieve-login').on('click', function (e) {
                e.preventDefault();
                cd.resetValidation();
                $('.js__login-container').addClass('d-none');
                $('.js__retrieve-login-container').removeClass('d-none');
            });

            // show login form
            $('.js__show-login').on('click', function (e) {
                e.preventDefault();
                cd.resetValidation();
                $('.js__retrieve-login-container').addClass('d-none');
                $('.js__signup-container').addClass('d-none');
                $('.js__login-container').removeClass('d-none');
            });
            // show signup form
            $('.js__show-signup').on('click', function (e) {
                e.preventDefault();
                cd.resetValidation();
                $('.js__retrieve-login-container').addClass('d-none');
                $('.js__login-container').addClass('d-none');
                $('.js__signup-container').removeClass('d-none');
            });

            $('.js__existing-record').on('click', function (e) {
                // existing record. show log in form
                $('.js__have-we-met-container').addClass('d-none');
                $('.js__login-container').removeClass('d-none');
            });
            $('.js__show-have-we-met').on('click', function (e) {
                // existing record. show log in form
                e.preventDefault();
                $('.js__login-container').addClass('d-none');
                $('.js__have-we-met-container').removeClass('d-none');
            });
            $('.js__new-record').on('click', function (e) {
            // new participant. continue to tfind step
                $('#f2fRegPartType #next_step').click();
            });

            $('.janrainEngage').html('<div class="btn-social-login btn-facebook"><i class="fab fa-facebook-f mr-2"></i> Create with Facebook</div><div class="btn-social-login btn-amazon"><i class="fab fa-amazon mr-2"></i> Create with Amazon</div>');

        }
        if ($('#reg_payment_page').length > 0) {
            $('.custom-progress-bar').hide();
        }
        $('#reg_total_label').html('Total:');

        //Rthanks
        if ($('#fr_thanks_page').length > 0) {
            $('.custom-progress-bar').hide();
        }
        //Form a team / join a team
        if ($('#team_find_page').length > 0) {
            $('.custom-progress-bar').hide();
        }
        if ($('#fr_team_goal').length <= 0) {
            $('#team_find_section_footer').hide();
        }
        //Custom progress bar
        if ($('#F2fRegPartType').length > 0) {
            $('.p-bar-step-1').show();
        }
        if ($('#F2fRegContact, form[name="RegisterAnother"]').length > 0) {
            $('.p-bar-step-1, .p-bar-step-2').show();
            $('#progressText1').hide();
            $('.p-bar-step-1').css('background', '#f18b21');
        }
        if ($('#fr_reg_summary_page #FriendraiserUserWaiver').length > 0) {
            $('.p-bar-step-1, .p-bar-step-2, .p-bar-step-3').show();
            $('#progressText1, #progressText2').hide();
            $('.p-bar-step-1, .p-bar-step-2').css('background', '#f18b21');
        }
        $('#sel_type_container').parent().addClass('aural-only');

        $('span.input-label:contains("Life is Why")').parent().parent().parent().parent().hide();
        $('.input-label:contains("How many years")').parent().parent().parent().parent().hide();
        $('.input-label:contains("Mobile Phone")').parent().parent().parent().parent().addClass('regMobilePhone');
        $('span.cons_email').parent().parent().addClass('consEmail');
        $('.survey-question-container.regMobilePhone').insertAfter('.cons-info-question-container.consEmail');

        $('#overlayWaiver, .lightboxWiaverClose').click(function() {
            $('#overlayWaiver, #lightboxWiaver').hide();
        });

        /* Page = Reg */
        if ($('input[name="pg"]').val() == 'reg') {
            $('#additional_questions_container .survey-question-container:contains("Facebook Fundraiser ID:")').hide();
        }
        $('#password_component_container #cons_rep_password').parent().parent().parent().addClass('left');
        $('#password_component_container #cons_password').parent().parent().parent().addClass('left');
        $('span.survey-question-label:contains("Would you like to be recognized as a survivor?")').parent().next().children().children().children('input').wrap('<div></div>');
        $('span.survey-question-label:contains("Would you like to be recognized as a survivor?")').parent().parent().addClass('survivor_yes_no');
        $('span.input-label:contains("SurvivorQ")').parent().parent().addClass('survivorSelect');
        $('span.input-label:contains("SurvivorQ")').parent().parent().parent().parent().hide();
        if ($('.survivor_yes_no li.input-container input[value="No"]').is(':checked')) {
            $('.survivor_yes_no li.input-container input[value="No"]').parent().parent().addClass('survivor_active');
        } else if ($('.survivor_yes_no li.input-container input[value="Yes"]').is(':checked')) {
            $('.survivor_yes_no li.input-container input[value="Yes"]').parent().parent().addClass('survivor_active');
        }
        $('.survivor_yes_no label').click(function() {
            $('.survivor_yes_no li').removeClass('survivor_active');
            $(this).parent().addClass('survivor_active');
        });

        if (fr_id = 3297 || fr_id == 3260 || fr_id == 3289) {
            $('label[for="cons_street2"]').parent().before('<span style="display: inline-block; width: 14px;"></span>');
            $('div.regMobilePhone').css('float', 'left');
            $('div.cons-address-street-full-container').css('margin-right', '0');
        } else {
            /* zip only reg flow */
            $('#cons_zip_code').parent().parent().parent().parent().addClass('field-required consZip');

            if ($(".consZip span.field-required").length === 0) {
                $('label[for="cons_zip_code"]').parent().before('<span class="field-required"></span>');
            }

            $('.cons-address-street-full-container').hide();
            $('#cons_city').parent().parent().parent().parent().hide();
            $('#cons_state').parent().parent().parent().parent().hide();
            $('#cons_info_country_container').hide();
        }


        /*Donation Buttons*/
        $('.donation-level-row-label').parent().parent().addClass('donation-amt');
        $('.donation-level-row-label:contains("Additional Gift:")').parent().parent().addClass('enterAmt').removeClass('donation-amt');
        $('<span>Other amount:</span>').insertBefore('.donation-level-row-container.enterAmt input:last-child');
        $(".donation-level-amount-text").each(function() {
            $(this).text($(this).text().replace(".00", ""));
        });
        $('.donation-level-row-container.donation-amt').click(function() {
            $(this).find('input').prop('checked', true);
            $('.donation-level-row-container.donation-amt').removeClass('active');
            $(this).addClass('active');
            $('#part_type_anonymous_input_container, #part_type_show_public_input_container').show();
            $('.donation-level-row-container.enterAmt input').val('');
        });
        $('.donation-level-row-container.enterAmt').click(function() {
            $(this).find('input').prop('checked', true);
            $('.donation-level-row-container.donation-amt').removeClass('active');
            $('#part_type_anonymous_input_container, #part_type_show_public_input_container').show();
        });
        $('#part_type_individual_company_selection_container').insertAfter('#part_type_selection_container');
        $('.donation-level-row-label-no-gift').insertBefore(jQuery('.donation-level-row-label-no-gift').parent());

        //QA

        if ($('#F2fRegPartType').length > 0 && $('#previous_step').length === 0) {
            $('#F2fRegPartType .section-footer button.next-step').after('<a href="TRR/?pg=utype&fr_id=' + fr_id + '" class="step-button previous-step backBtnReg">Back</a>');
        }

        $('#reg_summary_header_container').insertAfter('.section-header');
        $('#previous_step span').text("Back");
        if ($('input[name=fr_tm_opt]').val() == 'existingnew') {
            $('#fr_team_goal').val('');
            $('#fr_team_name').val('');
        }
        $('.part-type-description-text:contains("Free")').html('&nbsp;');
        $('.survey-question-container legend span:contains("Waiver agreement")').parent().parent().addClass('waiverCheck');
        $('.waiverCheck legend').addClass('aural-only');
        $('.waiverCheck label').html('I accept and acknowledge that I have read and understand the HeartWalk <a id="waiverPopLink" href="#">release and indemnification</a> and agree to them voluntarily.');
        $('.survey-question-container legend span:contains("Healthy for good signup")').parent().parent().addClass('healthyCheck');
        $('.healthyCheck legend').addClass('aural-only');
        $('#waiverPopLink').click(function(e) {
            e.preventDefault();
            $('#overlayWaiver, #lightboxWiaver').fadeIn(400);
        });
        $('.healthyCheck label').text('Yes, sign me up for sharable tips, videos and hacks so I can be Healthy For Good.');
        $('#responsive_payment_typecc_numbername').attr('maxlength', '16');

        $('.donation-level-row-label-no-gift').parent().addClass('notTime');
        $('.notTime').click(function() {
            $('.donation-level-row-container').removeClass('active');
        });



        //access
        $('html').attr('xmlns', 'http://www.w3.org/1999/xhtml').attr('lang', 'en').attr('xml:lang', 'en');

        var contentMeta = $('meta[name="Keywords"]').attr('content').trim();
        $('meta[name="Keywords"]').attr('content', contentMeta);
        if ($('.progress-bar-step-container').length > 0) {
            var progressBarCurr = $('.progress-bar-step-container.progress-bar-step-current').attr('class').trim();
            $('.progress-bar-step-container.progress-bar-step-current').attr('class', progressBarCurr);
            var progressBar = $('.progress-bar-step-container').not('.progress-bar-step-container.progress-bar-step-current').attr('class').trim();
            $('.progress-bar-step-container').attr('class', progressBar);
        }
        if ($('.part-type-decoration-messages').length > 0) {
            var decorationMessages = $('.part-type-decoration-messages').attr('class').trim();
            $('.part-type-decoration-messages').attr('class', decorationMessages);
        }
        if ($('.tr_sponsorship_logo_image').length > 0) {
            $('.tr_sponsorship_logo_image').each(function() {
                var logoImage = $('.tr_sponsorship_logo_image').attr('alt').trim();
                $('.tr_sponsorship_logo_image').attr('alt', logoImage);
            });
        }
        /*if ($('.cons-info-question-container.cons-address-street-full-container').length > 0) {
            var consInfoQ = $('.cons-info-question-container.cons-address-street-full-container').not('.cons-info-question-container.cons-address-street-full-container.field-required').attr('class').trim();
            $('.cons-info-question-container.cons-address-street-full-container').attr('class',consInfoQ);
        }*/

        $('.heart-hero__event-name p').first().replaceWith(function() {
            return '<h1 class="event-name-header">' + $(this).html() + '</h1>';
        });

        $('span#pt_title_container').replaceWith(function() {
            return '<h1 id="pt_title_container" class="section-header-text">' + $(this).html() + '</h1>';
        });

        $('#part_type_selection_container').wrapInner('<fieldset></fieldset>');
        $('#sel_type_container').wrap('<legend class="aural-only"></legend>');
        $('#part_type_selection_container .manageable-content legend').prependTo('#part_type_selection_container fieldset');

        $('#fr_part_co_list').before('<label class="aural-only" for="fr_part_co_list">Choose an existing company</label>');


        $('#part_type_donation_level_input_container').wrapInner('<fieldset></fieldset>');
        $('#part_type_donation_level_input_container fieldset').prepend('<legend class="aural-only">Choose an optional donation amount</legend>');

        $('#reg_summary_campaign_banner_container h2').replaceWith(function() {
            return '<h1 class="cstmTitle">' + $(this).html() + '</h1>';
        });
        $('span#title_container').replaceWith(function() {
            return '<h1 class="ObjTitle" id="title_container">' + $(this).html() + '</h1>';
        });

        $('.detail-show-link.detail-toggle-link img, .detail-hide-link.detail-toggle-link img').attr('alt', '');

        $('#team_find_new_team_company .input-label').attr('for', 'fr_co_list');

        $('#team_find_new_team_attributes span.field-required').attr('aria-hidden', 'true');

        if ($('#team_find_header_container .ErrorMessage.page-error .field-error-text').length > 0) {
            $('#team_find_header_container .ErrorMessage.page-error .field-error-text').attr('role', 'alert');
        }

        $('#team_find_new_fundraising_goal .form-content label').html('Team Fundraising Goal:<br>');
        $('#team_find_new_fundraising_goal .form-content span.hint-text').appendTo('#team_find_new_fundraising_goal label');

        $('#email_format_container label').attr('for', 'cons_email_format');

        $('#personal_info_section_one .cons-info-question-container.cons-full-name-container span.input-label.cons_first_name').text('First Name');
        $('#personal_info_section_one .cons-info-question-container.cons-full-name-container span.input-label.cons_last_name').text('Last Name');

        $('h3.ObjTitle:contains("Review your registration")').replaceWith(function() {
            return '<h1 class="ObjTitle" id="title_container">' + $(this).html() + '</h1>';
        });

        if ($('.donation-level-row-container.enterAmt').length > 0) {
            var otherID = $('.donation-level-row-container.enterAmt span:contains("Other amount")').next().attr('id');
            $('.donation-level-row-container.enterAmt span:contains("Other amount")').wrap('<label class="otherAmt" for="' + otherID + '"></label>');
        }

        $('#F2fRegPartType .required-indicator-legend-container').remove();

        /* end access edits */

        /* GA Codes */
        jQuery("#fr_find_search").blur(function() {
            _gaq.push(['t2._trackEvent', 'Register', 'click', 'Search for a team']);
        });
        jQuery("#friend_potion_next").blur(function() {
            _gaq.push(['t2._trackEvent', 'Register', 'click', 'Start a team']);
        });
        jQuery("a:contains('Join a Team')").blur(function() {
            _gaq.push(['t2._trackEvent', 'SwitchRegister', 'click', 'Join a team']);
        });
        jQuery("#individual_container").blur(function() {
            _gaq.push(['t2._trackEvent', 'Register', 'click', 'Join as an individual']);
        });
        jQuery("#utype-yes").blur(function() {
            _gaq.push(['t2._trackEvent', 'Fundraised Before', 'click', 'Yes']);
        });
        jQuery("#utype-no").blur(function() {
            _gaq.push(['t2._trackEvent', 'Fundraised Before', 'click', 'No']);
        });
        jQuery("input[name='fr_part_radio']").blur(function() {
            _gaq.push(['t2._trackEvent', 'Participation Type', 'click', 'Heart Walk']);
        });
        jQuery("input[name='fr_part_radio']").blur(function() {
            _gaq.push(['t2._trackEvent', 'Participation Type', 'click', 'Heart Walk']);
        });
        jQuery("#next_step").blur(function() {
            _gaq.push(['t2._trackEvent', 'Button', 'click', 'Next']);
        });
        jQuery(".backBtnReg").blur(function() {
            _gaq.push(['t2._trackEvent', 'Button', 'click', 'Back']);
        });
        jQuery(".notTime input").blur(function() {
            _gaq.push(['t2._trackEvent', 'Select Options', 'click', 'Not at this time']);
        });
        jQuery(".healthyCheck input").blur(function() {
            _gaq.push(['t2._trackEvent', 'Healthy Check', 'click', 'No']);
        });
        jQuery("a:contains('Edit')").blur(function() {
            _gaq.push(['t2._trackEvent', 'Complete Registration', 'click', 'Edit']);
        });
        jQuery("button[value='Complete Registration']").blur(function() {
            _gaq.push(['t2._trackEvent', 'Complete Registration', 'click', 'Complete']);
        });
        jQuery("#cancel_button").blur(function() {
            _gaq.push(['t2._trackEvent', 'Complete Registration', 'click', 'Cancel']);
        });
        jQuery("#reg_payment_page #responsive_payment_typecc_numbername").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Credit Card']);
        });
        jQuery("#reg_payment_page #responsive_payment_typecc_exp_date_MONTH").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Expire Month']);
        });
        jQuery("#reg_payment_page #responsive_payment_typecc_exp_date_YEAR").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Expire Year']);
        });
        jQuery("#reg_payment_page #responsive_payment_typecc_cvvname").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'CCV']);
        });
        jQuery("#reg_payment_page #billing_first_namename").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'First Name']);
        });
        jQuery("#reg_payment_page #billing_last_namename").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Last Name']);
        });
        jQuery("#reg_payment_page #billing_addr_street1name").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Street 1']);
        });
        jQuery("#reg_payment_page #billing_addr_street2name").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Street 2']);
        });
        jQuery("#reg_payment_page #billing_addr_cityname").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'City']);
        });
        jQuery("#reg_payment_page #billing_addr_state").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'State']);
        });
        jQuery("#reg_payment_page #billing_addr_zipname").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Zip']);
        });
        jQuery("#reg_payment_page #billing_addr_country").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Country']);
        });
        jQuery("#reg_payment_page #btn_next").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Payment', 'click', 'Next']);
        });
        jQuery("#part_ctr_container").blur(function() {
            _gaq.push(['t2._trackEvent', 'Reg Completed', 'click', 'Access Participant Center']);
        });

        jQuery("a:contains('Start a Team')").click(function(){
            _gaq.push(['t2._trackEvent', 'Register Landing', 'click', 'Start Team']);
        });
        jQuery("a:contains('Join a Team')").click(function(){
            _gaq.push(['t2._trackEvent', 'Register Landing', 'click', 'Join a Team']);
        });
        jQuery("a:contains('Join as Individual')").click(function(){
            _gaq.push(['t2._trackEvent', 'Register Landing', 'click', 'Join as Indiv']);
        });

        $('.survivor_yes_no input').change(function() {
            radioValue = $(this).val();
            console.log("radio value = ", radioVaalue);
            $('.survivor_yes_no li').removeClass('survivor_active');

            if ($(this).is(":checked") && radioValue == "Yes") {
                $(this).parent().parent().addClass('survivor_active');
            }
            if ($(this).is(":checked") && radioValue == "No") {
                $(this).parent().parent().addClass('survivor_active');
            }

        });

        if ($('#part_type_selection_container').length > 0) {
            var pTypeCurrent = jQuery('#part_type_selection_container .part-type-container.selected').find('.part-type-name').text();
            console.log('pTypeCurrent = ' + pTypeCurrent);
            pTypeSetCookie(pTypeCurrent);

            $('#part_type_selection_container label').click(function() {
                var pType = $(this).find('.part-type-name').text();
                console.log('pType after click ' + pType);
                pTypeSetCookie(pType);
            });

        }

        if ($('.lightboxWiaverContent').length > 0) {
            console.log("yes we're on the waiver apge");

            $.ajax({
                type: 'GET',
                url: 'CRTeamraiserAPI',
                data: {
                    method: 'getParticipationTypes',
                    api_key: 'wDB09SQODRpVIOvX',
                    v: '1.0',
                    fr_id: fr_id,
                },
                dataType: 'xml'
            }).done(function(data) {
                processPTypesData(data);
            });

        }

        if ($('#team_find_existing').length > 0) {
            if ($('#team_find_search_results_header_text').length > 0) {
                location.hash = "team_label_container";
                jQuery('#team_find_search_results_container').focus();
                jQuery('#team_find_search_results_header_text').css('display', 'inline-block');
                jQuery('<span style="display:inline-block;padding-left: 20px;"><a href="javascript:void(0)" id="searchAgain">(Search Again)</a></span>').insertAfter('#team_find_search_results_header_text')
                jQuery("#searchAgain").on('click', function(event) {
                    window.scrollTo(0, 0);
                })
            }
            jQuery('.list-component-row.list-row').each(function() {
                var join_link = jQuery(this).find('.list-component-cell-column-team-name a').attr('href');
                jQuery(this).find('.list-component-cell-column-team-name a').contents().unwrap();
                jQuery(this).find('.list-component-cell-column-join-link .list-component-cell-data-text a').after('<a href="' + join_link + '" style="background:white;background-color:white !important;border:2px solid #cd181d!important;margin:5px auto 0;display:block;width:132px" target="_blank">View</a>');
            });
            //jQuery('.list-component-cell-column-join-link .list-component-cell-data-text a').css('display','block');
        }

    });

    function processPTypesData(data) {
        var userParticipationType = readCookie('pType');
        console.log(userParticipationType);
        var waiver;
        $(data).find('participationType').each(function() {
            var nodeName = $(this).find('name').text();
            var nodeNameTrim = nodeName.replace(/\s/g, "");
            if (nodeNameTrim == userParticipationType) {
                waiver = $(this).find('waiver').text();
                waiverHTML = waiver.replace(/(?:\r\n\r\n|\r\r|\n\n)/, '<p>').replace(/(?:\r\n\r\n|\r\r|\n\n)/g, '</p><p>').replace('our Privacy Policy', '<a href="http://www.Heart.org/Privacy">our Privacy Policy</a>');
                waiverHTML = waiverHTML + "</p>";
                $('.lightboxWiaverContent').html(waiverHTML);
            }
        });
        console.log(waiver);
    }

    function pTypeSetCookie(pType) {
        var pTypeTrim = pType.replace(/\s/g, "");
        //console.log(pTypeTrim);
        document.cookie = "pType=" + pTypeTrim;
    }
    
    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }
})(jQuery);
