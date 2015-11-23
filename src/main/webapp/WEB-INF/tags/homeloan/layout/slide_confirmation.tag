<%@ tag description="Confirmation loading and parsing" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Load confirmation information --%>
<c:set var="styleCodeId" value="${pageSettings.getBrandId()}" />
<c:set var="token"><c:out value="${param.token}" escapeXml="true" /></c:set>
<c:set var="confirmationTranId">''</c:set>
<c:set var="confirmationData">{}</c:set>
<c:choose>
	<c:when test="${empty token}">
		<c:set var="confirmationData">{"message":"No confirmation token was provided"}</c:set>
	</c:when>
	<c:otherwise>
		<jsp:useBean id="confirmationService" class="com.ctm.web.core.confirmation.services.ConfirmationService" scope="page" />
		<c:set var="result" value="${confirmationService.getConfirmationByKeyAndBrandId(token, styleCodeId)}" />

		<c:choose>
			<c:when test="${empty result || result.getXmlData().equals('none')}">
				<c:set var="confirmationData">{"message":"No confirmation found matching the token"}</c:set>
			</c:when>
			<c:otherwise>
				<c:set var="confirmationTranId" value="${result.getTransactionId()}" />
				<c:set var="confirmationData" value="${go:XMLtoJSON(result.getXmlData())}" />
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>



<%-- HTML --%>
<layout:slide formId="confirmationForm" className="displayBlock">

	<layout:slide_content>
		<layout:slide_columns>

			<jsp:attribute name="rightColumn">
			</jsp:attribute>

			<jsp:body>
				<layout:slide_content>

					<div id="confirmation" class="more-info-content"></div>

					<confirmation:other_products />

				</layout:slide_content>
			</jsp:body>

		</layout:slide_columns>
	</layout:slide_content>

</layout:slide>



<%-- TEMPLATES --%>
<core:js_template id="confirmation-template">
	<ui:bubble variant="chatty">
		<p>Thanks <!-- SessionCam:Hide -->{{= obj.firstName }}<!-- /SessionCam:Hide --> for your Home Loans enquiry. We&#39;ll pass your details onto a broker who will be in touch with you within the next business day.</p>
		<p>Your reference number for your enquiry is <strong>{{= obj.flexOpportunityId }}</strong>. It&#39;s a good idea to keep this handy for future communications with your broker.</p>
	</ui:bubble>
</core:js_template>



<%-- JAVASCRIPT --%>
<script>
	var confirmationTranId = ${confirmationTranId};
	var confirmationData = ${confirmationData};
</script>
