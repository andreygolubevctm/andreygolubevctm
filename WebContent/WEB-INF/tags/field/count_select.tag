<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built with number values only, choose your max min and step" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true"		description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 	rtexprvalue="true"  	description="is this field required?" %>
<%@ attribute name="className" 			required="false"	rtexprvalue="true"		description="additional css class attribute" %>
<%@ attribute name="title" 				required="true" 	rtexprvalue="true"		description="title of the select box" %>
<%@ attribute name="min" 				required="true" 	rtexprvalue="true"  	description="minimum (starting) value" %>
<%@ attribute name="max" 				required="true"	 	rtexprvalue="true"  	description="maximum (ending) value, Note: will not appear if 'stepped' over" %>
<%@ attribute name="step" 				required="false"	rtexprvalue="true"  	description="the amount each value steps up (defaults to 1)" %>
<%@ attribute name="omitPleaseChoose" 	required="false"	rtexprvalue="true"		description="should 'please choose' be omitted? Y/N (Yes omits)" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<c:if test="${empty step}">
	<c:set var="step" value="1" />
</c:if>


<%-- HTML --%>
<select class="${className} field-count_select" id="${name}" name="${name}" >
	<c:if test="${empty omitPleaseChoose || omitPleaseChoose == 'N'}">
		<c:choose>
		<c:when test="${value == ''}">
			<option id="${name}_" value="" selected="selected">Please choose..</option>
			</c:when>
			<c:otherwise>
			<option id="${name}_" value="">Please choose..</option>
			</c:otherwise>
		</c:choose>
	</c:if>
	<c:forEach begin="${min}" end="${max}" step="${step}" varStatus="status">
		<c:choose>
			<c:when test="${status.index == value}">
				<option id="${name}_${status.index}" value="${status.index}" selected="selected">${status.index}</option>
			</c:when>
			<c:otherwise>
				<option id="${name}_${status.index}" value="${status.index}">${status.index}</option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose ${title}"/>
</c:if>