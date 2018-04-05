<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- <fmt:setLocale value="en_GB" scope="session" /> --%>
<fmt:setLocale value="en_AU" scope="session" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="now_Date" pattern="yyyy-MM-dd" value="${now}" />

<jsp:useBean id="nowPlusYear" class="java.util.GregorianCalendar" />
<% nowPlusYear.add(java.util.GregorianCalendar.YEAR, 1); %>
<fmt:formatDate var="nowPlusYear_Date" pattern="yyyy-MM-dd" value="${nowPlusYear.time}" />

<c:if test="${param.preload eq 'true'}">

	<jsp:useBean id="preloadToDate" class="java.util.GregorianCalendar" />
	<% preloadToDate.add(java.util.GregorianCalendar.DAY_OF_MONTH, 8); %>

	<fmt:formatDate var="preloadFromDate" value="${now}" pattern="dd/MM/yyyy" />
	<fmt:formatDate var="preloadToDate" pattern="dd/MM/yyyy" value="${preloadToDate.time}" />
	<go:setData dataVar="data" xpath="travel/dates/fromDate" value="${preloadFromDate}" />
	<go:setData dataVar="data" xpath="travel/dates/toDate" value="${preloadToDate}" />

	<jsp:useBean id="traveller1DOB" class="java.util.GregorianCalendar" />
	<jsp:useBean id="traveller2DOB" class="java.util.GregorianCalendar" />
	<% traveller1DOB.add(java.util.GregorianCalendar.YEAR, -23); %>
	<% traveller2DOB.add(java.util.GregorianCalendar.YEAR, -35); %>

	<fmt:formatDate var="preloadTraveller1DOB" pattern="dd/MM/yyyy" value="${traveller1DOB.time}" />
	<fmt:formatDate var="preloadTraveller2DOB" pattern="dd/MM/yyyy" value="${traveller2DOB.time}" />

	<go:setData dataVar="data" xpath="travel/travellers/traveller1DOB" value="${preloadTraveller1DOB}" />
	<go:setData dataVar="data" xpath="travel/travellers/traveller2DOB" value="${preloadTraveller2DOB}" />
</c:if>



<%-- TODO: Minimum/Maximum Dates used to be handled with this crazy go tag, lets determine what difference this has to the above. --%>
<%-- <fmt:formatDate value="${go:AddDays(now,365)}" var="nowPlusYear_Date" type="date" pattern="dd/MM/yyyy"/> --%>

<layout_v1:slide formId="detailsForm" nextLabel="Get Quotes">
    <layout_v1:slide_columns>
		<jsp:attribute name="rightColumn">

			<travel:brand_sidebar />

		</jsp:attribute>
		<jsp:body>
			<layout_v1:slide_content>
				<%-- PROVIDER TESTING --%>
				<agg_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" displayFullWidth="true" />
				<field_v1:hidden xpath="travel/lastCoverTabLevel" />
				<%-- YOUR CONTACT DETAILS SECTION --%>
				<form_v2:fieldset legend="Your Cover" id="yourcoverfs">
					<travel:your_cover />
				</form_v2:fieldset>

				<%-- COUNTRY SECTION --%>
				<form_v2:fieldset showHelpText="true" legend="Where are you going?"
													className="travel_details_destinations" id="destinationsfs">

						<jsp:useBean id="locationsService" class="com.ctm.web.travel.services.TravelIsoLocationsService"
												 scope="page"/>
											 
						<travel:destinations />

						<core_v1:select_tags
										variableListName="countrySelectionList"
										fieldType="autocomplete"
										variableListArray="${locationsService.getCountrySelectionList()}"
										xpath="travel/destinations"
										xpathhidden="travel/destination"
										label="Your selected Countries"
										title="Where are you travelling?"
										validationErrorPlacementSelector=".travel_details_destinations"
										helpId="213"
										source="/${pageSettings.getContextFolder()}isolocations/search.json?search="
						/>
						<field_v1:hidden xpath="travel/unknownDestinations"/>
				</form_v2:fieldset>

				<%-- DATES AND TRAVELLERS SECTION --%>
				<form_v2:fieldset legend="Dates" className="travel_details_datesTravellers" id="travelDatePicker">
					<travel:date_picker xpath="travel" /> 
				</form_v2:fieldset>
				 
				<form_v2:fieldset legend="Travellers" className="travel_details_datesTravellers" id="datestravellersfs">
					<form_v2:row label="Who's travelling?" className="smallWidth" helpId="216">
						<field_v2:array_radio items="S=Single,C=Couple,F=Family,G=Group" xpath="travel/party" title="who is travelling" required="true" className="thinner_input travel_party roundedCheckboxIcons" />
					</form_v2:row>

					<travel:travellers />

					<form_v2:row label="Will you be travelling with children?" className="single_parent_row" >
						<field_v2:array_radio xpath="travel/singleParent" required="true" defaultValue="N" items="Y=Yes,N=No" className="single_parent" title="whether you will be travelling with children" />
					</form_v2:row>
					<form_v2:row label="How many children?" className="smallWidth children_row" helpId="217">
						<field_v2:array_select items="=Select the number of children,1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10" xpath="travel/childrenSelect" title="at least 1 child" required="true" className="thinner_input" />
					</form_v2:row>

					<field_v1:hidden xpath="travel/adults" />
					<field_v1:hidden xpath="travel/children" />
				</form_v2:fieldset>
				<c:set var="fieldSetHeading">
					<c:if test="${data.travel.currentJourney == null or empty data.travel.currentJourney or (data.travel.currentJourney != null && data.travel.currentJourney != 7)}">
						Your&nbsp;
					</c:if>
				</c:set>

				<%-- TRIP TYPE SECTION --%>
				<form_v2:fieldset legend="Trip type" id="triptype">
					<travel:trip_type />
				</form_v2:fieldset>

				<%-- YOUR CONTACT DETAILS SECTION --%>
				<form_v2:fieldset legend="${fieldSetHeading}Contact Details" id="contactDetails">
					<travel:contact_details />
				</form_v2:fieldset>

			</layout_v1:slide_content>
		</jsp:body>
	</layout_v1:slide_columns>

</layout_v1:slide>