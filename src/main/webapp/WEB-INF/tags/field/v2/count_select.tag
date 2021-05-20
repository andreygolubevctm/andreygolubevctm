<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built with number values only, choose your max min and step" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true"		description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 	rtexprvalue="true"  	description="is this field required?" %>
<%@ attribute name="className" 			required="false"	rtexprvalue="true"		description="additional css class attribute" %>
<%@ attribute name="title" 				required="true" 	rtexprvalue="true"		description="title of the select box" %>
<%@ attribute name="min" 				required="true" 	rtexprvalue="true"  	description="minimum (starting) value" %>
<%@ attribute name="extraDataAttributes" required="false" 	rtexprvalue="true" 		description="additional data attributes" %>
<%@ attribute name="max" 				required="true"	 	rtexprvalue="true"  	description="maximum (ending) value, Note: will not appear if 'stepped' over" %>
<%@ attribute name="step" 				required="false"	rtexprvalue="true"  	description="the amount each value steps up (defaults to 1)" %>
<%@ attribute name="omitPleaseChoose" 	required="false"	rtexprvalue="true"		description="should 'please choose' be omitted? Y/N (Yes omits)" %>
<%@ attribute name="placeHolder"	 	required="false"	rtexprvalue="true"		description="dropdown placeholder" %>
<%@ attribute name="disableErrorContainer" required="false" rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="hideElement" 	required="false" 	rtexprvalue="true"    	 description="If true hides the entire element" %>
<%@ attribute name="defaultValue" 	required="false" 	rtexprvalue="true"    	 description="default the dropdown to pre-select this defaultValue" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${empty step}">
	<c:set var="step" value="1" />
</c:if>

<c:set var="placeHolderText" value="Please choose&hellip;" />
<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderText" value="${placeHolder}" />
</c:if>
<%-- HTML --%>
<div class="select <c:if test="${hideElement eq true}">hidden</c:if>">
	<span class=" input-group-addon" >
		<i class="icon-angle-down"></i>
	</span>
	<select class="form-control field-count_select ${className}" id="${name}" name="${name}" <c:if test="${required}">required data-msg-required="Please choose ${title}"</c:if> <c:if test="${disableErrorContainer eq true}"> data-disable-error-container='true'</c:if>  ${extraDataAttributes}>
		<c:if test="${empty omitPleaseChoose || omitPleaseChoose == 'N'}">
			<option id="${name}_" value="">${placeHolderText}</option>
		</c:if>
		<c:forEach begin="${min}" end="${max}" step="${step}" varStatus="status">
			<c:choose>
				<c:when test="${status.index == value || status.index == defaultValue}">
					<option id="${name}_${status.index}" value="${status.index}" selected="selected">${status.index}</option>
				</c:when>
				<c:otherwise>
					<option id="${name}_${status.index}" value="${status.index}">${status.index}</option>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</select>
</div>