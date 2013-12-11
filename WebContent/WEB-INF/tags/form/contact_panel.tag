<%@ tag description="The top-most header"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 		required="false" rtexprvalue="true"	description="The vertical this quote is associated with" %>
<%@ attribute name="isCallCentre" 	required="false" rtexprvalue="true"	description="Whether user is a call centre consultant" %>

<%-- HTML --%>
<c:if test="${not empty quoteType and fn:contains('health,life,ip', quoteType)}">
		<div id="contact-panel">
			<div class="row top"><span class="border-blue-bar"></span><!--  empty --></div>
			<div class="row mid">
				<div class="icon"><!-- empty --></div>
				<div class="msg"><span class="intro">Call us</span><span class="phone">1800 77 77 12</span>
					<span class="times">
						<span>Mon &#45; Thu 8:30am to 8pm &amp; Fri 8:30am-6pm (AEST)</span>
						<a href="javascript:HolidayHoursInfoDialog.launch();">Reduced Call Centre Holiday Hours.</a>
					</span>
				</div>
				<%-- Live person chat --%>
				<c:if test="${not callCentre}">
					<div id="chat-health-insurance-sales"></div>
				</c:if>
				<c:if test="${not callCentre and not empty quoteType and fn:contains('health', quoteType)}">
					<div class="handtext"><!-- empty --></div>
				</c:if>
			</div>
			<div class="row bot"><!--  empty --></div>
		</div>

<go:style marker="css-head">

#contact-panel {
	float: 					right;
	display:				none;
	z-index:				300;
}

#contact-panel {
	position:				relative;
	width:					226px;
	height:					80px;
	float:					right;
	right:					-230px;
	top:					-5px;
}

#contact-panel h3 {
	font-size:				15pt;
	padding:				15px 20px;
}

#contact-panel #chat-health-insurance-sales {
    position:				absolute;
	width:					105px;
	height:					38px;
	top:					2px;
    right:					10px;
}

#contact-panel #chat-health-insurance-sales a {
	position:				absolute;
	width:					105px;
	height:					38px;
	overflow:				hidden;
	background:				transparent url(common/images/liveperson/button/button_hover.png) top left no-repeat;
}

#contact-panel #chat-health-insurance-sales a:hover {
	background-position:	bottom left;
}

#contact-panel #chat-health-insurance-sales img {
	display:				none;
}
	
#contact-panel .row {
	width:					auto;
}
	
#contact-panel .row.top {
	height:					5px;
}
	
#contact-panel .row.bot {
	height:					5px;
}

#contact-panel h3 {
	color:					#E54200;
}

#contact-panel h3 span {
	color:					#4A4F51;
}
	
#contact-panel .row {
	background-color:		transparent;
	background-position:	top left;
	background-repeat:		no-repeat;
}
	
#contact-panel .row.top {
	background-image:		url(brand/ctm/images/callus_panel_top.png);
}
	
#contact-panel .row.mid {
	background-repeat:		repeat-y;
	background-image:		url(brand/ctm/images/callus_panel_mid.png);
}
	
#contact-panel .row.bot {
	background-position:	bottom left;
	background-image:		url(brand/ctm/images/callus_panel_bot.png);
}
#contact-panel .row.top.long {
	background-image:		url(brand/ctm/images/callus_panel_top_440.png);
}

#contact-panel .row.mid.long {
	background-image:		url(brand/ctm/images/callus_panel_mid_440.png);
}

#contact-panel .row.bot.long {
	background-image:		url(brand/ctm/images/callus_panel_bot_440.png);
}
#contact-panel .row.top.no-images {
	background-image:		none;
	background:				#0DB14B;
	-webkit-border-top-left-radius: 4px;
	-webkit-border-top-right-radius: 4px;
	-moz-border-radius-topleft: 4px;
	-moz-border-radius-topright: 4px;
	border-top-left-radius: 4px;
	border-top-right-radius: 4px;
}
#contact-panel .row.bot.no-images {
	background-image:		none;
}

#contact-panel .row.mid.no-images {
	background-image:		none;
	background:				#FBFBFB;
	border:					solid 1px #E3E8EC;
	-webkit-border-bottom-right-radius: 4px;
	-webkit-border-bottom-left-radius: 4px;
	-moz-border-radius-bottomright: 4px;
	-moz-border-radius-bottomleft: 4px;
	border-bottom-right-radius: 4px;
	border-bottom-left-radius: 4px;
}
#contact-panel .row.top.no-images .border-blue-bar {
	background:				#1C3F94;
	width:					22px;
	display:				block;
	height:					5px;
	-webkit-border-top-left-radius: 4px;
	-moz-border-radius-topleft: 4px;
	border-top-left-radius: 4px;
}
</go:style>		

</c:if>

<%-- JAVASCRIPT --%>
<c:if test="${not empty quoteType and fn:contains('health,life,ip', quoteType)}">
<go:script marker="js-head">	
	var ContactPanelHandler = function() {
		
		var	that = this,
			elements = {
				panel : $("#contact-panel"),
				win : $(window)
			},
			start = {
				top : 0,
				height: 0,
				ratio: 2
			};
		
		this.init = function() {
			elements.panel =	$("#contact-panel");
			elements.win = 		$(window);

			start.top = 		elements.panel.position().top;
			start.height =		elements.panel.find(".row.mid").first().innerHeight();			
			start.ratio = 		start.height / start.top;

			applyListeners();
		};

		this.reinit = function( new_top ) {	
			new_top = new_top || false;
			
			if( new_top ) {
				start.top = new_top;
			}	
			
			start.height =		elements.panel.find(".row.mid").first().innerHeight();
			start.ratio = 		start.height / start.top;
			
			// Need to reapply events as they may have been lost (particularly moving from a results page)
			applyListeners();
		};
		
		var applyListeners = function () {
				
			$(window).unbind("scroll", contactPanelHandler.rePosition);
			$(window).scroll(contactPanelHandler.rePosition);
		
			that.rePosition();	
		};

		this.rePosition = function() {
			if( elements.win.scrollTop() > (start.top + (start.height/ start.ratio)) ) {
				elements.panel.css({
					top : -5 + "px"
				});
				<c:if test="${not callCentre and not empty quoteType and fn:contains('health', quoteType)}">
				elements.panel.find('.handtext').first().css({top:10});
				</c:if>
				elements.panel.addClass('moving');
			} else if( elements.win.scrollTop() >= start.top ) {
				elements.panel.css({
					top : (start.top - (elements.win.scrollTop() - start.top) - 4) + "px"
				});
				<c:if test="${not callCentre and not empty quoteType and fn:contains('health', quoteType)}">
				elements.panel.find('.handtext').first().css({top:1});
				</c:if>
				elements.panel.addClass('moving');
			} else {
				elements.panel.css({
					top : start.top + "px"
				});
				<c:if test="${not callCentre and not empty quoteType and fn:contains('health', quoteType)}">
				elements.panel.find('.handtext').first().css({top:-5});
				</c:if>
				elements.panel.removeClass('moving');
			}
		}
	};
	
	var contactPanelHandler = new ContactPanelHandler();
</go:script>

<go:script marker="onready">
	contactPanelHandler.init();	
</go:script>
</c:if>
