<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a telephone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"					required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required"				required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="title"					required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="className"				required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id"						required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="size"					required="false" rtexprvalue="true"	 description="size of the input" %>
<%@ attribute name="maxLength"				required="true"  rtexprvalue="true"	 description="Input field maxLength" %>
<%@ attribute name="labelName"				required="false" rtexprvalue="true"	 description="the label to display for validation" %>
<%@ attribute name="placeHolder"			required="false" rtexprvalue="true"	 description="Placeholder text" %>
<%@ attribute name="placeHolderUnfocused"	required="false" rtexprvalue="true"	 description="HTML5 placeholder when input not in focus" %>
<%@ attribute name="validationAttribute"	required="false" rtexprvalue="true"	 description="Additional Validation Attributes" %>
<%@ attribute name="phoneType"				required="false" rtexprvalue="true"	 description="'Flexi'|'Mobile'|'LandLine' Phone Type for Validation" %>
<%@ attribute name="additionalAttributes"	required="false" rtexprvalue="true"	 description="Used for passing in additional attributes" %>
<%@ attribute name="requireOnePlusNumber"	required="false" rtexprvalue="true"	 description="true|false if two fields, require at least one" %>

<c:if test="${callCentre}">
	<c:set var="required" value="${false}" />
</c:if>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="dummyname" value="${name}input" />
<c:set var="id" value="${name}" />

<c:set var="labelText">
	<c:choose>
		<c:when test="${not empty labelName}">${labelName}</c:when>
		<c:when test="${not empty title}">${title}</c:when>
		<c:otherwise>phone number</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${empty phoneType}">
	<%--By Default lets accept both types of phone numbers--%>
	<c:set var="phoneType">Flexi</c:set>
</c:if>

<c:if test="${required && requireOnePlusNumber}">
	<c:set var="additionalAttributes" value=" ${additionalAttributes} data-rule-requireOneContactNumber='true' data-msg-requireOneContactNumber='Please include at least one phone number' " />
</c:if>

<%-- VALIDATION --%>
<c:choose>
	<c:when test="${phoneType == 'Mobile'}">
		<c:if test="${empty placeHolder}">
			<c:set var="placeHolder">04xx xxx xxx</c:set>
		</c:if>
		<c:set var="blacklistRules">
			<c:if test="${fn:startsWith(xpath, 'health/')}"> data-rule-validate${phoneType}TelNoWithBlacklist='true' data-msg-validate${phoneType}TelNoWithBlacklist='This ${labelText} appears to be invalid, please enter a valid ${labelText}' </c:if>
		</c:set>
		<c:set var="additionalAttributes"> data-rule-validate${phoneType}TelNo='true' data-msg-validate${phoneType}TelNo='Please enter the ${labelText} in the format 04xx xxx xxx for mobile' ${blacklistRules} ${additionalAttributes}</c:set>
		<c:set var="allowMobile" value="true"/>
		<c:set var="allowLandLine" value="false"/>
	</c:when>
	<c:when test="${phoneType == 'LandLine'}">
		<c:if test="${empty placeHolder}">
			<c:set var="placeHolder">(0x) xxxx xxxx</c:set>
		</c:if>
		<c:set var="additionalAttributes"> data-rule-validate${phoneType}TelNo='true' data-msg-validate${phoneType}TelNo='Please enter the ${labelText} in the format (0x)xxxx xxxx for landline' ${additionalAttributes}</c:set>
		<c:set var="allowMobile" value="false"/>
		<c:set var="allowLandLine" value="true"/>
	</c:when>
	<c:otherwise>
		<%-- Flexi--%>
		<c:if test="${empty placeHolder}">
			<c:set var="placeHolder">(0x) xxxx xxxx or 04xx xxx xxx</c:set>
		</c:if>
		<c:set var="additionalAttributes"> data-rule-validate${phoneType}TelNo='true' data-msg-validate${phoneType}TelNo='Please enter the ${labelText} in the format (0x)xxxx xxxx for landline or 04xx xxx xxx for mobile' ${additionalAttributes}</c:set>
		<c:set var="allowMobile" value="true"/>
		<c:set var="allowLandLine" value="true"/>
	</c:otherwise>
</c:choose>

<field_v1:phone_number className="${className}" required="${required}" xpath="${xpath}"
	placeHolder="${placeHolder}" placeHolderUnfocused="${placeHolderUnfocused}"
	labelName="${labelName}" title="${title}" size="${size}" maxLength="${maxLength}"
	allowMobile="${allowMobile}" allowLandline="${allowLandLine}" additionalAttributes="${validationAttribute} ${additionalAttributes}" />

