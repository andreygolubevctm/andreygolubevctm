<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Potcode field." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="the subject of the field" %>
<%@ attribute name="additionalAttributes" 		required="false"	 rtexprvalue="true"	 description="Additional Attributes" %>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="inputType"><field_v2:get_numeric_input_type /></c:set>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required data-msg-required="Please enter a ${title}."' />
</c:if>
<c:if test="${disableErrorContainer eq true}">
	<c:set var="additionalAttributes" value="${additionalAttributes} data-disable-error-container='true' " />
</c:if>

<%-- HTML --%>
<input type="${inputType}" ${requiredAttribute} name="${name}" pattern="[0-9]*" maxlength="4" id="${name}" class="form-control ${className}" value="${value}" size="4" data-rule-minlength="4" data-msg-minlength="Postcode should be 4 characters long" data-rule-number="true" data-rule-validatePostcode="true" data-msg-number="Postcode must contain numbers only." ${additionalAttributes} placeholder="PostCode" <field_v1:analytics_attr analVal="Postcode" quoteChar="\"" /> />
