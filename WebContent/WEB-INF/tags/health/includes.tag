<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--go:script marker="js-href" href="common/js/mtagconfig.js" / --%>
<go:script marker="js-href" href="common/js/health.js" />

<go:style marker="css-head">
<%-- Moving the slide forward if pre-populated --%>
<c:if test="${fromBrochure == true}">
	#qe-main {
		left: -639px;
	}
	#slide1 {
		max-height:5000px;
	}
</c:if>
</go:style>

<go:script marker="onready">

	// Button on slide 2 to show edit benefits on results page
	$('#alt-results-step').on('click', function(){
		Results._editBenefits = true;
		$('#next-step').trigger('click');
	});
	$('#results-step').on('click', function(){
		Results._editBenefits = false;
		$('#next-step').trigger('click');
	});
	
	QuoteEngine.nextSlide(function(currentSlide){
		if(Health.ajaxPending) {
			return false;
		} else if(Health.confirmed) {
			Health.gotToConfirmation();
			return false;
		} else {
		 $('.health-info-text').hide();
		switch(currentSlide){
			case 1:
				/* Call init rather than fetchPrices so that results page can decide
				   whether to render results normally or just show edit benefits */
				Results.init();
				return true;
				break;
			case 4:
				Health.submitApplication();
				return false;
				break;
			default:
				return true;
		}	
		}
	});	
	QuoteEngine.prevSlide(function(currentSlide){
		 $('.health-info-text').hide();
		return true;
	});	

<%-- Moving the slide forward if pre-populated --%>
<c:if test="${fromBrochure == true}">
	QuoteEngine.gotoSlide({index:1});
</c:if>

<%-- Position the ref number in Simples --%>
<c:if test="${callCentre}">	
	slide_callbacks.register({
		mode:			'after',
		slide_id:		-1,
		callback:		function(){	
			if( !QuoteEngine._options || QuoteEngine._options.currentSlide != 2 ) {
				$("#reference_number").css({top:"177px"});
			} else {
				$("#reference_number").css({top:"766px"});
			}
		}
	});
</c:if>
</go:script>



<go:script marker="onready">

	Track.onQuoteEvent("Start", ReferenceNo.getTransactionID());
	<c:choose>
		<c:when test="${fromBrochure == true}">
			Track.nextClicked(1);
		</c:when>
		<c:otherwise>
	Track.nextClicked(0);
		</c:otherwise>
	</c:choose>
		
	<%-- CONFIRMATION VIEW: see if confirmationID is called and render the last page and move user there --%>	
	<c:if test="${not empty param.ConfirmationID}">
		<c:import var="JSON" url="ajax/load/load_health_confirmation.jsp">
			<c:param value="${param.ConfirmationID}" name="ConfirmationID" />
		</c:import>		
		Health._mode = 'confirmation';

		<%-- //FIX: we need to kill anything here that can help the user 'edit' the file if something were to break --%>
		$('.button-wrapper,#slide0,#slide1').css('visibility','hidden');

		Health._confirmation = ${JSON};

		if( Health._confirmation.data.status == 'OK' && Health._confirmation.data.product != ''){
			<%-- //FIX: we need to put this into a catch error so if the json is an issue, we can alert the customer: see HLT-174 for error message  --%>
			Results._selectedProduct = $.parseJSON(Health._confirmation.data.product); 
			
			/* Safety-net for products with missing payment types
			   Only applies to products sold before new mthods */
			var pmtMethods = {
					weekly : {value:0, text:'$0.00'},
					fortnightly : {value:0, text:'$0.00'},
					monthly : {value:0, text:'$0.00'},
					annually : {value:0, text:'$0.00'},
					halfyearly : {value:0, text:'$0.00'},
					quarterly : {value:0, text:'$0.00'}
			};
			
			Results._selectedProduct.premium = $.extend(pmtMethods, Results._selectedProduct.premium);
			Results._selectedProduct.altPremium = $.extend(pmtMethods, Results._selectedProduct.altPremium);
			Results.jsonExpand(Results._selectedProduct);
			Results.renderApplication();
			healthPolicyDetails.final();
			Health.gotToConfirmation();
			<%-- NOTE: the quote page has on the last QuoteEngine call, removing the main health and quoteengine objects as they need to stay put (extreme measure) --%>
		} else {
			$('body').removeClass('confirmation');
			FatalErrorDialog.exec({
				message:		'Error: '+ Health._confirmation.data.message,
				page:			"health:includes.tag",
				description:	"Health Confirmation data loaded is invalid.",
				data:			Health._confirmation
			});  
			<%-- If confirmation data has not been saved --%>
			if(Health._confirmation.data.message == 'No Data Found'){
				FatalErrorDialog._elements.content.empty().append("Oops, we are currently experiencing difficulties generating your confirmation notification. But please be reassured that your application has been submitted successfully to the health fund and they'll be in contact with you shortly.");
			};			
		};
		Loading.hide();
	</c:if>
</go:script>

<%-- Only touch as a new quote when it IS actually a new quote and not just being opened --%>
<go:script marker="onready">
	<c:choose>
		<c:when test="${isNewQuote eq false}">
			<c:if test="${not empty callCentre}">
			Track.contactCentreUser( '${data.health.application.productId}', '${data.login.user.uid}' );
			</c:if>
		</c:when>
		<c:otherwise>
			Health.touchQuote("N");
		</c:otherwise>
	</c:choose>
</go:script>


<!-- CSS -->
<go:style marker="css-head">
	body.confirmation.stage-0 #loading-popup {
		display:block !important;
		z-index:1000;
		position:absolute;
		left:35%;
		top:175px;
	}
	body.confirmation.stage-0 #loading-overlay {
		display:block !important;
		position:absolute;
		z-index:999;	
	}
</go:style>