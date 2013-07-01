<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's date of birth, where the min and max age can be dynamically changed"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="ageMax" 	required="false"  	rtexprvalue="true"	 description="Min Age requirement for Person, e.g. 16" %>
<%@ attribute name="ageMin" 	required="false"  	rtexprvalue="true"	 description="Max Age requirement for Person, e.g. 99" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${empty ageMin}">
	<c:set var="ageMin" value="16" />
</c:if>

<c:if test="${empty ageMax}">
	<c:set var="ageMax" value="99" />
</c:if>

<%-- CSS --%>
<go:style marker="css-head">
	.dob_container span.fieldrow_legend {
		float:none;
	}
</go:style>

<%-- HTML --%>
<span class="dob_container">
	<input type="text" name="${name}" id="${name}" class="person_dob general_dob" value="${data[xpath]}" title="The ${title} date of birth" size="12">
	<span class="fieldrow_legend">Example: 14/06/1975</span>
</span>

<%-- JQUERY UI --%>
<go:script marker="jquery-ui">
	$("#${name}")
		.mask("99/99/9999",{placeholder: 'DD/MM/YYYY'})
		.blur(function(){
			$("#${name}_dp").val($(this).val());
		});
</go:script>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var dob_${name} = {
	ageMin:${ageMin},
	ageMax:${ageMax},
	message:''
};


$.validator.addMethod("min_dob_${name}",
	function(value, element) {
		
		var now = new Date();
		var temp = value.split('/');		 
		var minDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- dob_${name}.ageMin) ); <%-- ("MM/DD/YYYY") x-browser --%>
		
		//min Age check for fail
		if( minDate > now  ){
			return false;
		};
	
		return true;
	}
);

$.validator.addMethod("max_dob_${name}",
	function(value, element) {
		
		var now = new Date();
		var temp = value.split('/');		 
		var maxDate = new Date(temp[1] +'/'+ temp[0] +'/'+ (temp[2] -+- dob_${name}.ageMax) ); <%-- ("MM/DD/YYYY") x-browser --%>		
		
		//max Age check for fail
		if( maxDate < now ){
			return false;
		};		

		return true;
	}
);
</go:script>

<%-- VALIDATION --%>
<fmt:setLocale value="en_GB"/>

<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<fmt:formatDate value="${now.time}" pattern="MM/dd/yyyy" var="nowDate" />


<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title} date of birth"/>
<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="min_dob_${name}" parm="true" message="${title} age cannot be under ${ageMin}" />
<go:validate selector="${name}" rule="max_dob_${name}" parm="true" message="${title} age cannot be over ${ageMax}" />