<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="paymentDetailsForm">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns nextLabel="Submit Application" sideHidden="true" submitButton="true">

            <jsp:attribute name="rightColumn">
                <competition:snapshot vertical="health" />
                <reward:campaign_tile_container />
                <health_v4_payment:policySummary showProductDetails="true" />
                <health_v4:price_promise step="payment" dismissible="true" />
            </jsp:attribute>

            <jsp:body>
                <health_v4_payment:payment xpath="${pageSettings.getVerticalCode()}/payment" />
                <c:if test="${data.health.currentJourney == null || data.health.currentJourney != 2}">
                    <health_v4_payment:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
                </c:if>
                <c:if test="${data.health.currentJourney != null && data.health.currentJourney == 2}">
                    <health_v4_payment:declaration_v2 xpath="${pageSettings.getVerticalCode()}/declaration" />
                </c:if>

                <health_v4_payment:contactAuthority xpath="${pageSettings.getVerticalCode()}/contactAuthority" />

                <c:if test="${data.health.currentJourney == null || data.health.currentJourney != 2}">
                    <health_v4_payment:whatsNext />
                </c:if>
                <c:if test="${data.health.currentJourney != null && data.health.currentJourney == 2}">
                    <health_v4_payment:whatsNext_v2 />
                </c:if>

                <health_v1:fund_timezone_message_modal />

                <c:if test="${callCentre and not empty worryFreePromo and worryFreePromo eq '35'}">
                    <div class="simples-dialogue row-content  optionalDialogue">
                        <c:set var="simplesCompCopy"><content:get key="worryFreePromoSimplesCopy_Body" /></c:set>
                        <h3><content:get key="worryFreePromoSimplesCopy_Title" /></h3>
                        <div>
                            <field_v2:checkbox
                                    xpath="${pageSettings.getVerticalCode()}/competition/optin"
                                    value="Y"
                                    className="validate"
                                    required="false"
                                    label="${true}"
                                    title="${simplesCompCopy}"
                                    errorMsg="" />
                        </div>
                    </div>
                </c:if>
            </jsp:body>
        </form_v3:fieldset_columns>
    </layout_v3:slide_content>

</layout_v3:slide>