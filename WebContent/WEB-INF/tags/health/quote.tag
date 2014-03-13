<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Additional css class attribute"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="health-quote" class="${className}">

	<simples:dialogue id="31" vertical="health" className="red" />


	<div id="summary-header">
		<h2>Congratulations. You've compared and found the right Health Cover for you.<br /> We hope you've enjoyed comparing with us. <a href="javascript:void(0);" class="button" id="revise"><span>Start New Quote</span></a></h2>
	</div>	
	
	<div id="confirmation-order-summary">
	
		<div class="col_1x3">
		
			<div class="summary"><%-- Pull the product summary panel into here --%></div>

			<%-- Offers --%>		
			<div class="headed-box" id="confirmation_offers">
				<div class="headed-box-top"></div>
				<div class="headed-box-middle">
					<h4>Promotions &amp; offers</h4>
					<div class="content"></div>
				</div>
				<div class="headed-box-bottom"></div>
			</div>
			<%-- About --%>
			<div class="headed-box" id="confirmation_about">
				<div class="headed-box-top"></div>
				<div class="headed-box-middle">
					<h4>About the fund</h4>
					<div class="content"></div>
				</div>
				<div class="headed-box-bottom"></div>
			</div>						
		</div>
		
		
		<div class="col_2x3">	
			<health:policy_snapshot />		
		</div>
	
	</div>

</div>


<%-- CSS --%>
<go:style marker="css-head">

#slide5 > h2 {
	display:none;
}

#confirmation-order-summary {
	margin-top:40px;
}

#summary-header {
	display:none;
}

.col_1x3 {
	float:left;
	width:296px;
	margin-right:20px;
}

.col_2x3 {
	float:left;
	width:320px;
}

.headed-box {
	margin-bottom:20px;
}

.headed-box h4 {
	margin-bottom:10px;
}

#policy_snapshot .ui-tabs-nav,
#more_snapshotDialog .ui-tabs-nav {
	padding:0;
	margin-top:0;
}

#more_snapshotDialog .ui-tabs-nav {
	margin-top:0px;
}

#policy_snapshot .ui-tabs-nav li,
#more_snapshotDialog .ui-tabs-nav li {
	background:none;
	border:none;
	padding:0px;
	margin:0px;
	left:auto;
	top:auto;
}

#policy_snapshot .ui-state-default,
#more_snapshotDialog .ui-state-default  {
	background:none !important;
}

#policy_snapshot .ui-tabs-nav li a,
#more_snapshotDialog .ui-tabs-nav li a  {
	padding:15px 20px;
}

#more_snapshotDialog .ui-tabs-panel {
	clear:both;
	margin-bottom:20px;
	overflow:auto;
}

	#policy_snapshot .ui-tabs-panel h4,
	#more_snapshotDialog .ui-tabs-panel h4 {
		margin-top:0;
	}
	
	#policy_snapshot .hospital,
	#more_snapshotDialog .hospital,
	#policy_snapshot .extras,
	#more_snapshotDialog .extras {
		float:left;
		width:250px;
		margin-right:15px;
		margin-bottom:20px;
	}

#confirmation-2 .hospital {
	width:500px;
}

body.callcentre #health-quote .simples-dialogue {
	margin-top: 7em !important;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var Confirmation = {};

Confirmation = {
	init: function() {
		
<%-- HLT-317 Remove the 'Start New Quote' button on the confirmation page for Call Centre staff --%>
<c:if test="${not empty callCentre}">
		$("#revise").unbind().remove();
</c:if>

		Track.onConfirmation( Results.getSelectedProduct() );
		
		if( $("#navContainer").not("#summary-header") )
		{
			$('#summary-header').appendTo('#navContainer');
		}

		$('#steps:visible').hide();
		$('#summary-header:hidden').show();
		
		$('#policy_details, .marketing-panel').show();
		
		healthPolicyDetails.clearError();
		
		$('#policy_details').prependTo('.col_1x3');
		
		<%-- show the whats next tab --%>
		$('#policy_snapshot').tabs('option', 'selected', 3);
		
		<%-- If in confirmation mode, kill any functionality to cause mayhem, user needs to stay put --%>
		if(Health._mode === HealthMode.CONFIRMATION){
			var $_ref = $('#reference_number');
				$_ref.find('a').remove();
				$_ref.find('h4 span').text( Health._confirmation.data.transID );		
		};
		if (Health._mode === HealthMode.CONFIRMATION || Health._mode === HealthMode.PENDING) {
			Health = {};
			JourneyEngine = {};
		}

		<%--
		if( $('#healthynwealthy') ) {
			$('#healthynwealthy').insertBefore("#confirmation_offers").addClass('confirmation').slideDown('slow');
	}
		--%>
	}
};
</go:script>

<go:script marker="onready">
<%-- Reset the application by clearing the data bucket and reloading the page!!! --%>
$('#revise').on('click', function(){
	Loading.show();
	window.location = '${data['settings/root-url']}${data.settings.styleCode}/ajax/load/health_reset.jsp' + window.location.search;
});
</go:script>