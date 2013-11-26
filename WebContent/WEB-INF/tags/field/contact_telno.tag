<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a telephone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="size"		required="false" rtexprvalue="true"	 description="size of the input" %>
<%@ attribute name="isLandline"	required="false" rtexprvalue="true"	 description="Flag to require number to be landline" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="dummyname" value="${name}input" />
<c:set var="id" value="${name}" />
<c:if test="${not empty maxlength}"><c:set var="maxlength">maxlength="${maxlength}"</c:set></c:if>
<c:choose>
	<c:when test="${isLandline eq true}">
		<c:set var="allowMobile" value="false"/>
		<c:set var="placeHolder">(00) 0000 0000</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="isLandline" value="false"/><c:set var="allowMobile" value="true"/>
		<c:set var="placeHolder">(0x)xxx or 04xxx</c:set>
	</c:otherwise>
</c:choose>


<c:set var="titleText">
	<c:choose>
		<c:when test="${not empty title}">${title}</c:when>
		<c:otherwise>phone number</c:otherwise>
	</c:choose>
</c:set>

<field:phone_number className="${className}" required="${required}" xpath="${xpath}" placeHolder="${placeHolder}"
											titleText="${titleText}" size="${size}" allowMobile="${allowMobile}" allowLandline="true" />

<%-- VALIDATION --%>
<c:choose>
	<c:when test="${isLandline eq true}">
		<go:validate selector="${dummyname}" rule="confirmLandline" parm="true" message="Please enter a landline number for ${titleText}"/>
		<go:validate selector="${dummyname}" rule="validateTelNo" parm="true" message="Please enter the ${titleText} in the format (area code)(local number)"/>
	</c:when>
	<c:otherwise>
		<go:validate selector="${dummyname}" rule="validateTelNo" parm="true" message="Please enter the ${titleText} in the format (area code)(local number) for landline or 04xxxxxxxx for mobile"/>
	</c:otherwise>
</c:choose>

