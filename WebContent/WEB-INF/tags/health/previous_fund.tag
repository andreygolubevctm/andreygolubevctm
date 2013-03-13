<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="id" required="true" rtexprvalue="true" description="Id for this panel"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Additional css class attribute"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}">
		
	<simples:dialogue id="15" mandatory="true" />

	<form:fieldset id="${id}" legend="Previous Fund Details" className="health-previous_fund">

		<form:row label="Your current health fund" id="clientFund">		
			<field:import_select xpath="${xpath}/primary/fundName" url="/WEB-INF/option_data/health_funds.html" title="your health fund" required="true" />	
		</form:row>
	
		<form:row label="Partner's current health fund" id="partnerFund">
			<field:import_select xpath="${xpath}/partner/fundName" url="/WEB-INF/option_data/health_funds.html" title="partner's health fund" required="true" />	
		</form:row>
		
		<%-- Optional Membership ID's --%>
		<div class="membership">
	
			<h5>Please provide your membership IDs below.</h5>
			<p class="inlineMessage">This information will assist your new fund arrange the transfer for you</p>		

			<form:row label="Your membership ID" id="clientMemberID">
				<field:input xpath="${xpath}/primary/memberID" title="your member ID" required="true" />
				<div class="health_previous_fund_authority">
					<field:checkbox xpath="${xpath}/primary/authority" value="Y" title="I authorise <span>the fund</span> to contact my previous fund to obtain a <a href='javascript:void(0);' class='certificate'>clearance certificate</a>" label="I authorise <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" />
				</div>
			</form:row>
	
			<form:row label="Partner's membership ID" id="partnerMemberID">
				<field:input xpath="${xpath}/partner/memberID" title="partner's member ID" required="true" />
				<div class="health_previous_fund_authority">
					<field:checkbox xpath="${xpath}/partner/authority" value="Y" title="My partner authorises <span>the fund</span> to contact my previous fund to obtain a <a href='javascript:void(0);' class='certificate'>clearance certificate</a>" label="My partner authorises <span>the fund</span> to contact my previous fund to obtain a transfer certificate" required="false" />
				</div>
			</form:row>
	
		</div>
		
	</form:fieldset>

</div>


<go:style marker="css-head">
	#${name} .membership.onA.onB .inlineMessage {
		top:48px;		
	}
	#${name} .membership,
	#clientMemberID,
	#partnerMemberID {
		display:none;
		min-height:0px;
	}
	#clientMemberID, #partnerMemberID {
		min-height:0px;
	}
	.health_previous_fund_authority {
		margin-bottom:15px;
		margin-top:4px;
		width:240px;	
		display:none;
	}
</go:style>

<go:script marker="js-head">
	healthPreviousFund = {
		error: function(){
			if( $('#policy_details').find('.message').text() == healthPolicyDetails.messagePriceChange ){
				return; //not needed as 'goal' is already created
			};
			<%-- Compare the previously answered questions with these questions and throw a possible error --%>
			var _primary = 	$('#${name}_primary_fundName').find(':selected').val();
			var _primaryOriginal = $('.primary').find('.health-cover_details :checked').val();
			if(  _primary == 'NONE' &&  _primaryOriginal == 'Y' ){
				healthPolicyDetails.error();
			} else if( _primary != 'NONE' &&  _primaryOriginal == 'N' ) {
				healthPolicyDetails.error();
			} else {
				healthPayment.priceChange();
			};
			if( healthChoices.hasSpouse() ){
				var _partner = 	$('#${name}_partner_fundName').find(':selected').val();
				var _partnerOriginal = $('.partner').find('.health-cover_details :checked').val();
				if(  _partner == 'NONE' &&  _partnerOriginal == 'Y' ){
					healthPolicyDetails.error();
				} else if( _partner != 'NONE' &&  _partnerOriginal == 'N' ) {
					healthPolicyDetails.error();
				};
			};
			return;
		}
	};
</go:script>

<go:script marker="onready">
	$(function() {
		$("#${name}_confirmCover").buttonset();
	});
	
	$('#${name}_primary_fundName, #${name}_partner_fundName').on('change', function(){
		<%-- Compare Health Funds to see if error message needs to be displayed --%>
		healthPreviousFund.error();
		<%-- REVISE: do you need to change the pre-application questions --%>
		healthCoverDetails.displayHealthFunds();
	});
	$('#${name}').find('.membership').on('click', 'a.certificate', function(){
		generic_dialog.display('<p>When you change Health Funds, a clearance certificate is sent from the Fund you are leaving, to the Fund you are joining.</p><br /><p>It contains details of the cover provided by your existing policy, so that your new Fund can recognise the waiting periods you have already served.</p>', 'Clearance certificate')
	});
	
<c:if test="${not empty callCentre}">
	if( ($('#${name}_primary_fundName').val() != '' && $('#${name}_primary_fundName').val() != 'NONE') || ($('#${name}_partner_fundName').val() != '' && $('#${name}_partner_fundName').val() != 'NONE') )
	{
		$(".simples-dialogue-15").first().show();
	}
	else
	{
		$(".simples-dialogue-15").first().hide();
	}
	
	$('#${name}_primary_fundName, #${name}_partner_fundName').on('change', function(){
		if( $(this).val() != '' && $(this).val() != 'NONE' )
		{
			$(".simples-dialogue-15").first().show();
		}
		else if( ($('#${name}_primary_fundName').val() == '' || $('#${name}_primary_fundName').val() == 'NONE') && ($('#${name}_partner_fundName').val() == '' || $('#${name}_partner_fundName').val() == 'NONE') )
		{
			$(".simples-dialogue-15").first().hide();
		}
	});
</c:if>	
</go:script>
