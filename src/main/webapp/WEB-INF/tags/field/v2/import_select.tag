<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from imported option."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="url" 		required="true"	 rtexprvalue="true"	 description="url of import file containing options" %>
<%@ attribute name="omitPleaseChoose" required="false"	rtexprvalue="true"	 description="should 'please choose' be omitted?" %>
<%@ attribute name="additionalAttributes" required="false"	rtexprvalue="true"	 description="additional attributes to apply to the select" %>
<%@ attribute name="placeHolder" required="false"	rtexprvalue="true"	 description="dropdown placeholder" %>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="hideElement" 	required="false" 	rtexprvalue="true"    	 description="If true hides the entire element" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:set var="placeholderText" value='Please choose...' />
<c:if test="${not empty placeHolder}">
	<c:set var="placeholderText" value='${placeHolder}' />
</c:if>

<%-- HTML --%>
<%-- Import the file into a variable --%>
<c:import url="${url}" var="optionData" />
<%-- Substitute the value="X" --%>
<c:set var="findVal" 	value="value=\"${value}\"" />
<c:set var="replaceVal" value="value='${value}' selected='selected'" />

<c:if test="${required}">
	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>a value</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute" value=' required="required" '/>
</c:if>

<c:if test="${disableErrorContainer eq true}">
	<c:set var="additionalAttributes" value='${additionalAttributes}  data-disable-error-container="true" '/>
</c:if>

<div class="select"<c:if test="${hideElement eq true}"> style="height: 0; visibility: hidden;"</c:if>>
	<span class=" input-group-addon">
		<i class="icon-angle-down"></i>
	</span>
	<select name="${name}" ${requiredAttribute} data-msg-required="Please choose ${title}" id="${name}" class="form-control ${className}" ${additionalAttributes}>
		<%-- Write the initial "please choose" option --%>
		<c:choose>
			<c:when test="${omitPleaseChoose == 'Y'}"></c:when>
			<c:when test="${value == ''}">
				<option value="" selected="selected">${placeholderText}</option>
			</c:when>
			<c:otherwise>
				<option value="">${placeholderText}</option>
			</c:otherwise>
		</c:choose>
		${fn:replace(optionData,findVal,replaceVal)}
	</select>
</div>