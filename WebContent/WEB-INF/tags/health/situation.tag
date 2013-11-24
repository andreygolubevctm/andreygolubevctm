<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:set var="autocompleteSource">
	function( request, response ) {

		// format is something like "Toowong Bc 4066 QLD"
		format = /^.*\s\d{4}\s(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)$/;

		// don't search if the value matches the format we aim for
		if( !format.test( $('#${name}_location').val() ) ){

			$.ajax({
				url: "ajax/json/get_suburbs.jsp",
				data: {
						term: request.term,
						fields: 'postcode, suburb, state'
				},
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function( data ) {
					response( $.map( data, function( item ) {
						if( item.length != undefined ){

							if( data.length == 1 ) {
								$('#${name}_location').val(item);
							}

							return {
								label: item,
								value: item
							}
						} else {
							return data;
						}
					}));
				}
			});

		} else {
			$('#${name}_location').autocomplete("close");
		}

	}
</c:set>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

<%-- To proceed a user must select either a valid postcode or enter a suburb and
	select a valid suburb/postcode/state value from the autocomplete. This is to
	avoid suburbs that match multiple locations being sent with request only to be
	returned empty because can only search a single location (FUE-23). --%>
$.validator.addMethod("validateHealthPostcodeSuburb",
	function(value, element) {

		if( healthChoices.isValidLocation(value) ) {
			healthChoices.setLocation(value);

			return true;
		}

		return false;
	},
	"Replace this message with something else"
);
</go:script>

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
			<field:autocomplete xpath="${xpath}/location" title="Postcode/Suburb" required="true" source="${autocompleteSource}" min="2" placeholder="Suburb / Postcode"/>
			<field:hidden xpath="${xpath}/suburb" />
			<field:hidden xpath="${xpath}/postcode" />
			<field:hidden xpath="${xpath}/state" />
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

<%-- VALIDATION --%>
<go:validate selector="${name}_location" rule="validateHealthPostcodeSuburb" parm="true" message="Please select a valid suburb / postcode" />

<go:script marker="onready">
$('.health-situation-healthCvr').on('change',function() {
	healthChoices.setCover($(this).val());
});

$('.health-situation-healthSitu').on('change',function() {
	healthChoices.setSituation($(this).val());
});

$('.health-situation-location').on('change',function() {
	healthChoices.setLocation($(this).val());
});

if($('#${name}_location').val() != '') {
	healthChoices.setLocation($('#${name}_location').val());
}

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

<go:style marker="css-head">

#${name}-selection .fieldrow_legend {
	float:	none;
}

#${name}_location {
	width:	205px;
}

ul.ui-autocomplete.ui-menu  {
	max-height:200px;
	overflow:hidden;
}

</go:style>