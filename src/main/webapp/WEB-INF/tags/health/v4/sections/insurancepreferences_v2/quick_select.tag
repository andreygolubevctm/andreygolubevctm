<%@ tag description="The quick select tag to allow the preselection of items. Eg health benefits"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="options"	required="true"	 rtexprvalue="true"	 description="list of options to generate the quick select headings" %>
<%@ attribute name="trackingLabel"	required="true"	 rtexprvalue="true"
			  description="list of options to generate the quick select headings" %>

<%-- Calculate column width based on 12 columns --%>
<c:set var="maxColumns" value="12" />
<c:set var="noOfOptions" value="${fn:length(fn:split(options, '|'))}" />
<fmt:formatNumber var="colWidth" maxFractionDigits="0" value="${maxColumns / noOfOptions}"/>

<div class="row quickSelectContainer deactivated">
	<div class="col-xs-4">Quick select:</div>
	<div class="col-xs-8 quickSelect">
		<c:forTokens items="${options}" delims="|" var="qs">
			<c:set var="parts" value="${fn:split(qs, ':')}" />
			<div class="col-xs-${colWidth} col-sm-12 col-md-${colWidth}"><a href="javascript:;"	data-select-type="${parts[1]}" <field_v1:analytics_attr analVal="${trackingLabel} type quick select" quoteChar="\"" />>${parts[0]}</a></div>
		</c:forTokens>
	</div>
	<div class="col-xs-12 clearSelection hidden"><a href="javascript:;">Clear selection</a></div>
</div>