<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents kilometers travelled."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"  rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="id" 		required="true"  rtexprvalue="true"  description="Id attribute for panel" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"  description="title of the element" %>
<%@ attribute name="placeHolder" required="false" rtexprvalue="true"  description="placeholder of the element" %>

<jsp:useBean id="userAgentSniffer" class="com.ctm.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="id" value="${name}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="maxLength" value="7" />
<c:set var="error_message">Please enter the number of kilometres the vehicle is driven per year</c:set>
<c:set var="inputType">
    <c:choose>
        <c:when test='${deviceType eq "MOBILE" or deviceType eq "TABLET"}'>tel</c:when>
        <c:otherwise>text</c:otherwise>
    </c:choose>
</c:set>
<c:set var="formatNum">
    <c:choose>
        <c:when test='${deviceType eq "MOBILE" or deviceType eq "TABLET"}'>false</c:when>
        <c:otherwise>true</c:otherwise>
    </c:choose>
</c:set>

<%-- HTML --%>
<field_new:input type="${inputType}" xpath="${xpath}" required="${required}" className="numeric ${className}" maxlength="${maxLength}" title="${title}" pattern="[0-9]*" placeHolder="${placeHolder}" formattedInteger="${formatNum}" />

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="${error_message}"/>
<go:validate selector="${name}" rule="digits" parm="${required}" message="${error_message}"/>
<go:validate selector="quote_drivers_young_annualKilometres" rule="youngRegularDriversAnnualKilometersCheck" parm="${required}" message="The annual kilometres driven by the youngest driver cannot exceed those of the regular driver."/>
