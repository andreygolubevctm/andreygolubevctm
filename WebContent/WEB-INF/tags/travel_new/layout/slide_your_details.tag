<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="policyType" required="true" description="Defines if this is a single or AMT" %>

<%-- <fmt:setLocale value="en_GB" scope="session" /> --%>
<fmt:setLocale value="en_AU" scope="session" />

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="now_Date" pattern="yyyy-MM-dd" value="${now}" />

<jsp:useBean id="nowPlusYear" class="java.util.GregorianCalendar" />
<% nowPlusYear.add(java.util.GregorianCalendar.YEAR, 1); %>
<fmt:formatDate var="nowPlusYear_Date" pattern="yyyy-MM-dd" value="${nowPlusYear.time}" />

<%-- TODO: Minimum/Maximum Dates used to be handled with this crazy go tag, lets determine what difference this has to the above. --%>
<%-- <fmt:formatDate value="${go:AddDays(now,365)}" var="nowPlusYear_Date" type="date" pattern="dd/MM/yyyy"/> --%>

<layout:slide formId="detailsForm" nextLabel="Get Quote">
	<layout:slide_columns>
		<jsp:attribute name="rightColumn">
			<c:if test="${policyType == 'S'}">
				<ui:bubble variant="info">
					<h4>Annual Multi-Trip Cover</h4>
					<p>If you travel more than once a year, an Annual Multi-Trip Cover could help save you money on your travel insurance.</p>
					<p><a href="${pageSettings.getBaseUrl()}travel_quote.jsp?type=A">Compare Annual Multi-Trip policies here.</a></p>
				</ui:bubble>
			</c:if>
		</jsp:attribute>
		<jsp:body>
			<ui:bubble variant="chatty">
				<h4>Your Travels</h4>
				<p>Tell us about where you are travelling to and the dates of your trip to compare policies from our travel insurance providers.</p>
			</ui:bubble>
			<layout:slide_content>
				<%-- COUNTRY SECTION --%>
				<c:choose>
					<c:when test = "${policyType == 'S'}">
						<form_new:fieldset helpId="213" showHelpText="true" legend="Where are you going?" className="travel_details_destinations">
							<travel_new:country_selection xpath="travel/destinations" xpathhidden="travel/destination" />
						</form_new:fieldset>
					</c:when>
				</c:choose>

				<%-- DATES AND TRAVELLERS SECTION --%>
				<c:choose>
					<c:when test="${policyType == 'S'}">
						<c:set var="datesTravellersTitle" value="Dates &amp; Travellers" />
					</c:when>
					<c:otherwise>
						<c:set var="datesTravellersTitle" value="Travellers" />
					</c:otherwise>
				</c:choose>

				<form_new:fieldset legend="${datesTravellersTitle}" className="travel_details_datesTravellers">

					<c:if test="${policyType == 'S'}">
						<field_new:date_range xpath="travel/dates" required="true" labelFrom="When do you leave?" labelTo="When do you return?" titleFrom="departure" titleTo="return" minDateFrom="${now_Date}" maxDateFrom="${nowPlusYear_Date}" minDateTo="${now_Date}" maxDateTo="${nowPlusYear_Date}" offsetText="up to 1 year" helpIdFrom="214" helpIdTo="215" />
					</c:if>

					<form_new:row label="How many adults?" className="smallWidth" helpId="216">
						<field_new:array_select items="1=1,2=2" xpath="travel/adults" title="how many adults" required="true" className="thinner_input" />
					</form_new:row>
					<form_new:row label="How many children?"  className="smallWidth" helpId="217">
						<field_new:array_select items="0=0,1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10" xpath="travel/children" title="how many children" required="true" className="thinner_input" />
					</form_new:row>

					<form_new:row label="What is the age of the oldest traveller?">
						<field_new:input_age maxlength="2" xpath="travel/oldest" title="age of oldest traveller" required="true" className="age_input" validationNoun="traveller" />
					</form_new:row>
				</form_new:fieldset>


				<%-- YOUR CONTACT DETAILS SECTION --%>
				<form_new:fieldset legend="Your contact details" id="contactDetails">
					<travel_new:contact_details />
				</form_new:fieldset>

			</layout:slide_content>
		</jsp:body>
	</layout:slide_columns>

</layout:slide>