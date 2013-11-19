<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"  	rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="className" 	required="false"  	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  	rtexprvalue="true"	 description="optional id for this slide"%>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="health_application">
	<health:person_details xpath="${xpath}/primary" title="Your" id="primary" />
	<core:clear />
	<health:person_details xpath="${xpath}/partner" title="Your Partner's" id="partner" />
	<core:clear />
</div>

<%-- CSS --%>
<go:style marker="css-head">
	.health_person-details_authority_group {
		display:none;
	}
	.health_person-details_authority_group .fieldrow_value {
		margin-top:7px;
	}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
$.validator.addMethod("genderTitle",
	function(value, element, param) {

		if(value == ''){
			return true;
		};

		var _gender = $(element).closest('.qe-window').find('.person-gender input:checked').val();

		if(typeof _gender == 'undefined' || _gender == ''){
			return true; <%-- no need to validate until both completed --%>
		};

		switch( value )
		{
		case 'MR':
			var _success = (_gender == 'M') ? true : false;
			break;
		case 'MRS':
		case 'MISS':
		case 'MS':
			var _success = (_gender == 'F') ? true : false;
			break;
		default:
			var _success = true;
			break;
		};

		return _success;
	},
	$.validator.messages.genderTitle = 'The title and gender do not match'
);
</go:script>

<go:script marker="onready">
	$('#${name}').find('.person-title').each( function(){
		$(this).rules('add','genderTitle');
	});
	<%-- //REFINE: find a better way to call an individual rule check
	$('#${name}').find('.person-gender, .person-title').on('change', function(){
		$(this).closest('.content').find('.person-title').valid('genderTitle');
	});
	--%>
</go:script>