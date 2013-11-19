<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-selection" class="health-situation">

	<simples:dialogue id="19" vertical="health" />
	<simples:dialogue id="20" vertical="health" />
	<simples:dialogue id="0" vertical="health" className="red">
		<field:array_radio xpath="health/simples/contactType" items="outbound=Outbound quote,inbound=Inbound quote" required="true" title="Contact type (outbound/inbound)" />
	</simples:dialogue>
	<simples:dialogue id="21" vertical="health" mandatory="true" />
	<simples:dialogue id="22" vertical="health" className="green" />

	<form:fieldset legend="Cover Type" >
		<form:row label="I want cover for a">
			<field:general_select xpath="${xpath}/healthCvr" type="healthCvr" className="health-situation-healthCvr" required="true" title="type of cover" />
		</form:row>
		<form:row label="I live in">
			<field:array_select items="=Please choose...,ACT=ACT,NSW=NSW,NT=NT,QLD=QLD,SA=SA,TAS=TAS,VIC=VIC,WA=WA" xpath="${xpath}/state" title="your location" required="true" className="health-situation-state" />
		</form:row>
		<form:row label="My situation is">
			<field:general_select xpath="${xpath}/healthSitu" type="healthSitu" className="health-situation-healthSitu" required="true" title="situation type" />
		</form:row>
		<%-- Medicare card question --%>
		<c:if test="${callCentre}">
			<form:row label="Do all people to be covered on this policy have a green or blue Medicare card?" className="health_situation_medicare">
				<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/cover" title="your Medicare card cover" required="true" className="health-medicare_details-card" id="${name}_cover"/>
			</form:row>
			<go:validate selector="${name}_cover" 	rule="agree" parm="true" message="Unfortunately we cannot continue with your quote"/>
		</c:if>
	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
$('.health-situation-healthCvr').on('change',function() {
	healthChoices.setCover($(this).val());
});

$('.health-situation-healthSitu').on('change',function() {
	healthChoices.setSituation($(this).val());
});

$('.health-situation-state').on('change',function() {
	healthChoices.setState($(this).val());
});

$(function(){
	healthChoices.setState($('.health-situation-state').val());
});

<%-- Adding the Medicare Question at the start for the Call Centre people --%>
<c:if test="${callCentre}">
	$(function() {
		$("#${name}_cover").buttonset();
	});
	if(	$('#${name}_cover').val() == '' ){
		$('#${name}').slideDown('fast');
	};
	$('#${name}_cover').on('change', function(){
		$('.health-medicare_details').find('input.health-medicare_details-card[value="'+ $(this).find('input:radio:checked').val() +'"]').attr('checked',true).button('refresh');
	});
</c:if>

</go:script>