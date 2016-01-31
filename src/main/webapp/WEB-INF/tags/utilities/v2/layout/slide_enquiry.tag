<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />

<layout_v1:slide formId="enquiryForm">
    <layout_v1:slide_columns>
        <jsp:attribute name="rightColumn"><utilities_v2:enquire_snapshot /></jsp:attribute>
        <jsp:body>
            <layout_v1:slide_content>
                <utilities_v2_fieldset:your_details xpath="${xpath}/details" />
                <utilities_v2_fieldset:terms_and_conditions xpath="${xpath}/thingsToKnow" />
                <form_v2:row id="confirm-step" hideHelpIconCol="true">
                    <a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5" id="submit_btn">Submit Enquiry <span class="icon icon-arrow-right"></span></a>
                </form_v2:row>
            </layout_v1:slide_content>
        </jsp:body>
    </layout_v1:slide_columns>
</layout_v1:slide>