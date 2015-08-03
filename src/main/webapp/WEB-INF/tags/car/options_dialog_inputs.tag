<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Container for various input fields used by dialogs"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="hidden">
	<div class="factory"></div>
	<div class="accessories"></div>
</div>