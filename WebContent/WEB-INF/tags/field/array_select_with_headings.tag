<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Sample items string: "=Please choose,Wanting to avoid taxes and penalties[ATP=Wanting to avoid taxes and penalties],Lifestage[YS=Young single,YC=Young couple,M=Mature Couple]" --%>

<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="true"  rtexprvalue="true"	 description="title of the select box" %>
<%@ attribute name="items" 			required="true"  rtexprvalue="true"  description="comma seperated list of values in group[value=description,...],... format)" %>
<%@ attribute name="delims"			required="false"  rtexprvalue="true"  description="Appoints a new delimiter set, i.e. ||" %>
<%@ attribute name="groupDelimOpen"	required="false"  rtexprvalue="true"  description="Appoints a new delimiter set for group opening, i.e. [[" %>
<%@ attribute name="groupDelimClose" required="false"  rtexprvalue="true"  description="Appoints a new delimiter set for group closing, i.e. ]]" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<c:if test="${empty delims}">
	<c:set var="delims" value="," />
</c:if>

<c:if test="${empty groupDelimOpen}">
	<c:set var="groupDelimOpen" value="[" />
</c:if>

<c:if test="${empty groupDelimClose}">
	<c:set var="groupDelimClose" value="]" />
</c:if>

<%-- HTML --%>
<select class="${className} array_select" id="${name}" name="${name}" >
	<c:forTokens items="${items}" delims="${delims}" var="option">

		<c:set var="val" value="${fn:substringBefore(option,'=')}" />
		<c:set var="des" value="${fn:substringAfter(option,'=')}" />

		<%-- See if a group opens --%>
		<c:if test="${fn:contains(val,groupDelimOpen)}">
			<optgroup label="${fn:substringBefore(val,groupDelimOpen)}">
			<c:set var="val" value="${fn:substringAfter(val,groupDelimOpen)}" />
		</c:if>

		<%-- See if a group closes --%>
		<c:set var="closeGroup" value="false" />
		<c:if test="${fn:contains(des,groupDelimClose)}">
			<c:set var="closeGroup" value="true" />
			<c:set var="des" value="${fn:substringBefore(des,groupDelimClose)}" />
		</c:if>

		<c:set var="id" value="${name}_${val}" />
		<c:choose>
			<c:when test="${val == value}">
				<option id="${id}" value="${val}" selected="selected">${des}</option>
			</c:when>
			<c:otherwise>
				<option id="${id}" value="${val}">${des}</option>
			</c:otherwise>
		</c:choose>

		<c:if test="${closeGroup == true}">
			</optgroup>
		</c:if>

	</c:forTokens>
</select>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose ${title}"/>
</c:if>

