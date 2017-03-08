<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the age the driver obtained their full Australian driver licence "%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="inputType"><field_v2:get_numeric_input_type /></c:set>
<c:set var="analAttribute"><field_v1:analytics_attr analVal="Age licence obtained" quoteChar="\"" /></c:set>

<%-- HTML --%>

<div>
	<div class="floatLeft">
		<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
		<c:set var="validationRules" value="" />
		<c:if test="${required}">
			<c:set var="validationRules">data-rule-ageLicenceObtained='${required}' data-msg-ageLicenceObtained="Age licence obtained invalid due to ${title} driver's age." data-rule-digits='${required}' data-msg-digits="Please enter the age the ${title} driver obtained a driver's licence"</c:set>
		</c:if>
		<field_v2:input type="${inputType}" xpath="${xpath}" required="${required}" className="age_licence numeric ${classname}" maxlength="${2}" title="${title}" size="2" formattedInteger="true" pattern="[0-9]*" additionalAttributes="${validationRules} ${analAttribute}" />
	</div>

	<c:if test="${helpId != null && helpId != ''}">
		<div class="floatLeft">
			<span class="help_icon" id="help_${helpId}"></span>
		</div>
	</c:if>
</div>