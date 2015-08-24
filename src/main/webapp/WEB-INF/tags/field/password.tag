<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Password field"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the password field" %>
<%@ attribute name="minLength"	required="false" rtexprvalue="true"	 description="Minimum password length acceptable" %>
<%@ attribute name="onKeyUp" required="false" rtexprvalue="true"	 description="onKeyUp attribute" %>
<%@ attribute name="placeHolder" required="false" rtexprvalue="true"  description="html5 placeholder" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:if test="${empty minLength}">
	<c:set var="minLength">${6}</c:set>
</c:if>

<c:if test="${title == ''}">
	<c:set var="title" value="Password" />
</c:if>

<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderAttribute" value=' placeholder="${placeHolder}"' />
	<c:set var="className" value="${className} placeholder" />
</c:if>

<c:if test="${not empty onKeyUp}">
	<c:set var="onkeypressAttribute" value="onkeyup='${onKeyUp}'" />
</c:if>

<c:set var="validationAttributes" value="" />
<c:if test="${required}">
	<c:set var="validationAttributes" value=" required data-rule-minlength='${minLength}' data-msg-minlength='Please enter ${title} (min ${minLength} characters)'" />
</c:if>

<%-- HTML --%>
<input type="password" class="form-control password ${className}" id="${name}" name="${name}" title="${title}" ${onkeypressAttribute}${placeHolderAttribute}${validationAttributes} />