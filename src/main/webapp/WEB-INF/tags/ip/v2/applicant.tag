<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="label" 		required="false"	 rtexprvalue="true"	 description="The row heading label." %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty label}">
	<c:set var="label"  value="About You" />
</c:if>

<c:set var="error_phrase" value="the primary person's " />
<c:set var="error_phrase_postcode" value="" />
<c:if test="${fn:contains(name, 'partner')}">
	<c:set var="error_phrase" value="partner's " />
	<c:set var="error_phrase_postcode" value="partner's " />
</c:if>

<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
	</jsp:attribute>

	<jsp:body>
		<form_v1:fieldset legend="${label}">
			<form_v2:row label="First Name" id="firstName">
				<field_v1:person_name xpath="${xpath}/firstName" required="true" title="${error_phrase}first name" />
			</form_v2:row>

			<form_v2:row label="Last Name" id="lastName">
				<field_v1:person_name xpath="${xpath}/lastname" required="true" title="${error_phrase}surname" />
			</form_v2:row>

			<form_v2:row label="Gender">
				<field_v2:array_radio xpath="${xpath}/gender"
									  required="true"
									  items="F=Female,M=Male"
									  title="${error_phrase}gender" />
			</form_v2:row>

			<form_v2:row label="Date of Birth">
				<field_v2:person_dob xpath="${xpath}/dob" title="primary person's" required="true" ageMin="18" ageMax="65" />
			</form_v2:row>

			<form_v2:row label="Smoker status">
				<field_v2:array_radio xpath="${xpath}/smoker"
									  required="true"
									  items="N=Non-Smoker,Y=Smoker"
									  title="${error_phrase}smoker status" />
			</form_v2:row>

			<form_v2:row label="Occupation" id="${name}_yearRow" helpId="525">
				<field_v2:general_select type="occupation" xpath="${xpath}/occupation" required="true" title="${error_phrase}occupation"/>
			</form_v2:row>

		</form_v1:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>
<%-- JAVASCRIPT
<go:script marker="js-head">
var ${name}Handler = {
	getAgeAtNextBday: function(dob)
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
		{
			age--;
		}

		return ++age;
	}
};

$.validator.addMethod("validateAge",
	function(value, element) {
		var getAge = function(dob) {
			var dob_pieces = dob.split("/");
			var year = Number(dob_pieces[2]);
			var month = Number(dob_pieces[1]) - 1;
			var day = Number(dob_pieces[0]);
			var today = new Date();
			var age = today.getFullYear() - year;
			if(today.getMonth() < month || (today.getMonth() == month && today.getDate() < day))
			{
				age--;
			}
		}

		var age = getAge( value );

		if( age < 18 || age > 65 )
		{
			return false;
		}

		return true;
	},
	"Replace this message with something else"
);
</go:script>

<go:script marker="onready">

	$("#${name}_smoker, #${name}_gender").buttonset();

	if( $('input[name=${name}_smoker]:checked', '#mainform').val() == undefined )
	{
		$('#${name}_smoker_N').attr('checked', true).button('refresh');
	}

	if( $('#${name}_dob').val().length )
	{
		$('#${name}_age').val(${name}Handler.getAgeAtNextBday( $('#${name}_dob').val() ));
	}

	$('#${name}_dob').on("change keyup", function(){
		$('#${name}_age').val(${name}Handler.getAgeAtNextBday( $('#${name}_dob').val() ) );
	});

</go:script>

<%-- CSS
<go:style marker="css-head">
	#${name} .clear {
		clear: both;
	}

	#${name} .content {
		position: relative;
	}

	#${name}_occupation {
		width: 380px;
	}
</go:style>

<go:validate selector="${name}_dob" rule="validateAge" parm="true" message="Age must be between 18 and 65." />


--%>