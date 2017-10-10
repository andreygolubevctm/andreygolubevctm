<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="paymentDetailsForm" nextLabel="Submit Application">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns sideHidden="true">

            <jsp:attribute name="rightColumn">
                <competition:snapshot vertical="health" />
                <reward:campaign_tile_container />
                <health_v4_payment:policySummary showProductDetails="true" />
            </jsp:attribute>

            <jsp:body>
                <health_v4_payment:payment xpath="${pageSettings.getVerticalCode()}/payment" />
                <health_v4_payment:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
                <health_v4_payment:contactAuthority xpath="${pageSettings.getVerticalCode()}/contactAuthority" />
                <health_v4_payment:whatsNext />

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