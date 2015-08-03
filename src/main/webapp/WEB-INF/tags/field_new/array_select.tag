<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="extraDataAttributes" required="false" rtexprvalue="true" description="additional data attributes" %>
<%@ attribute name="title" 			required="true"  rtexprvalue="true"	 description="title of the select box" %>
<%@ attribute name="items" 			required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>
<%@ attribute name="delims"			required="false"  rtexprvalue="true" description="Appoints a new delimiter set, i.e. ||" %>
<%@ attribute name="helpId" 		required="false" rtexprvalue="true"	 description="The select help id (if non provided, help is not shown)" %>
<%@ attribute name="includeInForm"	required="false" rtexprvalue="true"  description="Force attribute to include value in data bucket - use true/false" %>

<c:choose>
	<c:when test="${includeInForm eq true}">
		<c:set var="includeInForm" value='true' />
	</c:when>
	<c:otherwise>
		<c:set var="includeInForm" value='false' />
	</c:otherwise>
</c:choose>

<div class="select">
	<span class=" input-group-addon">
		<i class="icon-sort"></i>
	</span>
	<field:array_select xpath="${xpath}" extraDataAttributes="${extraDataAttributes}" required="${required}" className="${className}" title="${title}" items="${items}" delims="${delims}" includeInForm="${includeInForm}" />
</div>
<c:if test="${not empty helpId}">
	<field_new:help_icon helpId="${helpId}" position="${helpPosition}" tooltipClassName="${helpClassName}" />
</c:if>