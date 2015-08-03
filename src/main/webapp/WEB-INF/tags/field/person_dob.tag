<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's date of birth, where the min and max age can be dynamically changed"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="false" 	rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="titleSuffix" 	required="false" 	rtexprvalue="true"	 description="Optional Suffix to the title"%>
<%@ attribute name="ageMax" 	required="false"  	rtexprvalue="true"	 description="Min Age requirement for Person, e.g. 16" %>
<%@ attribute name="ageMin" 	required="false"  	rtexprvalue="true"	 description="Max Age requirement for Person, e.g. 99" %>
<%@ attribute name="youngest" 	required="false"  	rtexprvalue="true"	 description="Whether the dob field is for the youngest driver" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${empty ageMin}">
	<c:set var="ageMin" value="16" />
</c:if>

<c:if test="${empty ageMax}">
	<c:set var="ageMax" value="99" />
</c:if>

<%-- Set the Example DOB text --%>
<c:choose>
	<c:when test="${not empty youngest}">
		<c:set var="youngDob" value="21/03/1991" />
	</c:when>
	<c:otherwise>
		<c:set var="youngDob" value="14/06/1975" />
	</c:otherwise>
</c:choose>

<%-- CSS --%>
<go:style marker="css-head">
	.dob_container span.fieldrow_legend {
		float:none;
	}
</go:style>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<span class="dob_container">
	<input type="text" name="${name}" id="${name}" class="sessioncamexclude person_dob general_dob ${className}" size="12" value="${value}" title="The ${title} date of birth ${titleSuffix}">
	<span class="fieldrow_legend help-block">Example: <c:out value="${youngDob}" /></span>
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

var dobHandler = new Object();
dobHandler = {
	getAge: function(dateString) {
		var today = new Date();
		var dateSplit = dateString.split("/").reverse();
		if($.browser.msie){
			var birthDate = new Date(parseInt(dateSplit[0],10),parseInt(dateSplit[1],10)-1,parseInt(dateSplit[2],10));
		}
		else {
			var birthDate = new Date(dateSplit);
		}
		var age = today.getFullYear() - birthDate.getFullYear();
		var m = today.getMonth() - birthDate.getMonth();
		if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
			age--;
		}
		return age;
	}
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


<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title} date of birth ${titleSuffix}"/>
<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="min_dob_${name}" parm="true" message="${title} age ${titleSuffix} cannot be under ${ageMin}" />
<go:validate selector="${name}" rule="max_dob_${name}" parm="true" message="${title} age ${titleSuffix} cannot be over ${ageMax}" />