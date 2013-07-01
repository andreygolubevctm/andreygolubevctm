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
				//contactPanelHandler.reinit(3);
				$("#contact-panel").addClass("long");
				$("#contact-panel").children().addClass("long");
			} else {
				CallNowPanel.renderSimple();
				//contactPanelHandler.reinit(30);
				$("#contact-panel").removeClass("long");
				$("#contact-panel").children().removeClass("long");
			}
		},
		
		renderDetail : function() {
			$("#contact-panel").find(".row.mid").first().empty().append('<h3>Call Now<br /><span>1800 204 124</span><br /><span class="contact_panel_small">To speak with a Lifebroker consultant</span></h3><span><strong>OR</strong></span> <a href="javascript:LifeQuote.onRequestCallback();" id="request-callback" title="Click to receive call from Lifebroker"><span><img alt="" title="Get a call back" src="common/images/icons/phone-operator-white.png">&nbsp;Call Me Back</span></a>');
			//contactPanelHandler.reinit(); //Reinitialise to reset the starting positions
		},
		
		renderSimple : function() {
			$("#contact-panel").find(".row.mid").first().empty().append('<h3>Call Now<br /><span>1800 204 124</span><br /><span class="contact_panel_small">To speak with a Lifebroker consultant</span></h3>');
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
	
	Track.nextClicked(0);

	CallNowPanel.render( true );

<%-- Only touch as a new quote when it IS actually a new quote and not just being opened --%>
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

	<go:style marker="css-head">
.contact_panel_small {
	font-size: 10px;
}

</go:style>