<%@ tag description="The top-most header"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 		required="false" rtexprvalue="true"	description="The vertical this quote is associated with" %>
<%@ attribute name="isCallCentre" 	required="false" rtexprvalue="true"	description="Whether user is a call centre consultant" %>

<%-- HTML --%>
<c:if test="${not empty quoteType and fn:contains('health,life,ip', quoteType)}">
		<div id="contact-panel">
			<div class="row top"><!--  empty --></div>
			<div class="row mid">
				<div class="icon"><!-- empty --></div>
				<div class="msg">Call us <span class="phone">1800 77 77 12</span></div>
				<%-- Live person chat --%>
				<c:if test="${not callCentre}">
					<span class='or'>OR</span>
					<div id="chat-health-insurance-sales"><!-- populated externally --></div>
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
    width:					95px;
    height:					37px;
    top:					50%;
    right:					10px;
    margin-top:				-10px;
}

#contact-panel #chat-health-insurance-sales img {
    margin-top: -10px;
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
</go:style>		

</c:if>

<%-- JAVASCRIPT --%>
<c:if test="${not empty quoteType and fn:contains('health', quoteType)}">
<go:script marker="js-head">	
	var ContactPanelHandler = function() {
		
		var	that = this,
			elements = {
				panel : $("#contact-panel"),
				win : $(window)
			},
			start = {
				top : 30,
				height: 0
			};
		
		this.init = function() {
			elements.panel =	$("#contact-panel");
			elements.win = 		$(window);
			start.height =		elements.panel.find(".row.mid").first().innerHeight();			
				
			$(window).unbind("scroll", contactPanelHandler.rePosition);
			$(window).scroll(contactPanelHandler.rePosition);
		};
		
		this.rePosition = function() {
			if( elements.win.scrollTop() > (start.top + (start.height/2)) ) {
				elements.panel.css({
					top : -4 + "px"
				});
			} else if( elements.win.scrollTop() >= start.top ) {
				elements.panel.css({
					top : (start.top - (elements.win.scrollTop() - start.top) - 4) + "px"
				});
			} else {
				elements.panel.css({
					top : start.top + "px"
				});
			}
		}
	};
	
	var contactPanelHandler = new ContactPanelHandler();
</go:script>

<go:script marker="onready">
	contactPanelHandler.init();	
</go:script>
</c:if>
