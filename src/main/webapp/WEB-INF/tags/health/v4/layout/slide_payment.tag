<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="paymentDetailsForm" nextLabel="Submit Application">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns sideHidden="true">

            <jsp:attribute name="rightColumn">
                <health_v1:policySummary showProductDetails="true" />
            </jsp:attribute>

            <jsp:body>
                <health_v4_payment:payment xpath="${pageSettings.getVerticalCode()}/payment" />
            </jsp:body>
        </form_v3:fieldset_columns>
    </layout_v3:slide_content>

</layout_v3:slide>