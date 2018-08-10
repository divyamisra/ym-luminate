'use strict';
(function ($) {
  $(document).ready(function ($) {
    /*************/
    /* Namespace */
    /*************/
    window.cd = {};

    // BEGIN WRAPPER JS

    /***************/
    /* NAV SCRIPTS */
    /***************/
    $('.nav-toggle').on('click', function (e) {
      e.preventDefault();
    });
    if ($('body').is('.pg_cn_home') || $('body').is('.pg_entry')) {
      // Only apply sticky nav to landing and greeting pages
      // Sticky nav
      var stickyToggle = function (sticky, stickyWrapper, scrollElement) {
        var stickyHeight = sticky.outerHeight();
        // var stickyTop = stickyWrapper.offset().top;
        var stickyTop = stickyWrapper.offset().top + 300;
        if (scrollElement.scrollTop() >= stickyTop) {
          stickyWrapper.height(stickyHeight);
          sticky.addClass('is-sticky');
        } else {
          sticky.removeClass('is-sticky');
          stickyWrapper.height('auto');
        }
      };

      // Find all data-toggle="sticky-onscroll" elements
      $('[data-toggle="sticky-onscroll"]').each(function () {
        var sticky = $(this);
        var stickyWrapper = $('<div>').addClass('sticky-wrapper');
        sticky.before(stickyWrapper);
        sticky.addClass('sticky');

        // Scroll & resize events
        $(window).on('scroll.sticky-onscroll resize.sticky-onscroll', function () {
          stickyToggle(sticky, stickyWrapper, $(this));
        });

        // On page load
        stickyToggle(sticky, stickyWrapper, $(window));
      });

      // bind api survey
      luminateExtend.api.bind();
    }

    // Select all links with hashes
    var addScrollLinks = function () {
      $('a.scroll-link')
        .on('click', function (event) {
          // On-page links
          // Figure out element to scroll to
          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
          // Does a scroll target exist?
          if (target.length) {
            // Only prevent default if animation is actually gonna happen
            event.preventDefault();
            var scrollLocation = target.offset().top - 130;
            $('html, body').animate({
              scrollTop: scrollLocation
            }, 1000, function () {});
          }
        });
    }
    addScrollLinks();


    // END WRAPPER JS


    // BEGIN LANDING PAGES
    /******************/
    /* SEARCH SCRIPTS */
    /******************/
    var eventType = 'CycleNation';
    var eventType2 = $('body').data('event-type2') ? $('body').data('event-type2') : null;
    var regType = $('body').data('reg-type') ? $('body').data('reg-type') : null;
    var publicEventType = $('body').data('public-event-type') ? $('body').data('public-event-type') : null;
    var isCrossEvent = $('body').is('.pg_cn_home') ? true : false;

    var isProd = (luminateExtend.global.tablePrefix === 'heartdev' ? false : true);
    var eventName = luminateExtend.global.eventName;
    var srcCode = luminateExtend.global.srcCode;
    var subSrcCode = luminateExtend.global.subSrcCode;
    var evID = $('body').data('fr-id') ? $('body').data('fr-id') : null;
    var consID = $('body').data('cons-id') ? $('body').data('cons-id') : null;

    function getURLParameter(url, name) {
      return (RegExp(name + '=' + '(.+?)(&|$)').exec(url) || [, null])[1];
    }

    cd.getParticipants = function (firstName, lastName) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getParticipants' +
          '&first_name=' + ((firstName !== undefined) ? firstName : '') +
          '&last_name=' + ((lastName !== undefined) ? lastName : '') +
          (isCrossEvent === true ? '&event_type=' + eventType : '&fr_id=' + evID) +
          '&list_page_size=499' +
          '&list_page_offset=0' +
          '&response_format=json' +
          '&list_sort_column=first_name' +
          '&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getParticipantsResponse.totalNumberResults === '0') {
              // no search results
              $('#error-participant').removeAttr('hidden').text('Sorry. Your search did not return any results.');
            } else {
              var participants = luminateExtend.utils.ensureArray(response.getParticipantsResponse.participant);

              $(participants).each(function (i, participant) {

                var teamRegUrl = ((participant.teamPageUrl !== null) ? luminateExtend.global.path.secure + 'TRR/?fr_tjoin=' + getURLParameter(participant.teamPageUrl, 'team_id') + '&amp;pg=tfind&amp;fr_id=' + participant.eventId : null);

                $('#participant_rows').append('<div class="row pb-4"><div class="col-xs-12 col-md-9 col-sm-8 search-result-details search-result-details"><p><strong>' +
                  participant.name.first + ' ' + participant.name.last +
                  '</strong><br>' +
                  participant.eventName + '<br>' +
                  ((participant.teamName !== null && participant.teamName !== undefined) ? participant.teamName + '<br>' : '') +
                  '<a href="' + participant.personalPageUrl + '">Visit Personal Page</a></p></div><div class="col-xs-12 col-md-3 col-sm-4"><a class="button btn-primary btn-block btn-lg pull-right" href="' + participant.donationUrl + '">Donate</a>' + ((teamRegUrl !== null) ? '<a class="button btn-outline-dark btn-block btn-lg pull-right" href="' + teamRegUrl + ((participant.aTeamCaptain === 'true') ? '&s_captainConsId=' + participant.consId : '') + '&s_regType=joinTeam">Join Team</a>' : '') + '</div></div>'
                );
              });
              //add call to hook donate button with payment type selections
              addPaymentTypesOnSearch();
              $('#participant_results').removeAttr('hidden');
            }
          },
          error: function (response) {
            $('#error-participant').removeAttr('hidden').text(response.errorResponse.message);

          }
        }
      });
    };

    cd.getTeams = function (teamName) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamsByInfo' +
          '&team_name=' + teamName +
          (isCrossEvent === true ? '&event_type=' + eventType : '&fr_id=' + evID) +
          '&list_page_size=499' +
          '&list_page_offset=0' +
          '&response_format=json' +
          '&list_sort_column=name' +
          '&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getTeamSearchByInfoResponse.totalNumberResults === '0') {
              // no search results
              $('#error-team').removeAttr('hidden').text('Sorry. Your search did not return any results.');
            } else {
              var teams = luminateExtend.utils.ensureArray(response.getTeamSearchByInfoResponse.team);

              $(teams).each(function (i, team) {
                var donFormId = team.teamDonateURL;

                $('#team_rows').append(
                  '<div class="row pb-4"><div class="col-xs-12 col-sm-8 col-md-9 search-result-details"><p><strong>' +
                  team.name +
                  '</strong><br>' +
                  team.eventName + '<br>' +
                  'Team Captain: ' + team.captainFirstName + ' ' + team.captainLastName + '<br>' +
                  ((team.companyName !== null && team.companyName !== undefined) ? team.companyName + '<br>' : '') +
                  '<a href="' + team.teamPageURL + '">Visit Team Page</a></p></div><div class="col-xs-12 col-sm-4 col-md-3"><a class="button btn-primary btn-block btn-lg pull-right" href="' + team.teamDonateURL + '">Donate</a><a class="button btn-outline-dark btn-block btn-lg pull-right" href="' + team.joinTeamURL + '&s_captainConsId=' + team.captainConsId +'&s_regType=joinTeam">Join Team</a></div></div>');
                $('#team_results').removeAttr('hidden');

              });
              //add call to hook donate button with payment type selections
              addPaymentTypesOnSearch();
            }
          },
          error: function (response) {
            $('#error-team').removeAttr('hidden').text(response.errorResponse.message);

          }
        }
      });
    };

    cd.getCompanies = function (companyName) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getCompaniesByInfo' +
          '&company_name=' + companyName +
          (isCrossEvent === true ? '&event_type=' + eventType : '&fr_id=' + evID) +
          '&list_page_size=499' +
          '&list_page_offset=0' +
          '&include_cross_event=true' +
          '&response_format=json' +
          '&list_sort_column=company_name' +
          '&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getCompaniesResponse.totalNumberResults === '0') {
              // no search results
              $('#error-company').removeAttr('hidden').text('Sorry. Your search did not return any results.');
            } else {
              var companies = luminateExtend.utils.ensureArray(response.getCompaniesResponse.company);

              $(companies).each(function (i, company) {
                $('#company_rows').append(
                  '<div class="row pb-4"><div class="col-sm-12 col-sm-8"><p><strong>' +
                  company.companyName +
                  '</strong></p></div>' +
                  '<div class="col-sm-12 col-sm-4"><a class="button btn-primary btn-block btn-lg pull-right" href="' + company.companyURL + '">Visit Company Page</a></div></div>'
                );
                $('#company_results').removeAttr('hidden');
              });

            }
          },
          error: function (response) {
            $('#error-company').removeAttr('hidden').text(response.errorResponse.message);

          }
        }
      });
    };

    // Search by Participant
    $('.js__participant-search').on('submit', function (e) {
      e.preventDefault();
      $('.results-table, .alert').attr('hidden', true);
      $('.results-rows').html('');
      var firstName = $('#participant_first_name').val();
      var lastName = $('#participant_last_name').val();
      cd.getParticipants(firstName, lastName);
    });

    // Search by Team
    $('.js__team-search').on('submit', function (e) {
      e.preventDefault();
      $('.results-table, .alert').attr('hidden', true);
      $('.results-rows').html('');
      var teamName = $('#teamName').val();
      cd.getTeams(teamName);
    });
    // Search by Company
    $('.js__company-search').on('submit', function (e) {
      e.preventDefault();
      $('.results-table, .alert').attr('hidden', true);
      $('.results-rows').html('');
      var companyName = $('#company_name').val();
      cd.getCompanies(companyName);
    });


    /******************************/
    /* CROSS EVENT ROSTER SCRIPTS */
    /******************************/
    var eventData = [];
    var compiledEventsData = [];
    var compiledParticipantsData = [];
    var compiledTeamsData = [];
    var compiledCompaniesData = [];

    var eventRosterReady = false;
    var participantRosterReady = false;
    var teamRosterReady = false;
    var companyRosterReady = false;

    cd.sort = function (prop, arr) {
      prop = prop.split('.');
      var len = prop.length;

      arr.sort(function (a, b) {
        var i = 0;
        while (i < len) {
          a = a[prop[i]];
          b = b[prop[i]];
          i++;
        }
        if (a > b) {
          return -1;
        } else if (a < b) {
          return 1;
        } else {
          return 0;
        }
      });
      return arr;
    };
    String.prototype.trunc = function (n) {
      return this.substr(0, n - 1) + (this.length > n ? '&hellip;' : '');
    };

    Number.prototype.formatMoney = function (c, d, t) {
      var n = this,
        c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;
      return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d +
        Math.abs(n - i).toFixed(c).slice(2) : "");
    };

    cd.getEvents = function (eventName) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamraisersByInfo' +
          '&name=' + eventName +
          '&event_type=' + eventType +
          '&response_format=json&list_page_size=499&list_page_offset=0&list_sort_column=event_date&list_ascending=true',
        callback: {
          success: function (response) {
            if (response.getTeamraisersResponse.totalNumberResults > '0') {

              var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);

              events.map(function (event, i) {
                var eventId = event.id;
                var eventName = event.name;
                var eventDate = luminateExtend.utils.simpleDateFormat(event.event_date,
                  'EEEE, MMMM d, yyyy');
                var eventCity = event.city;
                var eventStateAbbr = event.state;
                var eventStateFull = event.mail_state;
                var eventLocation = event.location_name;
                var eventType = event.public_event_type_name;
                var greetingUrl = event.greeting_url;
                var registerUrl = 'TRR/?pg=utype&fr_id=' + eventId + '&s_regType=';
                var acceptsRegistration = event.accepting_registrations;

                var eventRow = '<li class="event-detail row mb-4 fadein"' + (i < 3 ? '' : 'hidden') + '><div class="col-md-6"><p><a class="js__event-name" href="' +
                  greetingUrl + '" class="d-block font-weight-bold"><span class="city">' +
                  eventCity + '</span>, <span class="fullstate">' +
                  eventStateFull + '</span></a><span class="state-abbr d-none">' +
                  eventStateAbbr + '</span><span class="eventtype d-block">' +
                  eventType + '</span><span class="event-location d-block">' +
                  eventLocation + '</span><span class="event-date d-block">' +
                  eventDate + '</span></p></div><div class="col-md-3 col-6"><a href="' +
                  greetingUrl +
                  '" class="button btn-outline-dark btn-block btn-lg js__event-details">Details</a></div><div class="col-md-3 col-6">' +
                  (acceptsRegistration === 'true' ? '<a href="' +
                    registerUrl + '" class="button btn-primary btn-block btn-lg js__event-register">Register</a>' : '<span class="d-block text-center">Registration is closed<br>but <a class="scroll-link" href="#fundraiserSearch">you can still donate</a></span>') +
                  '</div></li>';

                $('.js__event-search-results').append(eventRow);

                eventData.push({
                  'eventId': eventId,
                  'eventLocation': eventCity + ', ' + eventStateFull
                });
              });

              $('.js__event-details').on('click', function () {
                _gaq.push(['t2._trackEvent', 'program-homepage', 'click', 'search-event-details-button']);
              });

              $('.js__event-register').on('click', function () {
                _gaq.push(['t2._trackEvent', 'program-homepage', 'click', 'search-event-register-button']);
              });

              $('.js__event-name').on('click', function () {
                _gaq.push(['t2._trackEvent', 'program-homepage', 'click', 'search-event-details-link']);
              });

              addScrollLinks();

              // applyListFilter only on cn_home
              applyListFilter();

              cd.getTopParticipants(eventData);
              cd.getTopTeams(eventData);
              cd.getTopCompanies(eventData);
            }
          },
          error: function (response) {
            console.log('getEvents error: ' + response.errorResponse.message);
          }
        }
      });
    };


    $('.js__show-more-events').on('click', function (e) {
      e.preventDefault();
      $(this).attr('hidden', true);
      $('.event-detail').removeAttr('hidden');
      $('.js__show-fewer-events').removeAttr('hidden');
    });

    $('.js__show-fewer-events').on('click', function (e) {
      e.preventDefault();
      $(this).attr('hidden', true);
      $('.event-detail').each(function (i) {
        if (i > 2) {
          $(this).attr('hidden', true);
        }
      });
      $('.js__show-more-events').removeAttr('hidden');
    });


    // BEGIN TOP PARTICIPANTS
    cd.getTopParticipants = function (eventData) {
      var hybridParticipantData = [];
      var promises = eventData.map(function (eventData) {
        return new Promise(function (resolve, reject) {
          var eventId = eventData.eventId;
          var eventLocation = eventData.eventLocation;
          luminateExtend.api({
            api: 'teamraiser',
            data: 'method=getTopParticipantsData&event_type=' + eventType + '&fr_id=' + eventId +
              '&response_format=json',
            callback: {
              success: function (response) {
                if (!$.isEmptyObject(response.getTopParticipantsDataResponse)) {
                  var participantData = luminateExtend.utils.ensureArray(response.getTopParticipantsDataResponse
                    .teamraiserData);

                  participantData.map(function (obj) {
                    obj.eventId = eventId;
                    obj.eventLocation = eventLocation;
                    hybridParticipantData.push(obj);
                    return;
                  });
                }
                resolve();
              },
              error: function (response) {
                console.log('getTopParticipants error: ' + response.errorResponse.message);
                reject();
              }
            }
          }); // end luminateExtend
        }); // end inner promise
      }); // end map

      Promise.all(promises).then(function () {
        cd.compileParticipantData(hybridParticipantData);
      });
    } // end getTopParticipants

    cd.compileParticipantData = function (eventsParticipants) {
      for (var i = 0, len = eventsParticipants.length; i < len; i++) {
        var consName = eventsParticipants[i].name.trunc(25);
        var consTotal = Number(eventsParticipants[i].total.replace('$', '').replace(',', ''));
        var consId = eventsParticipants[i].id;
        var consEventId = eventsParticipants[i].eventId;
        var consEventLocation = eventsParticipants[i].eventLocation;

        compiledParticipantsData.push({
          "consName": consName,
          "consTotal": consTotal,
          "consId": consId,
          "consEventId": consEventId,
          "consEventLocation": consEventLocation
        });
      }
      cd.buildParticipantList();
    } // end compileParticipantData

    cd.buildParticipantList = function () {
      // Sort participants descending by amount raised and trim array to the top 5 participants
      var sortedParticipantsData = cd.sort('consTotal', compiledParticipantsData).slice(0, 5);

      for (var i = 0, len = sortedParticipantsData.length; i < len; i++) {
        if (sortedParticipantsData[i].consTotal > 0) {
          var participantData = '<tr><td><a href="' + luminateExtend.global.path.nonsecure + 'TR/?fr_id=' +
            sortedParticipantsData[i].consEventId + '&pg=personal&px=' + sortedParticipantsData[i].consId +
            '">' + sortedParticipantsData[i].consName + '</a>' +
            ((isCrossEvent) ? '<br>' + sortedParticipantsData[i].consEventLocation : '') + '</td><td><span class="pull-right">$' +
            sortedParticipantsData[i].consTotal.formatMoney(0) + '</span></td></tr>';
          $('.js__top-participants-list').append(participantData);
        } else {
          // TODO - display 'no results' message
        }
      }
      participantRosterReady = true;
    }

    // END TOP PARTICIPANTS

    // BEGIN TOP TEAMS
    cd.getTopTeams = function (eventData) {
      var hybridTeamData = [];
      var teamPromise = eventData.map(function (eventData) {
        return new Promise(function (resolve, reject) {
          var eventId = eventData.eventId;
          var eventLocation = eventData.eventLocation;

          luminateExtend.api({
            api: 'teamraiser',
            data: 'method=getTopTeamsData&event_type=' + eventType + '&fr_id=' + eventId +
              '&response_format=json',
            callback: {
              success: function (response) {
                if (!$.isEmptyObject(response.getTopTeamsDataResponse)) {
                  var rawTeamData = luminateExtend.utils.ensureArray(response.getTopTeamsDataResponse
                    .teamraiserData);

                  rawTeamData.map(function (obj) {
                    obj.eventId = eventId;
                    obj.eventLocation = eventLocation;
                    hybridTeamData.push(obj);
                    return;
                  })
                }
                resolve();
              },
              error: function (response) {
                console.log('getTopTeams error: ' + response.errorResponse.message);
                reject();
              }
            }
          }); // end luminateExtend
        }); // end inner promise
      }); // end map


      Promise.all(teamPromise).then(function () {
        cd.compileTeamData(hybridTeamData);
      });
    } // end getTopTeams

    cd.compileTeamData = function (eventsTeams) {
      for (var i = 0, len = eventsTeams.length; i < len; i++) {
        var teamName = eventsTeams[i].name.trunc(25);
        var teamTotal = Number(eventsTeams[i].total.replace('$', '').replace(',', ''));
        var teamId = eventsTeams[i].id;
        var teamEventId = eventsTeams[i].eventId;
        var teamEventLocation = eventsTeams[i].eventLocation;

        compiledTeamsData.push({
          "teamName": teamName,
          "teamTotal": teamTotal,
          "teamId": teamId,
          "teamEventId": teamEventId,
          "teamEventLocation": teamEventLocation
        });
      }
      cd.buildTeamList();
    } // end compileTeamData

    cd.buildTeamList = function () {
      // Sort teams descending by amount raised and trim array to the top 5 teams
      var sortedTeamsData = cd.sort('teamTotal', compiledTeamsData).slice(0, 5);

      for (var i = 0, len = sortedTeamsData.length; i < len; i++) {
        if (sortedTeamsData[i].teamTotal > 0) {
          var teamData = '<tr><td><a href="' + luminateExtend.global.path.nonsecure + 'TR/?pg=team&team_id=' +
            sortedTeamsData[i].teamId + '&fr_id=' + sortedTeamsData[i].teamEventId + '">' + sortedTeamsData[i]
            .teamName + '</a>' +
            ((isCrossEvent) ? '<br>' + sortedTeamsData[i].teamEventLocation : '') + '</td><td><span class="pull-right">$' + sortedTeamsData[i].teamTotal.formatMoney(0) +
            '</span></td></tr>';

          $('.js__top-teams-list').append(teamData);

        } else {
          // TODO - display 'no results' message
        }
      }
      teamRosterReady = true;
    }
    // END TOP TEAMS

    // BEGIN TOP COMPANIES
    cd.getTopCompanies = function (eventData) {
      var hybridCompanyData = [];
      var companyPromise = eventData.map(function (eventData) {
        return new Promise(function (resolve, reject) {
          var eventId = eventData.eventId;
          var eventLocation = eventData.eventLocation;

          luminateExtend.api({
            api: 'teamraiser',
            data: 'method=getCompaniesByInfo&fr_id=' + eventId +
              '&include_cross_event=true&response_format=json',
            callback: {
              success: function (response) {
                if (!$.isEmptyObject(response.getCompaniesResponse)) {
                  var rawCompanyData = luminateExtend.utils.ensureArray(response.getCompaniesResponse
                    .company);

                  rawCompanyData.map(function (obj) {
                    obj.eventId = eventId;
                    obj.eventLocation = eventLocation;
                    hybridCompanyData.push(obj);
                    return;
                  });
                }
                resolve();
              },
              error: function (response) {
                console.log('getTopCompanies error: ' + response.errorResponse.message);
                reject();
              }
            }
          }); // end luminateExtend
        }); // end inner promise
      }); // end map


      Promise.all(companyPromise).then(function () {
        cd.compileCompanyData(hybridCompanyData);
      });
    } // end getTopCompanies

    cd.compileCompanyData = function (eventsCompanies) {
      for (var i = 0, len = eventsCompanies.length; i < len; i++) {
        var companyName = eventsCompanies[i].companyName.trunc(25);
        var companyTotal = Number(eventsCompanies[i].amountRaised.replace('$', '').replace(',', ''));
        var companyEventLocation = eventsCompanies[i].eventLocation;
        var companyUrl = eventsCompanies[i].companyURL;

        compiledCompaniesData.push({
          "companyName": companyName,
          "companyTotal": companyTotal,
          "companyUrl": companyUrl,
          "companyEventLocation": companyEventLocation
        });

      }
      cd.buildCompanyList();
    } // end compileCompanyData

    cd.buildCompanyList = function () {
      // Sort teams descending by amount raised and trim array to the top 5 teams
      var sortedCompaniesData = cd.sort('companyTotal', compiledCompaniesData).slice(0, 5);
      for (var i = 0, len = sortedCompaniesData.length; i < len; i++) {
        if (sortedCompaniesData[i].companyTotal > 0) {
          var companyData = '<tr><td><a href="' + sortedCompaniesData[i].companyUrl + '">' + sortedCompaniesData[
              i].companyName + '</a>' +
            ((isCrossEvent) ? '<br>' + sortedCompaniesData[i].companyEventLocation : '') + '</td><td><span class="pull-right">$' + (sortedCompaniesData[i].companyTotal / 100).formatMoney(
              0) + '</span></td></tr>';

          $('.js__top-companies-list').append(companyData);

        } else {
          // TODO - display 'no results' message
        }
      }
      companyRosterReady = true;

    }

    // Call roster scripts based on page type
    if ($('body').is('.pg_cn_home')) {
      cd.getEvents('%25%25');
      $('.js__event-search-form').on('submit', function (e) {
        e.preventDefault();
      });

      var allEventDataUrl = '../cyclenation_data/CN_EventTotals.txt';

      $.getJSON(allEventDataUrl, function (data) {
        var totalRaised = data[0].TotalRevenue;
        var totalRaisedFormatted = '$' + totalRaised.toFixed(0).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");;
        var totalGoal = data[0].TotalGoal;
        // var dateCalculated = luminateExtend.utils.simpleDateFormat(data[0].CalculatedOn, 'h:mm a MMMM d, yyyy');
        var percentAchieved = Math.round((totalRaised / totalGoal) * 100);
        var percentAchievedFormatted = percentAchieved + '%';

        $('.js__greeting-thermo').val(percentAchieved);
        $('.js__all-event-raised').text(totalRaisedFormatted);
        $('.js__event-stats-percent').text(percentAchievedFormatted);

      });

    } else if ($('body').is('.pg_entry')) {
      eventData.push({
        eventId: evID
      });
      cd.getTopParticipants(eventData);
      cd.getTopTeams(eventData);
      cd.getTopCompanies(eventData);
    }

    // reset show more/fewer functionality after filters have been cleared
    function resetEventList() {
      $('.event-detail').each(function (i) {
        if (i > 2) {
          $(this).attr('hidden', true);
        }
        $('.js__show-fewer-events').attr('hidden', true);
        $('.js__show-more-events').removeAttr('hidden');
        $('.js__show-more-container').removeClass('d-none');
      });
    }

    function applyListFilter() {
      // add sorting for landing page
      var options = {
        valueNames: [
          'city',
          'fullstate',
          'eventtype',
          'event-location',
          'state-abbr'
        ]
      };
      var eventList = new List('eventSearch', options);
      var activeFilters = [];

      eventList.on('updated', function (list) {
        $('.js__show-more-container').addClass('d-none');
        $('.event-detail').removeAttr('hidden');

        if (list.matchingItems.length == 0) {
          $('.js__no-event-results').removeClass('d-none');
        } else if (list.matchingItems.length == list.items.length) {
          $('.js__no-event-results').addClass('d-none');
          // reset show more/fewer functionality after filters have been cleared
          resetEventList();
        } else {
          $('.js__no-event-results').addClass('d-none');
        }
      });

      $('.filter').on('change', function () {
        activeFilters = [];
        var allFilters = $('input.filter');
        $(allFilters).not(this).prop('checked', false);
        $(allFilters).parent().removeClass('active');

        var isChecked = this.checked;
        var value = $(this).data('filter');

        if (isChecked) {
          //  add to list of active filters
          $(this).parent().addClass('active');
          activeFilters.push(value);
        } else {
          // remove from active filters
          activeFilters.splice(activeFilters.indexOf(value), 1);
          resetEventList();
        }

        eventList.filter(function (item) {
          if (activeFilters.length > 0) {
            $('.js__show-more-container').addClass('d-none');
            $('.event-detail').removeAttr('hidden');
            $('.js__clear-event-filters').removeClass('d-none');
            return (activeFilters.indexOf(item.values().eventtype)) > -1;
          } else {
            $('.js__clear-event-filters').addClass('d-none');
            // reset show more/fewer functionality after filters have been cleared
            setTimeout(function () {
              resetEventList();
            }, 200);
          }
          return true;
        });
      });

      // clear filters on click
      $('.js__clear-event-filters').on('click', function (e) {
        e.preventDefault();
        activeFilters = [];
        $('.js__clear-event-filters').addClass('d-none');

        $('input.filter').prop('checked', false);
        $('.search').val('');
        eventList.search();

        eventList.filter(function (item) {
          if (activeFilters.length > 0) {
            return (activeFilters.indexOf(item.values().eventtype)) > -1;
          }
          return true;
        });
        // reset show more/fewer functionality after filters have been cleared
        resetEventList();

      });
    }

    // disable animated gears on click
    $('.js__animated-gears').on('click', function (e) {
      $(this).toggleClass('animated-gear');
    });

    var knowSurveyParsleyConfig = {
      errorsContainer: function (pEle) {
        var $err = pEle.$element.parent().parent().parent().parent().parent().find('.know-survey-error');
        return $err;
      }
    }

    $('.js__know-survey').parsley(knowSurveyParsleyConfig);

    // END LANDING PAGE ONLY

    /******************************************************************/
    /* Get Captain ID - auto select ptype time for those joining team */
    /******************************************************************/

    cd.getTeamCaptainId = function (evID, teamId, trPage) {
      luminateExtend.api({
        api: 'teamraiser',
        data: 'method=getTeamCaptains&response_format=json&fr_id=' + evID + '&team_id=' + teamId,
        callback: {
          success: function (response) {
            var captainArray = luminateExtend.utils.ensureArray(response.getTeamCaptainsResponse.captain);
            var captainConsId = captainArray[0].consId;

            if(trPage === 'personal'){
              var origJoinTeamUrl = $('#personal_page_join_team_button').attr('href');
              var modJoinTeamUrl = origJoinTeamUrl + '&s_regType=joinTeam&s_captainConsId=' + captainConsId + '&s_dev_branch=cd-cyclenation';
              $('#personal_page_join_team_button').attr('href', modJoinTeamUrl);
            }else if(trPage === 'team'){
              var origJoinTeamUrl = $('#join_team_button').attr('href');
              var modJoinTeamUrl = origJoinTeamUrl + '&s_regType=joinTeam&s_captainConsId=' + captainConsId + '&s_dev_branch=cd-cyclenation';
              $('#join_team_button').attr('href', modJoinTeamUrl);
            }
          },
          error: function (response) {

          }
        }
      });
    };

    /*****************************/
    /* Survey - Stay in the Know */
    /*****************************/

    if ($('.survey-form').length > 0) {
      $('.survey-form').parsley();

      $('.survey-form').on('submit', function () {
        $(this).hide();
        $(this).before('<div class="well survey-loading">' +
          'Loading ...' +
          '</div>');
      });
    }


    cd.submitKnowSurveyCallback = {
      error: function (data) {
        $('#survey-errors').remove();
        $('.survey-form .form-group .alert').remove();

        $('.know-survey-error').html('<div id="survey-errors"><div class="alert alert-danger" role="alert">' +
          data.errorResponse.message +
          '</div></div>');

        $('.survey-loading').remove();
        $('.survey-form').show();
      },
      success: function (data) {
        $('#survey-errors').remove();
        $('.survey-form .form-group .survey-alert-wrap').remove();

        if (data.submitSurveyResponse.success == 'false') {

          $('.know-survey-error').html('<div id="survey-errors"><div class="alert alert-danger" role="alert">There was an error with your submission. Please try again.</div></div>');

          var surveyErrors = luminateExtend.utils.ensureArray(data.submitSurveyResponse.errors);
          $.each(surveyErrors, function () {
            if (this.errorField) {
              $('input[name="' + this.errorField + '"]').closest('.form-group')
                .prepend('<div class="col-sm-12 survey-alert-wrap">' +
                  '<div class="alert alert-danger" role="alert">' +
                  this.errorMessage +
                  '</div>' +
                  '</div>');
            }
          });

          $('.survey-loading').remove();
          $('.survey-form').show();
        } else {
          $('.survey-loading').remove();
          $('.survey-form').before('<div class="alert alert-success" role="alert">' +
            'Thank you! We will keep you in the know!' +
            '</div>');
        }
      }
    };



    /****************/
    /* REGISTRATION */
    /****************/

    // interaction logic
    if ($('#user_type_page').length > 0 || $('#team_find_page').length > 0) {
      var trLoginSourceCode = (srcCode.length ? srcCode : 'trReg');
      var trSignupSourceCode = (srcCode.length ? srcCode : 'trReg');
      var trSocialSourceCode = (srcCode.length ? srcCode : 'trReg');

      var trLoginSubSourceCode = (subSrcCode.length ? subSrcCode : eventName + '_' + evID);
      var trSignupSubSourceCode = (subSrcCode.length ? subSrcCode : eventName + '_' + evID);
      var trSocialSubSourceCode = (subSrcCode.length ? subSrcCode : eventName + '_' + evID);

      var trRegInteractionID = (isProd === true ? '1031' : '1022');
      var trLoginInteractionID = (isProd === true ? '1030' : '1021');
      var trSocialInteractionID = (isProd === true ? '1032' : '1023');
      var trLoggedInInteractionID = (isProd === true ? '1040' : '1031');

      cd.logInteraction = function (intTypeId, intSubject, intCallback) {
        var logInteractionCallback = {
          success: function (response) {
            console.log('interaction logged');
          },
          error: function (response) {
            console.log('Error logging interaction');
          }
        };
        luminateExtend.api({
          api: 'cons',
          useHTTPS: true,
          requestType: 'POST',
          requiresAuth: true,
          data: 'method=logInteraction&interaction_subject=' + intSubject + '&interaction_type_id=' + intTypeId,
          callback: logInteractionCallback
        });
      };

      var getRegInteractionCallback = {
        success: function (data) {
          // console.log('getRegInteraction success: ' + JSON.stringify(data));
          var hasInteraction = data.getUserInteractionsResponse.interaction;
          if (!hasInteraction) {
            // Does not have trRegInteraction. Check to see if has trLoginInteraction
            getSocialInteraction();
          }
        },
        error: function (data) {
          console.log('getRegInteraction error: ' + JSON.stringify(data));
        }
      };

      var getSocialInteractionCallback = {
        success: function (data) {
          // console.log('getSocialInteraction success: ' + JSON.stringify(data));
          var hasInteraction = data.getUserInteractionsResponse.interaction;
          if (!hasInteraction) {
            // Does not have trRegInteraction OR trSocialInteraction. Assign a trLoggedInInteraction
            getLoginInteraction();
          }
        },
        error: function (data) {
          console.log('getSocialInteraction error: ' + JSON.stringify(data));
        }
      };

      var getLoginInteractionCallback = {
        success: function (data) {
          // console.log('getLoginInteraction success: ' + JSON.stringify(data));
          var hasInteraction = data.getUserInteractionsResponse.interaction;
          if (!hasInteraction) {
            // Does not have trRegInteraction OR trSocialInteraction OR trLoginInteraction. Assign a trLoggedInInteraction
            cd.logInteraction(trLoggedInInteractionID, evID);
          }
        },
        error: function (data) {
          console.log('getLoginInteraction error: ' + JSON.stringify(data));
        }
      };

      cd.getInteraction = function (intTypeId, intSubject, intCallback) {
        luminateExtend.api({
          api: 'cons',
          useHTTPS: true,
          requestType: 'POST',
          requiresAuth: true,
          data: 'method=getUserInteractions&interaction_subject=' + intSubject + '&interaction_type_id=' + intTypeId,
          callback: intCallback
        });
      };

      var getRegInteraction = function () {
        cd.getInteraction(trRegInteractionID, evID, getRegInteractionCallback);
      }

      var getSocialInteraction = function() {
        cd.getInteraction(trSocialInteractionID, evID, getSocialInteractionCallback);
      }

      var getLoginInteraction = function() {
        cd.getInteraction(trLoginInteractionID, evID, getLoginInteractionCallback);
      }

      if ($('#team_find_page').length > 0) {
        // check registrants interactions and assign trLoggedInInteraction if they do not have trRegInteraction OR trSocialInteraction OR trLoginInteraction
        getRegInteraction();
      }

    }

    if ($('#user_type_page').length > 0) {


      // UTYPE step



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
              window.location = window.location.href + '&s_regType=';
            },
            error: function (response) {
              console.log('signup error: ' + JSON.stringify(response));
              if (response.errorResponse.code === '11') {
                /* email already exists */
                cd.consRetrieveLogin(email, false);
                $('.js__signup-error-message').html('Oops! An account already exists with matching information. A password reset has been sent to ' + email + '.');
              } else if(response.errorResponse.code === '22'){ 
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
        $('.js__signup-form').parsley().reset();
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


      $('.janrainEngage').html('<div class="btn-social-login btn-facebook"><i class="fab fa-facebook-f mr-2"></i> Create with Facebook</div><div class="btn-social-login btn-amazon mt-3"><i class="fab fa-amazon mr-2"></i> Create with Amazon</div>');

    }

    // BEGIN TFIND

    if ($('#team_find_page').length > 0) {
      // BEGIN tfind customizations
      $('form[name=FriendraiserFind]').attr('hidden', true);

      if (regType === 'startTeam') {
        if (eventType2 === 'Road' || eventType2 === 'StationaryV2' ) {
          $('form[name=FriendraiserFind]').removeAttr('hidden');
        }
      } else if (regType === 'joinTeam') {
        if ($('#team_find_existing').length > 0) {
          // On JOIN TEAM step - rename label
          $('#team_label_container').text('Team name:');
          $('form[name=FriendraiserFind]').removeAttr('hidden');

          // append cons ID to the join team button
          if($('#team_find_search_results_container').length > 0) {
            
            var teamRows = $('.list-component-row');
            $.each( teamRows, function(i, teamRow) {
              var captainConsId, origJoinTeamUrl, modJoinTeamUrl;
              var self = $(this);
              var origTeamNameUrl = $(this).find('.list-component-cell-column-team-name a').attr('href');
              var teamId = getURLParameter(origTeamNameUrl, 'team_id');
              
              luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getTeamCaptains&response_format=json&fr_id=' + evID + '&team_id=' + teamId,
                callback: {
                  success: function success(response) {
                    var captainArray = luminateExtend.utils.ensureArray(response.getTeamCaptainsResponse.captain);
                    captainConsId = captainArray[0].consId;
                    origJoinTeamUrl = $(self).find('.list-component-cell-column-join-link a').attr('href');
                    modJoinTeamUrl = origJoinTeamUrl + '&s_captainConsId=' + captainConsId;
                    $(self).find('.list-component-cell-column-join-link a').attr('href', modJoinTeamUrl);
                  },
                  error: function error(response) {}
                }
              });
            });
          }
        }
      }


      // rebuild LO's create team form
      var goalPerBike = 1000;
      var defaultNumBikeText = 'Number of Bikes';
      var numBikeSelector = $('.js__numbike-selector');
      var dynTeamGoal = $('.js__generated-team-goal');
      var currentTeamGoal, currentTeamGoalFormatted, minTeamGoalMsg;
      var loTeamGoal = $('#fr_team_goal');
      var promoCode =  ($('body').data('promocode')!==undefined ? $('body').data('promocode') : "");
     
      // tfind

      // begin StationaryV2 event conditional
      if (eventType2 === 'StationaryV2' ) {
        var loDefaultGoal = $('#fr_team_goal').val();
        if(loDefaultGoal){
          goalPerBike =  Number(loDefaultGoal.replace(/[^0-9\.-]+/g,""));
        }
        
      // check to see if Start a Team and Breakaway ptypes are available

      // if Start a Team and Breakaway ptypes are not available, remove those registration options and display a sponsor code field on the reg options step



        cd.getParticipationTypes = function (promo) {
          $('.js__reg-type-container .alert').addClass('hidden');
          var isStartTeamAvailable = false;
          var isBreakawayAvailable = false;
          var validPromo = false;
          var promoCodePtypesAvailable = false;

          luminateExtend.api({
            api: 'teamraiser',
            data: 'method=getParticipationTypes' +
            '&fr_id=' + evID +
            ((promo !== undefined) ? '&promotion_code=' + promo : '') +
            '&response_format=json',
            callback: {
              success: function (response) {

                if (response.getParticipationTypesResponse.participationType.length) {
                  // no search results
                  var participationTypes = luminateExtend.utils.ensureArray(response.getParticipationTypesResponse.participationType);
                  // var promoPtypeLoaded = false;
                  $(participationTypes).each(function (i, ptype) {
                      // There is no promo code in session 
                      if(ptype.participationTypeRegistrationLimit && ptype.participationTypeRegistrationLimit.limitReached === 'false'){
                        // Publicly available ptypes are available
                        // ptype has a limit and it has NOT been reached
                        if(ptype.name.indexOf('Start a Team') > -1){
                          if(ptype.participationTypeRegistrationLimit.limitReached === 'false'){
                            isStartTeamAvailable = true;
                          }
                        } else if(ptype.name.indexOf('Breakaway') > -1){
                          if(ptype.participationTypeRegistrationLimit.limitReached === 'false'){
                            isBreakawayAvailable = true;
                          }
                        }
                      } 

                      // if(promo){
                      // promo is loaded 
                      if(promo && ptype.promoCodeRequired === "true"){
                        console.log('promo code only ptype available');
                        // promo code is valid
                        
                          if(ptype.name.indexOf('Start a Team') > -1){
                            if(ptype.participationTypeRegistrationLimit.limitReached === 'false'){
                              isStartTeamAvailable = true;
                              // Promo code ptypes are available
                              promoCodePtypesAvailable = true;
                            }
                          } else if(ptype.name.indexOf('Breakaway') > -1){
                            if(ptype.participationTypeRegistrationLimit.limitReached === 'false'){
                              isBreakawayAvailable = true;
                              // Promo code ptypes are available
                              promoCodePtypesAvailable = true;
                            }
                          }
                        validPromo = true;

                        // } 
                      } else {
                        // promo code is inavlid
                        console.log('set promo to validPromo');
                        if(validPromo === true){
                          return false;
                        } else {
                          validPromo = false;
                        }
                      }
                    // }

                  });


                  if(isStartTeamAvailable === true){
                    $('.start-team-container').show();
                  } else {
                    $('.js__reg-options-promo-container, .js__promo-code-sold-out').removeClass('hidden');
                  }
                  if(isBreakawayAvailable === true){
                    $('.breakaway-container').show();
                  } 

                  if(promoCodePtypesAvailable){
                    console.log('promoCode ptypes are available and loaded');
                    // add promo code to reg options links in case they are entering it for the first time on this step
                    var regOptionLinks = $('.js__reg-type-form .step-button');

                    $(regOptionLinks).each(function(){
                      var origUrl = $(this).attr('href');
                      var modUrl = origUrl + '&s_promoCode=' + promo;
                      $(this).attr('href', modUrl);
                    });
                    if(!promoCode){
                      // show a custom message if a promo code is not already in session and someone manually enters a promo code and we DO retrieve an available ptype
                      $('.js__promo-code-success').removeClass('hidden');
                      $('html, body').animate({ scrollTop: 0 }, "slow");
                    }
                    $('.js__reg-options-promo-container').addClass('hidden');
                  // } else if(promo && promoCodePtypesAvailable === false && validPromo === false){
                  } else if(promo && promoCodePtypesAvailable === false && validPromo === true){

                    console.log('promoCode in session but NO promoCode ptypes are available for registration');
                    // show a custom message if someone manually enters a promo code and we DO NOT retrieve an available ptype
                    $('.js__promo-code-sold-out').addClass('hidden');
                    $('.js__promo-code-error, .js__reg-options-promo-container').removeClass('hidden');
                  } else if(promo && validPromo === false){
                    console.log('invalid promoss');
                    $('.js__promo-code-sold-out').addClass('hidden');
                    $('.js__promo-code-invalid, .js__reg-options-promo-container').removeClass('hidden');
                  }

                  $('.join-team-container').show();
                } 
              },
              error: function (response) {
                console.log(response.errorResponse.message);
              }
            }
          });
        };

        if(promoCode){
          cd.getParticipationTypes(promoCode);
        } else {
          cd.getParticipationTypes();
        }

        // manage manual submission of promo codes on reg options step
        $('.js__reg-options-promo-form').on('submit', function(e){
          e.preventDefault();
          var manualPromoCode = $('#sponsorCode').val();
          cd.getParticipationTypes(manualPromoCode);
        });

      } // end StationaryV2 event conditional

      // only show the VIP code field if a promo code is not already in session
      if(!promoCode){
        $('#team_find_new_company_selection_container').append('<div id="team_sponsor_code" class="input-container"><div class="form-group"><label for="sponsorCode">Do you have a VIP Code?</label><input name="s_promoCode"type="text"id="sponsorCode"class="form-control" value=""></div></div>');
      }

      var numTeamResults = $('#team_find_search_results_container .list-component-row').length;

      if (numTeamResults < 20) {
        $('.list-component-paginator').hide();
      }

      $('#friend_potion_next')
        .wrap('<div class="order-1 order-sm-2 col-sm-4 offset-md-6 col-md-3 col-8 offset-2 mb-3"/>');

      $('#team_find_section_footer')
        .prepend('<div class="order-2 order-sm-1 col-sm-4 col-md-3 col-8 offset-2 offset-sm-0"><a href="TRR/?pg=tfind&amp;fr_id=' + evID + '&amp;s_regType=" class="button btn-secondary btn-block">Back</a></div>')

      // Add minimum validation to LOs team goal input
      $(loTeamGoal)
        .val(goalPerBike)
        .addClass('pl-0 border-left-0')
        .wrap('<div class="input-group" />')
        .before('<div class="input-group-prepend"><div class="input-group-text input-group-text pr-0 border-right-0 bg-white">$</div></div>')
        .attr({
          "min": goalPerBike,
          "step": "100",
          "aria-label": "Goal amount (to the nearest dollar)",
          "data-parsley-validation-threshold": "1",
          "data-parsley-trigger": "keyup",
          "data-parsley-type": "number",
          "data-parsley-min-message": minTeamGoalMsg
        });
      $('#team_find_new_fundraising_goal_input_hint').before('<div class="team-goal-error"></div>');

      $('.js__show-team-bikes').on('click', function (e) {
        e.preventDefault();
        // display team captain page where bike numbers are calculated
        $('.js__reg-type-container').addClass('d-none');
        $('.js__team-bikes-container').removeClass('d-none');
      });

      $('.js__show-reg-type').on('click', function (e) {
        e.preventDefault();
        $('.js__team-bikes-container').addClass('d-none');
        $('.js__reg-type-container').removeClass('d-none');
      });


      var teamFindParsleyConfig = {
        errorsContainer: function (pEle) {
          var $err = pEle.$element.parent().parent().find('.team-goal-error');
          return $err;
        }
      }

      $('.js__show-team-details').on('click', function (e) {
        e.preventDefault();
        $('#fr_team_goal')
          .attr({
            "data-parsley-min-message": minTeamGoalMsg
          });
        $('.js__team-bikes-container').attr('hidden', true);
        $('form[name=FriendraiserFind]').removeAttr('hidden');
        cd.calculateRegProgress();

        // add parsley validation to the form AFTER all of the elements have been moved around/created. Since minimum team goal is being set by the bikes step, we really shouldn't validate this until we update that min attribute and the user clicks 'next'
        if (eventType2 === 'Stationary') {
          $('#team_find_page > form').parsley(teamFindParsleyConfig);
        }
      });

      // if team name submission fails, show system default error messages instead of going back to the bike number selector
      if ($('.ErrorMessage').length > 0) {
        $('.js__team-bikes-container').attr('hidden', true);
        $('form[name=FriendraiserFind]').removeAttr('hidden');
      }

      if (eventType2 === 'Road' || eventType2 === 'StationaryV2') {
        $('#team_find_page > form').parsley(teamFindParsleyConfig);
      }

      // append session variable setting hidden input to track number of bikes selected so same value can be automatically selected in reg info step
      $('form[name="FriendraiserFind"]').prepend('<input type="hidden" class="js__numbikes" name="s_numBikes" value="">');

      $('.dropdown-item').on('click', function (e) {
        e.preventDefault();
        var bikesSelected = $(this).data('numbikes');
        var bikesSelectedText = $(this).html();
        currentTeamGoal = bikesSelected * goalPerBike;
        currentTeamGoalFormatted = '$' + currentTeamGoal.formatMoney(0);
        minTeamGoalMsg = 'Your goal must be at least ' + currentTeamGoalFormatted;
        $(numBikeSelector).html(bikesSelectedText);
        $(dynTeamGoal).val(currentTeamGoalFormatted);
        $('.js__numbikes').val(bikesSelected);
        $('#fr_team_goal').val(currentTeamGoal);
        $('.js__show-team-details').prop('disabled', false);
      });

      if (eventType2 === 'StationaryV2') {
        $('#team_find_new_fundraising_goal_input_hint').text('You can increase your team\'s goal, but the amount shown above is your team\'s required fundraising minimum.');
      } else {
        $('#team_find_new_fundraising_goal_input_hint').text('You can increase your team\'s goal, but the amount shown above is your required fundraising minimum based off of the number of reserved bikes you selected.');
      }
      $('#previous_step span').text('Back');

    }

    // BEGIN PTYPE CUSTOMIZATIONS
    if ($('#F2fRegPartType').length > 0) {
        // add reg full class to ptype container
        var ptypeBlocks = $('.part-type-decoration-messages');

        $(ptypeBlocks).each(function(){
          if($(this).hasClass('part-type-full')){
            $(this).parent().removeClass('selected').addClass('ptype-full').find('input[type=radio]').remove();
            var disabledLabel = $(this).find('label');
            $(disabledLabel).replaceWith('<div>' + $(disabledLabel).html() + '</div>');
          }
          if (eventType2 === 'StationaryV2' ) {
            var ptypeName = $(this).find('.part-type-name').text();

            // Hide and disable participation types that don't apply to this particular registration path
            $(this).parent().find('input[type=radio]').attr('aria-hidden', 'true').prop('checked', false).prop('disabled', true);
            
            if(ptypeName.indexOf('VIP') > -1) {
              $(this).closest('.part-type-container').addClass('vip-ptype-container');
            } else if(ptypeName.indexOf('Breakaway') > -1) {
              $(this).closest('.part-type-container').addClass('breakaway-ptype-container');
            } else if (ptypeName.indexOf('Start a Team') > -1){
              $(this).closest('.part-type-container').addClass('start-team-ptype-container');
            } else if (ptypeName.indexOf('Join a Team') > -1){
              $(this).closest('.part-type-container').addClass('join-team-ptype-container');
              var coachPtype = $('.captain-ptype').text();

              // NOTE - participation type names and times must always be split by " - "
              if(coachPtype){
                var coachTime = coachPtype.split('-')[1];
                console.log(coachTime);
                if(ptypeName.indexOf(coachTime) > -1) {
                // add special class to the join team ptype that matches the coach's ptype time
                $(this).closest('.part-type-container').addClass('join-team-ptype-time');
                }
              }
            }
          }
        });

      // begin StationaryV2 event conditional
      if (eventType2 === 'StationaryV2' ) {
        if (regType === 'joinTeam') {
          $('#sel_type_container').text('What time will you ride?');
          if($('.join-team-ptype-container').hasClass('join-team-ptype-time')){
            // ensure the relevant ptypes are visiable and accessible from keyboard navigation
            $('.join-team-ptype-time').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
            // only display the ptype that matches the coach's ptype
            $('.join-team-ptype-time').show();
          } else {
            // ensure the relevant ptypes are visiable and accessible from keyboard navigation
            $('.join-team-ptype-container').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
            // show all join team ptypes as coach's ptype time was not found
            $('.join-team-ptype-container').show();
          }
        } else if(regType === 'startTeam'){
          if($('.vip-ptype-container').length){
            // ensure the relevant ptypes are visiable and accessible from keyboard navigation
            $('.vip-ptype-container').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
            // if promo code based ptype is available on page, only show that ptype option
            $('.vip-ptype-container').show();
          } else {
            // ensure the relevant ptypes are visiable and accessible from keyboard navigation
            $('.start-team-ptype-container').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
            // otherwise, show publicly available ptypes that match selected reg option
            $('.start-team-ptype-container').show();
          }
        } else if(regType === 'individual'){
          if($('.vip-ptype-container').length){
            // ensure the relevant ptypes are visiable and accessible from keyboard navigation
            $('.vip-ptype-container').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
            // if promo code based ptype is available on page, only show that ptype option
            $('.vip-ptype-container').show();
          } else {
            // ensure the relevant ptypes are visiable and accessible from keyboard navigation
            $('.breakaway-ptype-container').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
            // otherwise, show publicly available ptypes that match selected reg option
            $('.breakaway-ptype-container').show();
          }
        } else {
          // ensure the relevant ptypes are visiable and accessible from keyboard navigation
          $('.part-type-container').find('input[name=fr_part_radio]').attr('aria-hidden', 'false').prop('disabled', false).eq(0).prop('checked', true);
          // show all participation types in the case that a session variable has not been set for regType
          $('.part-type-container').show();
        }

      }

      if (eventType2 === 'Stationary' || eventType2 === 'StationaryV2') {
        $('#sel_type_container').text('What time will you ride?');
        // $('.part-type-container.selected input').prop('checked', false).removeClass('selected');
        $('.part-type-container').on('click focus', function (e) {
            $('.part-type-container').removeClass('selected');
            $(this).addClass('selected');
            $(this).find('input[type="radio"]').prop('checked', true);
        });

        // add accessibility events for keyboard navigation
        $('input[name=fr_part_radio]').on('click focus', function (e) {
          $('.part-type-container').removeClass('selected');
          $(this).closest('.part-type-container').addClass('selected');
        });

      } else {
        if (regType === 'virtual') {
          $('.part-type-name:contains("Virtual")').closest('.part-type-container').show();
        }
        $('.part-type-container.selected input').prop('checked', false).removeClass('selected');

        $('.part-type-container.selected').removeClass('selected');

        $('#next_step').addClass('disabled');

        $('#next_step').on('click', function () {
          if (!$('.part-type-container input').is(':checked')) {
            $('.js__ptype-errors').remove();
            $('#sel_type_container').after('<div class="js__ptype-errors"><div class="alert alert-danger" role="alert">Please select a participation type and agree to the Self-Pledge.</div></div>')
            $('html, body').animate({
              scrollTop: $("#part_type_selection_container").offset().top
            }, 1000);

            return false;
          }
        });

        $('.part-type-container').on('click', function (e) {
            $('.part-type-container').removeClass('selected');
            $(this).addClass('selected');
            $(this).find('input[type="radio"]').prop('checked', true);
            $('#next_step').removeClass('disabled');
            $('#dspPledge').modal({backdrop: 'static', keyboard: false}).modal('show');
        });
        // remove on click event if has class .ptype-full
        $('.ptype-full').off();

      }



      $('#fund_goal_container').prepend('<span class="field-required"></span>&nbsp;');
      $('#part_type_additional_gift_section_header').prepend('<div class="bold-label">Make a Donation</div>');

      $('.donation-level-amount-text').closest('.donation-level-row-container').addClass('don-level-btn');
      $('.donation-level-container .input-container').parent().addClass('other-amount-row-container');

      $('.other-amount-row-container .donation-level-row-label').text('Or enter your own amount:').attr('id', 'enterAmtLabel');

      $('.donation-level-row-label-no-gift').text("I don\'t want to make a donation towards my goal at this time").closest('.donation-level-row-container').addClass('don-no-gift');
      $('.don-no-gift, #part_type_anonymous_input_container, #part_type_show_public_input_container').wrap('<div class="form-check"/>');

      $('label[for="fr_anonymous_gift"]').text('You can show my donation amount on this website');
      $('label[for="fr_show_public_gift"]').text('I would like to make this donation private and not show my name on this website');

      // modify button behavior at bottom
      $('#next_step').wrap('<div class="order-1 order-sm-2 col-sm-4 offset-md-4 col-8 offset-2 mb-3"></div>');

      $('.donation-level-row-label').on('click', function (e) {
        $('.donation-level-row-label').removeClass('active');
        $('.other-amount-row-container input[type="text"]').val('');
        $(this).addClass('active');
      });
      // add label to other amount text input
      $('.other-amount-row-container input[type=text]').addClass('other-amount').attr('aria-labelledby', 'enterAmtLabel');

      $('.other-amount')
        .prop('onclick',null).off('click')
        .prop('onkeyup',null).off('keyup')
        .prop('onchange',null).off('change')
        .prop('onfocus',null).off('focus');

        $('.other-amount').on('keyup', function(e){
          if($(this).val() > 0){
            $('.donation-level-row-label').removeClass('active');
            $(this).parent().find('input[type="radio"]').prop('checked', true);
          } else {
            $(this).parent().find('input[type="radio"]').prop('checked', false);
          }
        });

      $('.other-amount-row-container input[type="radio"]').on('click, focus', function (e) {
        $('.donation-level-row-label').removeClass('active');
        $(this).closest('input[type=radio]').prop('checked', true);
      });

      $('.don-no-gift').on('click', function (e) {
        $('.donation-level-row-label').removeClass('active');
      });

      $('.donation-level-row-label-no-gift').on('click', function (e) {
        $('.donation-level-row-label').removeClass('active');
        $('.other-amount-row-container input[type="text"]').val('');
      });
      $('.don-level-btn').each(function () {
        var donRadio = $(this).find('input[type="radio"]');
        var donLabel = $(this).find('.donation-level-row-label');

        $(donLabel).append($(donRadio));
      });

      if (regType === 'virtual' || regType === 'individual') {
        $('#part_type_section_footer').append('<div class="order-2 order-sm-1 col-sm-4 col-8 offset-2 offset-sm-0"><a href="TRR/?pg=tfind&amp;fr_id=' + evID + '&amp;s_regType=" class="button btn-secondary btn-block">Back</a></div>');
      } else {
        $('#previous_step').replaceWith('<div class="order-2 order-sm-1 col-sm-4 col-8 offset-2 offset-sm-0"><a href="TRR/?pg=tfind&amp;fr_id=' + evID + '&amp;s_regType=" class="button btn-secondary btn-block">Back</a></div>');
      }

    }

    // BEGIN REG INFO CUSTOMIZATIONS
    if ($('#F2fRegContact').length > 0) {

      $('.input-label.cons_city_town').text('City:');
      $('.input-label.cons_state').text('State:');

      $('.input-label:contains("Mobile")').closest('.survey-question-container').addClass('mobile-question-container');

      $('.cons_dob').text('Birthday:');
      $('.mobile-question-container').after($('#cons_info_dob'));

      cd.setBirthMonth = function () {
        var birthDay = $('#cons_birth_date_DAY').val();
        var birthMonth = $('#cons_birth_date_MONTH').val();
        var birthYear = $('#cons_birth_date_YEAR').val();
        if (birthDay !== '0' && birthMonth !== '0') {
          $('#cons_birth_date_YEAR').val('1901');
        } else {
          $('#cons_birth_date_YEAR').val('0');
        }
      }
      cd.setBirthMonth();

      $('#cons_birth_date_DAY, #cons_birth_date_MONTH').on('change', function (e) {
        cd.setBirthMonth();
      });

      $('#cons_birth_date_DAY').before('<label class="sr-only" for="cons_birth_date_DAY">Birth Day</label>');
      $('#cons_birth_date_MONTH').before('<label class="sr-only" for="cons_birth_date_MONTH">Birth Month</label>');
      $('#cons_birth_date_YEAR').before('<label class="sr-only" for="cons_birth_date_YEAR">Birth Year</label>');


      $('#cons_info_dob .form-content').append('<p class="small">If you would like to provide your birthday, we would love to acknowledge your special day each year.</p>');

      $('.mobile-question-container .form-content').append('<p class="small">We require your cell/mobile phone number in case last minute or emergency situations happen with the event and we need to communicate important details to you. We respect your privacy and will not sell or divulge your cell phone number to third parties, without your consent.</p>');

      if (eventType2 === 'Stationary') {
        // autoselect number of bikes based on tfind responses and/or ptype
        var bikeQuestion = $('.input-label:contains("How many bikes")');
        $(bikeQuestion).closest('.survey-question-container').attr('hidden', true);
        if (regType === 'individual') {
          $(bikeQuestion).closest('.input-container').find('select').val('1');
        } else if (regType === 'startTeam') {
          var numBikesSelected = $('body').data('numbikes');
          $(bikeQuestion).closest('.input-container').find('select').val(numBikesSelected);
        } else if (regType === 'joinTeam') {
          $(bikeQuestion).closest('.input-container').find('select').val('0');
        }
      }

      $('.input-container label:contains("terms and conditions")').html('I accept and acknowledge that I have read and understand these <a href="#" class="js__terms-conditions">terms and conditions</a> and agree to them voluntarily.')


      $('.js__terms-conditions').on('click', function (e) {
        e.preventDefault();
        $('#termsModal').modal();
      });
      // disable next step button unless terms have been checked
      $('#next_step')
        .attr('disabled', true)
        .wrap('<div class="order-1 order-sm-2 col-sm-4 offset-md-4 col-8 offset-2 mb-3"/>');
      $('#previous_step').text('Back')
        .wrap('<div class="order-2 order-sm-1 col-sm-4 col-8 offset-2 offset-sm-0" />');

      var waiverCheckbox = $('.input-container label:contains("terms and conditions")').prev('input[type=checkbox]');

      $(waiverCheckbox).on('click', function (e) {
        if ($(this).is(':checked')) {
          $('#next_step').attr('disabled', false);
        } else {
          $('#next_step').attr('disabled', true);
        }
      });
      if ($(waiverCheckbox).is(':checked') === true) {
        $('#next_step').attr('disabled', false);
      }

    }

    if ($('#FriendraiserUserWaiver').length > 0) {
      // reg summary step
      $('.reg-summary-reg-info').prepend('<p>Click the <strong>"Complete Registration"</strong> button below to finish your registration.</p><p>Click on <strong>"Edit"</strong> below to revise your registration details</p>');

      $('.additional-gift-label').text('Personal Donation:');
      $('.total-label').text('Your registration total:');

    }
    // payment step of reg
    if ($('#fr_payment_form').length > 0) {



      $('#btn_next').text('Submit')
        .wrap('<div class="order-1 order-sm-2 col-sm-6 offset-md-2 col-8 offset-2 mb-3"/>');
      $('#btn_prev').text('Back')
        .wrap('<div class="order-2 order-sm-1 col-sm-4 col-8 offset-2 offset-sm-0" />');

    }


    if ($('body').is('.app_id_27')) {
      // BEGIN THERMO LOGIC
      cd.updateRegProgress = function (stepsComplete, stepsPossible) {
        var percentComplete = Math.round((stepsComplete / stepsPossible) * 100);
        $('.js__reg-progress')
          .attr('aria-valuenow', percentComplete)
          .css('width', percentComplete + '%')
          .text(percentComplete + '%');
      }

      cd.calculateRegProgress = function () {
        var requiresPayment;
        if ($('.progress-bar-step-text-container:contains("Make Payment")').length) {
          requiresPayment = true;
        } else {
          requiresPayment = false;
        }

        // Utype Step
        if ($('#user_type_page').length > 0) {
          // assuming max number of steps at beginning. As decisions are made in registration, will remove steps if necessary, i.e. if they do NOT create a team or have a payment step
          if (eventType2 === 'Stationary') {
            cd.updateRegProgress(1, 9);
          } else {
            cd.updateRegProgress(1, 8);
          }
        }
        // Tfind Step
        if ($('#team_find_page').length > 0) {
          if (eventType2 === 'Stationary') {
            // stationary logic
            if (regType === 'startTeam') {
              // regtype selection has not been made yet
              if ($('.js__numbikes').val() > 0) {
                // On "Team Details" step
                cd.updateRegProgress(4, 9);
              } else {
                // On "Hello Team Captain" step
                cd.updateRegProgress(3, 9);
              }
            } else if (regType === 'joinTeam') {
              cd.updateRegProgress(4, 9);
            } else if (regType === 'individual' || regType === 'virtual') {
              // if individual or virtual has been selected, they will no longer be on the tfind page
            } else {
              // On "I want to" step. regType selection has not been made yet
              cd.updateRegProgress(2, 9);
            }
          } else {
            // road logic
            if (regType === 'startTeam') {
              // On "Team Details" step
              cd.updateRegProgress(3, 8);
            } else if (regType === 'joinTeam') {
              cd.updateRegProgress(3, 8);
            } else if (regType === 'individual' || regType === 'virtual') {
              // if individual or virtual has been selected, they will no longer be on the tfind page
            } else {
              // On "I want to" step. regType selection has not been made yet
              cd.updateRegProgress(2, 8);
            }
          }
        }

        // Ptype Step
        if ($('#F2fRegPartType').length > 0) {

          if (eventType2 === 'Stationary') {
            // stationary logic
            if (regType === 'startTeam') {
              cd.updateRegProgress(5, 9);
            } else if (regType === 'joinTeam') {
              cd.updateRegProgress(4, 8);
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(3, 7);
            }
          } else {
            // road logic
            if (regType === 'startTeam' || regType === 'joinTeam') {
              cd.updateRegProgress(4, 8);
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(3, 7);
            }
          }
        }

        // Reg Info Step
        if ($('#F2fRegContact').length > 0) {
          if (eventType2 === 'Stationary') {
            // stationary logic
            if (regType === 'startTeam') {
              cd.updateRegProgress(6, (requiresPayment === true ? 9 : 8));
            } else if (regType === 'joinTeam') {
              cd.updateRegProgress(5, (requiresPayment === true ? 8 : 7));
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(4, (requiresPayment === true ? 7 : 6));
            }
          } else {
            // road logic
            if (regType === 'startTeam' || regType === 'joinTeam') {
              cd.updateRegProgress(5, (requiresPayment === true ? 8 : 7));
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(4, (requiresPayment === true ? 7 : 6));
            }
          }

        }

        // Review Step
        if ($('#FriendraiserUserWaiver').length > 0) {
          if (eventType2 === 'Stationary') {
            // stationary logic
            if (regType === 'startTeam') {
              cd.updateRegProgress(7, (requiresPayment === true ? 9 : 8));
            } else if (regType === 'joinTeam') {
              cd.updateRegProgress(6, (requiresPayment === true ? 8 : 7));
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(5, (requiresPayment === true ? 7 : 6));
            }
          } else {
            // road logic
            if (regType === 'startTeam' || regType === 'joinTeam') {
              cd.updateRegProgress(6, (requiresPayment === true ? 8 : 7));
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(5, (requiresPayment === true ? 7 : 6));
            }
          }
        }

        // Payment Step
        if ($('#fr_payment_form').length > 0) {
          if (eventType2 === 'Stationary') {
            // stationary logic
            if (regType === 'startTeam') {
              cd.updateRegProgress(8, 9);
            } else if (regType === 'joinTeam') {
              cd.updateRegProgress(7, 8);
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(6, 7);
            }
          } else {
            // road logic
            if (regType === 'startTeam' || regType === 'joinTeam') {
              cd.updateRegProgress(7, 8);
            } else if (regType === 'individual' || regType === 'virtual') {
              cd.updateRegProgress(6, 7);
            }
          }
        }
      }

      cd.calculateRegProgress();
    }

    $('#part_type_selection_container .manageable-content, #fund_goal_container').prepend('<span class="aural-only">Field Is Required</span>');

    // Add 2017 Marathon Accessibility Updates

    // Issue #92 make edit link more clear -->
    $('.reg-summary-edit-link a').text('Edit Details');
    // End Issue #92 -->

    // Issue #a3 make labels more clear -->
    $('.input-label.cons_first_name').text('First Name');
    $('.input-label.cons_last_name').text('Last Name');
    // End Issue #a3 -->

    // Issue #a10 unhide legend for screenreaders -->
    $('#responsive_payment_typecc_type_row legend').addClass('aural-only');
    // End Issue #a10 -->

    // Add aria-required to donation form inputs -->
    $('#billing_first_namename,#billing_last_namename,#billing_addr_street1name,#billing_addr_street1name,#billing_addr_state,#billing_addr_cityname,#billing_addr_zipname,#donor_email_addressname,#responsive_payment_typecc_numbername,#responsive_payment_typecc_exp_date_MONTH,#responsive_payment_typecc_exp_date_YEAR,#responsive_payment_typecc_cvvname').attr('aria-required', 'true');
    // End add donation form required inputs -->

    // tr-05-utype-login-or-register
    $("#janrainModal img[src='https://docj27ko03fnu.cloudfront.net/rel/img/17c96fc4b9c8464d1c95cd785dd3120b.png']").attr('alt', 'Close button');
    //// This won't run because the JanRain scripts are at very bottom of body tag.
    $('#janrain-amazon, #janrain-facebook').removeAttr('role');

    $('.list-component-sort-select-text').attr('id', 'team_sort_label');
    $('.list-component-sort-select').attr('aria-labelledby', 'team_sort_label');
    // tr-06-join-or-form-a-team
    $('#team_find_new_team_company label.input-label').attr('for', 'fr_co_list');

    $('#team_find_new_team_recruiting_goal label.input-label').attr('for', 'fr_team_member_goal');

    // ptype
    $('#part_type_selection_container').wrapInner('<fieldset role="radiogroup" class="ptype-selection" aria-labelledby="sel_type_container"/>');
    
    // $('input[name=fr_part_radio]').attr('aria-labelledby', 'sel_type_container');
    
    // wrap donation options in a fieldset with legend
    // $('#part_type_additional_gift_container').wrapInner('<fieldset role="radiogroup" class="donation-form-fields" aria-lablledby="part_type_additional_gift_section_header"/>');


    // $('#part_type_donation_level_input_container').wrapInner('<fieldset role="radiogroup" class="donation-form-fields" aria-lablledby="part_type_additional_gift_section_header"/>');
    $('.donation-level-container').before('<legend id="reg_donation_label" class="sr-only">Make a donation</legend>');

    $('#part_type_donation_level_input_container').wrapInner('<fieldset role="radiogroup" class="donation-form-fields" aria-labelledby="reg_donation_label"/>');
    // $('.donation-level-container input[type=radio]').attr('aria-labelledby', 'reg_donation_label');

    // associate ptype label with input
    $('.part-type-container label').each(function (i) {
      var ptypeOptionId = $(this).attr('for');
      $(this).closest('.part-type-container').find('input[name="fr_part_radio"]').attr('id', ptypeOptionId);
    });


    // Reg
    $('label[for="cons_first_name"]').eq(0).remove();
    // $('#cons_birth_date_MONTH, #cons_birth_date_DAY, #cons_birth_date_YEAR').attr('aria-labelledby', 'enterAmtLabel');
    $('#cons_birth_date_YEAR').attr('aria-hidden', true);

    // paymentForm
    $('#responsive_payment_typepay_typeradio_payment_types').wrap('<fieldset />').prepend('<legend class="sr-only">Payment method:</legend>');
    $('.cardExpGroup').prepend('<legend class="sr-only">Credit card expiration date</legend>');

    $('#find_hdr_container').replaceWith(function () {
      return '<h2 class="' + $(this).attr('class') + '" id="' + $(this).attr('id') + '">' + $(this).html() + '</h2>';
    });
    $('.section-header-text').replaceWith(function () {
      return '<h1 class="h3 ' + $(this).attr('class') + '" id="' + $(this).attr('id') + '">' + $(this).html() + '</h1>';
    });

    $('#title_container').replaceWith(function () {
      return '<h1 class="h3 ' + $(this).attr('class') + '" id="' + $(this).attr('id') + '">' + $(this).html() + '</h1>';
    });

    // Update help link to not be redundant
    $('#responsive_payment_typecc_cvv_row .HelpLink').attr('title', 'Opens in new window');


    // END REGISTRATION

    if ($('body').is('.pg_entry')) {
      $('.js__greeting-intro-text').html($('.js__chapter-intro-text'));
      $('.js__greeting-intro-images').html($('.js__chapter-intro-images'));
      $('.js__how-it-works-container').html($('.js__chapter-how-it-works'));
      $('.js__greeting-inspire-text').html($('.js__chapter-inspire-text'));
      $('.js__greeting-inspire-image').html($('.js__chapter-inspire-image'));
    }
    if ($('body').is('.pg_personal')) {
      var personalHeadline = $('#personal_page_header h2');
      $(personalHeadline).replaceWith('<h1>' + $(personalHeadline).text() + '</h1>');
      // populate captain cons ID in body attributes and append to modified join team URL
      var currentUrl = $('#personal_page_join_team_button').attr('href');
      var teamId = getURLParameter(currentUrl, 'fr_tjoin');
      var captainId = cd.getTeamCaptainId(evID, teamId, 'personal');
    }
    if ($('body').is('.pg_team')) {

      var teamHeadline = $('#team_page_title');
      var existingTeamName = $('#team_name');
      $(teamHeadline).replaceWith('<h1>' + $(teamHeadline).text() + '</h1>');
      $(existingTeamName).replaceWith('<h2>' + $(existingTeamName).text() + '</h2>');

      // populate captain cons ID in body attributes and append to modified join team URL
      var currentUrl = window.location.href;
      var teamId = getURLParameter(currentUrl, 'team_id');
      var captainId = cd.getTeamCaptainId(evID, teamId, 'team');


    }
    if ($('body').is('.pg_company')) {
      var companyHeadline = $('.cstmTitle');
      $(companyHeadline).replaceWith('<h1>' + $(companyHeadline).text() + '</h1>');
    }
    if ($('body').is('.app_donation')) {
      // replace duplicate ID
      $('#level_flexible_row.form-row.form-donation-level').attr('id', 'level_flexible_row2');

      $('.donation-level-user-entered input[type="text"]').after('<small class="form-text text-muted"><em>($25 minimum)</em></small>');

      // Add text above matching company label
      $('#donor_matching_employer_Row').prepend('<p><strong>Play matchmaker. Here&#8217;s how.</strong></p><ul><li>Find out if your employer participates in a matching gifts program, an easy way to increase your donation.</li><li>Just fill in your company&#8217;s details below.</li></ul>');

      $('fieldset.cardExpGroup').prepend('<legend class="aural-only">Credit Card Expires</legend>');

      $('#level_flexible_row2').wrapInner('<fieldset></fieldset>');
      $('#level_flexible_row2 fieldset').prepend('<legend class="aural-only">Select Gift Amount</legend>');

      $('#responsive_payment_typepay_typeradio_payment_types').wrapInner('<fieldset></fieldset>');
      $('#responsive_payment_typepay_typeradio_payment_types fieldset').prepend('<legend class="aural-only">Payment options</legend>');

      $('h5.transaction-summary-header').replaceWith(function () {
        return '<h1 class="transaction-summary-header summary-section-header dividerHeading" class="section-header-text">' + $(this).html() + '</h1>';
      });

      $('#responsive_payment_typecc_numbername, #responsive_payment_typecc_cvvname, #billing_first_namename, #billing_last_namename, #billing_addr_street1name, #billing_addr_cityname, #billing_addr_zipname, #donor_email_addressname, #responsive_payment_typecc_exp_date_MONTH, #responsive_payment_typecc_exp_date_YEAR, #billing_addr_state, #billing_addr_country').attr('aria-required', 'true');

      if ($('.errorMessageContainer .ErrorMessage.page-error .field-error-text').length > 0) {
        $('.errorMessageContainer .ErrorMessage.page-error .field-error-text').attr('role', 'alert');
      }
      $('#responsive_payment_typecc_numbername').attr('placeholder', 'XXXXXXXXXXXXXXXX');
      $('#level_flexible_row').before('<div class="required-indicator-legend d-block w-100"><span class="field-required"></span><span class="required-indicator-legend-text">&nbsp;Indicates Required</span></div>');

      $('label[for="responsive_payment_typepay_typeradiocredit"] a').attr('aria-label', 'PAYMENT BY CREDIT CARD');
      $('label[for="responsive_payment_typepay_typeradiopaypal"] a').attr('aria-label', 'PAYMENT BY PAY PAL');

      // Selecting empty value from the Gift Duration drop-down when the One-time Gift box is checked
      $('#level_flexiblegift_type1').click(function () {
        $('#level_flexibleduration').val("");
      });

      // Limiting number of characters in credit card field
      $('#responsive_payment_typecc_numbername').attr('maxlength', '16');
      $('#responsive_payment_typecc_cvvname').attr('minlength', '3').attr('maxlength', '4');


      // Change order of help link for tabbing
      $('.HelpLink').insertAfter('#responsive_payment_typecc_cvvname');

      $('#billing_addr_state option[value="None"]').remove();

      /*Thank You Page access edits */
      if ($('.transaction-summary-info').length > 0) {
        $('.transaction-summary-entry .entry-label').attr('tabindex', '0');
        $('.transaction-summary-entry .entry-value').each(function () {
          if ($(this).text().length > 0) {
            $(this).attr('tabindex', '0');
          } else {
            $(this).attr('tabindex', '1');
          }
        });
        $('.entry-label:contains("Total Gift Amount:")').attr('aria-label', 'Total Gift Amount');
      }


      $('#cell_or_phone_number_input').attr('placeholder', 'ex. 555-555-5555');

      $('.donation-levels').before('<span id="donation-errors"></span>');

      $('input[name="level_flexibleexpanded"]')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'Donation Amount is required')
        .attr('data-parsley-errors-container', '#donation-errors');

      $('#billing_first_namename')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'First Name is required');

      $('#billing_last_namename')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'Last Name is required');

      $('#donor_email_addressname')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'Email Address is required')
        .attr('data-parsley-type', 'email')
        .attr('data-parsley-type-message', 'Please enter a valid email address');

      $('#billing_addr_state')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'State is required');

      $('#billing_addr_cityname')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'City is required');

      $('#billing_addr_street1name')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'Billing Street is required');

      $('#billing_addr_zipname')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'Zip Code is required')
        .attr('data-parsley-type', 'number')
        .attr('data-parsley-type-message', 'Zip Code must be a number')
        .attr('data-parsley-maxlength', '7')
        .attr('data-parsley-maxlength-message', 'Zip Code  cannot be more than 7 characters');

      $('#responsive_payment_typecc_numbername')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'Credit Card Number is required')
        .attr('data-parsley-type', 'number')
        .attr('data-parsley-type-message', 'Credit Card must be a number')
        .attr('data-parsley-maxlength', '16')
        .attr('data-parsley-maxlength-message', 'Credit Card cannot be more than 16 characters');

      $('#responsive_payment_typecc_cvvname')
        .attr('data-parsley-required', '')
        .attr('data-parsley-required-message', 'CVV is required')
        .attr('data-parsley-type', 'number')
        .attr('data-parsley-type-message', 'CVV must be a number')
        .attr('data-parsley-minlength', '3')
        .attr('data-parsley-maxlength-message', 'CVV must be at least 3 characters')
        .attr('data-parsley-maxlength', '4')
        .attr('data-parsley-maxlength-message', 'CVV cannot be more than 4 characters');

      var parsleyDonDefaults = {
        uiEnabled: true,
        priorityEnabled: true,
        errorsWrapper: '<div class="help-block with-errors"></div>',
        errorTemplate: '<span class="text-danger"></span>'
      }

      $('#ProcessForm').parsley(parsleyDonDefaults);

      $('.internal-payment').on('click', function (e) {
        $('#responsive_payment_typecc_numbername').attr('data-parsley-required', '');
        $('#responsive_payment_typecc_cvvname').attr('data-parsley-required', '');
      });
      $('.external-payment').on('click', function (e) {
        $('#responsive_payment_typecc_numbername').removeAttr('data-parsley-required');
        $('#responsive_payment_typecc_cvvname').removeAttr('data-parsley-required');
      });


    }


  });
}(jQuery));
