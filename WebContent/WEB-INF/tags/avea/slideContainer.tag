<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="true"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="optional id for this slide container"%>

<%-- HTML --%>
<div id="qe-wrapper">
	<div class="scrollable">
		<div id="qe-main">
			<jsp:doBody />
		</div>
	</div>
	<a href="javascript:void(0);" class="tab-button prev" id="slide-prev" style="display:none">Previous</a>
	<a href="javascript:void(0);" class="tab-button next" id="slide-next" style="display:none">Next</a>
</div>


<%-- JAVASCRIPT --%>
<go:script marker="onready">
	initQuoteEngineScreens();
	initFormElements();


	<%-- This prevents the slide from breaking when the user tabs from the last field on the slide to the new field on the next slide --%>
	$('#quote_avea_regoNumber, #avea_payment_cardExpiryYear').live('keydown', function(e) {
		var key = e.charCode ? e.charCode : e.keyCode;
		if(key==9){
		   return false;
		}
		return true;
	});


	var nav = $("#qe-wrapper").data("scrollable");
	$('.message').css({'margin-left':'-57px'});


	<%-- NASTIHACK jQuery Set to Absolute --%>
	$('.ui-helper-hidden-accessible').css({'position':'absolute'});

	<%-- Handle Slider Navigation NEXT --%>
	jQuery("#next-step").click(function(){

		$('#next-step').hide();

		validation = true;
		$("#mainform").validate().resetNumberOfInvalids();
		var numberOfInvalids = 0;

		<%-- NASTIHACK jQuery Set to Static Temporarily --%>
		$('.ui-helper-hidden-accessible').css({'position':'static'});

		$('#slide'+slideIdx + ' :input:visible').each(function(index) {
			if ($(this).attr("id") && !formError && !$(this).is(':hidden'))
				$("#mainform").validate().element("#" + $(this).attr("id"));
		});

		<%-- NASTIHACK jQuery Set back to Absolute --%>
		$('.ui-helper-hidden-accessible').css({'position':'absolute'});


		//if($("#mainform").validate().showLabel( $('#quote_avea_modifications_extractor'), 'Lalallalalala' )){
		if ($("#mainform").validate().numberOfInvalids() == 0) {
			Track.nextClicked(slideIdx);

			if(!$("#helpToolTip").is(':hidden'))
				$("#helpToolTip").fadeOut(300);

			if(!navPause) {
				if(slideIdx == 0){
					getFinalQuote(slideIdx, nav);
					$("#qe-wrapper .scrollable").css({'height':'auto'});
				}
				if(slideIdx == 1){
					processPayment(slideIdx, nav);
				}
				if(slideIdx == 2){
					nav.next();
					progressBar(slideIdx);
				}
			}
		}else{
			<%-- Validation did not pass --%>
			$('#next-step').show();
		}
		//}


	});


	<%-- Handle Slider Navigation BACK --%>
	jQuery("#prev-step,#slide-prev").click(function(){
		$("#mainform").validate().resetNumberOfInvalids();
		$("#mainform").validate().resetForm();
		if (!$("#helpToolTip").is(':hidden')) $("#helpToolTip").fadeOut(300);
		if (!navPause) {
			nav.prev();
			progressBar(slideIdx);
			if(slideIdx == 0){
				$("#qe-wrapper .scrollable").css({'height':'auto'});
				$("#next-step").show();
				$("#next-step").html('Next Step');
			}
		}
	});


</go:script>



<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	<%-- GET FINAL QUOTE --%>
	function getFinalQuote(slideIdx, nav){

		<%-- Prepare Form Data --%>
		validation = false;
		var dat = $('#mainform').find('input, select').serialize();

		$.ajax({
			url: "ajax/json/avea_final_quote.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			success: function(result){

				<%-- Check for successful response and errors --%>
				var validresponse = (result!==null && typeof(result)!='undefined' && typeof(result.results)!='undefined');
				var response;
				var available;
				var unacceptable;
				var goterror;
				if(validresponse){
					available = (typeof(result.results.price.available)!='undefined' && result.results.price.available == 'Y');
					unacceptable = (typeof(result.results.price.available)!='undefined' && result.results.price.available == 'N');
					goterror = (typeof(result.results.price.error)!='undefined');
					response = result.results;
				}

				if(validresponse && available && !goterror && !unacceptable){

					<%-- Update payment page with the current main drivers details --%>
					$('#quote_avea_policyholder_firstName').html( $('#quote_avea_driver0_firstName').val() );
					$('#quote_avea_policyholder_lastName').html( $('#quote_avea_driver0_lastName').val() );
					$('#quote_avea_policyholder_title').html( toTitleCase($('#quote_avea_driver0_title').val()) );
					$('#quote_avea_policyholder_phone').val( splitPhoneNum("${data['quote/contact/phone']}") );
					$('#quote_avea_policyholder_email').val('${data['quote/contact/email']}');
					$('#quote_avea_riskAddress_postCode').val('${data['quote/riskAddress/postCode']}');
					$('#quote_avea_riskAddress_streetSearch').val('${data['quote/riskAddress/streetSearch']}');
					$('#quote_avea_riskAddress_sbrSeq').val('${data['quote/riskAddress/sbrSeq']}');
					$('#quote_avea_riskAddress_state').val('${data['quote/riskAddress/state']}');
					$('#quote_avea_riskAddress_unitShop').val('${data['quote/riskAddress/unitShop']}');
					$('#ajaxdrop_quote_avea_riskAddress_unitShop').val('${data['quote/riskAddress/unitShop']}');
					$('#quote_avea_riskAddress_suburbName').val('${data['quote/riskAddress/suburbName']}');
					$('#quote_avea_riskAddress_houseNoSel').val('${data['quote/riskAddress/houseNoSel']}');
					$('#quote_avea_riskAddress_streetId').val('${data['quote/riskAddress/streetId']}');
					$('#quote_avea_riskAddress_type').val('${data['quote/riskAddress/type']}');
					$('#quote_avea_riskAddress_streetName').val('${data['quote/riskAddress/streetName']}');

					<%-- Display appropriate address fields --%>
					if('${data['quote/riskAddress/unitShop']}' != ''){
						$('#quote_avea_riskAddress_unitShopRow').show();
						$('#quote_avea_riskAddress_unitShop').show();
					}

					<%-- Format Numbers --%>
					response.price.onlinePrice.lumpSumTotal 	= response.price.onlinePrice.lumpSumTotal.toFixed(2);
					response.price.onlinePrice.instalmentTotal 	= response.price.onlinePrice.instalmentTotal.toFixed(2);
					response.price.onlinePrice.instalmentPayment = response.price.onlinePrice.instalmentPayment.toFixed(2);
					response.price.excess = response.price.excess.toFixed(2);

					<%-- Populate Yearly --%>
					$('#avea_yearly_container .avea_quote_startdate').html('${data['quote/options/commencementDate']}');
					$('#avea_yearly_container .avea_quote_excess').html('*$' + response.price.excess);
					$('#avea_yearly_container .avea_quote_premium').html('$' + response.price.onlinePrice.lumpSumTotal);
					$('#avea_yearly_quote_payable').html('**$' + response.price.onlinePrice.lumpSumTotal);
					$('.avea_yearly_price').html('<b>$' + response.price.onlinePrice.lumpSumTotal + '</b>');
					yearly_total = response.price.onlinePrice.lumpSumTotal;

					<%-- Populate Monthly --%>
					$('#avea_monthly_container .avea_quote_startdate').html('${data['quote/options/commencementDate']}');
					$('#avea_monthly_container .avea_quote_excess').html('*$' + response.price.excess);
					$('#avea_monthly_container .avea_quote_premium').html('$' + response.price.onlinePrice.instalmentTotal);
					$('#avea_monthly_quote_payable').html('**$' + response.price.onlinePrice.instalmentTotal + '<br /><span class="font9 lh14">(12 payments of $'+response.price.onlinePrice.instalmentPayment+')</span>');
					$('#avea_monthly_container .avea_monthly_premium').html('$' + response.price.onlinePrice.instalmentPayment);
					$('.avea_monthly_price').html('$' + response.price.onlinePrice.instalmentPayment + ' (Total <b>$'+ response.price.onlinePrice.instalmentTotal +'</b>)');
					monthly_total = response.price.onlinePrice.instalmentTotal;

					<%-- Go to next page --%>
					nav.next();
					progressBar(1);

					<%-- Dynamic Page Manipulations --%>
					$("#qe-wrapper .scrollable").css({'height':'930px'});
					$("#next-step").show();
					$("#next-step").html('Buy Now');
					$('html, body').animate({ scrollTop: 0 }, 500);

					<%-- Updade default final amount to yearly --%>
					$('#avea_quote_final_payed').html('*$' + response.price.onlinePrice.lumpSumTotal);
					$('.avea_quote_payed').html('*$' + response.price.onlinePrice.lumpSumTotal);

					<%-- Omniture Reporting - Price Presentation Screen "Buy Online" --%>
					//omnitureReporting(1);

				}else{
					if(validresponse){
						<%-- Launch Unacceptable Popup --%>
						$('html, body').animate({ scrollTop: 0 }, 600, function(){
							UnacceptPopup.show();
						});
					}else{
						<%-- Empty Response = Session Timeout --%>
						alert('Session Timeout');
						window.opener.location.href="http://www.comparethemarket.com.au";
						window.close();
					}
				}
			},
			error: function(obj,txt){
				<%-- Unknown Error --%>
				alert('Session Timeout');
				window.opener.location.href="http://www.comparethemarket.com.au";
				window.close();
			},
			timeout:50000
		});

	}


	<%-- If the phone number has an Area Code, split it into the appropriate fields on the form --%>
	function splitPhoneNum(num){

		<%-- Sanitize --%>
		num = num.toString();
		var result = num;

		<%-- Split if requirements matched --%>
		if(num.length == 10){
			var area_code = num.substring(0,2);
			if(area_code == '02' || area_code == '03' || area_code == '07' || area_code == '08'){
				$('#quote_avea_policyholder_areaCode').val(area_code);
				result = num.substring(2,10);
			}
		}
		return result;
	}


	<%-- Clear AVEA from data bucket first, then close window --%>
	function clearAvea(){
		$.ajax({
			url: "ajax/json/avea_clear.jsp",
			type: "POST",
			async: false,
			dataType: "json",
			success: function(result){
			}
		});
	}


	<%-- PROCESS PAYMENT --%>
	function processPayment(slideIdx, nav){

		<%-- Hide Buttons --%>
		$('#next-step').hide();
		$('#prev-step').hide();
		$('.buy-grey').show();

		<%-- Prepare Form Data --%>
		validation = false;
		var dat = serialiseWithoutEmptyFields('#mainform');

		$.ajax({
			url: "ajax/json/avea_quote_payment.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			success: function(result){

				<%-- Check for successful response and errors --%>
				var available = (typeof(result.results.policyDetails.available)!='undefined' && result.results.policyDetails.available == 'Y');
				var goterror = (typeof(result.results.policyDetails.error)!='undefined');

				if(available && !goterror){

					<%-- Prepare Response --%>
					var response = result.results.policyDetails;

					<%-- Update success page values & progress slide --%>
					$('#final_policynumber').html( response.policyNumber );
					$('#final_policylink').html('<a href="' + response.policySchedule + '" target="_blank">Your Policy Schedule</a>');
					avea_policy = response.policyNumber;
					if( $('#quote_avea_premiumType_CreditCardInFull').is(':checked') ){
						avea_premium = yearly_total;
					}else{
						avea_premium = monthly_total;
					}
					nav.next();
					progressBar(2);

					<%-- Dynamic Page Manipulations --%>
					$("#qe-wrapper .scrollable").css({'height':'640px'});
					$('html, body').animate({ scrollTop: 0 }, 300);
					$("#next-step").hide();
					$("#prev-step").hide();
					$(".poweredby").hide();
					$('.buy-grey').hide();
					$(".avea_details").show();

					setTimeout("clearAvea()", 1000);

					<%-- Omniture Reporting - Payment/Policy Confirmation Screen --%>
					//omnitureReporting(2);

				}else{

					<%-- Show Buttons --%>
					$('.buy-grey').hide();
					$('#next-step').show();
					$('#prev-step').show();

					if(goterror){
						alert("An error occurred while processing the payment. \n" + result.results.policyDetails.error.message);
					}else{
						//alert("An unknown error occurred.");
					}
				}
			},
			error: function(obj,txt){
				alert(txt);
			},
			timeout:50000
		});

	}

	function toTitleCase(str){
		return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
	}


</go:script>

