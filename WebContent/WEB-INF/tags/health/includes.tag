<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%--go:script marker="js-href" href="common/js/mtagconfig.js" / --%>

<go:script marker="js-href" href="common/js/health.js" />

<go:script marker="onready">
	QuoteEngine.nextSlide(function(currentSlide){
		 $('.health-info-text').hide();
		switch(currentSlide){
			case 1:
				Health.fetchPrices(true);
				return true;
				break;
			case 4:
				Health.submitApplication();
				return false;
				break;
			default:
				return true;
		}	
	});	
	QuoteEngine.prevSlide(function(currentSlide){
		 $('.health-info-text').hide();
		return true;
	});	

<c:if test="${callCentre}">	
	slide_callbacks.register({
		mode:			'after',
		slide_id:		-1,
		callback:		function(){	
			if( !QuoteEngine._options || QuoteEngine._options.currentSlide != 2 ) {
				$("#reference_number").css({top:"177px"});
			} else {
				$("#reference_number").css({top:"673px"});
			}
		}
	});
</c:if>
</go:script>



<go:script marker="onready">
	Track.onQuoteEvent("Start", ReferenceNo.getTransactionID());
	Track.nextClicked(0);
		
	<%-- CONFIRMATION VIEW: see if confirmationID is called and render the last page and move user there --%>	
	<c:if test="${not empty param.ConfirmationID}">
		<c:import var="JSON" url="ajax/load/load_health_confirmation.jsp">
			<c:param value="${param.ConfirmationID}" name="ConfirmationID" />
		</c:import>		
		Health._mode = 'confirmation';
		Health._confirmation = ${JSON};
		if( Health._confirmation.data.status == 'OK' && Health._confirmation.data.product != ''){
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
			
			Results.renderApplication();
			QuoteEngine.gotoSlide({'noAnimation':true, 'index':5}); <%-- //FIX: need the jump instead of sliding --%>
			<%-- NOTE: the quote page has on the last QuoteEngine call, removing the main health and quoteengine objects as they need to stay put (extreme measure) --%>
		} else {
			$('body').removeClass('confirmation');
			FatalErrorDialog.exec({
				message:		'Error: '+ Health._confirmation.data.message,
				page:			"health:includes.tag",
				description:	"Health Confirmation data loaded is invalid.",
				data:			Health._confirmation
			});  
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