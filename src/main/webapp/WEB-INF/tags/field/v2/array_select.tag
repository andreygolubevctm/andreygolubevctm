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
<%@ attribute name="placeHolder"	required="false" rtexprvalue="true"  description="dropdown placeholder" %>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="hideElement" 	required="false" 	rtexprvalue="true"    	 description="If true hides the entire element" %>


<c:choose>
	<c:when test="${includeInForm eq true}">
		<c:set var="includeInForm" value='true' />
	</c:when>
	<c:otherwise>
		<c:set var="includeInForm" value='false' />
	</c:otherwise>
</c:choose>

<c:if test="${disableErrorContainer eq true}">
	<c:set var="extraDataAttributes" value='${extraDataAttributes}  data-disable-error-container="true" '/>
</c:if>

<div class="select <c:if test="${hideElement eq true}">hidden</c:if>">
	<span class=" input-group-addon">
		<i class="icon-angle-down"></i>
	</span>
	<field_v1:array_select xpath="${xpath}" extraDataAttributes="${extraDataAttributes}" required="${required}" className="${className}" title="${title}" items="${items}" delims="${delims}" includeInForm="${includeInForm}" placeHolder="${placeHolder}" />
</div>
<c:if test="${not empty helpId}">
	<field_v2:help_icon helpId="${helpId}" position="${helpPosition}" tooltipClassName="${helpClassName}" />
</c:if>