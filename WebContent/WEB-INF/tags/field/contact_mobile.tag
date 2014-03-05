<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a mobile phone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="size"	required="false" rtexprvalue="true"	 description="size of the input" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="dummyname" value="${name}input" />

<c:set var="titleText">
	<c:choose>
		<c:when test="${not empty title}">${title}</c:when>
		<c:otherwise>mobile number</c:otherwise>
	</c:choose>
</c:set>

<field:phone_number className="${className}" required="${required}" xpath="${xpath}"
				placeHolder="(0000) 000 000" title="${titleText}" size="${size}"
				allowMobile="true" allowLandline="false" />

<%-- VALIDATION --%>
<go:validate selector="${dummyname}" rule="validateMobile" parm="true" message="Please enter the ${titleText} in the format 04xxxxxxxx " />