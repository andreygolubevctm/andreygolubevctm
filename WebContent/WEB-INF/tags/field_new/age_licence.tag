<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the age the driver obtained their full Australian driver licence "%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>

<jsp:useBean id="userAgentSniffer" class="com.ctm.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="inputType">
	<c:choose>
		<c:when test='${deviceType eq "MOBILE" or deviceType eq "TABLET"}'>tel</c:when>
		<c:otherwise>text</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>

<div>
	<div class="floatLeft">
		<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
		<field_new:input type="${inputType}" xpath="${xpath}" required="${required}" className="age_licence numeric ${classname}" maxlength="${2}" title="${title}" size="2" pattern="[0-9]*" />
	</div>

	<c:if test="${helpId != null && helpId != ''}">
		<div class="floatLeft">
			<span class="help_icon" id="help_${helpId}"></span>
		</div>
	</c:if>
</div>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="digits" parm="${required}" message="Please enter the age the ${title} driver obtained a driver's licence"/>
<go:validate selector="${name}" rule="ageLicenceObtained" parm="${required}" message="Age licence obtained invalid due to ${title} driver's age."/>
