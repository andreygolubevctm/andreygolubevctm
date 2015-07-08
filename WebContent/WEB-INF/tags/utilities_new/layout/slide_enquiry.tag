<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}/application" />

<layout:slide formId="enquiryForm">
    <layout:slide_columns>
        <jsp:attribute name="rightColumn"><utilities_new:enquire_snapshot /></jsp:attribute>
        <jsp:body>
            <layout:slide_content>
                <utilities_new_fieldset:your_details xpath="${xpath}/details" />
                <utilities_new_fieldset:terms_and_conditions xpath="${xpath}/thingsToKnow" />
                <form_new:row id="confirm-step" hideHelpIconCol="true">
                    <a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5" id="submit_btn">Submit Enquiry <span class="icon icon-arrow-right"></span></a>
                </form_new:row>
            </layout:slide_content>
        </jsp:body>
    </layout:slide_columns>
</layout:slide>