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
<%@ attribute name="additionalAttributes" required="false" rtexprvalue="true"  description="Additional attributes to be passed to the input field" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="id" value="${name}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="maxLength" value="7" />
<c:set var="error_message">Please enter the number of kilometres the vehicle is driven per year</c:set>
<c:set var="inputType"><field_v2:get_numeric_input_type /></c:set>
<c:set var="formatNum">
    <c:choose>
        <c:when test='${inputType eq "text"}'>false</c:when>
        <c:otherwise>true</c:otherwise>
    </c:choose>
</c:set>

<%-- HTML --%>
<c:set var="additionalAttributes">
    ${additionalAttributes} <c:if test="${required}"> data-msg-required='${error_message}' data-rule-digitsIgnoreComma='true' data-msg-digitsIgnoreComma='${error_message}' <c:if test="${name eq 'quote_drivers_young_annualKilometres'}">data-rule-youngRegularDriversAnnualKilometersCheck='true'</c:if></c:if>
</c:set>

<field_v2:input type="${inputType}" xpath="${xpath}" required="${required}" className="numeric ${className}" maxlength="${maxLength}" title="${title}" pattern="[0-9]*" placeHolder="${placeHolder}" formattedInteger="true" additionalAttributes="${additionalAttributes}" />