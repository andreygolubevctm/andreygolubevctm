<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="policyType" 	required="true"	 rtexprvalue="true"	 description="Defines if this is a single or AMT" %>

<layout:slide nextLabel="Get Quote">
	<layout:slide_columns>
		<jsp:attribute name="rightColumn">
			Right column
		</jsp:attribute>
		<jsp:body>
			<layout:slide_content>
				<p>Travel details</p>
				<%-- COUNTRY SECTION --%>
				<%-- 
				<c:choose>
					<c:when test = "${param.policyType == 'S'}">
						<form:fieldset legend="Where are you going?" className="no-background-color">

							<travel:country_selection xpath="travel/destinations" xpathhidden="travel/destination" />

						</form:fieldset>
					</c:when>
				</c:choose>
				 --%>

				<%-- DATES AND TRAVELLERS SECTION --%>
				<%-- 
				<form:fieldset legend="Dates &amp; Travellers" className="narrower">

					<div class="twocol">
						<field:date_range minDate="today" maxDate="${maxDate}" maxDateValidity="1y" prefill="${prefill}" showIcon="true" helpIdFrom="214" helpIdTo="215" helpClassName="fright" xpath="travel/dates" className="dates_label" inputClassName="basicDate narrow_input" labelFrom="When do you leave?" labelTo="When do you return?" titleFrom="departure" titleTo="return" required="true"></field:date_range>
						<div class="clear"></div>
					</div>

					<div class="twocoln">
						<form:row label="How many adults?" helpId="216" className="smallWidth">
							<field:array_select items="1=1,2=2" xpath="travel/adults" title="how many adults" required="true" className="thinner_input" />
						</form:row>
						<form:row label="How many children?" helpId="217" className="smallWidth">
							<field:array_select items="0=0,1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10" xpath="travel/children" title="how many children" required="true" className="thinner_input" />
						</form:row>
						<div class="clear"></div>
					</div>

					<div class="clear"></div>
					<div class="line"></div>


					<form:row label="What is the age of the oldest traveller?" helpId="218">
						<field:input_age maxlength="2" xpath="travel/oldest" title="age of oldest traveller" required="true" className="age_input" />
					</form:row>
				</form:fieldset>
				--%>

				<%-- YOUR CONTACT DETAILS SECTION --%>
				<%--
				<form:fieldset legend="Your contact details" id="contactDetails">
					<travel:name_email_opt />
				</form:fieldset>
				--%>
			</layout:slide_content>
		</jsp:body>
	</layout:slide_columns>

</layout:slide>