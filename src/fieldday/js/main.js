'use strict';

(function ($) {
    $(document).ready(function ($) {

        /*************/
        /* Namespace */
        /*************/
        window.cd = {};

        /*******************/
        /* WRAPPER SCRIPTS */
        /*******************/

        var screenWidth = $(window).innerWidth();

        // Mobile nav toggle
        $('#mobile-toggle').click(function () {
            if ($('#navbar-container').hasClass('is-search')) {
                $('#navbar-container').removeClass('is-search');
                $('.mobile-search-trigger').removeClass('active');
            } else {
                $('#navbar-container').slideToggle('fast');
            }
            $('.navbar-toggler-icon').toggleClass('fa-align-justify').toggleClass('fa-times');
            $('.pg_company .tr-page-container, .pg_personal .tr-page-container, .pg_team .tr-page-container').toggleClass('static');
            $('.pg_company header, .pg_personal header, .pg_team header').toggleClass('mobile-open');
        });

        // Mobile search toggle
        $('.mobile-search-trigger').click(function () {
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
                    $('#navbar-container').slideToggle('fast', function () {
                        $('#navbar-container').toggleClass('is-search');
                    });
                } else {
                    $('#navbar-container').toggleClass('is-search');
                    $('#navbar-container').slideToggle('fast');
                }
            }
        });

        // $('#find').on('click', function(e){
        //   e.preventDefault();
        //   $('.dropdown-menu-container.find, .dropdown-menu-container.find .dropdown-menu').toggle();
        // });

        // $('.js--nav-about').on('click', function(e){
        //   e.preventDefault();
        //   $('.dropdown-menu-container.about, .dropdown-menu-container.about .dropdown-menu').toggle();
        // });

        // $( "#find" ).focusin(function() {
        //   $('.dropdown-menu-container.find, .dropdown-menu-container.find .dropdown-menu').show();
        // });

        // $( ".js--nav-about" ).focusin(function() {
        //   $('.dropdown-menu-container.find, .dropdown-menu-container.find .dropdown-menu').hide();
        //   $('.dropdown-menu-container.about, .dropdown-menu-container.about .dropdown-menu').show();
        // });

        // $( ".js--top-menu-contact" ).focusout(function() {
        //   $('.dropdown-menu-container.about, .dropdown-menu-container.about .dropdown-menu').hide();
        // });


        /******************/
        /* SEARCH SCRIPTS */
        /******************/
        var eventType = 'Field%20Day';
        var eventType2 = $('body').data('event-type2') ? $('body').data('event-type2') : null;
        var regType = $('body').data('reg-type') ? $('body').data('reg-type') : null;
        var publicEventType = $('body').data('public-event-type') ? $('body').data('public-event-type') : null;

        var isProd = (luminateExtend.global.tablePrefix === 'heartdev' ? false : true);
        var eventName = luminateExtend.global.eventName;
        var srcCode = luminateExtend.global.srcCode;
        var subSrcCode = luminateExtend.global.subSrcCode;
        var evID = $('body').data('fr-id') ? $('body').data('fr-id') : null;
        var dfID = $('body').data('df-id') ? $('body').data('df-id') : null;
        var consID = $('body').data('cons-id') ? $('body').data('cons-id') : null;

        function getURLParameter(url, name) {
            return (RegExp(name + '=' + '(.+?)(&|$)').exec(url) || [, null])[1];
        }

        var currentUrl = window.location.href;
        var searchType = getURLParameter(currentUrl, 'search_type');
        var isCrossEventSearch = getURLParameter(currentUrl, 'cross_event');
        var teamId = getURLParameter(currentUrl, 'team_id');
        var companyIdParam = getURLParameter(currentUrl, 'company_id');

        var skipLink = document.getElementById('skip-main');

        var companyCSV = 'https://dev2.heart.org/fieldday_company_data/supplemental_company_data.csv';

        skipLink.addEventListener('click', function (e) {
            e.preventDefault();
            document.getElementById('pcBodyContainer').scrollIntoView();
        });

        if ($('body').is('.pg_FieldDay_HQ')) {
            $('.js__skip-to').on('click', function (e) {
                e.preventDefault();
                $('html, body').animate({
                    scrollTop: $('#pcBodyContainer').offset().top
                }, 500);
            });
        }

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
                        var scrollLocation = target.offset().top;
                        // var scrollLocation = target.offset().top - 230;
                        $('html, body').animate({
                            scrollTop: scrollLocation
                        }, 1000, function () {
                        });
                    }
                });
        }
        addScrollLinks();

        cd.getParticipants = function (firstName, lastName, isCrossEvent) {
            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getParticipants' +
                    ((firstName !== undefined) ? '&first_name=' + firstName : '') +
                    ((lastName !== undefined) ? '&last_name=' + lastName : '') +
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
                            $('#error-participant').removeAttr('hidden').text('Teammate not found. Please try different search terms.');
                        } else {
                            var participants = luminateExtend.utils.ensureArray(response.getParticipantsResponse.participant);
                            var totalParticipants = parseInt(response.getParticipantsResponse.totalNumberResults);

                            if ($.fn.DataTable) {
                                if ($.fn.DataTable.isDataTable('#participantResultsTable')) {
                                    $('#participantResultsTable').DataTable().destroy();
                                }
                            }
                            $('#participantResultsTable tbody').empty();

                            $('.js--num-participant-results').text((totalParticipants === 1 ? '1 Result' : totalParticipants + ' Results'));

                            $(participants).each(function (i, participant) {
                                if (screenWidth >= 768) {
                                    $('.js--participants-results-rows').append('<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' + participant.personalPageUrl + '">' +
                                        participant.name.first + ' ' + participant.name.last +
                                        '</a></td><td>' +
                                        ((participant.teamName !== null && participant.teamName !== undefined) ? '<a href="' + participant.teamPageUrl + '">' + participant.teamName + '</a>' : '') + '</td><td><a href="TR/?fr_id=' + participant.eventId + '&pg=entry">' +
                                        participant.eventName + '</a></td><td class="col-cta"><a href="' + participant.donationUrl + '" aria-label="Donate to ' + participant.name.first + ' ' + participant.name.last + '" class="btn btn-primary btn-block btn-rounded">Donate</a></td></tr>');
                                } else {
                                    $('#participantResultsTable thead').remove();
                                    $('.js--participants-results-rows').addClass('mobile').append('<tr><td><table><tr' + (i > 10 ? ' class="d-none"' : '') + '><td>Teammate</td><td><a href="' + participant.personalPageUrl + '">' +
                                        participant.name.first + ' ' + participant.name.last + '</a></td></tr>' +
                                        ((participant.teamName !== null && participant.teamName !== undefined) ? '<tr><td>Team</td><td><a href="' + participant.teamPageUrl + '">' + participant.teamName + '</a>' : '') +
                                        '</td></tr><tr><td>Event Name</td><td><a href="TR/?fr_id=' + participant.eventId + '&pg=entry">' + participant.eventName + '</a></td></tr><tr><td colspan="2" class="text-center"><a href="' + participant.donationUrl + '" class="btn btn-primary btn-block btn-rounded" title="Donate to ' + participant.name.first + ' ' + participant.name.last + '" aria-label="Donate to ' + participant.name.first + ' ' + participant.name.last + '">Donate</a></td></tr></table></td></tr>');
                                }


                            });

                            if (totalParticipants > 10) {
                                $('.js--more-participant-results').removeAttr('hidden');
                            }

                            if (screenWidth >= 768) {
                                $('#participantResultsTable').DataTable({
                                    "paging": false,
                                    "searching": false,
                                    "info": false,
                                    "autoWidth": false
                                });
                            }
                            $('.dataTables_length').addClass('bs-select');
                            //add call to hook donate button with payment type selections
                            addPaymentTypesOnSearch();
                            $('.js--participant-results-container').removeAttr('hidden');

                            $('.js--more-participant-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--participants-results-rows tr').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--end-participant-list').removeAttr('hidden');
                            });

                        }
                    },
                    error: function (response) {
                        $('#error-participant').removeAttr('hidden').text(response.errorResponse.message);
                    }
                }
            });
        };

        cd.getTeams = function (teamName, isCrossEvent) {
            $('.js__team-results-rows').html('');
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

                        if ($.fn.DataTable) {
                            if ($.fn.DataTable.isDataTable('#teamResultsTable')) {
                                $('#teamResultsTable').DataTable().destroy();
                            }
                        }
                        $('#teamResultsTable tbody').empty();

                        if (response.getTeamSearchByInfoResponse.totalNumberResults === '0') {
                            // no search results
                            $('#error-team').removeAttr('hidden').text('Team not found. Please try different search terms.');
                            $('.js--error-team-search').show();
                        } else {
                            var teams = luminateExtend.utils.ensureArray(response.getTeamSearchByInfoResponse.team);

                            $(teams).each(function (i, team) {
                                if (screenWidth >= 768) {
                                    $('.js--team-results-rows')
                                        .append('<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' + team.teamPageURL + '">' +
                                            team.name + '</a></td><td><a href="TR/?px=' + team.captainConsId + '&pg=personal&fr_id=' + team.EventId + '">' + team.captainFirstName + ' ' + team.captainLastName + '</a></td><td>' +
                                            ((team.companyName !== null && team.companyName !== undefined) ? '<a href="TR?company_id=' + team.companyId + '&fr_id=' + team.EventId + '&pg=company">' + team.companyName + '</a>' : '') +
                                            '</td><td><a href="TR/?fr_id=' + team.EventId + '&pg=entry">' + team.eventName + '</a></td><td class="col-cta"><a href="' + team.teamDonateURL + '" class="btn btn-primary btn-block btn-rounded" title="Donate to ' + team.name + '" aria-label="Donate to ' + team.name + '">Donate</a></td></tr>');
                                } else {
                                    $('#teamResultsTable thead').remove();
                                    $('.js--team-results-rows')
                                        .addClass('mobile')
                                        .append('<tr><td><table><tr' + (i > 10 ? ' class="d-none"' : '') + '><td>Team</td><td><a href="' + team.teamPageURL + '">' +
                                            team.name + '</a></td></tr><tr><td>Team Captain</td><td><a href="TR/?px=' + team.captainConsId + '&pg=personal&fr_id=' + team.EventId + '">' + team.captainFirstName + ' ' + team.captainLastName + '</a></td></tr>' +
                                            ((team.companyName !== null && team.companyName !== undefined) ? '<tr><td>Company</td><td><a href="TR?company_id=' + team.companyId + '&fr_id=' + team.EventId + '&pg=company">' + team.companyName + '</a>' : '') +
                                            '</td></tr><tr><td>Event Name</td><td><a href="TR/?fr_id=' + team.EventId + '&pg=entry">' + team.eventName + '</a></td></tr><tr><td colspan="2" class="text-center"><a href="' + team.teamDonateURL + '" class="btn btn-primary btn-block btn-rounded" title="Donate to ' + team.name + '" aria-label="Donate to ' + team.name + '">Donate</a></td></tr></table></td></tr>');
                                }
                            });

                            var totalTeams = parseInt(response.getTeamSearchByInfoResponse.totalNumberResults);

                            $('.js--num-team-results').text((totalTeams === 1 ? '1 Result' : totalTeams + ' Results'));

                            if (totalTeams > 10) {
                                $('.js--more-team-results').removeAttr('hidden');
                            }

                            $('.js--team-results-container').removeAttr('hidden');

                            $('.js--more-team-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--team-results-rows tr').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--end-team-list').removeAttr('hidden');
                            });
                            if (screenWidth >= 768) {
                                $('#teamResultsTable').DataTable({
                                    "paging": false,
                                    "searching": false,
                                    "info": false
                                });
                            }
                            $('.dataTables_length').addClass('bs-select');
                            //add call to hook donate button with payment type selections
                            addPaymentTypesOnSearch();
                            $('.js--team-results-container').removeAttr('hidden');

                        }
                    },
                    error: function (response) {
                        $('#error-team').removeAttr('hidden').text(response.errorResponse.message);
                        $('.js--search-results').show();
                        $('.js--search-results-container').show();
                    }
                }
            });
        };

        cd.getCompanies = function (companyName, isCrossEvent) {
            cd.getCompanyData();
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

                      if ($.fn.DataTable) {
                          if ($.fn.DataTable.isDataTable('#companyResultsTable')) {
                              $('#companyResultsTable').DataTable().destroy();
                          }
                      }
                      $('#companyResultsTable tbody').empty();
                        if (response.getCompaniesResponse.totalNumberResults === '0') {
                            // no search results
                            $('#error-company').removeAttr('hidden').text('Company not found. Please try different search terms.');
                        } else {
                            var companies = luminateExtend.utils.ensureArray(response.getCompaniesResponse.company);
                            var totalCompanies = parseInt(response.getCompaniesResponse.totalNumberResults);
                            $('.js--num-company-results').text((totalCompanies === 1 ? '1 Result' : totalCompanies + ' Results'));

                            $(companies).each(function (i, company) {

                              var companyId = company.companyId;
                              var companyLocation;
                              var companyLead;

                              companyLocation = $('#company-id-'+ companyId + ' .js--company-data-location').html();
                              companyLead = $('#company-id-'+ companyId + ' .js--company-data-coordinator').html();

                              if (screenWidth >= 768) {
                              $('.js--company-results-rows').append('<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' + company.companyURL + '">' +
                                  company.companyName + '</a></td><td class="col-cta">' + (companyLead !== undefined ? companyLead : '') + '</td><td class="col-cta">' + (companyLocation !== undefined ? companyLocation : '') + '</td><td class="col-cta"><a href="' + company.companyURL + '">' + 'Details</a></td></tr>');
                              } else {
                                  $('#companyResultsTable thead').remove();
                                  $('.js--team-results-rows')
                                      .addClass('mobile')
                                      .append('<tr><td><table><tr' + (i > 10 ? ' class="d-none"' : '') + '><td>Company</td><td><a href="' + company.companyURL + '">' +
                                          company.companyName + '</a></td></tr><tr><td>Company Lead</td><td>' + (companyLead !== undefined ? companyLead : '') + '</td></tr>' +
                                          ((team.companyName !== null && team.companyName !== undefined) ? '<tr><td>Company</td><td><a href="TR?company_id=' + team.companyId + '&fr_id=' + team.EventId + '&pg=company">' + team.companyName + '</a>' : '') +
                                          '</td></tr><tr><td>Event Location</td><td class="col-cta">' + (companyLocation !== undefined ? companyLocation : '') + '</td></tr><tr><td colspan="2" class="text-center"><td class="col-cta"><a href="<a href="' + company.companyURL + '">' + 'Details</a></td></td></tr></table></td></tr>');
                              }
                            });

                            $('.js--company-results-container').removeAttr('hidden');
                            $('.js--company-results-container').removeAttr('hidden');

                            if (screenWidth >= 768) {
                                $('#companyResultsTable').DataTable({
                                    "paging": false,
                                    "searching": false,
                                    "info": false,
                                    "autoWidth": false
                                });
                            }

                            $('.dataTables_length').addClass('bs-select');
                        }
                    },
                    error: function (response) {
                        $('.js--company-results-container').removeAttr('hidden').text(response.errorResponse.message);
                    }
                }
            });
        };

        cd.getTeamCaptains = function () {
            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getTeamCaptains' +
                    '&fr_id=' + evID +
                    '&team_id=' + teamId +
                    '&response_format=json',
                callback: {
                    success: function (response) {
                            var captains = luminateExtend.utils.ensureArray(response.getTeamCaptainsResponse.captain);

                            $(captains).each(function (i, captain) {
                              var captainName = captain.name.first + ' ' + captain.name.last;
                              var captainPage = captain.personalPageUrl;

                              $('<p><a href="'+ captainPage +'">' + captainName +'</p>').appendTo('.js--team-captain');
                            });

                    },
                    error: function (response) {
                        console.log(response.errorResponse.message);
                    }
                }
            });
        };

        // Header Search Forms
        //search by company
        $('.js--header-company-search').on('submit', function (e) {
            e.preventDefault();
            var companySearched = encodeURIComponent($('#companySearch').val());
            window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=company&cross_event=' + (evID ? 'false' : 'true') + (evID ? '&fr_id=' + evID : '') + '&company=' + companySearched;
        });

        // Search by Event
        $('.js--header-zip-search').on('submit', function (e) {
            e.preventDefault();
            var zipSearched = encodeURIComponent($('#zipSearch').val());
            window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=zip&cross_event=' + (evID ? 'false' : 'true') + (evID ? '&fr_id=' + evID : '') + '&zip=' + zipSearched;
        });

        //
        $('.js--header-state-search').on('submit', function (e) {
            e.preventDefault();
            var stateSearch = encodeURIComponent($('#stateSearch').val());
            window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=state&cross_event=' + (evID ? 'false' : 'true') + (evID ? '&fr_id=' + evID : '') + '&state=' + stateSearch;
        });


        $('#stateSearch').on('change', function () {
            var stateSearch = encodeURIComponent($('#stateSearch').val());
            window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=state&cross_event=' + (evID ? 'false' : 'true') + (evID ? '&fr_id=' + evID : '') + '&state=' + stateSearch;
        });

        // Search page by Participant
        $('.js--header-participant-search').on('submit', function (e) {
            e.preventDefault();
            var firstName = encodeURIComponent($('#participantSearchFirst').val());
            var lastName = encodeURIComponent($('#participantSearchLast').val());
            window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=participant&cross_event=' + (evID ? 'false' : 'true') + (evID ? '&fr_id=' + evID : '') + '&fr_id=' + evID + (firstName ? '&first_name=' + firstName : '') +
                (lastName ? '&last_name=' + lastName : '');
        });

        // Search by Team
        $('.js--header-team-search').on('submit', function (e) {
            e.preventDefault();
            var teamName = encodeURIComponent($('#teamSearch').val());
            cd.getTeams(teamName, (isCrossEventSearch === "true" ? true : false));
            window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=team&cross_event=' + (evID ? 'false' : 'true') + (evID ? '&fr_id=' + evID : '') + '&team_name=' + teamName;
        });


        /******************************/
        /* EVENT SEARCH SCRIPTS */
        /******************************/

        // Get events by zip
        cd.getEventsByDistance = function (zipCode, isCrossEvent) {
            $('#eventStateResultsTable').addClass('d-none');
            $('#eventResultsTable').removeClass('d-none');
            $('.js--no-event-results').addClass('d-none');
            $('.js--loading').show();

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
                            $('.js--loading').hide();
                            var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);
                            var totalEvents = parseInt(response.getTeamraisersResponse.totalNumberResults);

                            if ($.fn.DataTable) {
                                if ($.fn.DataTable.isDataTable('#eventResultsTable')) {
                                    $('#eventResultsTable').DataTable().destroy();
                                }
                            }
                            $('#eventResultsTable tbody').empty();

                            $('.js--num-event-results').text((totalEvents === 1 ? '1 Result' : totalEvents + ' Results'));

                            $(events).each(function (i, event) {
                                var eventDate = luminateExtend.utils.simpleDateFormat(event.event_date,
                                    'EEE, MMM d, yyyy');
                                var eventTimestamp = new Date(event.event_date);
                                var eventStatus = event.status;
                                var acceptsRegistration = event.accepting_registrations;

                                if (screenWidth >= 768) {
                                    var eventRow = '<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' +
                                        event.greeting_url + '">' + event.name + '</a></td><td data-order="' + event.event_date + '">' + event.city + ', ' +  event.state + '</td><td data-order="' + parseFloat(event.distance) + '">' + event.distance + 'mi</td><td><a href="' + event.greeting_url + '" aria-label="More details about ' + event.name + '" class="btn btn-secondary btn-block btn-rounded">Details</a></td><td class="col-cta">' + (acceptsRegistration === 'true' ? '<a href="SPageServer/?pagename=fieldday_register&fr_id=' + event.id + '" aria-label="Register for ' + event.name + '" class="btn btn-primary btn-block btn-rounded">Register</a>' : 'Registration Closed') + '</td></tr>';
                                } else {
                                    $('#eventResultsTable thead').remove();
                                    $('.js--event-results-rows').addClass('mobile')

                                    var eventRow = '<tr><td><table><tr' + (i > 10 ? ' class="d-none"' : '') + '><td>Event Name</td><td><a href="' +
                                        event.greeting_url + '">' + event.name + '</a></td></tr>' +
                                        '</td></tr><tr><td>Date</td><td>' + eventDate + '</td></tr><tr><td>Distance</td><td>' + event.distance + 'mi</td></tr><tr><td colspan="2" class="text-center">' + (acceptsRegistration === 'true' ? '<a href="SPageServer/?pagename=fieldday_register&fr_id=' + event.id + '" class="btn btn-primary btn-block btn-rounded" title="Register for ' + event.name + '" aria-label="Register for ' + event.name + '">Register</a>' : 'Registration Closed') + '</td></tr></table></td></tr>';
                                }


                                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                                    $('.js--event-results-rows').append(eventRow);
                                }
                            });

                            if (totalEvents > 10) {
                                $('.js--more-event-results').removeAttr('hidden');
                            }

                            $('.js--more-event-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--event-results-rows tr').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--end-event-list').removeAttr('hidden');
                            });
                            if (screenWidth >= 768) {
                                $('#eventResultsTable').DataTable({
                                    "paging": false,
                                    "searching": false,
                                    "info": false
                                });
                            }
                            $('.dataTables_length').addClass('bs-select');

                            $('.js--event-results-container').removeAttr('hidden');
                        } else {
                            $('.js--loading').hide();
                            $('#error-event').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--loading').hide();
                    }
                }
            });
        };
        // END getEventsByDistance

        // Get events by state
        cd.getEventsByState = function (eventState, isCrossEvent) {
          $('#eventResultsTable').addClass('d-none');
          $('#eventStateResultsTable').removeClass('d-none');
            $('.js--no-event-results').addClass('d-none');
            $('.js--loading').show();

            luminateExtend.api({
            api: 'teamraiser',
            data: 'method=getTeamraisersByInfo' +
                '&state=' + eventState +
                '&event_type=' + eventType +
                '&search_distance=200' +
                '&response_format=json&list_page_size=499&list_page_offset=0&list_sort_column=event_date&list_ascending=true',
            callback: {
                    success: function (response) {
                        if (response.getTeamraisersResponse.totalNumberResults > '0') {
                            $('.js--loading').hide();
                            var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);
                            var totalEvents = parseInt(response.getTeamraisersResponse.totalNumberResults);

                            if ($.fn.DataTable) {
                                if ($.fn.DataTable.isDataTable('#eventResultsTable')) {
                                    $('#eventStateResultsTable').DataTable().destroy();
                                }
                            }
                            $('#eventStateResultsTable tbody').empty();

                            $('.js--num-event-results').text((totalEvents === 1 ? '1 Result' : totalEvents + ' Results'));

                            $(events).each(function (i, event) {

                                var eventStatus = event.status;
                                var acceptsRegistration = event.accepting_registrations;

                                if (screenWidth >= 768) {
                                    var eventRow = '<tr' + (i > 10 ? ' class="d-none"' : '') + '><td><a href="' +
                                        event.greeting_url + '">' + event.name + '</a></td><td data-order="' + event.event_date + '">' + event.city + ', ' +  event.state + '</td><td><a href="' + event.greeting_url + '" aria-label="More details about ' + event.name + '" class="btn btn-secondary btn-block btn-rounded">Details</a></td><td class="col-cta">' + (acceptsRegistration === 'true' ? '<a href="SPageServer/?pagename=fieldday_register&fr_id=' + event.id + '" aria-label="Register for ' + event.name + '" class="btn btn-primary btn-block btn-rounded">Register</a>' : 'Registration Closed') + '</td></tr>';
                                } else {
                                    $('#eventStateResultsTable thead').remove();
                                    $('.js--event-state-results-rows').addClass('mobile')

                                    var eventRow = '<tr><td><table><tr' + (i > 10 ? ' class="d-none"' : '') + '><td>Event Name</td><td><a href="' +
                                        event.greeting_url + '">' + event.name + '</a></td></tr>' +
                                        '</td></tr><tr><td>Date</td><td>' + eventDate + '</td></tr><tr><td colspan="2" class="text-center">' + (acceptsRegistration === 'true' ? '<a href="SPageServer/?pagename=fieldday_register&fr_id=' + event.id + '" class="btn btn-primary btn-block btn-rounded" title="Register for ' + event.name + '" aria-label="Register for ' + event.name + '">Register</a>' : 'Registration Closed') + '</td></tr></table></td></tr>';
                                }


                                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                                    $('.js--event-state-results-rows').append(eventRow);
                                }
                            });

                            if (totalEvents > 10) {
                                $('.js--more-event-results').removeAttr('hidden');
                            }

                            $('.js--more-event-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--event-results-rows tr').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--end-event-list').removeAttr('hidden');
                            });
                            if (screenWidth >= 768) {
                                $('#eventStateResultsTable').DataTable({
                                    "paging": false,
                                    "searching": false,
                                    "info": false
                                });
                            }
                            $('.dataTables_length').addClass('bs-select');

                            $('.js--event-results-container').removeAttr('hidden');
                        } else {
                            $('.js--loading').hide();
                            $('#error-event').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--loading').hide();
                    }
                }
            });
        };
        // END getEventsByState

        // Get events by name or state
        cd.getEvents = function (eventName, eventState) {
            $('.js--loading').show();
            $('.js--no-event-results').addClass('d-none');
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
                            $('.js--loading').hide();
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
                                var eventRow = '<li class="event-detail row col-12 col-lg-4 mb-4 fadein"><div class="event-detail-content col-10"><a class="js--event-name" href="' +
                                    greetingUrl + '" aria-label="Visit ' + eventCity + ' ' + eventType + ' Event"><span class="city">' +
                                    eventCity + '</span>, <span class="fullstate">' +
                                    eventStateAbbr + '</span></a><span class="eventtype d-block">' +
                                    eventType + ' Event</span><span class="event-date d-block">' +
                                    eventDate + '</span></div><a href="' +
                                    greetingUrl + '" class="event-detail-button btn col-2" aria-label="Visit event page for CycleNation ' + eventCity + '"><i class="fas fa-angle-right" aria-hidden="true" alt=""></i></a></li>';

                                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                                    $('.js--event-search-results').append(eventRow);
                                }
                            });
                        } else {
                            $('.js--loading').hide();
                            $('.js--no-event-results').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--loading').hide();
                    }
                }
            });
        };

        // Get events by zip

        cd.getEventsByDistanceLanding = function (zipCode) {
            $('.js--no-event-results').addClass('d-none');
            $('.js--loading').show();

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
                            $('.js--loading').hide();
                            var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);
                            var totalEvents = parseInt(response.getTeamraisersResponse.totalNumberResults);

                            $(events).each(function (i, event) {
                                var eventDate = luminateExtend.utils.simpleDateFormat(event.event_date,
                                    'EEE, MMM d, yyyy');
                                var eventTimestamp = new Date(event.event_date);
                                var eventStatus = event.status;
                                var acceptsRegistration = event.accepting_registrations;

                                var eventRow = '<div class="event-results__company row' + (i > 10 ? ' class="d-none"' : '') + '"><div class="col-12 col-md-6 d-flex align-items-center justify-content-center"><h3>' + event.name + '</h3></div><div class="col-12 col-md-6 d-flex align-items-center justify-content-center"><a href="' +
                                        event.greeting_url + '" class="btn btn-primary">Find a Company</a></div></div>';


                                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                                    $('.js--event-search-results').append(eventRow);
                                }
                            });

                            if (totalEvents > 10) {
                                $('.js--more-event-results').removeAttr('hidden');
                            }

                            $('.js--more-event-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--event-search-results row').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--end-event-list').removeAttr('hidden');
                            });

                            $('.js--event-results-container').removeAttr('hidden');
                        } else {
                            $('.js--loading').hide();
                            $('.js--no-event-results').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--loading').hide();
                    }
                }
            });
        };
        // END getEventsByDistance

        // getEventsByStateLanding
        cd.getEventsByStateLanding = function (eventState) {
            $('.js--no-event-results').addClass('d-none');
            $('.js--loading').show();

            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getTeamraisersByInfo' +
                    '&state=' + eventState +
                    '&event_type=' + eventType +
                    '&search_distance=200' +
                    '&response_format=json&list_page_size=499&list_page_offset=0&list_sort_column=event_date&list_ascending=true',
                callback: {
                    success: function (response) {
                        if (response.getTeamraisersResponse.totalNumberResults > '0') {
                            $('.js--loading').hide();
                            var events = luminateExtend.utils.ensureArray(response.getTeamraisersResponse.teamraiser);
                            var totalEvents = parseInt(response.getTeamraisersResponse.totalNumberResults);

                            $(events).each(function (i, event) {
                                var eventDate = luminateExtend.utils.simpleDateFormat(event.event_date,
                                    'EEE, MMM d, yyyy');
                                var eventTimestamp = new Date(event.event_date);
                                var eventStatus = event.status;
                                var acceptsRegistration = event.accepting_registrations;

                                var eventRow = '<div class="event-results__company row' + (i > 10 ? ' class="d-none"' : '') + '"><div class="col-12 col-md-6 d-flex align-items-center justify-content-center"><h3>' + event.name + '</h3></div><div class="col-12 col-md-6 d-flex align-items-center justify-content-center"><a class="btn btn-primary" href="' +
                                        event.greeting_url + '" class="btn btn-primary">Find a Company</a></div></div>';


                                if (eventStatus === '1' || eventStatus === '2' || eventStatus === '3') {
                                    $('.js--event-search-results').append(eventRow);
                                }
                            });

                            if (totalEvents > 10) {
                                $('.js--more-event-results').removeAttr('hidden');
                            }

                            $('.js--more-event-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--event-search-results row').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--end-event-list').removeAttr('hidden');
                            });

                            $('.js--event-results-container').removeAttr('hidden');
                        } else {
                            $('.js--loading').hide();
                            $('.js--no-event-results').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--loading').hide();
                    }
                }
            });
        };
        // END getEventsByStateLanding


        // getCompaniesLandingPage
        cd.getCompaniesLanding = function (companyName) {
            cd.getCompanyData();
            $('.js--no-participant-results, .js--participant-no-event-results').addClass('d-none');
            $('.js--participant-loading').show();

            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getCompaniesByInfo' +
                    '&company_name=' + companyName +
                    '&event_type=' + eventType +
                    '&response_format=json&list_page_size=499&list_page_offset=0',
                callback: {
                    success: function (response) {
                        if (response.getCompaniesResponse.totalNumberResults > '0') {
                            $('.js--participant-loading').hide();
                            var companies = luminateExtend.utils.ensureArray(response.getCompaniesResponse.company);
                            var totalEvents = parseInt(response.getCompaniesResponse.totalNumberResults);

                            $(companies).each(function (i, company) {

                                var companyId = company.companyId;

                                var companyLocation;

                                companyLocation = $('#company-id-'+ companyId + ' .js--company-data-location').html();


                                var eventRow = '<div class="row py-3' + (i > 10 ? 'd-none' : '') + '"><div class="landing-participant-search__name col-12 col-lg-6"><p><a href="'+ company.companyURL +'">'+ company.companyName +'</a><br>';

                                if (companyLocation !== undefined ) {
                                  eventRow += '<span class="js--company-location">'+ companyLocation +'</span>'
                                }

                                eventRow +='</p></div><div class="landing-participant-search__register col-12 col-lg-6"><p><a href="'+ company.companyURL +'" class="btn btn-primary">Register</a></p></div>';

                                $('.js--participant-search-results').append(eventRow);

                            });

                            if (totalEvents > 10) {
                                $('.js--participant-more-event-results').removeClass('hidden');
                            }

                            $('.js--participant-more-event-results').on('click', function (e) {
                                e.preventDefault();
                                $('.js--participant-search-results .row').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--participant-end-event-list').removeAttr('hidden');
                            });

                            $('.js--participant-search-results').removeAttr('hidden');
                        } else {
                            $('.js--participant-loading').hide();
                            $('.js--participant-no-event-results').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--participant-loading').hide();
                    }
                }
            });
        };
        // END getCompaniesLandingPage


        // getCompaniesLandingPage
        cd.getParticipantsLanding = function (firstName, lastName) {
            $('.js--no-participant-results, .js--participant-no-event-results').addClass('d-none');
            $('.js--participant-loading').show();

            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getParticipants' +
                    '&first_name=' + (firstName ? firstName : '%25%25') +
                    '&lastName=' + (lastName ? lastName : '%25%25') +
                    '&event_type=' + eventType +
                    '&response_format=json&list_page_size=499&list_page_offset=0',
                callback: {
                    success: function (response) {
                        if (response.getParticipantsResponse.totalNumberResults > '0') {
                            $('.js--participant-loading').hide();
                            var participants = luminateExtend.utils.ensureArray(response.getParticipantsResponse.participant);
                            var totalEvents = parseInt(response.getParticipantsResponse.totalNumberResults);

                            $(participants).each(function (i, participant) {

                                var eventRow = '<div class="row py-3 ' + (i > 10 ? ' d-none' : '') + '"><div class="landing-participant-search__name col-12 col-lg-6"><p><a href="'+ participant.personalPageUrl + '">' + participant.name.first + ' ' + participant.name.last +'</a><br>' +
                              (participant.teamName ? participant.teamName : "")  + '</p></div><div class="landing-participant-search__register col-12 col-lg-6"><p><a href="'+ participant.donationUrl +'" class="btn btn-primary">Donate</a></p></div>';

                                $('.js--participant-search-results').append(eventRow);

                            });

                            if (totalEvents > 10) {
                                $('.js--participant-more-event-results').removeClass('hidden');
                            }

                            $('.js--participant-more-event-result').on('click', function (e) {
                                e.preventDefault();
                                $('.js--participant-search-results .row').removeClass('d-none');
                                $(this).attr('hidden', true);
                                $('.js--participant-end-event-list').removeAttr('hidden');
                            });

                            $('.js--participant-search-results').removeAttr('hidden');
                        } else {
                            $('.js--participant-loading').hide();
                            $('.js--participant-no-event-results').removeClass('d-none');
                        }
                    },
                    error: function (response) {
                        $('.js--participant-loading').hide();
                    }
                }
            });
        };
        // END getCompaniesLandingPage




        /***********************/
        /* THERMOMETER SCRIPTS */
        /***********************/

        cd.runThermometer = function (raised, goal) {
            var fundraiserRaised = Number(raised.replace(/[^0-9.-]+/g, ''));
            var fundraiserGoal = Number(goal.replace(/[^0-9.-]+/g, ''));

            var percentRaised = (fundraiserRaised / fundraiserGoal);
            if (isNaN(percentRaised)) {
                percentRaised = 0;
            }
            var percentRaisedFormatted = (percentRaised * 100) + '%';

            $('.js__progress-bar')
                .animate({width: percentRaisedFormatted}, 2000)
                .attr("aria-valuenow", percentRaised * 100);
            $('.js__progress-bar svg').show();
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

        /******************/
        /* ROSTER SCRIPTS */
        /******************/

        cd.getTopParticipants = function (eventId) {
            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getParticipants&first_name=%25%25%25&event_type=' + eventType + '&fr_id=' + eventId + '&list_sort_column=total&list_ascending=false&list_page_size=10&response_format=json',
                callback: {
                    success: function (response) {
                        if (!$.isEmptyObject(response.getParticipantsResponse)) {
                            var counter = 0;
                            var participantData = luminateExtend.utils.ensureArray(response.getParticipantsResponse
                                .participant);

                            $(participantData).each(function () {
                                if (counter <= 4) {
                                    var participantName = this.name.first + ' ' + this.name.last;
                                    var participantRaised = (parseInt(this.amountRaised) * 0.01).toFixed(2);

                                    var participantRaisedFormmatted = participantRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,").replace('.00', '');
                                    var participantId = this.consId;
                                    var participantPage = this.personalPageUrl;
                                    var isCaptain = this.aTeamCaptain;
                                    var topWalkerHtml = '<li><div class="d-flex"><div class="flex-grow-1"><a href="' + participantPage + '">' + participantName + '</a></div><div class="raised">Raised<br><strong>$' + participantRaisedFormmatted + '</strong></div></div></li>';
                                    if (participantName !== "null null") {
                                        $('.js--participant-top-list ul').append(topWalkerHtml);
                                        counter = counter + 1;
                                    }
                                }
                            });
                        }
                    },
                    error: function (response) {
                    }
                }
            });
        };
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
                                var teamRaised = (parseInt(this.amountRaised) * 0.01).toFixed(2);

                                var teamRaisedFormmatted = teamRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,").replace('.00', '');
                                var teamId = this.id;

                                var topTeamRow = '<li><div class="d-flex"><div class="flex-grow-1"><a href="TR/?team_id=' + teamId + '&amp;pg=team&amp;fr_id=' + evID + '">' + teamName + '</a></div><div class="raised">Raised<br><strong>$' + teamRaisedFormmatted + '</strong></div></div></li>';

                                $('.js--team-top-list ul').append(topTeamRow);
                            });
                        }
                    },
                    error: function (response) {
                        // console.log('getTopTeams error: ' + response.errorResponse.message);
                    }
                }
            });
        };

        // END TOP TEAMS

        // BEGIN TOP COMPANIES
// TODO - replace with companyList

        cd.getCompanyList = function (eventId) {
            luminateExtend.api({
                api: 'teamraiser',
                data: 'method=getCompanyList&fr_id=' + eventId +
                    '&include_all_companies=true&response_format=json',
                callback: {
                    success: function (response) {
                        var childCompanyIdMap, companyItems, ref, rootAncestorCompanies;
                        companyItems = ((ref = response.getCompanyListResponse) != null ? ref.companyItem : void 0) || [];
                        if (!$.isArray(companyItems)) {
                            companyItems = [companyItems];
                        }
                        rootAncestorCompanies = [];
                        childCompanyIdMap = {};
                        $.each(companyItems, function (i, companyItem) {
                            var rootAncestorCompany;
                            if (companyItem.parentOrgEventId == '0') {
                                rootAncestorCompany = {
                                    eventId: eventId,
                                    companyId: companyItem.companyId,
                                    companyName: companyItem.companyName,
                                    amountRaised: companyItem.amountRaised ? Number(companyItem.amountRaised) : 0
                                };
                                rootAncestorCompanies.push(rootAncestorCompany);
                            }
                        });
                        $.each(companyItems, function (i, companyItem) {
                            var parentOrgEventId;
                            parentOrgEventId = companyItem.parentOrgEventId;
                            if (parentOrgEventId != "0") {
                                childCompanyIdMap['company-' + companyItem.companyId] = parentOrgEventId;
                            }
                        });
                        $.each(childCompanyIdMap, function (key, value) {
                            if (childCompanyIdMap['company-' + value]) {
                                childCompanyIdMap[key] = childCompanyIdMap['company-' + value];
                            }
                        });
                        $.each(childCompanyIdMap, function (key, value) {
                            if (childCompanyIdMap['company-' + value]) {
                                childCompanyIdMap[key] = childCompanyIdMap['company-' + value];
                            }
                        });
                        $.each(companyItems, function (i, companyItem) {
                            var childCompanyAmountRaised, rootParentCompanyId;
                            if (companyItem.parentOrgEventId != '0') {
                                rootParentCompanyId = childCompanyIdMap['company-' + companyItem.companyId];
                                childCompanyAmountRaised = companyItem.amountRaised ? Number(companyItem.amountRaised) : 0;
                                $.each(rootAncestorCompanies, function (rootAncestorCompanyIndex, rootAncestorCompany) {
                                    if (rootAncestorCompany.companyId === rootParentCompanyId) {
                                        rootAncestorCompanies[rootAncestorCompanyIndex].amountRaised = rootAncestorCompanies[rootAncestorCompanyIndex].amountRaised + childCompanyAmountRaised;
                                    }
                                });
                            }
                        });

                        //$.each(rootAncestorCompanies, function(rootAncestorCompanyIndex, rootAncestorCompany) {
                        //   rootAncestorCompanies[rootAncestorCompanyIndex].amountRaisedFormatted = $filter('currency')(rootAncestorCompany.amountRaised / 100, '$', 0);
                        //});
                        var sortedAncestorCompanies = rootAncestorCompanies.sort(function (a, b) {
                            return b.amountRaised - a.amountRaised
                        });
                        //var sortedAncestorCompanies = $filter('orderBy')(rootAncestorCompanies, 'amountRaised', true);
                        $(sortedAncestorCompanies).each(function (i) {
                            if (i < 5) {
                                var companyName = this.companyName;
                                var companyRaised = (parseInt(this.amountRaised) * 0.01).toFixed(2);
                                var companyRaisedFormmatted = companyRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,").replace('.00', '');
                                var topCompanyHtml = '<li><div class="d-flex"><div class="flex-grow-1"><a href="TR?company_id=' + this.companyId + '&fr_id=' + evID + '&pg=company">' + companyName + '</a></div><div class="raised">Raised<br><strong>$' + companyRaisedFormmatted + '</strong></div></div></li>';
                                $('.js--company-top-list ul').append(topCompanyHtml);
                            }
                        });
                    },
                    error: function (response) {
                        // console.log('getCompanyList error: ' + response.errorResponse.message);
                    }
                }
            });
        };

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
                            var totalCompanies = parseInt(response.getCompaniesResponse.totalNumberResults);
                            $('.js--num-companies').text(totalCompanies);
                        }
                    },
                    error: function (response) {
                        // console.log('getTopCompanies error: ' + response.errorResponse.message);
                    }
                }
            });
        };

        //CUSTOM COMPANY DATA FUNCTIONS


        cd.getCompanyByID = function(arr, value) {
     	  for (var i=0, iLen=arr.length; i<iLen; i++) {
     	    if (arr[i].companyid == value) return arr[i];
     		 }
     		}

       cd.getCompanyData = function() {
   			Papa.parse(companyCSV, {
   				header: true,
   				download: true,
   				dynamicTyping: true,
   				complete: function(results) {
   					var companies = results.data;
   					$('<div class="js--company-data hidden"></div>').insertAfter('main');
   			 	  for (var i=0, iLen=companies.length; i<iLen; i++) {
   							var dataOutput = '<div id="company-id-' + companies[i].companyid + '">';
   							dataOutput += '<div class="js--company-data-location">'+ companies[i].eventcity + ', ' + companies[i].eventstate + '</div>';
   							dataOutput += '<div class="js--company-data-coordinator">'+ companies[i].coordinatorfirstname + ' ' + companies[i].coordinatorlastname + '</div>';
   							dataOutput += '</div>';
   							$(dataOutput).appendTo('.js--company-data');
   			 		 }
     			 }
     		 });
    		}

        cd.getCompanyInfo = function(companyId){
          console.log('called company data' + companyId);
     		 Papa.parse(companyCSV, {
     		   header: true,
           download: true,
     		   complete: function(results) {
     		   console.log(results);

     				 var data = results.data;

     				 var company = cd.getCompanyByID(data, companyId);

     				 var eventMapLink;
     				 if (company.eventlocationmapurl!== undefined) {
     					 eventMapLink = company.eventlocationmapurl
     				 } else {
     					 eventMapLink = 'https://www.google.com/maps/place/' + company.eventaddress + ',' + company.eventcity + ',' + company.eventstate + ',' + company.eventzip;
     				 }

     				 var fieldDayDetails = '';
     				 fieldDayDetails += '<p>' + company.eventlocationname + '</p>';
     				 fieldDayDetails += '<p>' + company.eventcity + ', ' + company.eventstate + '</p>';
     				 $(fieldDayDetails).appendTo('.js--field-day-details');

     				 var companyLead = '<p><a href="mailto:' + company.coordinatoremail +'">' + company.coordinatorfirstname + ' ' + company.coordinatorlastname + '</a></p>' ;
     				 $(companyLead).appendTo('.js--company-lead');

             var eventDateFormatted = moment(company.eventdate).format('MMMM D, YYYY');

     				 var  eventDate = '<p><strong>' + eventDateFormatted + '<br>' + company.eventtime + '</strong></p>';
     				 $(eventDate).appendTo('.js--event-date');

     				 var companyLocation = '<p>' + company.eventcity + ', ' + company.eventstate + '</p>'
     				 $(companyLocation).appendTo('.js--company-location');

             $('.js--company-link').attr('href', eventMapLink);
             $('.js--company-link').html(company.companyname);

     		   }
     		 });
     	 }

       cd.getCompanyLocation = function(companyId){
         console.log('called company data' + companyId);
        Papa.parse(companyCSV, {
          header: true,
          download: true,
          complete: function(results) {

            var data = results.data;
            var company = cd.getCompanyByID(data, companyId);

            if (company !== undefined) {
              var companyLocation = company.eventcity + ', ' + company.eventstate;

              $(companyLocation).appendTo('.js--company-location');
            }
          }
        });
      }

        // EXPANDABLE DONOR ROLL
        $('.js--honor-roll-expander').on('click', function (e) {
            if ($(this).children('i').hasClass('fa-chevron-down')) {
                $(this).children('i').removeClass('fa-chevron-down');
                $(this).children('i').addClass('fa-chevron-up');
            } else {
                $(this).children('i').removeClass('fa-chevron-up');
                $(this).children('i').addClass('fa-chevron-down');
            }

            $('.hidden-donor-row').slideToggle(200);
        });
        cd.reorderPageForMobile = function () {
            // Reorganize page for mobile views
            if (screenWidth <= 767) {

                $('.tr-page-info').insertAfter('.sidebar-hero');
                $('.fundraising-amounts').prepend($('.fundraising-amounts .col-12'));

                if ($('body').is('.pg_team')) {
                    $('.team-roster').insertBefore($('.donor-roll'));
                    $('.js--information-box').prependTo('.js--sidebar');
                    $('.information-box__content').removeClass('box-shadow');
                    $('.team-roster li .raised span').each(function (i, span) {
                        if ($(this).parent().prev('.donor-name').find('span.coach').length !== 0) {
                            $(this).insertAfter($(this).parent().prev('.donor-name').children('.coach'));
                        } else {
                            $(this).insertAfter($(this).parent().prev('.donor-name').children('a'));
                        }
                    });

                    $('.team-roster form .btn').html($('.team-roster form .btn i'));
                }

                if ($('body').is('.pg_company')) {
                    $('.js--information-box').prependTo('.sidebar-content');

                    $('.team-roster form .btn').html('<i class="fas fa-search"></i>');
                    $('#participant-roster td:nth-child(3) a').html('Donate');

                }

                if ($('body').is('.pg_personal')) {
                  $('.js--information-box').prependTo('.js--sidebar-content');
                  $('.information-box__content').removeClass('box-shadow');

                }
            }
        };

        cd.initializeTeamRosterTable = function () {
            window.cdTeamRosterTable = $('#team-roster').DataTable({
                "paging": false,
                "autoWidth": false,
                "order": [[1, 'desc']],
                "language": {
                    "search": "Search for a Team"
                }
            });
            $('#team-roster_info, #team-roster_filter').wrapAll('<div class="row"></div>');
            $('#team-roster_info').insertBefore($('#team-roster_filter')).wrap('<div class="col-lg-6 col-md-12 sorter pl-md-0"></div>');
            $('#team-roster_filter').wrap('<div class="col-lg-6 col-md-12"></div>');

            $('#team-roster_filter input[type="search"]').attr('id', 'team_search').wrap('<div class="input-group"></div>').addClass('form-control').after('<div class="input-group-append"><button class="btn btn-primary btn-outline-secondary" type="button"><span class="sr-only">Search</span> <i class="fas fa-search"></i></button></div>');

            $('#team-roster_filter label').attr('for', 'team_search');

            // Add general team donation total and link
            var genTeamDonAmt = $('.team-roster-participant-name:contains("Team Gifts")').next().text();
            $('.js--gen-team-don-total').text(genTeamDonAmt);

            $('#team-roster_wrapper .sorter').prepend($('.js--gen-team-don-container'));

            $('.js--gen-team-don-container').show();

        };

        cd.initializeParticipantRosterTable = function () {
            window.cdParticipantRosterTable = $('#participant-roster').DataTable({
                "paging": false,
                "autoWidth": false,
                "order": [[2, 'desc']],
                "language": {
                    "search": "Search for a Teammate"
                }
            });

            $('#participant-roster_info, #participant-roster_filter').wrapAll('<div class="row"></div>');
            $('#participant-roster_info').insertBefore($('#participant-roster_filter')).wrap('<div class="col-lg-6 col-md-12 sorter d-flex align-items-end"></div>');
            $('#participant-roster_filter').wrap('<div class="col-lg-6 col-md-12"></div>');

            $('#participant-roster_filter input[type="search"]').attr('id', 'participant_search').wrap('<div class="input-group"></div>').addClass('form-control').after('<div class="input-group-append"><button class="btn btn-primary btn-outline-secondary" type="button"><span class="sr-only">Search</span> <i class="fas fa-search"></i></button></div>');

            $('#participant-roster_filter label').attr('for', 'participant_search');

        };

        cd.getTeamHonorRoll = function () {
            // populate donor honor roll
            if ($('.team-honor-list-row').length > 0) {
                // console.log('native honor row length:', $('.team-honor-list-row').length);
                $('.team-honor-list-row').each(function (i, donor) {
                    var donorName = $(this).find('.team-honor-list-name').text();
                    var donorAmt = $(this).find('.team-honor-list-value').text();
                    $('.js--donor-roll').append('<div ' + (i > 4 ? 'style="display:none;"' : '') + ' class="donor-row ' + (i > 4 ? 'hidden-donor-row' : '') + '"><span class="name">' + donorName + '</span><span class="amount">' + donorAmt + '</span></div>');
                    if (i === 5) {
                        $('.js--honor-roll-expander').addClass('d-block').removeClass('hidden');
                    }
                });
            }
        };

        cd.convertNumberToDollarAmount = function (number) {
            return (number + '').replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
        };

        cd.setDonorRollHeight = function () {
            $('.donations-container div').each(function (i, div) {
                if (i > 4) {
                    $('.donations-container').css('height', '205px');
                }
            });
        };
        //if ($('body').is('.app_id_26') || $('body').is('.app_id_27')) {
        //run unslider anytime sponsor_slider is found
        if ($('.sponsor_slider .local_sponsors').length > 0) {
            $('.sponsor_slider .local_sponsors').unslider({
                selectors: {
                    container: 'div.tr_sponsorship_logos',
                    slides: 'div.tr_sponsorship_logo'
                },
                autoplay: true
            });
        }
        //}

        if ($('body').is('.pg_entry')) {
            // Greeting Page
            // populate greeting page content
            $('.js--greeting-text').html($('#fr_html_container').html());

            if (publicEventType === "Multi-Event") {
                // populate multi-event
                var multiEventPageId = (isProd === true ? '3571' : '1110');

                var multiEventApiRequest = "TR?fr_id=" + evID + "&pg=informational&sid=" + multiEventPageId + " #page_body_container";

                $('.js--multi-event-locations').load(multiEventApiRequest);
            }


            // Event info section mobile expand/collapse functionality
            $('.event-info-expand').click(function () {
                $(this).children('.event-info-collapse').toggleClass('d-sm-none');
                var icon = $(this).children('h3').children('span').children('i');

                if ($(icon).hasClass('fa-plus')) {
                    $(icon).removeClass('fa-plus').addClass('fa-minus');
                } else {
                    $(icon).removeClass('fa-minus').addClass('fa-plus');
                }
            });

            // show EMC link if logged in visitor is EMC for this event
            if ($('.event-management-link-container').length) {
                $('.custom-event-management-link-container').removeClass('hidden');
            }

            // Update placeholder text in mobile for top walker search
            if (screenWidth <= 1065) {
                $('#greeting-search-first-name').attr('placeholder', 'First Name');
                $('#greeting-search-last-name').attr('placeholder', 'Last Name');
            }

            // Launch thermometer
            var progress = $('#progress-amount').text();
            var goal = $('#goal-amount').text();
            cd.runThermometer(progress, goal);
            // Build roster on greeting page
            cd.getTopParticipants(evID);
            cd.getTopTeams(evID);
            cd.getCompanyList(evID);
            cd.getTopCompanies(evID);

            // Walker Search
            $('.js--greeting-participant-search-form').on('submit', function (e) {
                e.preventDefault();
                console.log('teammate search');
                var firstName = encodeURIComponent($('#greeting-search-first-name').val());
                var lastName = encodeURIComponent($('#greeting-search-last-name').val());
                window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=participant&cross_event=false&fr_id=' + evID + (firstName ? '&first_name=' + firstName : '') +
                    (lastName ? '&last_name=' + lastName : '');
            });

            // Team Search
            $('.js--greeting-team-search-form').on('submit', function (e) {
                e.preventDefault();
                var teamName = encodeURIComponent($('#greeting-search-team').val());
                window.location.href = luminateExtend.global.path.secure + 'SPageServer/?pagename=FieldDay_Search&search_type=team&cross_event=false&fr_id=' + evID + '&team_name=' + teamName;
            });
        }

        if ($('.tr_sponsorship_logos').length > 0) {
            jQuery('.tr_sponsorship_logos a').on('click', function (e) {
                e.preventDefault();
                var sponsorUrl = jQuery(this).attr('href');
                if (confirm("These are proud sponsors of the American Heart Association's Heart Walk. By clicking on this link, you will be taken outside American Heart Association and this is not an endorsement of either the linked-to entity or any product or service.")) {
                    window.location.href = sponsorUrl;
                }
            });
        }

        if ($('body').is('.pg_personal')) {
            // Personal Page
            var progress = $('#progress-amount').text();
            var goal = $('#goal-amount').text();
            cd.runThermometer(progress, goal);
            cd.reorderPageForMobile();
            cd.setDonorRollHeight();

            //mobile placement

            // populate custom personal page content
            $('.js--personal-text').html($('#fr_rich_text_container').html());

            // populate donor honor roll
            cd.getTeamHonorRoll();

            var companyIdParam = $('.js--sidebar-content').data('company');
            console.log('company id: ' + companyIdParam)

            //fill in company sidebar data
            cd.getCompanyInfo(companyIdParam);

            // Build personal donation form
            cd.getDonationFormInfo = function (options) {
                luminateExtend.api({
                    api: 'donation',
                    requestType: 'POST',
                    data: 'method=getDonationFormInfo&fr_id=' + evID + '&form_id=' + dfID,
                    requiresAuth: true,
                    callback: {
                        success: function (response) {
                            var i = 0,
                                donationLevels = luminateExtend.utils.ensureArray(response.getDonationFormInfoResponse.donationLevels.donationLevel);

                            $.each(donationLevels, function (i) {
                                var userSpecified = this.userSpecified,
                                    amountFormatted = this.amount.formatted.replace('.00', ''),
                                    levelID = this.level_id;

                                i++;

                                if (userSpecified == 'false') {
                                    // build pre-defined giving levels
                                    $('.donation-amounts').append('<label class="form-check-label donation-amount-btn btn mb-3" for="personalDonAmt' + i + '" data-level-id="' + levelID + '"> <input class="form-check-input" type="radio" name="personalDonAmt" id="personalDonAmt' + i + '" value="' + levelID + '"> ' + amountFormatted + '</label>');
                                } else {
                                    // build user-specified level
                                    $('.donation-amounts').append('<div class="custom-amount"> <input class="form-check-input other-amt-radio sr-only" type="radio" name="personalDonAmt" id="personalDonAmt' + i + '" value="' + levelID + '"> <label class="js--don-amt-other sr-only" for="personalDonAmt' + i + '" data-level-id="' + levelID + '">Enter your own amount</label> <label class="form-label d-inline-block" for="personalOtherAmt">Custom Amount:</label><br/> <input type="text" id="personalOtherAmt" class="form-control d-inline-block js--personal-amt-other" data-parsley-min="25" data-parsley-min-message="Donations of all amounts are greatly appreciated. Online donations have a $25 minimum."/> </div>');
                                }
                            });

                            $('.custom-amount').after('<span class="error-row"></span>');


                            $('.js--personal-don-form').removeClass('hidden');
                            var defaultDonUrl = $('.js--personal-don-submit').data('don-url');
                            var finalDonUrl = null;
                            $('.js--personal-don-submit').attr('data-final-don-url', defaultDonUrl);

                            // define donation widget button behavior
                            $('.js--personal-don-form label').on('click', function () {
                                $('.js--personal-amt-other').val('');
                                $('.js--personal-don-form .donation-amount-btn').removeClass('active');
                                $('.paymentSelType').addClass('hidden');
                                $(this).addClass('active');
                                // $('.js--don-amt').text($(this).text());
                                finalDonUrl = defaultDonUrl + '&set.DonationLevel=' + $(this).data('level-id');
                                $('.js--personal-don-submit').attr('data-final-don-url', finalDonUrl);

                            });

                            $('.js--personal-amt-other').on('keyup', function (e) {
                                var keyCode = (e.keyCode ? e.keyCode : e.which);
                                // console.log('keyCode: ', keyCode);
                                $('.paymentSelType').addClass('hidden');
                                if (keyCode != 9) {
                                    $('.js--personal-don-form .donation-amount-btn').removeClass('active');
                                    $('.custom-amount input[name="personalDonAmt"]').prop('checked', true);

                                    var customAmt = parseInt($(this).val()) * 100;

                                    finalDonUrl = defaultDonUrl + '&set.DonationLevel=' + $('.js--don-amt-other').data('level-id') + (isNaN(customAmt) === true ? '' : '&set.Value=' + customAmt);
                                    $('.js--personal-don-submit').attr('data-final-don-url', finalDonUrl);
                                }
                            });

                            // Set default donation amount
                            $('input[name="personalDonAmt"]').eq(1).click().prop('checked', true).closest('.donation-amount-btn').addClass('active');
                            // $('.js--don-amt').text($('.form-check-label').eq(1).text().trim());


                            // redirect is now managed in amazonpay.js
                            // $('.js--personal-don-form').on('submit', function(e){
                            //   e.preventDefault();
                            //   // redirect to personal donation form with preselected amount
                            //   window.location.href = finalDonUrl;
                            // });

                        },
                        error: function (response) {
                            // $('.field-error-text').text(response.errorResponse.message);
                            // $('.ErrorContainer').removeClass('hidden');
                        }
                    }
                });
            };
            cd.getDonationFormInfo();


            // Get events by name or state
            cd.getPersonalVideo = function (frId, consId) {
                luminateExtend.api({
                    api: 'teamraiser',
                    data: 'method=getPersonalVideoUrl' +
                        '&fr_id=' + frId +
                        '&cons_id=' + consId +
                        '&response_format=json',
                    callback: {
                        success: function (response) {
                            var videoEmbedHtml;
                            if (response.getPersonalVideoUrlResponse.videoUrl) {
                                var videoUrl = response.getPersonalVideoUrlResponse.videoUrl;

                                if (videoUrl && videoUrl.indexOf('vidyard') === -1) {
                                    videoUrl = videoUrl.replace('&amp;v=', '&v=');
                                    var videoId = '';
                                    var personalVideoEmbedUrl = '';

                                    if (videoUrl.indexOf('?v=') !== -1) {
                                        videoId = videoUrl.split('?v=')[1].split('&')[0];
                                    } else if (videoUrl.indexOf('&v=') !== -1) {
                                        videoId = videoUrl.split('&v=')[1].split('&')[0];
                                    } else if (videoUrl.indexOf('/embed/') !== -1) {
                                        videoId = videoUrl
                                            .split('/embed/')[1]
                                            .split('/')[0]
                                            .split('?')[0];
                                    } else if (videoUrl.indexOf('youtu.be/') !== -1) {
                                        videoId = videoUrl
                                            .split('youtu.be/')[1]
                                            .split('/')[0]
                                            .split('?')[0];
                                    }
                                    if (videoId !== '') {
                                        personalVideoEmbedUrl = 'https://www.youtube.com/embed/' + videoId + '?wmode=opaque&amp;rel=0&amp;showinfo=0';
                                    }
                                }
                                videoEmbedHtml = '<iframe class="embed-responsive-item" src="' + personalVideoEmbedUrl + '" title="American Heart Association Heart Walk Video" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
                            } else {
                                // TODO - show default video
                                videoEmbedHtml = '<iframe width="560" height="315" src="https://www.youtube.com/embed/LryhjU1bEC4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
                            }
                            $('.js--personal-video-container').append(videoEmbedHtml);
                        },
                        error: function (response) {
                            // console.log('getPersonalVideo error: ' + response.errorResponse.message);
                        }
                    }
                });
            };
            var personalPageConsId = getURLParameter(currentUrl, 'px');
            cd.getPersonalVideo(evID, personalPageConsId);

            /*$(window).on('resize', function () {
              if (screenWidth <= 768) {
                $('.sidebar-content').insertAfter('.information-box__content').removeClass('box-shadow');
              } else {
                $('.sidebar-content').insertAfter('.sidebar img').addClass('box-shadow');
              }
            }).resize();*/
        }

        if ($('body').is('.pg_team')) {
            // Team Page
            var progress = $('#progress-amount').text();
            var goal = $('#goal-amount').text();
            cd.runThermometer(progress, goal);
            cd.setDonorRollHeight();
            cd.reorderPageForMobile();
            cd.getTeamCaptains();

            var companyIdParam = $('.js--sidebar-content').data('company');
            console.log('company id: ' + companyIdParam)

            //fill in company sidebar data
            cd.getCompanyInfo(companyIdParam);

            // populate custom team page content
            $('.js--team-text').html($('#fr_rich_text_container').html());
            // populate donor honor roll
            cd.getTeamHonorRoll();

            // build team roster
            cd.getTeamRoster = function () {
                var teamId = getURLParameter(currentUrl, 'team_id');
                luminateExtend.api({
                    api: 'teamraiser',
                    data: 'method=getParticipants' +
                        '&first_name=%25%25%25&fr_id=' + evID +
                        '&list_filter_column=reg.team_id' +
                        '&list_filter_text=' + teamId +
                        '&list_page_size=499' +
                        '&list_page_offset=0' +
                        '&response_format=json' +
                        '&list_sort_column=first_name' +
                        '&list_ascending=true',
                    callback: {
                        success: function (response) {
                            if (response.getParticipantsResponse.totalNumberResults === '0') {
                                // no search results

                            } else {
                                var participants = luminateExtend.utils.ensureArray(response.getParticipantsResponse.participant);
                                var totalParticipants = parseInt(response.getParticipantsResponse.totalNumberResults);

                                // if ( $.fn.DataTable ) {
                                //   if ( $.fn.DataTable.isDataTable('#participantResultsTable') ) {
                                //     $('#participantResultsTable').DataTable().destroy();
                                //   }              }
                                // $('#participantResultsTable tbody').empty();

                                // $('.js--num-participant-results').text((totalParticipants === 1 ? '1 Result' : totalParticipants + ' Results'));

                                $(participants).each(function (i, participant) {

                                    var participantRaised = (parseInt(participant.amountRaised) * 0.01).toFixed(2);
                                    var participantRaisedFormmatted = participantRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,").replace('.00', '');

                                    $('#team-roster tbody').append('<tr class="' + (i > 4 ? 'd-none' : '') + '"><td class="donor-name">' + (participant.aTeamCaptain === "true" ? ' <span class="coach"><svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="23" height="23" viewBox="0 0 23 23"><defs><pattern id="a" preserveAspectRatio="xMidYMid slice" width="100%" height="100%" viewBox="0 0 441 443"><image width="441" height="443" xlink:href="data:image/png;base64,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"></image></pattern></defs><rect width="23" height="23" fill="url(#a)"></rect></svg> </span>' : '') + '<a href="' + participant.personalPageUrl + '">' +
                                        participant.name.first + ' ' + participant.name.last +
                                        '</a></td><td class="raised" data-sort="' + participantRaisedFormmatted + '"><span><strong>$' + participantRaisedFormmatted + '</strong></span></td><td><a href="' + participant.donationUrl + '">' + (screenWidth <= 480 ? 'Donate' : 'Donate to ' + participant.name.first) + '</a></td></tr>');
                                    if (participant.aTeamCaptain === 'true') {
                                        $('.js--team-captain-link').attr('href', participant.personalPageUrl).text(participant.name.first + ' ' + participant.name.last);
                                    }
                                });

                                if (totalParticipants > 5) {
                                    $('.js--more-participant-results').removeAttr('hidden');
                                }
                                // cd.initializeTeamRosterTable();

                                //add call to hook donate button with payment type selections
                                addPaymentTypesOnSearch();
                                $('.js--more-participant-results').on('click', function (e) {
                                    e.preventDefault();
                                    $('#team-roster tr').removeClass('d-none');
                                    $(this).attr('hidden', true);
                                });
                            }
                        }
                    },
                    error: function (response) {
                        $('#error-participant').removeAttr('hidden').text(response.errorResponse.message);
                        // console.log('error response: ', response);
                    }
                });
            };
            cd.getTeamRoster();

        }



        if ($('body').is('.pg_company')) {
            // Company Page

            // Populate company name from page title
            var pageTitle = jQuery('head title').text().trim();
            var start_pos = pageTitle.indexOf(':') + 1;
            var end_pos = pageTitle.indexOf('- Field Day', start_pos);
            var currentCompanyName = pageTitle.substring(start_pos, end_pos).trim();
            var currentCompanyId = getURLParameter(currentUrl, 'company_id');
            $('.js--company-name').text(currentCompanyName);
            // var isParentCompany = ($('#company_hierarchy_list_component .lc_Row1').length ? true : false)
            var isParentCompany = ($('.js--company-hierarchy-list-container .lc_Row1').length ? true : false);

            console.log('Parent company: ' + isParentCompany);

            var allCompanyData = [{
                id: currentCompanyId,
                name: currentCompanyName
            }];
            // allCompanyData.push({currentCompanyId, companyName});
            // get child company IDs
            if (isParentCompany) {

                $('.js--company-hierarchy-list-container .trr-td a').each(function () {
                    var childCompanyLink = $(this).attr('href');
                    var childCompanyName = $(this).text();
                    var childCompanyId = getURLParameter(childCompanyLink, 'company_id');
                    allCompanyData.push({id: childCompanyId, name: childCompanyName});
                    // allCompanyData.id
                });
            } else {

                $('.js--company-multiple-locations').hide();

                luminateExtend.api({
                    api: 'teamraiser',
                    data: 'method=getCompanyList&fr_id=' + evID +
                        '&include_all_companies=true&response_format=json',
                    callback: {
                        success: function (response) {
                            if (!$.isEmptyObject(response.getCompanyListResponse)) {
                                var companyItems = luminateExtend.utils.ensureArray(response.getCompanyListResponse.companyItem);

                                $(companyItems).each(function (i, company) {
                                    if (company.companyId === currentCompanyId) {
                                        var parentCompanyId = company.parentOrgEventId;

                                        luminateExtend.api({
                                            api: 'teamraiser',
                                            data: 'method=getCompaniesByInfo' +
                                                '&company_id=' + parentCompanyId +
                                                '&response_format=json',
                                            callback: {
                                                success: function (response) {
                                                    if (response.getCompaniesResponse.totalNumberResults !== '0') {
                                                        $('.js--company-name').before('<small><a href="' + response.getCompaniesResponse.company.companyURL + '">' + response.getCompaniesResponse.company.companyName + '</a></small>');
                                                    }
                                                },
                                                error: function (response) {
                                                    $('.js--company-results-container').removeAttr('hidden').text(response.errorResponse.message);
                                                }
                                            }
                                        });

                                    }
                                });
                            }
                        },
                        error: function (response) {
                            // console.log('getCompanyList error: ' + response.errorResponse.message);
                        }
                    }
                });
            }

            var raised = $('.indicator-title:contains("Company Fundraising Status")').parent().find('.amount-raised-value').text();

            if (raised) {
                $('#progress-amount').html(raised);
            }

            // Get company goal
            $('.indicator-title:contains("Company Fundraising")').closest('.tr-status-indicator-container').addClass('default-company-thermometer');
            // var companyoGoalText = $('.default-company-thermometer .total-goal-value').text();
            var companyoGoalText = $('.indicator-title:contains("Company Fundraising Status")').parent().find('.total-goal-value').text();


            var companyGoal = companyoGoalText.split('.');
            $('#goal-amount').html(companyGoal[0]);

            // populate custom personal page content
            $('.js--company-text').html($('#fr_rich_text_container').html());
            $('.js--company-logo').html($('#company_banner').html());

            var progress = $('#progress-amount').text();
            var goal = $('#goal-amount').text();
            if (parseInt(progress) > parseInt(goal) ) {
              $('.js--thermometer-trophy-goal').removeClass('d-none');
              $('.js--thermometer-trophy').addClass('d-none');
            }
            cd.runThermometer(progress, goal);
            cd.reorderPageForMobile();

            cd.getCompanyInfo(companyIdParam);
            console.log('called data');


            // Reset selected sort option
            $('.nav-tabs .nav-link').click(function () {
                $('.selected-sort-option').html('Amount Raised');
            });

            // Build company team roster
            // build team roster
            var numTeamRows = 0;

            cd.getCompanyTeams = function (companyId, companyName, numCompanies, companyIndex) {
                luminateExtend.api({
                    api: 'teamraiser',
                    data: 'method=getTeamsByInfo' +
                        '&team_name=%25%25%25' +
                        '&fr_id=' + evID +
                        '&team_company_id=' + companyId +
                        '&list_page_size=499' +
                        '&list_page_offset=0' +
                        '&response_format=json' +
                        '&list_sort_column=team_name' +
                        '&list_ascending=true',
                    callback: {
                        success: function (response) {
                            if (response.getTeamSearchByInfoResponse.totalNumberResults === '0') {
                                // no search results

                            } else {
                                var teams = luminateExtend.utils.ensureArray(response.getTeamSearchByInfoResponse.team);
                                $(teams).each(function (i, team) {
                                    var teamRaised = (parseInt(team.amountRaised) * 0.01).toFixed(2);
                                    var teamRaisedFormmatted = teamRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,").replace('.00', '');
                                    $('#team-roster tbody').append('<tr class="' + (numTeamRows > 4 ? 'd-none' : '') + '"> <td class="team-name"> <a href="' + team.teamPageURL + '" data-sort="' + team.name + '">' + team.name + '</a> </td><td class="donor-name"> <a href="TR/?px=' + team.captainConsId + '&pg=personal&fr_id=' + team.EventId + '" data-sort="' + team.captainFirstName + ' ' + team.captainLastName + '">' + team.captainFirstName + ' ' + team.captainLastName + '</a> </td><td class="company-name"> <a href="' + luminateExtend.global.path.secure + 'TR/?pg=company&company_id=' + team.companyId + '&fr_id=' + team.EventId + '" data-sort="' + companyName + '">' + companyName + '</a> </td><td class="raised" data-sort="' + teamRaisedFormmatted + '"> <span><strong>$' + teamRaisedFormmatted + '</strong></span> </td><td> <a href="' + team.joinTeamURL + '">' + (screenWidth <= 480 ? 'Join' : 'Join Team') + '</a> </td></tr>');
                                    numTeamRows++;
                                });

                                $('.js--more-team-results').on('click', function (e) {
                                    e.preventDefault();
                                    $('#team-roster tr').removeClass('d-none');
                                    $(this).attr('hidden', true);
                                });
                            }

                            if (companyIndex === numCompanies) {
                                setTimeout(function () {
                                    cd.initializeTeamRosterTable();
                                    var totalTeams = $('.team-name').length;
                                    var totalTeamsText = totalTeams > 1 ? ' Teams' : ' Team';
                                    $('.js--num-company-teams').text(totalTeams + totalTeamsText);
                                    if (totalTeams > 5) {
                                        $('.js--more-team-results').removeAttr('hidden');
                                    }
                                }, 250);
                            }
                        }
                    },
                    error: function (response) {
                        $('#error-participant').removeAttr('hidden').text(response.errorResponse.message);
                        // console.log('error response: ', response);
                    }
                });
            };

            cd.buildCompanyTeamRoster = function () {
                var numCompanies = allCompanyData.length;
                for (var i = 0, l = allCompanyData.length; i < l; i++) {
                    var company = allCompanyData[i];
                    var companyIndex = i + 1;
                    var companyId = company.id;
                    var companyName = company.name;
                    cd.getCompanyTeams(companyId, companyName, numCompanies, companyIndex);
                }
            }

            cd.buildCompanyTeamRoster();
            var numWalkerRows = 0;

            // build team roster
            cd.getCompanyParticipants = function () {
                var numCompanies = allCompanyData.length - 1;
                var company = allCompanyData[0];
                var companyIndex = 0;
                var companyId = company.id;
                var companyName = company.name;

                $('#participant-roster tbody').html('');
                var participants = [];

                cd.getAllParticipants = function (pgcnt) {
                    var deferred = $.Deferred();
                    var companyId = allCompanyData[companyIndex].id;
                    var companyName = allCompanyData[companyIndex].name;

                    $.ajax({
                        type: 'GET',
                        url: luminateExtend.global.path.secure + 'CRTeamraiserAPI',
                        data: {
                            method: 'getParticipants',
                            api_key: luminateExtend.global.apiKey,
                            v: '1.0',
                            team_name: '%%%',
                            fr_id: evID,
                            list_filter_column: 'team.company_id',
                            list_filter_text: companyId,
                            list_page_size: '499',
                            list_page_offset: pgcnt,
                            response_format: 'json',
                        },
                        dataType: 'json'
                    }).done(function (response) {
                        if (response.getParticipantsResponse.totalNumberResults === '0') {
                            if (allCompanyData[companyIndex + 1] != undefined) {
                                companyIndex = companyIndex + 1;
                                pgcnt = 0;
                                cd.getAllParticipants(pgcnt).done(function() {
                                    deferred.resolve();
                                });
                            } else {
                                deferred.resolve();
                            }
                        } else {
                            if (typeof (response.getParticipantsResponse.participant) == "undefined") {
                                if (allCompanyData[companyIndex + 1] != undefined) {
                                    companyIndex = companyIndex + 1;
                                    pgcnt = 0;
                                    cd.getAllParticipants(pgcnt).done(function() {
                                        deferred.resolve();
                                    });
                                } else {
                                    deferred.resolve();
                                }
                            } else {
                                pgcnt++;
                                var participantList = luminateExtend.utils.ensureArray(response.getParticipantsResponse.participant);
                                $(participantList).each(function (i, participant) {
                                    participantList[i].companyId = companyId;
                                    participantList[i].companyName = companyName;
                                });
                                participants = participants.concat(participantList);
                                cd.getAllParticipants(pgcnt).done(function() {
                                    deferred.resolve();
                                });
                            }
                        }
                    })
                    .fail(function (response) {
                        deferred.reject();
                        $('#error-participant').removeAttr('hidden').text(response.errorResponse.message);
                    });

                    return deferred.promise();
                }

                var numCompanies = allCompanyData.length - 1;
                var company = allCompanyData[0];
                var ipCompanyIndex = 0;
                var companyId = company.id;
                var companyName = company.name;
                var indivpgcnt = 0;

                cd.getCompanyIndividualParticipants = function (indivpgcnt) {
                    var deferred = $.Deferred();
                    var companyId = allCompanyData[ipCompanyIndex].id;
                    var companyName = allCompanyData[ipCompanyIndex].name;

                    $.ajax({
                        type: 'GET',
                        url: luminateExtend.global.path.secure + 'CRTeamraiserAPI',
                        data: {
                            method: 'getParticipants',
                            api_key: luminateExtend.global.apiKey,
                            v: '1.0',
                            first_name: '%%%',
                            fr_id: evID,
                            list_filter_column: 'reg.company_id',
                            list_filter_text: companyId,
                            list_page_size: '499',
                            list_page_offset: indivpgcnt,
                            response_format: 'json',
                        },
                        dataType: 'json'
                    }).done(function (indivResponse2) {
                        if (indivResponse2.getParticipantsResponse.totalNumberResults === '0') {
                            if (allCompanyData[ipCompanyIndex + 1] != undefined) {
                                ipCompanyIndex = ipCompanyIndex + 1;
                                indivpgcnt = 0;
                                cd.getCompanyIndividualParticipants(indivpgcnt).done(function() {
                                    deferred.resolve();
                                });
                            } else {
                                deferred.resolve();
                            }
                        } else {
                            if (typeof (indivResponse2.getParticipantsResponse.participant) == "undefined") {
                                if (allCompanyData[ipCompanyIndex + 1] != undefined) {
                                    ipCompanyIndex = ipCompanyIndex + 1;
                                    indivpgcnt = 0;
                                    cd.getCompanyIndividualParticipants(indivpgcnt).done(function() {
                                        deferred.resolve();
                                    });
                                } else {
                                    deferred.resolve();
                                }
                            } else {
                                indivpgcnt++;
                                var indivParticipantList2 = luminateExtend.utils.ensureArray(indivResponse2.getParticipantsResponse.participant);
                                $(indivParticipantList2).each(function (i, participant) {
                                    indivParticipantList2[i].companyId = companyId;
                                    indivParticipantList2[i].companyName = companyName;
                                });
                                participants = participants.concat(indivParticipantList2);
                                cd.getCompanyIndividualParticipants(indivpgcnt).done(function() {
                                    deferred.resolve();
                                });
                            }
                        }
                    })
                    .fail(function (indivResponse2) {
                        deferred.reject();
                        $('#error-participant').removeAttr('hidden').text(indivResponse2.errorResponse.message);
                    });

                    return deferred.promise();
                }

                $.when(cd.getCompanyIndividualParticipants(0), cd.getAllParticipants(0)).done(function (result) {
                    if (participants.length > 0) {
                        cd.buildParticipantList(participants);
                    } else {
                        // console.log('testing length of participants array - not greater than 0');
                    }
                });
            };

            cd.getCompanyParticipants();

            cd.buildParticipantList = function (participants) {
                $(participants).each(function (i, participant) {
                    var participantRaised = (parseInt(participant.amountRaised) * 0.01).toFixed(2);
                    var participantRaisedFormmatted = participantRaised.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,").replace('.00', '');

                    $('#participant-roster tbody').append('<tr class="' + (numWalkerRows > 4 ? 'd-none' : '') + '"><td class="participant-name"><a href="' + participant.personalPageUrl + '">' +
                        participant.name.first + ' ' + participant.name.last +
                        '</a>' + (participant.aTeamCaptain === "true" ? ' <span class="coach">- Team Captain</span>' : '') + '</td><td class="company-name"> <a href="' + luminateExtend.global.path.secure + 'TR/?pg=company&company_id=' + participant.companyId + '&fr_id=' + participant.eventId + '" data-sort="' + participant.companyName + '">' + participant.companyName + '</a> </td><td class="raised" data-sort="' + participantRaisedFormmatted + '"><span><strong>$' + participantRaisedFormmatted + '</strong></span></td><td><a href="' + participant.donationUrl + '">' + (screenWidth <= 480 ? 'Donate' : 'Donate to ' + participant.name.first) + '</a></td></tr>');
                    numWalkerRows++;
                });

                $('.js--more-participant-results').on('click', function (e) {
                    e.preventDefault();
                    $('#participant-roster tr').removeClass('d-none');
                    $(this).attr('hidden', true);
                });

                setTimeout(function () {
                    cd.initializeParticipantRosterTable();
                    var totalParticipants = $('.participant-name').length;
                    var totalParticipantsText = totalParticipants > 1 ? ' Teammates' : ' Teammate';
                    $('.js--num-company-participants').text(totalParticipants + totalParticipantsText);
                    if (numWalkerRows > 5) {
                        $('.js--more-participant-results').removeAttr('hidden');
                    }
                }, 250);

                //add call to hook donate button with payment type selections
                $('a:contains(Donat)').on('click', function (e) {
                    e.preventDefault();
                    if (!$(this).hasClass('js--team-member-donate')) {
                        if ($(this).next('.paymentSelType').length > 0) {
                            $(this).next('.paymentSelType').remove();
                        } else {
                            var dlink = $(this).attr("href");
                            var fr_id = $.getCustomQuerystring(dlink, "FR_ID");
                            var px = $.getCustomQuerystring(dlink, "PROXY_ID");
                            var pt = $.getCustomQuerystring(dlink, "PROXY_TYPE");

                            var html = "<div class='paymentSelType text-center' style='padding-top:10px;'>" +
                                "<h2 class='h6'>How would you like to donate?</h2>" +
                                "<div class='payment-options-container'><a href='" + dlink + "'><img src='https://www2.heart.org/images/content/pagebuilder/credit-card-logos2.png' alt='Donate with Visa, MasterCard, American Express or Discover cards'/></a>" +
                                "<a href='" + default_path + "/site/SPageNavigator/fieldday_donate_amazon.html?FR_ID=" + fr_id + "&mfc_pref=T&PROXY_ID=" + px + "&PROXY_TYPE=" + pt + "' class='amazon'><img src='https://donatenow.heart.org/images/amazon-payments_inactive.png' alt='Donate with Amazon Pay'/></a>" +
                                "<a href='" + default_path + "/site/SPageNavigator/fieldday_donate_googlepay.html?FR_ID=" + fr_id + "&mfc_pref=T&PROXY_ID=" + px + "&PROXY_TYPE=" + pt + "' class='googlepay'><img src='https://www2.heart.org/donation-forms/donatenow/images/googlepay-button.png' alt='Donate with Google Pay'/></a>" +
                                "<a href='" + default_path + "/site/SPageNavigator/fieldday_donate_applepay.html?FR_ID=" + fr_id + "&mfc_pref=T&PROXY_ID=" + px + "&PROXY_TYPE=" + pt + "' class='applepay hidden-md hidden-lg'><img src='https://www2.heart.org/donation-forms-braintree/donatenow/images/DonateBlack_32pt_@2x.png' alt='ApplePay'/></a>" +
                                "<a href='" + default_path + "/site/SPageNavigator/fieldday_donate_venmo.html?FR_ID=" + fr_id + "&mfc_pref=T&PROXY_ID=" + px + "&PROXY_TYPE=" + pt + "' class='venmo hidden-md hidden-lg'><img src='https://www2.heart.org/donation-forms/donatenow/images/venmo-button.png' alt='Venmo'/></a>" +
                                "<a href='" + dlink + "&paypal=true'><img src='https://www2.heart.org/images/content/pagebuilder/PP_logo_h_100x26.png'/ alt='Donate with PayPal'></a></div>";
                            $(this).after(html);
                        }
                    }
                });

            }

        }



        if ($('body').is('.pg_informational')) {
            // Custom TR Page
        }


        if ($('body').is('.pg_FieldDay_Search')) {
            // FieldDay Search Page
            var clearSearchResults = function () {
                $('.js--event-results-container, .alert').attr('hidden', true);
                $('.js--event-results-rows').html('');
                $('.js--participant-results-container, .alert').attr('hidden', true);
                $('.js--participants-results-rows').html('');
                $('.js--team-results-container, .alert').attr('hidden', true);
                $('.js--team-results-rows').html('');
            }

            // Search by Company
            $('.js--company-search-form').on('submit', function (e) {
                e.preventDefault();
                clearSearchResults();
                var companySearched = encodeURIComponent($('#companyNameSearch').val());
                cd.getCompanies(companySearched, isCrossEventSearch === "true" ? true : false);
            });

            // Search by Event
            $('.js--zip-search-form').on('submit', function (e) {
                e.preventDefault();
                clearSearchResults();
                var zipSearched = encodeURIComponent($('#zipCodeSearch').val());
                cd.getEventsByDistance(zipSearched, isCrossEventSearch === "true" ? true : false);

            });
            $('#eventStateSearch').on('change', function () {
                clearSearchResults();
                var stateSearched = encodeURIComponent($('#eventStateSearch').val());
                cd.getEventsByState(stateSearched, isCrossEventSearch === "true" ? true : false);
            });

            $('.js--state-search-form').on('submit', function (e) {
                e.preventDefault();
                clearSearchResults();
                var stateSearched = encodeURIComponent($('#eventStateSearch').val());
                cd.getEventsByDistance(stateSearched, isCrossEventSearch === "true" ? true : false);
            });



            // Search page by Participant
            $('.js--participant-search-form').on('submit', function (e) {
                e.preventDefault();
                clearSearchResults();
                var firstName = encodeURIComponent($('#participantFirstName').val());
                var lastName = encodeURIComponent($('#participantLastName').val());

                cd.getParticipants(firstName, lastName, (isCrossEventSearch === "true" ? true : false));
            });

            // Search by Team
            $('.js--team-search-form').on('submit', function (e) {
                e.preventDefault();
                clearSearchResults();
                var teamName = encodeURIComponent($('#teamNameSearch').val());
                cd.getTeams(teamName, (isCrossEventSearch === "true" ? true : false));
            });


            if (searchType) {
                cd.autoSearchParticipant = function () {
                    var firstNameVal = getURLParameter(currentUrl, 'first_name') ? getURLParameter(currentUrl, 'first_name') : '';
                    var lastNameVal = getURLParameter(currentUrl, 'last_name') ? getURLParameter(currentUrl, 'last_name') : '';

                    if (!firstNameVal && !lastNameVal) {
                        // General participant search from greeting page. Show all walkers
                        cd.getParticipants('%25%25%25', '%25%25%25', (isCrossEventSearch === "true" ? true : false));
                    } else {
                        firstNameVal = decodeURIComponent(firstNameVal);
                        lastNameVal = decodeURIComponent(lastNameVal);

                        $('#participantFirstName').val(firstNameVal);
                        $('#participantLastName').val(lastNameVal);

                        cd.getParticipants(firstNameVal, lastNameVal, (isCrossEventSearch === "true" ? true : false));
                    }

                }

                cd.autoSearchTeam = function () {
                    var teamName = getURLParameter(currentUrl, 'team_name') ? getURLParameter(currentUrl, 'team_name') : '';
                    teamName = decodeURIComponent(teamName);
                    $('#teamNameSearch').val(teamName);

                    cd.getTeams(teamName, (isCrossEventSearch === "true" ? true : false));
                }

                cd.autoSearchCompany = function () {
                    var companyName = getURLParameter(currentUrl, 'company') ? getURLParameter(currentUrl, 'company') : '';
                    companyName = decodeURIComponent(companyName);
                    $('#companyNameSearch').val(companyName);
                    var crossEventSearch = (isCrossEventSearch === "true" ? true : false);
                    console.log(crossEventSearch);

                    cd.getCompanies(companyName, (isCrossEventSearch === "true" ? true : false));
                }

                cd.autoSearchZip = function () {
                    var searchZip = getURLParameter(currentUrl, 'zip') ? getURLParameter(currentUrl, 'zip') : '';
                    $('#zipCodeSearch').val(searchZip);
                    cd.getEventsByDistance(searchZip, (isCrossEventSearch === "true" ? true : false));
                }

                cd.autoSearchState = function () {
                    var searchState = getURLParameter(currentUrl, 'state') ? getURLParameter(currentUrl, 'state') : '';
                      $('#eventStateSearch').val(searchState);
                    cd.getEventsByState(searchState, (isCrossEventSearch === "true" ? true : false));
                }

                if (searchType === 'event') {
                    cd.autoSearchZip();
                } else if (searchType === 'participant') {
                    cd.autoSearchParticipant();
                    // Switch to walker tab
                    $('#searchParticipantTab').tab('show');
                } else if (searchType === 'team') {
                    cd.autoSearchTeam();
                    // Switch to team tab
                    $('#searchTeamTab').tab('show');
                } else if (searchType === 'zip') {
                    cd.autoSearchZip();
                    // Switch to team tab
                    $('#searchEventTab').tab('show');
                  } else if (searchType === 'state') {
                      cd.autoSearchState();
                      // Switch to team tab
                      $('#searchEventTab').tab('show');
                  } else if (searchType === 'company') {
                   cd.autoSearchCompany();
                   // Switch to company tab
                   $('#searchCompanyTab').tab('show');
                }
            }
        }

        //Landong Page

        if($('body').is('.pg_FieldDay_Landing_Page')) {
          //Search functionality

          //State and Zip search
          $('.js--zip-search').on('submit', function (e) {
              e.preventDefault();
              $('.js--event-search-results').html('');
              var zipSearched = encodeURIComponent($('.js--zip-search-val').val());
              cd.getEventsByDistanceLanding(zipSearched);
          });
          $('.js--state-search-val').on('change', function () {
              $('.js--event-search-results').html('');
              var eventState = encodeURIComponent($('.js--state-search-val').val());
              cd.getEventsByStateLanding(eventState);
          });

          //Company and participant search
          $('.js--page-company-search').on('submit', function (e) {
              e.preventDefault();
              $('.js--participant-search-results').html('');
              var companyName = encodeURIComponent($('.js--page-company-search-val').val());
              cd.getCompaniesLanding(companyName);
          });
          $('.js--page-participant-search').on('submit', function (e) {
              e.preventDefault();
              $('.js--participant-search-results').html('');
              var firstName = encodeURIComponent($('.js--page-participant-search-first-val').val());
              var lastName = encodeURIComponent($('.js--page-participant-search-last-val').val());
              cd.getParticipantsLanding(firstName, lastName);
          });

          $('.js--card-content').each(function(){
            var highestBox = 0;

            if($(this).height() > highestBox) {
              highestBox = $(this).height();
            }

            $('.js--card-content').height(highestBox);
          });

         }
         //End Landing Page
    });
}(jQuery));

var cdSortByColumnNumber = 1;
var cdSortByText = 'Amount Raised';
var direction = 'desc';

var cdSortRoster = function (element, isParticipantRoster) {
    var roster = isParticipantRoster ? cdParticipantRosterTable : cdTeamRosterTable;
    direction = roster.order()[0][1] === 'desc' ? 'asc' : 'desc';
    roster.order([cdSortByColumnNumber, direction]).draw();
    $('.selected-sort-option').html(cdSortByText);
    setIconDirection(element);
};

var cdSetSortBy = function (columnNumber, element, isParticipantRoster) {
    cdSortByColumnNumber = columnNumber;
    cdSortByText = $(element).text();
    var sortIconElement = $(element).parent().prev('.selected-sort-option');
    direction = 'desc';
    setIconDirection(element);
    cdSortRoster(sortIconElement, isParticipantRoster ? isParticipantRoster : false);
};

var setIconDirection = function (element) {
    var icon = $(element).children('i');

    if (direction === 'asc') {
        icon.removeClass('fa-chevron-down');
        icon.addClass('fa-chevron-up');
    } else {
        icon.removeClass('fa-chevron-up');
        icon.addClass('fa-chevron-down');
    }
};


var toggleMultiEventInfo = function (elem) {
    $(elem).toggleClass('open');
    $('.js--multi-event-locations').slideToggle();

    if ($('.multi-event-info-toggler i').hasClass('fa-plus')) {
        $('.multi-event-info-toggler i').removeClass('fa-plus');
        $('.multi-event-info-toggler i').addClass('fa-minus');
    } else {
        $('.multi-event-info-toggler i').addClass('fa-plus');
        $('.multi-event-info-toggler i').removeClass('fa-minus');
    }
};
