<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:script marker="onready">
	QuoteEngine.nextSlide(function(currentSlide){
		switch(currentSlide){
			case 1:
				LifeQuote.fetchPrices(true);
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
			} else {
				CallNowPanel.renderSimple();
			}
		},
		
		renderDetail : function() {
			$("#contact-panel").removeClass("simple");
			$("#contact-panel").find(".row.mid").first().empty().append('<h3>Call Lifebroker Now<br /><span>1800 204 124</span></h3><a href="javascript:LifeQuote.onRequestCallback();" id="request-callback" title="Click to receive call from Lifebroker"><span>Call Me Back</span></a><p>A Lifebroker consultant can call you back to discuss your options.</p>');
		},
		
		renderSimple : function() {
			$("#contact-panel").addClass("simple");
			$("#contact-panel").find(".row.mid").first().empty().append('<h3>Call Lifebroker Now<br /><span>1800 204 124</span></h3>');
		}
	};
	
	slide_callbacks.register({
		mode:			'before',
		slide_id:		-1,
		callback:		function(){	
			CallNowPanel.render( QuoteEngine._options.currentSlide != 2 );
			$('html, body').animate({ scrollTop: 0 }, 'fast');
		}
	});
</go:script>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<go:script marker="onready">
	Track.onQuoteEvent("Start", ReferenceNo.getTransactionID());
	
	CallNowPanel.render( true );
</go:script>

<%-- Only touch as a new quote when it IS actually a new quote and not just being opened --%>
<go:script marker="onready">
		<c:choose>
			<c:when test="${isNewQuote eq false}">
				<c:if test="${not empty callCentre}">
				Track.contactCentreUser( '${data.life.application.productId}', '${data.login.user.uid}' );
				</c:if>
			</c:when>
			<c:otherwise>
				LifeQuote.touchQuote("N");
			</c:otherwise>
		</c:choose>

		ReferenceNo.overrideSave(function(){
			var defaults = {
				email: $("#life_contactDetails_email").val(),
				optin: $("#life_contactDetails_optIn").is(":checked") ? "Y" : "N"
			}
			SaveQuote.setToMySQL().show( SaveQuote._SAVE, defaults, function( optin ) {
				if( optin == "Y" )
				{
					$("#life_contactDetails_optIn").attr("checked", "true");
				}
				else
				{
					$("#life_contactDetails_optIn").removeAttr("checked");
				}
			} );
		});
	</go:script>