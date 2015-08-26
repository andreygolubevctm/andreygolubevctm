<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Potcode field." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="the subject of the field" %>
<%@ attribute name="additionalAttributes" 		required="false"	 rtexprvalue="true"	 description="Additional Attributes" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required" data-msg-required="Please enter ${title}"' />
</c:if>


<%-- HTML --%>
<input type="text"${requiredAttribute} name="${name}" pattern="[0-9]*" maxlength="4" id="${name}" class="form-control ${className}" value="${value}" size="4" data-rule-minlength="4" data-msg-minlength="Postcode should be 4 characters long" data-rule-number="true" data-msg-number="Postcode must contain numbers only." ${additionalAttributes} />
