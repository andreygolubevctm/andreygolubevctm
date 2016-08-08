<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:if test="${callCentre}">
    <div class="sidebar-box hidden-sm hidden simplesSnapshot">
        <h4>Customer: </h4>
        <div class="row snapshot transactionIdContainer">
            <div class="col-md-5">
                <span class="snapshot-title">TransactionId:</span>
            </div>
            <div class="col-md-7">
                <span class="transactionId">${data.current.transactionId}</span>
            </div>
        </div>
        <div class="row snapshot">
            <div class="col-md-5">
                <span class="snapshot-title">Name:</span>
            </div>
            <div class="col-md-7">
                <span class="snapshotApplicationFirstName" data-source="#health_application_primary_firstname"></span>
                <span class="snapshotApplicationSurname" data-source="#health_application_primary_surname"></span>
                <span class="snapshotJourneyName" data-source="#health_contactDetails_name"></span>
            </div>
        </div>
        <div class="row snapshot">
            <div class="col-md-5">
                <span class="snapshot-title">Cover for:</span>
            </div>
            <div class="col-md-7">
                <span class="snapshotJourneySituation"  data-source="#health_situation_healthCvr"></span>
            </div>
        </div>
        <div class="row snapshot">
            <div class="col-md-5">
                <span class="snapshot-title">State:</span>
            </div>
            <div class="col-md-7">
                <span class="snapshotApplicationState"  data-source="#health_application_address_state"></span>
                <span class="snapshotJourneyState"  data-source="#health_situation_state"></span>
            </div>
        </div>
        <div class="row snapshot">
            <div class="col-md-5">
                <span class="snapshot-title">Postcode:</span>
            </div>
            <div class="col-md-7">
                <span class="snapshotApplicationPostcode"  data-source="#health_application_address_postCode"></span>
                <span class="snapshotJourneyPostcode"  data-source="#health_situation_postcode"></span>
            </div>
        </div>
    </div>
</c:if>