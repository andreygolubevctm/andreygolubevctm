<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Anchor TAG for link to privacy statement."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- ATTRIBUTES --%>
<%@ attribute name="overrideLabel" required="false" rtexprvalue="true" description="Override the default label for the link"%>
<%@ attribute name="useModalMessage" required="false" rtexprvalue="true" description="If want to see the pop-up that contains a link to the Privacy policy set to true" %>
<c:set var="anchorLabel">
	<c:choose>
		<c:when test="${not empty overrideLabel}">${overrideLabel}</c:when>
		<c:otherwise>Privacy Policy</c:otherwise>
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
<c:choose>
	<c:when test="${useModalMessage == true}">
		<a data-toggle="dialog" data-content="${openingContent}${bodyContent}" data-cache="true" data-dialog-hash-id="privacystatement">${anchorLabel}</a>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${pageSettings.getBrandCode() eq 'choo'}">
				<a href='${pageSettings.getSetting('privacyPolicyUrl')}' target='_blank' data-title="Privacy Policy" class="termsLink showDoc">${anchorLabel}</a>
			</c:when>
			<c:when test="${pageSettings.getBrandCode() eq 'wfdd'}">
				<a href='/static/legal/wfdd/privacy_policy.pdf' target='_blank'>${anchorLabel}</a>
			</c:when>
			<c:otherwise>
				<a href='/static/legal/privacy_policy.pdf' target='_blank'>${anchorLabel}</a>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>