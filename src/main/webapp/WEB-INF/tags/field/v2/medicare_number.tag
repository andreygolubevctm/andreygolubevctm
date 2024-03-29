<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="disableErrorContainer" required="false" rtexprvalue="true"    	 description="Show or hide the error message container" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="inputType"><field_v2:get_numeric_input_type /></c:set>
<c:set var="additionalAttributes">
    data-rule-medicareNumber='${required}' data-rule-digitsIgnoreComma='true'
</c:set>

<%-- SANITISE EXISTING DATA --%>
<c:if test="${not empty data[xpath]}">
    <go:setData  dataVar="data" xpath="${xpath}" value="${fn:replace(data[xpath],' ', '')}" />
</c:if>

<%-- HTML --%>
<field_v2:input type="${inputType}" xpath="${xpath}" className="medicare_number ${className}" title="${title}" required="true" maxlength="10" pattern="[0-9]*" integerKeyPressLimit="true" additionalAttributes="${additionalAttributes}" placeHolder="Card Number" disableErrorContainer="${disableErrorContainer}" />