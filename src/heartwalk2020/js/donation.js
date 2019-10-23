'use strict';
(function ($) {
  $(document).ready(function () {
  // Heart Walk 2020 Donation JS
    //Donation Levels
    // var amountLevel = readCookie('level');
    var amountLevel = null;
    // replace default radio button check if page is errored out
    jQuery('input[name="level_flexibleexpandedsubmit"]:checked').closest('.donation-level-container').addClass('active');

    if (amountLevel == null || amountLevel == "") {
       jQuery(".donation-level-container").each(function(i){
          if (jQuery(this).find('input:checked').length > 0) {
             document.cookie="level=level"+i;
             amountLevel="level"+i;
             return; 
          }
       });
    }

    $('.donation-level-container:last-child').addClass('enterAmt'); 
    var donateSpan = '<span class="donation-level-total-amount"></span>';
    $('.donation-level-container').each(function(i){
        $(this).addClass('level'+i);
        i++;
    });   
    $(".donation-level-amount-container").each(function() {
        $(this).text($(this).text().replace(".00", ""));
    });     
    $('.donation-level-container').click(function(){
        $('.donation-level-container').removeClass('active');
        $('.formMessage p').removeClass('active');
        if($(this).hasClass('level0')){
            var level = 'level0';
        }else if ($(this).hasClass('level1')){
            var level = 'level1';
        }else if ($(this).hasClass('level2')){
            var level = 'level2';
        }else if ($(this).hasClass('level3')){
            var level = 'level3';
        }else if ($(this).hasClass('level4')){
            var level = 'level4';
        }
        document.cookie="level="+level;
        $(this).addClass('active');
        var amt = $(this).find('.donation-level-amount-container').text();
        //$('.donateSubmit').text('Donate '+amt);        
        if($('.donation-level-container.active').hasClass('level0')) {
            $('.formMessage .level0').addClass('active');
        }else if ($('.donation-level-container.active').hasClass('level1')) {
            $('.formMessage .level1').addClass('active');
        }else if ($('.donation-level-container.active').hasClass('level2')) {
            $('.formMessage .level2').addClass('active');
        }else if ($('.donation-level-container.active').hasClass('level3')) {
            $('.formMessage .level3').addClass('active');
        }else if ($('.donation-level-container.active').hasClass('level4')) {
            $('.formMessage .level4').addClass('active');
        }            
    }); 


    //make sure to remember values on reload
    if(amountLevel == 'level0') {
        $('.level0').addClass('active');
        $('.level0 .donation-level-label-input-container input').click();
    }else if (amountLevel == 'level1') {
        $('.level1').addClass('active');
        $('.level1 .donation-level-label-input-container input').click();
    }else if (amountLevel == 'level2') {
        $('.level2').addClass('active');
        $('.level2 .donation-level-label-input-container input').click();
    }else if (amountLevel == 'level3') {
        $('.level3').addClass('active');
        $('.level3 .donation-level-label-input-container input').click();
    }else if (amountLevel == 'level4') {
        $('.level4').addClass('active');
        $('.level4 .donation-level-label-input-container input').click();
    }  
    $('.donateSubmit').click(function(){
        $('#pstep_finish').click();
    });

    $('#level_flexiblegift_type_Row .form-content fieldset legend').addClass('aural-only');
    //$('#tr_recognition_nameanonymous_row').insertAfter('.form-donation-level');
    //$('#tr_show_gift_to_public_row').insertAfter('.form-donation-level');
    //$('#show_employer_match_row').insertAfter('.form-donation-level');
    

    $('h2:contains("Matching Gift:")').wrap('<div id="matching_gift_section"></div>');
    $('.matching-gift-container').appendTo('#matching_gift_section');
    //$('#matching_gift_section').insertAfter('.form-donation-level');
    $('.donation-level-user-entered input').attr("placeholder","Enter an Amount").after("<div class='other-amt-note'><em>$25 minimum donation</em></div>");
    
    /*$('#show_employer_match_check').click(function(){
        $('#matching_gift_section').slideToggle();
        if (!$(this).is(':checked')) {
            console.log("is is now NOT checked");
            document.cookie = "ahaMatch=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/heartdev/site;";
        }
        else {
            document.cookie = "ahaMatch=true";
        }
    });
    var cookieMatch = readCookie('ahaMatch');
    if (cookieMatch == 'true') {
        console.log('the cookie is true');
        $('#show_employer_match_check').trigger('click');
    }*/

    var xname = $('#part_name_donform').text()
    if (xname != ''){
    $('#tr_show_gift_to_public_row label').text('Would you like your name displayed on '+xname+'\'s page.');
    $('#tr_recognition_nameanonymous_row label').text('Hide my name from lists on '+xname+'\'s page. \('+xname+' will still see your name regardless of your choice.\)');}

    $('.external-payment label a').text('PayPal');
    $('.internal-payment a.payment-type-label:contains(Credit)').text('Credit');
    $('.internal-payment a.payment-type-label img').closest('a').text('Swiper');
    $('.payment-type-option input').wrap('<span></span>');

    $('.level5 .donation-level-label-input-container').addClass('aural-only');

/**** impact statement randomizer *****/
      var $all = $(".impactStatement").hide();
      $(randImpactStatement($all).slice(0, 1)).show();
/***** end impact statement randomizer ****/


    /*access*/
    $('html').attr('xmlns','http://www.w3.org/1999/xhtml').attr('lang','en').attr('xml:lang','en');
    
    var contentMeta = $('meta[name="Keywords"]').attr('content').trim();
    $('meta[name="Keywords"]').attr('content',contentMeta);
    
    //$('.payment-type-label').attr('tabindex','-1');
    
    $('#ProcessForm').attr('name','ProcessForm');
    
    $('#level_flexible_row.form-row.form-donation-level').attr('id','level_flexible_row2');

    $('fieldset.cardExpGroup').prepend('<legend class="aural-only">Credit Card Expires</legend>');

    $('#level_flexible_row2').wrapInner('<fieldset></fieldset>');
    $('#level_flexible_row2 fieldset').prepend('<legend class="aural-only">Select Gift Amount</legend>');

    $('#responsive_payment_typepay_typeradio_payment_types').wrapInner('<fieldset></fieldset>');
    $('#responsive_payment_typepay_typeradio_payment_types fieldset').prepend('<legend class="aural-only">Payment options</legend>');

    $('h5.transaction-summary-header').replaceWith(function () {
        return '<h1 class="transaction-summary-header summary-section-header dividerHeading" class="section-header-text">' + $(this).html() + '</h1>';
    });
    
    $('#responsive_payment_typecc_numbername, #responsive_payment_typecc_cvvname, #billing_first_namename, #billing_last_namename, #billing_addr_street1name, #billing_addr_cityname, #billing_addr_zipname, #donor_email_addressname, #responsive_payment_typecc_exp_date_MONTH, #responsive_payment_typecc_exp_date_YEAR, #billing_addr_state, #billing_addr_country').attr('aria-required','true');
    $('#billing_addr_street1_row, #billing_addr_street2_row, #billing_addr_city_row, #billing_addr_state_row, #billing_addr_zip_row, #billing_addr_country_row').wrapAll('<div class="billing-fields-container"></div>');
    
    if ($('.errorMessageContainer .ErrorMessage.page-error .field-error-text').length > 0) {
        $('.errorMessageContainer .ErrorMessage.page-error .field-error-text').attr('role','alert');
    }
    $('#responsive_payment_typecc_numbername').attr('placeholder','XXXXXXXXXXXXXXXX');
    $('#level_flexible_row').before('<div class="required-indicator-legend"><span class="field-required"></span><span class="required-indicator-legend-text">Indicates Required</span></div>');

    $('label[for="responsive_payment_typepay_typeradiocredit"] a').attr('aria-label','PAYMENT BY CREDIT CARD');
    $('label[for="responsive_payment_typepay_typeradiopaypal"] a').attr('aria-label','PAYMENT BY PAY PAL');

    // Adding Mark's text above matching company label
    $('#donor_matching_employer_Row').prepend('<p><strong>Play matchmaker. Here&#8217;s how.</strong></p><ul><li>Find out if your employer participates in a matching gifts program, an easy way to increase your donation.</li><li>Just fill in your company&#8217;s details below.</li></ul>');

    // Selecting empty value from the Gift Duration drop-down when the One-time Gift box is checked
    $('#level_flexiblegift_type1').click(function(){
        console.log('One-time gift box checked');
        $('#level_flexibleduration').val("");
        $('#level_flexibleduration_row').hide();
    });
    $('#level_flexiblegift_type2').click(function(){
        $('#level_flexibleduration_row').show();
    });

    // Limiting number of characters in credit card field
    $('#responsive_payment_typecc_numbername').attr('maxlength','16');

    // Change order of help link for tabbing
    $('.HelpLink').insertAfter('#responsive_payment_typecc_cvvname');

    // Moving matching gift widget to top of page if a search has been conducted
    /*if ($('#donor_matching_employer_company_information').length > 0) {
        $('#matching_gift_section').insertAfter($('h1#formTitle').parent().parent());
    }*/ 

    // a11y radio group for donation levels
    $('#level_flexible_row2 fieldset').attr('aria-labelledby', 'level_flexible_row2');
    $('#level_flexible_row2 fieldset').attr('role', 'radiogroup');
    $('input[name="level_flexibleexpanded"]').attr({
      role: 'radio', 
      group: 'donation-levels'
    });



    /*Thank You Page access edits */
    if (jQuery('.transaction-summary-info').length > 0) {
        jQuery('.transaction-summary-entry .entry-label').attr('tabindex','0');
        jQuery('.transaction-summary-entry .entry-value').each(function() {
            if (jQuery(this).text().length > 0) {
                jQuery(this).attr('tabindex','0');
            }
            else {
                jQuery(this).attr('tabindex','1');
            }
        });
        jQuery('.entry-label:contains("Total Gift Amount:")').attr('aria-label','Total Gift Amount');
    }


    // Google Events
    jQuery("input[name*='level_flexibleexpanded']").blur(function(){
        _gaq.push(['t2._trackEvent', 'Donation Level', 'click', 'Donation amount']);
    });
    jQuery("#donor_matching_employersearchname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Employer Match', 'click', 'Employer Search']);
    });
    jQuery("#tr_show_gift_to_publicname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Display Options', 'click', 'Display Amount']);
    });
    jQuery("#tr_recognition_nameanonymousname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Display Options', 'click', 'Hide Name']);
    });
    jQuery("#level_flexibleduration").blur(function(){
        _gaq.push(['t2._trackEvent', 'Recurring Gift', 'click', 'Gift Duration']);
    });
    jQuery("#tr_recognition_namerec_namename").blur(function(){
        _gaq.push(['t2._trackEvent', 'Display Options', 'click', 'How to Display']);
    });
    jQuery("#responsive_payment_typecc_numbername").blur(function(){
        _gaq.push(['t2._trackEvent', 'Payment', 'click', 'Credit Card']);
    });
    jQuery("#responsive_payment_typecc_cvvname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Payment', 'click', 'Credit Card Expires']);
    });
    jQuery("#billing_first_namename").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'First Name']);
    });
    jQuery("#billing_last_namename").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'Last Name']);
    });
    jQuery("#billing_addr_street1name").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'Street 1']);
    }); 
    jQuery("#billing_addr_street2name").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'Street 2']);
    });
    jQuery("#billing_addr_cityname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'City']);
    });
    jQuery("#billing_addr_state").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'State']);
    });
    jQuery("#billing_addr_zipname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'Zip']);
    });
    jQuery("#billing_addr_country").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'Country']);
    });  
    jQuery("#donor_email_addressname").blur(function(){
        _gaq.push(['t2._trackEvent', 'Billing Info', 'click', 'Email']);
    }); 
    jQuery("input[name='donor_matching_employerradioGroup']").blur(function(){
        _gaq.push(['t2._trackEvent', 'Employer Match', 'click', 'Company']);
    }); 
    jQuery("#amazonPayLink a").blur(function(){
        _gaq.push(['t2._trackEvent', 'Payment', 'click', 'Amazon']);
    }); 
    jQuery("#modalDonationButton").blur(function(){
        _gaq.push(['t2._trackEvent', 'Donation form lightbox', 'click', 'Donate Now']);
    }); 


    // donation form year label
    jQuery('label[for="responsive_payment_typecc_exp_date_YEAR"] span').removeClass('aural-only').text('and Year');

    jQuery('label[for="responsive_payment_typecc_exp_date_MONTH"] span').text('Expiration Date');
     
  });
    function randImpactStatement(array) {
      var m = array.length, t, i;
      while (m) {
        i = Math.floor(Math.random() * m--);
        t = array[m];
        array[m] = array[i];
        array[i] = t;
      }
      return array;
    }
    function readCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }
})(jQuery);

(function() {
    Y.use('jquery-noconflict', function() {
        jQuery(function($) {
            if ($('.field-error-indicator').length) {
                if ($('#additional_amountname').val() <= 0) {
                    $("#cover-fee-no").prop("checked", true);
                }
            }
            
            if (getDonationAmount() > 0) {
               var initAmt = parseFloat(getDonationAmount());
               var toDonate =  initAmt + parseFloat((getDonationAmount() * 0.026 + .26).toFixed(2));
               $('button#pstep_finish').html("Donate $" + toDonate);
               $('.bb-additional-amount').text(toDonate)
            }
            
            $("#cover-fee-yes").click(function() {
               if ($(this).is(':checked')) {
                  var initAmt = parseFloat(getDonationAmount());
                  var toDonate =  initAmt + parseFloat((getDonationAmount() * 0.026 + .26).toFixed(2));
                  $('button#pstep_finish').html("Donate $" + toDonate);
                  $('.bb-additional-amount').text(toDonate)
               } else {
                  $('.bb-additional-amount').text(0)
                  var initAmt = parseFloat(getDonationAmount());
                  $('button#pstep_finish').html("Donate $" + initAmt);
               }
            });
            jQuery('[id^=level_]').change(function() {
               var initAmt = parseFloat(getDonationAmount());
               var toDonate =  initAmt + parseFloat((getDonationAmount() * 0.026 + .26).toFixed(2));
               $('button#pstep_finish').html("Donate $" + toDonate);
               $('.bb-additional-amount').text(toDonate)
            });
            $('.donation-level-user-entered input').blur(function() {
               var initAmt = parseFloat(getDonationAmount());
               var toDonate =  initAmt + parseFloat((getDonationAmount() * 0.026 + .26).toFixed(2));
               $('button#pstep_finish').html("Donate $" + toDonate);
               $('.bb-additional-amount').text(toDonate)
            });

            $("#ProcessForm").submit(function(e) {
                //e.preventDefault();
                if ($('#cover-fee-yes').is(':checked')) {
                    $('#additional_amountname').val(getDonationAmount() * 0.026 + .26);
                } else {
                    $('#additional_amountname').val(0);
                }
console.log($('#additional_amountname').val());
                $("#ProcessForm").unbind('submit');
                $('#pstep_finish').click();
            });
        });
    });
})();

function getDonationAmount() {
	//get selected amount from checkbox
	var amt = jQuery('[id^=level_]:checked').closest('.donation-level-container').find('label').html();
	if (amt === null || amt == undefined || amt.indexOf("Enter an Amount") > -1) {
		amt = jQuery('[id^=level_flexible]:checked').parent().parent().find('input[id$="amount"]').val();
		if (amt === null) {
			amt = 0;
		}
	}
	//Convert currency string to number
	amt = Number(amt.replace(/[^0-9\.]+/g, ""));
	//console.log(amt);
	return amt;
}
