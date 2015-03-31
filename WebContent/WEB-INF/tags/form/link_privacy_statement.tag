<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Anchor TAG for link to privacy statement."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="overrideLabel" required="false" rtexprvalue="true" description="Override the default label for the link"%>

<c:set var="anchorLabel">
	<c:choose>
		<c:when test="${not empty overrideLabel}">${overrideLabel}</c:when>
		<c:otherwise>privacy statement</c:otherwise>
	</c:choose>
</c:set>

<c:set var="openingContent"><content:get key="privacyStatementOpening" /></c:set>
<c:set var="bodyContent"><content:get key="privacyStatementBody" /></c:set>
<c:set var="privacyPolicyPDF" value="${pageSettings.getSetting('privacyPolicyUrl')}" />
<c:if test="${fn:contains(bodyContent,'#PRIVACY_POLICY_URL#')}">
	<c:set var="bodyContent" value="${fn:replace(bodyContent, '#PRIVACY_POLICY_URL#', privacyPolicyPDF)}" />
</c:if>
<c:if test="${fn:contains(bodyContent,'#AFG_PRIVACY_POLICY_URL#')}">
	<c:set var="bodyContent" value="${fn:replace(bodyContent, '#AFG_PRIVACY_POLICY_URL#', pageSettings.getSetting('argPrivacyPolicyUrl'))}" />
</c:if>

<a data-toggle="dialog" data-content="${openingContent}${bodyContent}" data-cache="true" data-dialog-hash-id="privacystatement">${anchorLabel}</a>