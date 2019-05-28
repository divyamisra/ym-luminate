'use strict';

(function ($) {
  $(document).ready(function ($) {

    /*************/
    /* Namespace */
    /*************/
    window.cd = {};


    /******************/
    /* SEARCH SCRIPTS */
    /******************/
    var eventType = 'Heart%20Walk';
    var eventType2 = $('body').data('event-type2') ? $('body').data('event-type2') : null;
    var regType = $('body').data('reg-type') ? $('body').data('reg-type') : null;
    var publicEventType = $('body').data('public-event-type') ? $('body').data('public-event-type') : null;

    var isProd = (luminateExtend.global.tablePrefix === 'heartdev' ? false : true);
    var eventName = luminateExtend.global.eventName;
    var srcCode = luminateExtend.global.srcCode;
    var subSrcCode = luminateExtend.global.subSrcCode;
    var evID = $('body').data('fr-id') ? $('body').data('fr-id') : null;
    var consID = $('body').data('cons-id') ? $('body').data('cons-id') : null;

    cd.getParticipants = function (firstName, lastName, searchAllEvents) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getParticipants' +
          '&first_name=' + ((firstName !== undefined) ? firstName : '') +
          '&last_name=' + ((lastName !== undefined) ? lastName : '') +
          (searchAllEvents === true ? '&event_type=' + eventType : '&fr_id=' + evID) +
          '&list_page_size=499' +
          '&list_page_offset=0' +
          '&response_format=json' +
          '&list_sort_column=first_name' +
          '&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getParticipantsResponse.totalNumberResults === '0') {
              // no search results
              $('#error-participant').removeAttr('hidden').text('Participant not found. Please try different search terms.');
            } else {
              var participants = luminateExtend.utils.ensureArray(response.getParticipantsResponse.participant);
              var totalParticipants = parseInt(response.getParticipantsResponse.totalNumberResults);

              $('.js__num-participant-results').text((totalParticipants === 1 ? '1 Result' : totalParticipants + ' Results'));

              $(participants).each(function (i, participant) {

                $('.js__participants-results-rows').append('<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' + participant.personalPageUrl + '">' +
                  participant.name.first + ' ' + participant.name.last +
                  '</a></td><td>' +
                  ((participant.teamName !== null && participant.teamName !== undefined) ? '<a href="' + participant.teamPageUrl + '">' + participant.teamName + '</a>' : '') + '</td><td><a href="TR/?fr_id=' + participant.eventId + '&pg=entry">' +
                  participant.eventName + '</a></td><td class="col-cta"><a href="' + participant.donationUrl + '" aria-label="Donate to ' + participant.name.first + ' ' + participant.name.last + '" class="btn-rounded btn-primary btn-block">Donate</a></td></tr>');

              });

              $('.js__participant-results-container').removeAttr('hidden');
            }
          },
          error: function (response) {
            $('#error-participant').removeAttr('hidden').text(response.errorResponse.message);
          }
        }
      });
    };

    cd.getTeams = function (teamName, searchType, isCrossEvent, firstName, lastName, companyId) {
      $('.js__team-results-rows').html('');
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamsByInfo' +
          '&team_name=' + teamName +
          (isCrossEvent === true ? '&event_type=' + eventType : '&fr_id=' + evID) +
          (firstName ? '&first_name=' + firstName : '') +
          (lastName ? '&last_name=' + lastName : '') +
          (companyId ? '&team_company_id=' + companyId : '') +
          '&list_page_size=499' +
          '&list_page_offset=0' +
          '&response_format=json' +
          '&list_sort_column=name' +
          '&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getTeamSearchByInfoResponse.totalNumberResults === '0') {
              // no search results
              $('#error-team').removeAttr('hidden').text('Team not found. Please try different search terms.');
              $('.js__error-team-search').show();
            } else {
              var teams = luminateExtend.utils.ensureArray(response.getTeamSearchByInfoResponse.team);

              $(teams).each(function (i, team) {
                $('.js__team-results-rows')
                  .append('<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' + team.teamPageURL + '">' +
                    team.name + '</a></td><td><a href="TR/?px=' + team.captainConsId + '&pg=personal&fr_id=' + team.EventId + '">' + team.captainFirstName + ' ' + team.captainLastName + '</a></td><td>' +
                    ((team.companyName !== null && team.companyName !== undefined) ? '<a href="TR?company_id=' + team.companyId + '&fr_id=' + team.EventId + '&pg=company">' + team.companyName + '</a>' : '') +
                    '</td><td><a href="TR/?fr_id=' + team.EventId + '&pg=entry"' + team.eventName + '</a></td><td class="col-cta"><a href="' + team.teamDonateURL + '" class="btn-rounded btn-primary btn-block" title="Donate to ' + team.name + '" aria-label="Donate to ' + team.name + '">Donate</a></td></tr>');
              });

              var totalTeams = parseInt(response.getTeamSearchByInfoResponse.totalNumberResults);

              $('.js__num-team-results').text((totalTeams === 1 ? '1 Result' : totalTeams + ' Results'));
              $('.js__team-results-container').removeAttr('hidden');
            }
          },
          error: function (response) {
            $('#error-team').removeAttr('hidden').text(response.errorResponse.message);

            $('.js__search-results').show();
            $('.js__search-results-container').show();
          }
        }
      });
    };

    cd.getCompanies = function (companyName, isCrossEvent) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getCompaniesByInfo' +
          '&company_name=' + companyName +
          (isCrossEvent === true ? '&event_type=' + eventType : '&fr_id=' + evID) +
          '&list_page_size=499' +
          '&list_page_offset=0' +
          (isCrossEvent === true ? '&include_cross_event=true' : '') +
          '&response_format=json' +
          '&list_sort_column=company_name' +
          '&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getCompaniesResponse.totalNumberResults === '0') {
              // no search results
              $('#error-company').removeAttr('hidden').text('Company not found. Please try different search terms.');
            } else {
              var companies = luminateExtend.utils.ensureArray(response.getCompaniesResponse.company);
              var totalCompanies = parseInt(response.getCompaniesResponse.totalNumberResults);

              $('.js__num-company-results').text((totalCompanies === 1 ? '1 Result' : totalCompanies + ' Results'));

              $(companies).each(function (i, company) {
                $('.js__company-results-rows').append('<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' + company.companyURL + '">' +
                  company.companyName + '</a></td><td class="col-cta"><a href="' + company.companyURL + '" aria-label="Visit page for ' + company.companyName + '" class="btn-rounded btn-primary btn-block">View</a></td></tr>');
              });

              $('.js__company-results-container').removeAttr('hidden');
              $('.js__company-results-container').removeAttr('hidden');
            }
          },
          error: function (response) {
            $('.js__company-results-container').removeAttr('hidden').text(response.errorResponse.message);
          }
        }
      });
    };


    /******************************/
    /* EVENT SEARCH SCRIPTS */
    /******************************/

    // Get events by name or state
    cd.getEvents = function (eventName, eventState) {
      $('.js__loading').show();
      $('.js__no-event-results').addClass('d-none');
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamraisersByInfo' +
          '&name=' + (eventState ? '%25%25' : eventName) +
          (eventState ? '&state=' + eventState : '') +
          '&event_type=' + eventType +
          '&response_format=json&list_page_size=499&list_page_offset=0&list_sort_column=event_date&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getTeamraisersResponse.totalNumberResults > '0') {
              $('.js__loading').hide();
              var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);

              $(events).each(function (i, event) {
                var eventId = event.id;
                var eventName = event.name;
                var eventDate = luminateExtend.utils.simpleDateFormat(event.event_date,
                  'EEEE, MMMM d, yyyy');
                var eventTimestamp = new Date(event.event_date);
                var eventCity = event.city;
                var eventStateAbbr = event.state;
                var eventStateFull = event.mail_state;
                var eventLocation = event.location_name;
                var eventStatus = event.status;
                var eventType = event.public_event_type_name;
                var greetingUrl = event.greeting_url;
                var registerUrl = 'SPageServer/?pagename=cn_register&fr_id=' + eventId + '&s_regType=';
                var acceptsRegistration = event.accepting_registrations;
                var eventRow = '<li class="event-detail row col-12 col-lg-4 mb-4 fadein"><div class="event-detail-content col-10"><a class="js__event-name" href="' +
                  greetingUrl + '" aria-label="Visit ' + eventCity + ' ' + eventType + ' Event"><span class="city">' +
                  eventCity + '</span>, <span class="fullstate">' +
                  eventStateAbbr + '</span></a><span class="eventtype d-block">' +
                  eventType + ' Event</span><span class="event-date d-block">' +
                  eventDate + '</span></div><a href="' +
                  greetingUrl + '" class="event-detail-button btn col-2" aria-label="Visit event page for CycleNation ' + eventCity + '"><i class="fas fa-angle-right" aria-hidden="true" alt=""></i></a></li>';

                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                  $('.js__event-search-results').append(eventRow);
                }
              });
            } else {
              $('.js__loading').hide();
              $('.js__no-event-results').removeClass('d-none');
            }
          },
          error: function (response) {
            $('.js__loading').hide();
            console.log('getEvents error: ' + response.errorResponse.message);
          }
        }
      });
    };

    // Get events by zip

    cd.getEventsByDistance = function (zipCode) {
      $('.js__no-event-results').addClass('d-none');
      $('.js__loading').show();

      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamraisersByDistance' +
          '&starting_postal=' + zipCode +
          '&distance_units=mi' +
          '&search_distance=200' +
          '&event_type=' + eventType +
          '&response_format=json&list_page_size=499&list_page_offset=0&list_sort_column=event_date&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getTeamraisersResponse.totalNumberResults > '0') {
              $('.js__loading').hide();
              var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);

              $(events).each(function (i, event) {
                var eventId = event.id;
                var eventName = event.name;
                var eventDate = luminateExtend.utils.simpleDateFormat(event.event_date,
                  'EEEE, MMMM d, yyyy');
                var eventTimestamp = new Date(event.event_date);
                var eventCity = event.city;
                var eventStateAbbr = event.state;
                var eventStateFull = event.mail_state;
                var eventLocation = event.location_name;
                var eventStatus = event.status;
                var eventType = event.public_event_type_name;
                var greetingUrl = event.greeting_url;
                var registerUrl = 'SPageServer/?pagename=cn_register&fr_id=' + eventId + '&s_regType=';
                var acceptsRegistration = event.accepting_registrations;

                var eventRow = '<li class="event-detail row col-12 col-lg-4 mb-4 fadein"><div class="event-detail-content col-10"><a class="js__event-name" href="' +
                  greetingUrl + '" aria-label="Visit ' + eventCity + ' ' + eventType + ' Event"><span class="city">' +
                  eventCity + '</span>, <span class="fullstate">' +
                  eventStateAbbr + '</span></a><span class="eventtype d-block">' +
                  eventType + ' Event</span><span class="event-date d-block">' +
                  eventDate + '</span></div><a href="' +
                  greetingUrl + '" class="event-detail-button btn col-2"  aria-label="Visit event page for CycleNation ' + eventCity + '"><i class="fas fa-angle-right" aria-hidden="true" alt=""></i></a></li>';
                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                  $('.js__event-search-results').append(eventRow);
                }
              });

            } else {
              $('.js__loading').hide();
              $('.js__no-event-results').removeClass('d-none');
            }
          },
          error: function (response) {
            $('.js__loading').hide();
            console.log('getEvents error: ' + response.errorResponse.message);
          }
        }
      });
    };
    // END getEventsByDistance

    /***********************/
    /* THERMOMETER SCRIPTS */
    /***********************/

    // GREETING PAGE
    if ($('body').is('.pg_entry')) {
      cd.runThermometer = function (raised, goal) {
        var fundraiserRaised = Number(raised.replace(/[^0-9.-]+/g,''));
        var fundraiserGoal = Number(goal.replace(/[^0-9.-]+/g,''));

        var percentRaised = (fundraiserRaised / fundraiserGoal);
        if (isNaN(percentRaised)) {
          percentRaised = 0;
        }
        var percentRaisedFormatted = (percentRaised * 100) + '%';

        $('.js__progress-bar')
            .animate({width : percentRaisedFormatted}, 2000)
            .attr("aria-valuenow", percentRaisedFormatted);
        $('.js__percent-raised').each(function () {
          $(this).prop('Counter', 0).animate({
            Counter: percentRaisedFormatted
          }, {
            duration: 1000,
            easing: 'swing',
            step: function (now) {
              $(this).text(Math.ceil(now) + '%');
              if (now > 80 && now <= 100) {
                $(this).addClass('invert-percent-raised');
              } else if (now > 100) {
                $(this).addClass('progress-goal-met');
              }
            }
          });
        });
      };

      // Event info section mobile expand/collapse functionality
      $('.event-info-expand').click(function() {
        $(this).parent().next('.event-info-collapse').toggleClass('d-sm-none');
        var icon = $(this).children('i');

        if ($(icon).hasClass('fa-plus')) {
            $(icon).removeClass('fa-plus').addClass('fa-minus');
        } else {
            $(icon).removeClass('fa-minus').addClass('fa-plus');
        }
      });

      // Mobile nav toggle
      $('#mobile-toggle').click(function() {
          if ($('#navbar-container').hasClass('is-search')) {
              $('#navbar-container').removeClass('is-search');
              $('.mobile-search-trigger').removeClass('active');
          } else {
              $('#navbar-container').slideToggle('fast');
          }
          $('.navbar-toggler-icon').toggleClass('fa-align-justify').toggleClass('fa-times');
      });

      // Mobile search toggle
      $('.mobile-search-trigger').click(function() {
          if ($('.navbar-toggler-icon').hasClass('fa-times')) {
              $('#navbar-container').addClass('is-search');
              $('.mobile-search-trigger').addClass('active');
              $('.navbar-toggler-icon').toggleClass('fa-align-justify').toggleClass('fa-times');
          } else {
              $('.mobile-search-trigger').toggleClass('active');
              if ($('#navbar-container').hasClass('is-search')) {
                  // Wait to toggle is-search class until the container
                  // is fully closed so that the user doesn't see the
                  // gray navigation appear as it closes
                  $('#navbar-container').slideToggle('fast', function() {
                      $('#navbar-container').toggleClass('is-search');
                  });
              } else {
                  $('#navbar-container').toggleClass('is-search');
                  $('#navbar-container').slideToggle('fast');
              }
          }
      });
    }

    /******************/
    /* ROSTER SCRIPTS */
    /******************/

    cd.getTopParticipants = function (eventId) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getParticipants&first_name=%25%25%25&event_type=' + eventType + '&fr_id=' + eventId + '&list_sort_column=total&list_ascending=false&list_page_size=5&response_format=json',
        callback: {
          success: function (response) {
            if (!$.isEmptyObject(response.getParticipantsResponse)) {
              var participantData = luminateExtend.utils.ensureArray(response.getParticipantsResponse
                .participant);

              $(participantData).each(function () {
                console.log('getting top participants');
                var participantName = this.name.first + ' ' + this.name.last;
                var participantRaised = (parseInt(this.amountRaised) * 0.01);
                var participantRaisedFormmatted = participantRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
                var participantId = this.consId;
                var participantPage = this.personalPageUrl;
                var isCaptain = this.aTeamCaptain;
                var topParticipantHtml = '<div class="top-list-entry row pb-2"><div class="names-amounts col-10 pl-0"><a class="participant-name" href="' + participantPage + '">' + participantName + '</a><span class="amount-raised">$' + participantRaisedFormmatted + '</span></div></div>';

                $('.js__top-participants-list').append(topParticipantHtml);

              });
            }
          },
          error: function (response) {
            console.log('getTopParticipants error: ' + response.errorResponse.message);
          }
        }
      }); 
    }
    // END TOP PARTICIPANTS

    // BEGIN TOP TEAMS
    cd.getTopTeams = function (eventId) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamsByInfo&fr_id=' + eventId + '&list_sort_column=total&list_ascending=false&list_page_size=5&response_format=json',
        callback: {
          success: function (response) {
            if (!$.isEmptyObject(response.getTeamSearchByInfoResponse)) {
              var teamData = luminateExtend.utils.ensureArray(response.getTeamSearchByInfoResponse.team);

              $(teamData).each(function (i) {
                var teamName = this.name;
                var teamRaised = (parseInt(this.amountRaised) * 0.01);
                var teamRaisedFormmatted = teamRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
                var teamId = this.id;

                var topTeamRow = '<div class="top-list-entry row pb-2"><div class="names-amounts col-10 pl-0"> <a class="participant-name" href="TR/?team_id=' + teamId + '&amp;pg=team&amp;fr_id=' + evID + '">' + teamName + '</a> <span class="amount-raised">$' + teamRaisedFormmatted + '</span> </div></div>';

                $('.js__top-teams-list').append(topTeamRow);
              });
            }
          },
          error: function (response) {
            console.log('getTopTeams error: ' + response.errorResponse.message);
          }
        }
      }); 
    } 

    // END TOP TEAMS

    // BEGIN TOP COMPANIES
    cd.getTopCompanies = function (eventId) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getCompaniesByInfo&fr_id=' + eventId +
          '&include_cross_event=true&list_sort_column=total&list_ascending=false&list_page_size=5&response_format=json',
        callback: {
          success: function (response) {
            if (!$.isEmptyObject(response.getCompaniesResponse)) {
              var topCompanies = luminateExtend.utils.ensureArray(response.getCompaniesResponse
                .company);

              $(topCompanies).each(function () {
                var companyName = this.companyName;
                var companyRaised = (parseInt(this.amountRaised) * 0.01);
                var companyRaisedFormmatted = companyRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
                var topCompanyHtml = '<div class="top-list-entry row pb-2"><div class="names-amounts col-10 pl-0"> <a class="participant-name" href="TR?company_id=' + this.companyId + '&fr_id=' + evID + '&pg=company">' + companyName + '</a> <span class="amount-raised">$' + companyRaisedFormmatted + '</span> </div></div>';
                $('.js__top-companies-list').append(topCompanyHtml);
              });
            }
          },
          error: function (response) {
            console.log('getTopCompanies error: ' + response.errorResponse.message);
          }
        }
      }); 
    } 


    if ($('body').is('.pg_entry')) {
      // Greeting Page

        // Launch thermometer
        var progress = $('#progress-amount').text();
        var goal = $('#goal-amount').text();
        cd.runThermometer(progress, goal);
            // Build roster on greeting page
            cd.getTopParticipants(evID);
            cd.getTopTeams(evID);
            cd.getTopCompanies(evID);
    }
    if ($('body').is('.pg_personal')) {
      // Personal Page
    }
    if ($('body').is('.pg_team')) {
      // Team Page
    }
    if ($('body').is('.pg_company')) {
      // Company Page
    }
    if ($('body').is('.pg_informational')) {
      // Custom TR Page
    }


  });
}(jQuery));
