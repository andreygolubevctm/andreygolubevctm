<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:style marker="css-href" href="common/avea.css" />

<go:style marker="css-head">
	#helpContainer{margin-left:50px;}
	#helpHide{background-image:none;}
	#helpPanel{left:760px;top:152px;}
	.ui-helper-hidden-accessible{position:static;}
	#quote_avea_payment_cardNumber{width:140px;}
</go:style>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">
	Track.startAvea();

	<%-- Populate and show youngest (additional) driver --%>
	<c:if test="${data['quote/drivers/young/exists'] == 'Y'}">
		$('#driver_driver1').show();
		$("[for='quote_avea_drivers_additional_Y']").click();
		$('#driver_driver1 .driver_head').html('Youngest Driver');
		$('#quote_avea_drivers_driver1_firstName').val('Youngest driver');
	</c:if>
	
	<%-- Initial population --%>
	popupateDriverDropdowns();
	
	<c:if test="${param.preload == '1'}"> 
	
		<%-- Preload-only related actions --%>
		<c:if test="${data['quote/avea/drivers/driver1'] != null}">$('#driver_driver1').show(); 		 $("[for='quote_avea_drivers_additional_Y']").click(); 			 </c:if>
		<c:if test="${data['quote/avea/charged/charged0'] != null}">$('#charged_charged0').show(); 		 $("[for='quote_avea_incidentsClaimsOther_charged_Y']").click(); 	 </c:if>
		<c:if test="${data['quote/avea/damaged/damaged0'] != null}">$('#damaged_damaged0').show(); 		 $("[for='quote_avea_incidentsClaimsOther_damaged_Y']").click(); 	 </c:if>
		<c:if test="${data['quote/avea/suspended/suspended0'] != null}">$('#suspended_suspended0').show(); $("[for='quote_avea_incidentsClaimsOther_suspended_Y']").click(); </c:if>
		<c:if test="${data['quote/avea/offence/offence0'] != null}">$('#offence_offence0').show();		 $("[for='quote_avea_incidentsClaimsOther_offence_Y']").click(); 	 </c:if>
		<c:if test="${data['quote/avea/refusal/refusal0'] != null}">$('#refusal_refusal0').show();		 $("[for='quote_avea_incidentsClaimsOther_refusal_Y']").click(); 	 </c:if>

		$("#quote_avea_charged_charged0_driver").val('${data['quote/avea/charged/charged0/driver']}').attr('selected',true);
		$("#quote_avea_damaged_damaged0_driver").val('${data['quote/avea/damaged/damaged0/driver']}').attr('selected',true);
		$("#quote_avea_suspended_suspended0_driver").val('${data['quote/avea/suspended/suspended0/driver']}').attr('selected',true);
		$("#quote_avea_offence_offence0_driver").val('${data['quote/avea/offence/offence0/driver']}').attr('selected',true);
		$("#quote_avea_refusal_refusal0_driver").val('${data['quote/avea/refusal/refusal0/driver']}').attr('selected',true);
		$("#quote_avea_damaged_damaged0_driver").val('${data['quote/avea/damaged/damaged0/driver']}');
		$("#quote_avea_refusal_refusal0_driver").val('${data['quote/avea/refusal/refusal0/driver']}');
		$('#quote_avea_damaged_damaged0_driverFault_Y').attr('checked', true);
		$('#quote_avea_agreeDisclosures').attr('checked', true);
		
	</c:if>
	
</go:script>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	<%-- Prepare globals --%>
	var monthly_total = 0;
	var yearly_total = 0;
	var avea_premium = 0;
	var avea_brand = '';
	var avea_policy = '';
	if('${param.prdId}' == 'crsr')
		avea_brand = 'Carsure';
	if('${param.prdId}' == 'aubn')
		avea_brand = 'AutoBarn';
	
	<%-- The 'additional drivers' Y/N radio was changed --%>
	function toggle_drivers(){
		if($("#quote_avea_drivers_additional_Y:checked").val()=='Y'){
			$('#driver_driver1').slideDown(500);
			$('#add_driver_driver0').hide();
			re_show_links('driver_driver1');
		}
		if($("#quote_avea_drivers_additional_N:checked").val()=='N'){
			$('.driver').not('#driver_driver0').slideUp(500);
			$('#driver_driver0').show();
			$('#add_driver_driver0').show();
			$('#driver_driver1 input').val('');
		}
	}
	
	<%-- Update the select dropdowns for driver selection --%>
	function popupateDriverDropdowns(){
	
		<%-- Gather existing selections first --%>
		var driver_selections = [];
		$.each( $('.driver_dropdown :selected') , function() {
			if( $(this).val().length > 0 )
				driver_selections[$(this).parent().attr('id')] = $(this).val();
		});
	
		<%-- Populate the drop downs --%>
		$('.driver_dropdown').html('');
		$('.driver_dropdown').append($("<option />").val('').text('Select driver'));
		var drivers = $('#slide0 .driver_first_name').not('#quote_avea_driver0_firstName').filter(':visible');
		$('.driver_dropdown').append($("<option />").val('driver0').text('Regular driver'));

		$.each(drivers, function() {
			var num = $(this).parent().parent().parent().attr('id');
			num = num.substring(num.length-1, num.length);
			if($(this).val().length > 1)
				$('.driver_dropdown').append($("<option />").val('driver'+num).text($(this).val()));
		});
		
		<%-- Re-assign drivers selected --%>
		for(v in driver_selections){
			$('#'+v).val(driver_selections[v]);
		}
		
	}
	
	<%-- Cleanup / Reset any redundant form data in the 'additional' rows --%>
	function cleanupDriverOffences(){
	
		$.each( $('.driver_dropdown') , function() {
			if( $(this).val().length > 0 ){
				<%-- Hide offence associated with the driver removed --%>
				if( $('#driver_'+ $(this).val() ).is(':hidden') ){
					$(this).parent().parent().parent().slideUp(300, function(){
						<%-- Set Yes/No Radios to no if empty --%>
						if( $('.motoringOffences :visible').length < 1 		&& $("#quote_avea_incidentsClaimsOther_motoringOffences_Y:checked").val()=='Y') 	$("[for='quote_avea_incidentsClaimsOther_motoringOffences_N']").click(); 
						if( $('.accidents :visible').length < 1 			&& $("#quote_avea_incidentsClaimsOther_accidents_Y:checked").val()=='Y') 			$("[for='quote_avea_incidentsClaimsOther_accidents_N']").click();
						if( $('.licenseEndorsements :visible').length < 1 	&& $("#quote_avea_incidentsClaimsOther_licenseEndorsements_Y:checked").val()=='Y') 	$("[for='quote_avea_incidentsClaimsOther_licenseEndorsements_N']").click();
						if( $('.criminalConvictions :visible').length < 1 	&& $("#quote_avea_incidentsClaimsOther_criminalConvictions_Y:checked").val()=='Y') 	$("[for='quote_avea_incidentsClaimsOther_criminalConvictions_N']").click();
						if( $('.insuranceRefused :visible').length < 1 		&& $("#quote_avea_incidentsClaimsOther_insuranceRefused_Y:checked").val()=='Y') 	$("[for='quote_avea_incidentsClaimsOther_insuranceRefused_N']").click();
					});
				}
			}
		});
		popupateDriverDropdowns();
		
	}

	var Track_Avea = new Object();
	
	Track_Avea = {
<c:choose>
	<c:when test="'${param.prdId}' == 'crsr'">
		_leadNo: "${data['quote/crsr/leadNo']}",
	</c:when>
	<c:otherwise>
		_leadNo: "${data['quote/aubn/leadNo']}",
	</c:otherwise>
</c:choose> 
		_transId: "${data['current/transactionId']}",
		_prodId: "${param.prdId}",
	
		init: function(){
			Track.init('Avea','Avea Start');
			PageLog.log("Avea Start");

			Track.startAvea = function(){
				var actionStep='Avea Start';

				superT.trackAvea({
					actionStep: actionStep,
					quoteReferenceNumber: Track_Avea._leadNo,
					transactionID: Track_Avea._transId,
					productID: Track_Avea._prodId
				});
			},
			
			Track.nextClicked = function(stage){
				var actionStep='';
				switch(stage){
				case 0:
					actionStep='Avea Payment';
					PageLog.log("AveaPayment");
					break;
				case 1: 
					actionStep='Avea Complete'; 
					PageLog.log("AveaComplete");
					break;
				}

				superT.trackAvea({
					actionStep: actionStep,
					quoteReferenceNumber: Track_Avea._leadNo,
					transactionID: Track_Avea._transId,
					productID: Track_Avea._prodId
				});
			};
			
		}
	};

</go:script>