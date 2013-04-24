<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:script marker="onready">
	QuoteEngine.nextSlide(function(currentSlide){
		switch(currentSlide){
			case 0:
				IPQuote.fetchPrices(true);
				return true;
				break;
			default:
				return true;
		}	
	});	
	
	var CallNowPanel = new Object();
	CallNowPanel = {
	
		render : function( simple ) {
			simple = simple || false;
			
			if( !simple && QuoteEngine.validate() ) {
				CallNowPanel.renderDetail();
				contactPanelHandler.reinit(3);
			} else {
				CallNowPanel.renderSimple();
				contactPanelHandler.reinit(30);
			}
		},
		
		renderDetail : function() {
			$("#contact-panel").find(".row.mid").first().empty().append('<h3>Call Lifebroker Now<br /><span>1800 204 125</span></h3><a href="javascript:IPQuote.onRequestCallback();" id="request-callback" title="Click to receive call from Lifebroker"><span>Call Me Back</span></a><p>A Lifebroker consultant can call you back to discuss your options.</p>');
			contactPanelHandler.reinit(); //Reinitialise to reset the starting positions
		},
		
		renderSimple : function() {
			$("#contact-panel").find(".row.mid").first().empty().append('<h3>Call Lifebroker Now<br /><span>1800 204 124</span></h3>');
		}
	};
	
	slide_callbacks.register({
		mode:			'before',
		slide_id:		-1,
		callback:		function(){	
			CallNowPanel.render( QuoteEngine._options.currentSlide != 1 );
			$('html, body').animate({ scrollTop: 0 }, 'fast');
		}
	});
</go:script>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<go:script marker="onready">
	Track.onQuoteEvent("Start", ReferenceNo.getTransactionID());
	
	Track.nextClicked(0);

	CallNowPanel.render(true);
</go:script>

<%-- Only touch as a new quote when it IS actually a new quote and not just being opened --%>
<go:script marker="onready">
	<c:choose>
		<c:when test="${isNewQuote eq false}">
			<c:if test="${not empty callCentre}">
			Track.contactCentreUser( '${data.ip.application.productId}', '${data.login.user.uid}' );
			</c:if>
		</c:when>
		<c:otherwise>
			IPQuote.touchQuote("N");
		</c:otherwise>
	</c:choose>

	ReferenceNo.overrideSave(function(){
		var defaults = {
			email: $("#ip_contactDetails_email").val(),
			optin: $("#ip_contactDetails_optIn").is(":checked") ? "Y" : "N"
		}
		SaveQuote.setToMySQL().show( SaveQuote._SAVE, defaults, function( optin ) {
			if( optin == "Y" )
			{
				$("#ip_contactDetails_optIn").attr("checked", "true");
			}
			else
			{
				$("#ip_contactDetails_optIn").removeAttr("checked");
			}
		} );
	});
</go:script>