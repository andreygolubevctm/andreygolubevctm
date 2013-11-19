<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a mobile phone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true" rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 		required="true" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="size"			required="true" rtexprvalue="true"	 description="size of the input" %>
<%@ attribute name="titleText"		required="true" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="placeHolder"	required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="allowLandline"	required="true" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="allowMobile"	required="true" rtexprvalue="true"	 description="subject of the input box" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="nameInput" value="${name}input" />
<c:set var="xpathInput">${xpath}input</c:set>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="valueInput"><c:out value="${data[xpathInput]}" escapeXml="true"/></c:set>

<c:if test="${empty valueInput && not empty value}">
	<c:set var="valueInput" value="${value}" />
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute"> required="required" </c:set>
</c:if>

<c:set var="sizeAttribute"><c:if test="${not empty size}"> size="${size}" </c:if></c:set>

<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderAttribute">placeholder="${placeHolder}"</c:set>
</c:if>

<c:choose>
	<c:when test="${allowLandline && allowMobile}" >
		<c:set var="phoneTypeClassName"> anyPhoneType </c:set>
	</c:when>
	<c:when test="${allowMobile}" >
		<c:set var="phoneTypeClassName"> mobile </c:set>
	</c:when>
	<c:otherwise>
		<c:set var="phoneTypeClassName"> landline </c:set>
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" class="" value="${value}" pattern="0[243785]{1}[0-9]{8}" >
<input type="text" name="${nameInput}" id="${nameInput}" class="${className} contact_telno ${phoneTypeClassName} phone ${name}"
								value="${valueInput}" title="The ${titleText}" ${sizeAttribute}
								${placeHolderAttribute} data-msg-required="Please enter the ${titleText}"
								${requiredAttribute} maxlength="14" >

<go:script marker="onready">

	<c:if test="${not empty placeHolder}">
		<field:placeHolder elementName="${nameInput}" placeholder="${placeHolder}" />
	</c:if>
</go:script>