<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="More Info Ambulance Cover"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="row ambulanceCoverSection">
    <h2>Ambulance cover</h2>
    <div class="col-xs-12 benefitTable">
        <div class="row benefitRow benefitRowHeader">
            <div class="col-xs-8 newBenefitRow benefitHeaderTitle">
                <div class="benefitRowTableCell">
                    Ambulance service
                </div>
            </div>
            <div class="col-xs-4 newBenefitRow benefitHeaderTitle align-center">
                <div class="benefitRowTableCell">
                    Waiting period
                </div>
            </div>
        </div>
        <div class="row benefitRow">
            <div class="col-xs-8 newBenefitRow benefitRowTitle">
                <div class="benefitRowTableCell">
                    {{= obj.ambulance.otherInformation }}
                </div>
            </div>
            <div class="col-xs-4 newBenefitRow benefitRowTitle align-center">
                <div class="benefitRowTableCell">
                    {{= obj.ambulance.waitingPeriod }}
                </div>
            </div>
        </div>
    </div>
</div>
