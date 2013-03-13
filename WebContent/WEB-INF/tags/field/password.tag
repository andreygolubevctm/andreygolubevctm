<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Password field"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the password field" %>
<%@ attribute name="minlength"	required="false" rtexprvalue="true"	 description="Minimum password length acceptable" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty minLength}">
	<c:set var="minLength">${6}</c:set>
</c:if>
	<c:if test="${title == ''}">
		<c:set var="title" value="Password" />
	</c:if>
<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	$.validator.addMethod("validateMinPasswordLength",
		function(value, element) {
			return String(value).length >= ${minLength};
		},
		"Replace this message with something else"
	);
</go:script>

<%-- HTML --%>
	<input type="password" class="password ${className}" id="${name}" type="${name}" name="${name}" title="${title}">

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="validateMinPasswordLength" parm="${required}" message="Please enter ${title} (min ${minLength} characters)" />
</c:if>