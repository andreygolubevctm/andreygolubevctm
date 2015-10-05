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

<layout:slide formId="detailsForm" nextLabel="Get Quote">
	<layout:slide_columns>
		<jsp:attribute name="rightColumn">
			<ui:bubble variant="info" className="hidden-xs">
				<content:get key="step1Info"/>
			</ui:bubble>

			<travel:brand_sidebar />

		</jsp:attribute>
		<jsp:body>
			<ui:bubble variant="chatty">
					<div class="default">
						<content:get key="defaultStep1Marketing"/>
					</div>
					<div class="amt">
						<content:get key="amtStep1Marketing"/>
					</div>
					<div class="single">
						<content:get key="singleTripStep1Marketing"/>
					</div>
			</ui:bubble>
			<layout:slide_content>
				<%-- PROVIDER TESTING --%>
				<agg:provider_testing xpath="${pageSettings.getVerticalCode()}" displayFullWidth="true" />

				<%-- YOUR CONTACT DETAILS SECTION --%>
				<form_new:fieldset legend="Your Cover" id="yourcoverfs">
					<travel:your_cover />
				</form_new:fieldset>

				<%-- COUNTRY SECTION --%>
				<form_new:fieldset showHelpText="true" legend="Where are you going?" className="travel_details_destinations" id="destinationsfs">
					<jsp:useBean id="locationsService" class="com.ctm.services.IsoLocationsService" scope="page" />
					<core:select_tags 
						variableListName="countrySelectionList"
						fieldType="autocomplete"
						variableListArray="${locationsService.getCountrySelectionList()}"
						xpath="travel/destinations" 
						xpathhidden="travel/destination" 
						label="What Country(ies) are you going to?"
						title="Where are you travelling?"
						validationErrorPlacementSelector=".travel_details_destinations"
						helpId="213"
						source="/${pageSettings.getContextFolder()}isolocations/search.json?search="
						/>
					<field:hidden xpath="travel/unknownDestinations" />
				</form_new:fieldset>

				<%-- DATES AND TRAVELLERS SECTION --%>
				<form_new:fieldset legend="Dates &amp; Travellers" className="travel_details_datesTravellers" id="datestravellersfs">
					<field_new:date_range xpath="travel/dates" required="true" labelFrom="When do you leave?" labelTo="When do you return?" titleFrom="departure" titleTo="return" minDateFrom="${now_Date}" maxDateFrom="${nowPlusYear_Date}" minDateTo="${now_Date}" maxDateTo="${nowPlusYear_Date}" offsetText="up to 1 year" helpIdFrom="214" helpIdTo="215" />

					<form_new:row label="How many adults?" className="smallWidth" helpId="216">
						<field_new:array_select items="1=1,2=2" xpath="travel/adults" title="how many adults" required="true" className="thinner_input" />
					</form_new:row>
					<form_new:row label="Your date of birth?" className="smallWidth">
						<field_new:person_dob xpath="travel/travellers/traveller1DOB" title="your" required="true" ageMin="16" ageMax="99" />
					</form_new:row>
					<form_new:row label="Second traveller's date of birth" className="second_traveller_age_row">
						<field_new:person_dob xpath="travel/travellers/traveller2DOB" title="the second traveller's" required="false" ageMin="16" ageMax="99" />
					</form_new:row>
					<form_new:row label="How many children?"  className="smallWidth" helpId="217">
						<field_new:array_select items="0=0,1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10" xpath="travel/children" title="how many children" required="true" className="thinner_input" />
					</form_new:row>
				</form_new:fieldset>
				<c:set var="fieldSetHeading">
					<c:if test="${data.travel.currentJourney == null or empty data.travel.currentJourney or (data.travel.currentJourney != null && data.travel.currentJourney != 7)}">
						Your&nbsp;
					</c:if>
				</c:set>

				<%-- YOUR CONTACT DETAILS SECTION --%>
				<form_new:fieldset legend="${fieldSetHeading}Contact Details" id="contactDetails">
					<travel:contact_details />
				</form_new:fieldset>

			</layout:slide_content>
		</jsp:body>
	</layout:slide_columns>

</layout:slide>