<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
<c:set var="accountname" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<input type="text" name="${accountname}" id="${accountname}" class="account_name ${className} numeric" value="${data[xpath]}" size="20" maxlength="${maxLength}">

<%-- VALIDATION --%>
<go:validate selector="${accountname}" rule="required" parm="${required}" message="Please enter ${title}"/>
<go:validate selector="${accountname}" rule="digits" parm="${required}" message="Please enter ${title}"/>


<c:if test="${not empty minLength}">
	<go:validate selector="${accountname}" rule="nrminLength" parm="${minLength}" message="The number cannot have less than ${minLength} digits"/>	
</c:if>

<c:if test="${not empty maxLength}">
	<go:validate selector="${accountname}" rule="nrmaxLength" parm="${maxLength}" message="The number cannot have more than ${maxLength} digits"/>
</c:if> 

<field:highlight_row name="${go:nameFromXpath(xpath)}" inlineValidate="${required}" />