<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a telephone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"					required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required"				required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="title"					required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="className"				required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id"						required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="size"					required="false" rtexprvalue="true"	 description="size of the input" %>
<%@ attribute name="labelName"				required="false" rtexprvalue="true"	 description="the label to display for validation" %>
<%@ attribute name="placeHolder"			required="false" rtexprvalue="true"	 description="Placeholder text" %>
<%@ attribute name="placeHolderUnfocused"	required="false" rtexprvalue="true"	 description="HTML5 placeholder when input not in focus" %>
<%@ attribute name="validationAttribute"	required="false" rtexprvalue="true"	 description="Additional Validation Attributes" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="dummyname" value="${name}input" />
<c:set var="id" value="${name}" />
<c:if test="${empty placeHolder}">
	<c:set var="placeHolder">(0x) xxxx xxxx or 04xx xxx xxx</c:set>
</c:if>

<c:set var="labelText">
	<c:choose>
		<c:when test="${not empty labelName}">${labelName}</c:when>
		<c:when test="${not empty title}">${title}</c:when>
		<c:otherwise>phone number</c:otherwise>
	</c:choose>
</c:set>

<%-- VALIDATION --%>
<c:set var="additionalAttributes"> data-rule-validateTelNo='true' data-msg-validateTelNo='Please enter the ${labelText} in the format (0x)xxxx xxxx for landline or 04xx xxx xxx for mobile' </c:set>

<field:phone_number className="${className}" required="${required}" xpath="${xpath}"
	placeHolder="${placeHolder}" placeHolderUnfocused="${placeHolderUnfocused}"
	labelName="${labelName}" title="${title}" size="${size}"
	allowMobile="true" allowLandline="true" additionalAttributes="${validationAttribute} ${additionalAttributes}" />

