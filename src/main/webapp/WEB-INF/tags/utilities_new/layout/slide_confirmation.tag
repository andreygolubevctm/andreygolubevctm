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
<c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>
<core:js_template id="confirmation-template">
    <ui:bubble variant="chatty">
        <p>
            Thank you <!-- SessionCam:Hide -->{{= obj.firstName }}<!-- /SessionCam:Hide --> for choosing ${brandedName} (powered by Thought World) to compare your energy options and save on your energy bills. Thought World's energy specialists will be in contact shortly to discuss your application. Please print this page with your reference number for your records.

        </p>
        <p>If you have any questions about your energy application, please call our trusted partner Thought World on: ${callCentreNumber}</p>
        <p>Your reference number for your enquiry is <strong>{{= obj.uniquePurchaseId }}</strong>. It&#39;s a good idea to keep this handy for future communications.</p>
    </ui:bubble>
</core:js_template>



<%-- JAVASCRIPT --%>
<script>
    var confirmationTranId = ${confirmationTranId};
    var confirmationData = ${confirmationData};
</script>
