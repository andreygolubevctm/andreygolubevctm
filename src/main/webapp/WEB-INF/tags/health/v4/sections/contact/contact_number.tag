<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="fakeMobileValidation">
	<c:choose>
		<c:when test="${pageSettings.getSetting('fakeMobileValidation') eq 'Y'}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<field_v4:contact_number mobileXpath="${xpath}/contactNumber/mobile" otherXpath="${xpath}/contactNumber/other" className="contact-details-contact-number" checkMobileBlacklist="${fakeMobileValidation}" />
<field_v1:hidden xpath="${xpath}/flexiContactNumber" />