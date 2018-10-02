'use strict';
(function ($) {
  $(document).ready(function ($) {
    // New NCHW JS goes here...
    // Example of retrieving data attribute (fr_id) from the body tag
    var evID = $('body').data('fr-id') ? $('body').data('fr-id') : null;
    console.log("Event ID = ",evID);

    //mobile nav
    jQuery('#mobileNav .sub-nav-toggle-link').click(function () {
      //slide up all the link lists
      jQuery('.sub-nav').slideUp();
      jQuery(this).removeClass('sub-nav-open').parent().removeClass('sub-active');
      //slide down the link list below the h3 clicked - only if its closed
      if (!jQuery(this).next().is(':visible')) {
        jQuery(this).next().slideDown();
        jQuery(this).removeClass('sub-nav-open').parent().removeClass('sub-active');
        jQuery(this).addClass('sub-nav-open').parent().addClass('sub-active');
      }
    });

    //sponsor slider
    jQuery('.sponsor_slider .local_sponsors').unslider({
      selectors: {
        container: 'div.tr_sponsorship_logos',
        slides: 'div.tr_sponsorship_logo'
      },
      autoplay: true
    });

    if ($('body').is('.pg_entry')) {
      // Greeting page-specific JS goes here
      console.log('testing the new main.js file')
      $('#insert_ele_welcome').appendTo('#welcome .row');
      $('#insert_ele_contact').appendTo('#contact .row');

      if(!$('#insert_ele_subtitle:empty').length) {
        $('#insert_ele_subtitle').insertAfter('.greeting_hero_inner h1');
      }

      $('.social_icons a').each(function () {
        if ($(this).attr('href').length > 0) {
          $(this).parent().addClass('show_icon');
        }
      });
      $('#top_lists').hide();

      // getTopParticipantsData
      var participantPromise = new Promise(function(resolve, reject) {
        luminateExtend.api({
          api: 'teamraiser',
          data: 'method=getTopParticipantsData&fr_id=' + evID + '&response_format=json',
          callback: {
            success: function (response) {
              if (!$.isEmptyObject(response.getTopParticipantsDataResponse)) {
                var participantData = luminateExtend.utils.ensureArray(response.getTopParticipantsDataResponse.teamraiserData);
                console.log(participantData);
                console.log('participantData.length = ',participantData.length);
                if (participantData.length > 0) {
                  var sortedParticipantsData = participantData.slice(0, 5);
                  for (var i = 0, len = sortedParticipantsData.length; i < len; i++) {
                    sortedParticipantsData[i].total = Number(sortedParticipantsData[i].total.replace('$', '').replace(',', ''));
                    if (sortedParticipantsData[i].total > 0) {
                      var participantDataOutput = '<tr><td><a href="' + luminateExtend.global.path.nonsecure + 'TR/?fr_id=' + evID + '&pg=personal&px=' + sortedParticipantsData[i].id + '">' + sortedParticipantsData[i].name + '</a></td><td><span class="pull-right">$' + sortedParticipantsData[i].total.formatMoney(0) + '</span></td></tr>';
                      $('.insert_top-participants-list').append(participantDataOutput);

                    }
                  }
                }
              }
              resolve();
            },
            error: function (response) {
              console.log('getTopParticipants error: ' + response.errorResponse.message);
              reject(Error());
            }
          }
        });
      });


      // getTopTeamsData
      var teamPromise = new Promise(function(resolve, reject) {
        luminateExtend.api({
          api: 'teamraiser',
          data: 'method=getTopTeamsData&fr_id=' + evID + '&response_format=json',
          callback: {
            success: function (response) {
              if (!$.isEmptyObject(response.getTopTeamsDataResponse)) {
                var teamData = luminateExtend.utils.ensureArray(response.getTopTeamsDataResponse.teamraiserData);
                console.log(teamData);
                console.log('teamData.length = ',teamData.length);
                if (teamData.length > 0) {
                  var sortedTeamsData = teamData.slice(0, 5);
                  for (var i = 0, len = sortedTeamsData.length; i < len; i++) {
                    sortedTeamsData[i].total = Number(sortedTeamsData[i].total.replace('$', '').replace(',', ''));
                    if (sortedTeamsData[i].total > 0) {
                      var teamsData = '<tr><td><a href="' + luminateExtend.global.path.nonsecure + 'TR/?pg=team&team_id=' + sortedTeamsData[i].id + '&fr_id=' + evID + '">' + sortedTeamsData[i].name + '</a></td><td><span class="pull-right">$' + sortedTeamsData[i].total.formatMoney(0) + '</span></td></tr>';
                      $('.insert_top-teams-list').append(teamsData);
                    }
                  }
                }
              }
              resolve();
            },
            error: function (response) {
              console.log('getTopTeams error: ' + response.errorResponse.message);
              reject(Error());
            }
          }
        });
      });

      // getTopCompaniesByInfo
      var companyPromise = new Promise(function(resolve, reject) {
        luminateExtend.api({
          api: 'teamraiser',
          data: 'method=getCompaniesByInfo&fr_id=' + evID + '&response_format=json',
          callback: {
            success: function (response) {
              if (!$.isEmptyObject(response.getCompaniesResponse)) {
                var companyData = luminateExtend.utils.ensureArray(response.getCompaniesResponse.company);
                console.log(companyData);
                console.log('companyData.length = ',companyData.length);
                if (companyData.length > 0) {
                  var sortedCompaniesData = companyData.slice(0, 5);
                  // build company roster here
                  for (var i = 0, len = sortedCompaniesData.length; i < len; i++) {
                    if (sortedCompaniesData[i].amountRaised > 0) {
                      var companyData = '<tr><td><a href="' + sortedCompaniesData[i].companyURL + '">' + sortedCompaniesData[i].companyName + '</a></td><td><span class="pull-right">$' + (sortedCompaniesData[i].amountRaised / 100).formatMoney(0) + '</span></td></tr>';
                      $('.insert_top-companies-list').append(companyData);
                    }
                  }
                }
              }
              resolve();
            },
            error: function (response) {
              console.log('getTopCompanies error: ' + response.errorResponse.message);
              reject(Error());
            }
          }
        });
      });
      var partP;
      var teamP;
      var compP;
      participantPromise.then(function() {
        if( !$.trim( $('.insert_top-participants-list').html() ).length ) {
          console.log('parts empty');
          partP = false;
          $('.top-participants-list').hide();
        }
        else {
          console.log("parts no empty");
          partP = true;
          $('#top_lists').show();
          $('.top-participants-list').show();
        }
      }, function(err) {
        console.log(err);
      });

      teamPromise.then(function() {
        if( !$.trim( $('.insert_top-teams-list').html() ).length ) {
          console.log('teams empty');
          teamP = false;
          $('.top-teams-list').hide();
        }
        else {
          console.log("teams no empty");
          teamP = true;
          $('#top_lists').show();
          $('.top-teams-list').show();
        }
      }, function(err) {
        console.log(err);
      });

      companyPromise.then(function() {
        if( !$.trim( $('.insert_top-companies-list').html() ).length ) {
          console.log('comps empty');
          compP = false;
          $('.top-companies-list').hide();
        }
        else {
          console.log("comps no empty");
          compP = true;
          $('#top_lists').show();
          $('.top-companies-list').show();
        }
      }, function(err) {
        console.log(err);
      });

      setTimeout(function(){
        console.log(partP+' '+teamP+' '+compP);
        if ( partP == false) {
            if ( teamP == false) {
                // No part list and no team list
                if ( compP == false) {
                    // No lists are showing
                    // No adjustments necessary
                } else {
                    // Only company list is showing
                    $('.top-companies-list').addClass('col-md-offset-2 col-md-8');
                    $('.top-companies-list').removeClass('col-md-offset-0 col-md-4');
                }
            } else {
                // No part list but yes team list
                if ( compP == false) {
                    // Only team list is showing
                    $('.top-teams-list').addClass('col-md-offset-2 col-md-8');
                    $('.top-teams-list').removeClass('col-md-offset-0 col-md-4');
                } else {
                    // Team list and company list
                    $('.top-companies-list').addClass('col-md-6');
                    $('.top-companies-list').removeClass('col-md-4');
                    $('.top-teams-list').addClass('col-md-6');
                    $('.top-teams-list').removeClass('col-md-4');
                }
            }
        } else {
            if ( teamP == false) {
                // Yes part list and no team list
                if ( compP == false) {
                    // Only part list is showing
                    $('.top-participants-list').addClass('col-md-offset-2 col-md-8');
                    $('.top-participants-list').removeClass('col-md-offset-0 col-md-4');
                } else {
                    // Part list and company list are showing
                    $('.top-companies-list').addClass('col-md-6');
                    $('.top-companies-list').removeClass('col-md-4');
                    $('.top-participants-list').addClass('col-md-6');
                    $('.top-participants-list').removeClass('col-md-4');
                }
            } else {
                // Part list and team list
                if ( compP == false) {
                    // Part list and team list
                    $('.top-participants-list').addClass('col-md-6');
                    $('.top-participants-list').removeClass('col-md-4');
                    $('.top-teams-list').addClass('col-md-6');
                    $('.top-teams-list').removeClass('col-md-4');
                } else {
                    // Part list and team list and comp list
                    // No adjustments necessary
                }
            }
        }
      }, 1000);

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
    }
  });
}(jQuery));
