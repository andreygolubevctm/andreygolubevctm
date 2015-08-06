<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- <form_new:fieldset legend="Snapshot of Your Quote" className="hidden-sm hidden quoteSnapshot"> --%>
	<span class="hidden simplesSnapshot">
		<span class="">
			<span>Customer: </span>
			<span>
				<span class="snapshotApplicationFirstName" data-source="#health_application_primary_firstname"></span>
				<span class="snapshotApplicationSurname" data-source="#health_application_primary_surname"></span>
				<span class="snapshotJourneyName" data-source="#health_contactDetails_name"></span><span>, </span>
			</span>
			<span>
				<span class="snapshotJourneySituation"  data-source="#health_situation_healthCvr"></span><span>, </span>
			</span>
			<span>
				<span class="snapshotApplicationState"  data-source="#health_application_address_state"></span>
				<span class="snapshotJourneyState"  data-source="#health_situation_state"></span><span>, </span>
			</span>
			<span>
				<span class="snapshotApplicationPostcode"  data-source="#health_application_address_postCode"></span>
				<span class="snapshotJourneyPostcode"  data-source="#health_situation_postcode"></span>
			</span>
		</span>
	</span>
<%-- </form_new:fieldset> --%>