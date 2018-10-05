<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Creates a set of radio buttons for the passed xpath using a comma separated list of name=value pairs."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>
<%@ attribute name="items" 		required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>
<%@ attribute name="delims"			required="false"  rtexprvalue="true" description="Appoints a new delimiter set, i.e. ||" %>
<%@ attribute name="defaultValue" 	required="false"  rtexprvalue="true"  description="default value to be checked" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${empty delims}">
	<c:set var="delims" value="," />
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required" ' />
</c:if>

<c:if test="${empty value and not empty defaultValue}">
	<c:set var="value" value="${defaultValue}" />
</c:if>
<c:if test="${not empty helpId}">
	<c:set var="className" value="${className} floatLeft " />
</c:if>
<div>
<div class="${className} radio_buttons" id="${id}">
	<c:forTokens items="${items}" delims="${delims}" var="radio" varStatus="status">
		<c:set var="val" value="${fn:substringBefore(radio,'=')}" />
		<c:set var="des" value="${fn:substringAfter(radio,'=')}" />
		<c:set var="id" value="${name}_${val}" />

		<%-- Setup first and last-child class --%>
		<c:choose>
			<c:when test="${status.first}">
				<c:set var="classVar" value="first-child ${className}" />
			</c:when>
			<c:when test="${status.last}">
				<c:set var="classVar" value="last-child  ${className}" />
			</c:when>
			<c:otherwise>
				<c:set var="classVar" value="${className}" />
			</c:otherwise>
		</c:choose>

		<c:choose>
			<c:when test="${val == value}">
				<input type="radio" name="${name}" id="${id}" value="${val}" checked="checked" class="${classVar}"  data-msg-required="Please choose ${titleText}"  ${requiredAttribute} >
			</c:when>
			<c:otherwise>
				<input type="radio" name="${name}" id="${id}" value="${val}" class="${classVar}"  data-msg-required="Please choose ${title}"  ${requiredAttribute} >
			</c:otherwise>
		</c:choose>
		<label for="${id}">${des}</label>
	</c:forTokens>
</div>


<c:if test="${helpId != null && helpId != ''}">
	<div class="floatLeft">
		<span class="help_icon" id="help_${helpId}"></span>
	</div>
</c:if>

</div>

<%-- CSS --%>
<go:style marker="css-head">
	.floatLeft {float:left;}
</go:style>
