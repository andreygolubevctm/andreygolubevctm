<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A submit button for a form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="label"	required="false" rtexprvalue="true"	 description="Label for the button" %>

<c:if test="${empty label}">
    <c:set var="label" value="SAVE RESULTS" />
</c:if>

<%-- HTML --%>
<a href="javascript:;" data-opensavequote="true" class="hidden-xs btn btn-save-quote-trigger" <field_v1:analytics_attr analVal="save button" quoteChar="\"" />>${label}</a>
