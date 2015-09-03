<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="label" 		required="false"	 rtexprvalue="true"	 description="The row heading label." %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<c:set var="vertical">
	<c:choose>
		<c:when test="${fn:startsWith(name, 'life_')}">life</c:when>
		<c:otherwise>ip</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${empty label}">
	<c:set var="label"  value="Your Details" />
</c:if>

<c:set var="error_phrase" value="primary person's " />
<c:set var="error_phrase_postcode" value="" />
<c:if test="${fn:contains(name, 'partner')}">
	<c:set var="error_phrase" value="partner's " />
	<c:set var="error_phrase_postcode" value="partner's " />
</c:if>

<%-- HTML --%>
<div id="${name}" class="${name}_details">
	<form:fieldset legend="${label}">
		<life:name xpath="${xpath}" error_phrase="${error_phrase}" />

		<div class="clear"><!-- empty --></div>

		<form:row label="Gender">
			<field:array_radio  id="${name}_gender" xpath="${xpath}/gender" required="true" title="${error_phrase}gender" items="F=Female,M=Male" />
		</form:row>

		<form:row label="Date of birth">
			<field:person_dob xpath="${xpath}/dob" required="true" title="${error_phrase}" />
		</form:row>

		<field:hidden xpath="${xpath}/age" required="false" />

		<form:row label="Smoker status">
			<field:array_radio  id="${name}_smoker" xpath="${xpath}/smoker" required="true" title="${error_phrase}smoker status" items="N=Non-Smoker,Y=Smoker" />
		</form:row>

		<form:row label="Occupation" helpId="525">
			<field:general_select type="occupation" comboBox="true" xpath="${xpath}/occupation" hannoverXpath="${xpath}/hannover" required="true" title="${error_phrase}occupation"/>
		</form:row>

	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
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

<%-- CSS --%>
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