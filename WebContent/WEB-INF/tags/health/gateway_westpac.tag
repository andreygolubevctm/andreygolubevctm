<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment: Credit Card popup"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

	<%-- VARIABLES --%>
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />

	<input type="hidden" id="${name}_number" name="${name}_number" value="" />
	<input type="hidden" id="${name}_type" name="${name}_type" value="" />
	<input type="hidden" id="${name}_expiry" name="${name}_expiry" value="" />
	<input type="hidden" id="${name}_name" name="${name}_name" value="" />