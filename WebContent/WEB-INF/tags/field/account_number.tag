<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="minLength" 		required="false"	 rtexprvalue="true"	 description="Maximum number of digits"%>
<%@ attribute name="maxLength" 		required="false"	 rtexprvalue="true"	 description="Minimum number of digits"%>

<%-- VARIABLES --%>
<c:set var="accountnum" value="${go:nameFromXpath(xpath)}" />

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<input type="text" name="${accountnum}" id="${accountnum}" class="account_name ${className} numeric" value="${value}" size="20" maxlength="${maxLength}">

<go:script marker="js-head">
$.validator.addMethod('trimLeftZeros', function(value, element, param) {
	/**
	 * This validation will always pass but will strip out invalid characters
	 * from the string before moving onto the genuine validation tests.
	 */
	var tmpVal = '';
	
	if( value != '' ) {
		try {
			tmpVal = String( parseInt(String(value), 10) );
		} catch(e) {
			// ignore and move on son
		}
	
		$(element).val( String(tmpVal) );
	}
	
	return true;
});
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${accountnum}" rule="trimLeftZeros" parm="${required}" message="No message required - always passes"/>

<go:validate selector="${accountnum}" rule="required" parm="${required}" message="Please enter ${title}"/>
<go:validate selector="${accountnum}" rule="digits" parm="${required}" message="Please enter ${title}"/>

<c:if test="${not empty minLength}">
	<go:validate selector="${accountnum}" rule="minlength" parm="${minLength}" message="The account number cannot have less than ${minLength} digits"/>
</c:if>

<c:if test="${not empty maxLength}">
	<go:validate selector="${accountnum}" rule="maxlength" parm="${maxLength}" message="The account number cannot have more than ${maxLength} digits"/>
</c:if> 
<%--
<field:highlight_row name="${go:nameFromXpath(xpath)}" inlineValidate="${required}" />
--%>