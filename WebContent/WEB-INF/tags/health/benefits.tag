<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 					value="${go:nameFromXpath(xpath)}" />
	<%-- Set these as session scope to be used later --%>
	<c:set var="xpathBenefitsExtras" value="${xpath}/benefitsExtras"  />


<%-- HTML --%>

<%-- Selection Pre-Heading --%>
<div id="${name}-selection" class="health-benefits">
	
	<simples:dialogue id="23" vertical="health" className="green" />
	
	<p class="intro"><%-- Completed via JS-Object --%></p>

	<div class="clear"><!-- empty --></div>
</div>

<%-- Simples --%>
<div id="${name}MoveDestination"></div>

<simples:dialogue id="24" vertical="health" mandatory="true" />



<%-- CSS --%>
<go:style marker="css-head">
	.health-benefits .intro {
		margin-top:20px;
		margin-bottom:20px;
	    font-size: 1.2em;
	    line-height: 125%;		
	}
	#${name} .clear {
		clear: both;
	}
	
	<%-- Styles to display benefits on Step 1 --%>
	.stage-0 #health_benefitsUpdateBtn, .stage-0 .health_benefitsSituation {
		display: none;
	}
	.stage-0 #health_benefitsContentContainer {
		display: block !important;
	}
	.stage-0 #health_benefitsContentContainer .four-columns {
		width: 50%;
	}
	.stage-0 #health_benefitsContentContainer .two-columns.extras {
		position: relative;
		left: 75%;
		clear: both;
	}
	.stage-0 #health_benefitsContentContainer #col3 {
		clear: left;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var HealthBenefits = {

	<%-- This is to make sure the faux button is visible if it needs to be --%>
	_resetButtons: function(){
	},
	
	applyNoteListeners : function()
	{
	},
	
	showHideNotes : function( force_hide, delay )
	{
	},
	
	updateIntro: function( situ ) {
		var msg = '';
		
		switch (situ) {
			case 'YS':
				msg = "If you have an active lifestyle, you may want to consider extras like physiotherapy or even cover for expensive treatments like knee reconstructions. More about cover for <a href='javascript:HintsDetailDialog.launch(\"young-singles\");'>young singles</a>.";
				break;
			case 'YC':
				msg = "Thinking of starting a family? Waiting periods for pregnancy or birth-related services are generally 12 months. Don't leave it too late. More about cover for <a href='javascript:HintsDetailDialog.launch(\"young-couples\");'>young couples</a>.";
				break;
			case 'CSF':
				msg = "Waiting periods for <a href='javascript:HintsDetailDialog.launch(\"birth-related-services\");'>pregnancy and birth related services</a> are generally 12 months. Don't leave it too late. More about <a href='javascript:HintsDetailDialog.launch(\"couples-starting-family\");'>couples starting a family</a>.";
				break;
			case 'FK':
				msg = "Cover for braces usually has a 12 month waiting period. Some funds will pay more toward these services the longer you are with them. More about <a href='javascript:HintsDetailDialog.launch(\"families\");'>cover for families</a>.";
				break;
			case 'M':
				msg = "The waiting period for joint replacement is generally 2 months unless it's a pre-existing condition in which case 12 months will apply. More information about cover for <a href='javascript:HintsDetailDialog.launch(\"mature-couples\");'>mature couples</a>.";
				break;
			case 'ATP':
				msg = "If you earn over $88,000 as a single or $176,000 as a family, you will have to pay additional tax if you don't have private hospital cover. More on the <a href='javascript:HintsDetailDialog.launch(\"medicare-levy-surcharge\");'>Medicare Levy Surcharge</a>.";
				break;
		}
		
		$('.${name}Situation p').html(msg);
	},

	<%-- Move benefits panel to Step 1 --%>
	moveBenefitsToStep1: function() {
		$('#health_benefitsContentContainer').appendTo('#${name}MoveDestination');
		$('.health_benefitsContent > .two-columns.extras').insertAfter('.health_benefitsContent #col2');
	},
	
	<%-- Move benefits panel back to Results --%>
	moveBenefitsToResults: function() {
		$('#health_benefitsContentContainer').insertAfter('#health_benefitsHeader');
		$('.health_benefitsContent .two-columns.extras').insertAfter('.health_benefitsContent .two-columns.hospital');
	}	
};

<%-- Only call centre users will see benefits on Step 1 --%>
<c:if test="${not empty callCentre}">
	slide_callbacks.register({
		mode:		'after',
		slide_id:	0,
		callback:	function() { HealthBenefits.moveBenefitsToStep1(); }
	});
	slide_callbacks.register({
		mode:		'after',
		direction:	'forward',
		slide_id:	1,
		callback:	function() { HealthBenefits.moveBenefitsToResults(); }
	});	
</c:if>
</go:script>
	
<go:script marker="onready">
</go:script>
