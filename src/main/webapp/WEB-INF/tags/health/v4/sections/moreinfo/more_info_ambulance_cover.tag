<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="More Info Ambulance Cover"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="row ambulanceCoverSection">
    <h2 class="text-dark">Ambulance cover</h2>
    <div class="col-xs-12 benefitTable">
        <div class="row benefitRow benefitRowHeader">
            <div class="col-xs-8 newBenefitRow benefitHeaderTitle">
                Ambulance service
            </div>
            <div class="col-xs-4 newBenefitRow benefitHeaderTitle align-center">
                Waiting period
            </div>
        </div>
        <div class="row benefitRow">
            <div class="col-xs-8 newBenefitRow benefitRowTitle">
                {{= obj.ambulance.otherInformation }}
            </div>
            <div class="col-xs-4 newBenefitRow benefitRowTitle align-center">
                {{= obj.ambulance.waitingPeriod }}
            </div>
        </div>
    </div>
</div>
