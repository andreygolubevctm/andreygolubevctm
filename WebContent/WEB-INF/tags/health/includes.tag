<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:if test="${empty callCentre}">
	<health:live_chat />
</c:if>

<go:script marker="js-href" href="common/js/health.js" />

<go:style marker="css-head">
	<%-- Moving the slide forward if pre-populated. CSS used by design to avoid the on-ready slide animation etc. --%>
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

	<%--  Button on slide 2 to show edit benefits on results page --%>
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
					<%--  Call init rather than fetchPrices so that results page can decide
					whether to render results normally or just show edit benefits  --%>
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

<%-- Monitor the live person placeholder and check for when the content changes.
	At which time toggle a class to render the contact panel as appropriate. --%>
<c:if test="${empty callCentre}">
	setInterval(function(){
		var content = $('#chat-health-insurance-sales').html();
		if(content == "" || content == "<span></span>"){
			$('#contact-panel').removeClass("hasButton");
		} else {
			$('#contact-panel').addClass("hasButton");
		}
	}, 250);
</c:if>

<%-- Moving the slide forward if pre-populated. Return to Step 1 if it doesn't validate. --%>
<c:if test="${fromBrochure == true}">
	if (!QuoteEngine.validate()) {
		QuoteEngine.gotoSlide({
			index:0,
			callback: function() {
				$('#slide1').css('max-height', 300);
				QuoteEngine.validate();
			}
		});
	}
	else {
	QuoteEngine.gotoSlide({index:1});
	}
</c:if>

</go:script>



<go:script marker="onready">
	Track.onQuoteEvent('Start', referenceNo.getTransactionID(false));
	<c:choose>
		<c:when test="${fromBrochure == true}">
			Track.nextClicked(1, referenceNo.getTransactionID(false));
		</c:when>
		<c:otherwise>
			Track.nextClicked(0, referenceNo.getTransactionID(false));
		</c:otherwise>
	</c:choose>
		
	<c:choose>
		<%-- PENDING VIEW: see if PendingID is called and render the last page and move user there --%>
		<c:when test="${not empty param.PendingID}">
			<c:if test="${fn:contains(param.PendingID, '-')}">
				<c:set var="PendingTranID" value="${fn:substringAfter(param.PendingID, '-')}" />

				<c:import var="JSON" url="ajax/load/load_health_pending.jsp">
					<c:param name="PendingID" value="${param.PendingID}" />
					<c:param name="PendingTranID" value="${PendingTranID}" />
				</c:import>

				<c:if test="${fn:contains(JSON, 'Error')}">
					<c:set var="PendingTranID" value="" />
				</c:if>
			</c:if>

			callMeBack.hide();
			Health._mode = HealthMode.PENDING;

			<c:if test="${not empty PendingTranID}">
				referenceNo.setTransactionId("<c:out value="${PendingTranID}" />");

				var temp = ${JSON};
				Results._selectedProduct = temp.data;

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
				$('#policy_snapshot > ul li:not(.ui-state-active)').hide();
				$('#policy_details .data li:not(.start)').hide();

				$('.button-wrapper,#slide0,#slide1').css('visibility','hidden');
				$('body').addClass('pending');
				Health.gotToConfirmation();
			</c:if>

			<c:if test="${empty PendingTranID}">
				FatalErrorDialog.exec({
					message:		'Status=Error',
					page:			"health:includes.tag, Pending View",
					description:	"Health Pending data loaded is invalid.",
					data:			${JSON}
				});
			</c:if>

			Loading.hide();
		</c:when>

		<%-- CONFIRMATION VIEW: see if confirmationID is called and render the last page and move user there --%>
		<c:when test="${not empty param.ConfirmationID}">
			callMeBack.hide();
		<c:import var="JSON" url="ajax/load/load_health_confirmation.jsp">
			<c:param value="${param.ConfirmationID}" name="ConfirmationID" />
		</c:import>		
			Health._mode = HealthMode.CONFIRMATION;

		<%-- //FIX: we need to kill anything here that can help the user 'edit' the file if something were to break --%>
		$('.button-wrapper,#slide0,#slide1').css('visibility','hidden');

		Health._confirmation = ${JSON};

		if( Health._confirmation.data.status == 'OK' && Health._confirmation.data.product != ''){
			Results._selectedProduct = $.parseJSON(Health._confirmation.data.product); 
			
				<%-- Sometimes multiple products are saved in the confirmation? --%>
				if (Results._selectedProduct.price && $.isArray(Results._selectedProduct.price)) {
					Results._selectedProduct = Results._selectedProduct.price[0];
				}

				<%-- Safety-net for products with missing payment types
				Only applies to products sold before new methods --%>
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
		</c:when>

		<c:when test="${(not empty data['health/confirmationEmailCode']) || (not empty data['health/policyNo'])}">
			<%--TODO handle confirmation --%>
		</c:when>

		<c:when test="${not empty data['health/journey/stage'] && param.action == 'amend'}">
			var stage = '${data['health/journey/stage']}';
			if(stage == 'results' || stage >= 2) {
				Health.loadingSavedResults = true;
				Health.savedResultsTransactionId = '${data['previous/transactionId']}';
				<%-- Call init rather than fetchPrices so that results page can decide
					whether to render results normally or just show edit benefits --%>
					QuoteEngine.gotoSlide({'noAnimation':true, 'index':2});
					Results.init();
			} else if (!isNaN(stage)) {
				QuoteEngine.gotoSlide({'noAnimation':true, 'index':stage});
			}
		</c:when>

		<c:otherwise>
			<%-- Default stage hash now being set in a common place for all verticals - form:head.tag --%>
		</c:otherwise>
	</c:choose>
</go:script>

<%-- Only touch as a new quote when it IS actually a new quote and not just being opened --%>
<c:if test="${isNewQuote eq false and not empty callCentre}">
<go:script marker="onready">
			Track.contactCentreUser( '${data.health.application.productId}', '${data.login.user.uid}' );
	</go:script>
			</c:if>


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