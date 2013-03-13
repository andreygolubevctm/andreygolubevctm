<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="data" value="*PARAMS" />
<fmt:setLocale value="en_GB" scope="session" />

	<%-- Minimum/Maximum Dates --%>
	<fmt:formatDate value="${go:AddDays(now,365)}" var="maxDate" type="date" pattern="dd/MM/yyyy"/> 
	

	<form:fieldset legend="Where are you going?" className="no-background-color">
		
		<travel:country_selection xpath="travel/destinations" xpathhidden="travel/destination" />
		
	</form:fieldset>

	<form:fieldset legend="Dates &amp; Travellers" className="narrower">

		<div class="twocol">
			<field:date_range minDate="today" maxDate="${maxDate}" prefill="true" showIcon="true" helpIdFrom="214" helpIdTo="215" helpClassName="fright" xpath="travel/dates" className="dates_label" inputClassName="basicDate narrow_input" labelFrom="When do you leave?" labelTo="When do you return?" titleFrom="departure" titleTo="return" required="true"></field:date_range>
			<div class="clear"></div>
		</div>

		<div class="twocoln">
			<form:row label="How many adults?" helpId="216">
				<field:array_select items="1=1,2=2" xpath="travel/adults" title="how many adults" required="true" className="thinner_input" />
			</form:row>
			<form:row label="How many children?" helpId="217">
				<field:array_select items="0=0,1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10" xpath="travel/children" title="how many children" required="true" className="thinner_input" />	
			</form:row>
			<div class="clear"></div>
		</div>
		
		<div class="clear"></div>
		<div class="line"></div>
		
		
		<form:row label="What is the age of the oldest traveller?" helpId="218">
			<field:input_age maxlength="2" xpath="travel/oldest" title="age of oldest traveller" required="true" className="age_input" />
		</form:row>
		<%--
		<form:row label="Do all travellers live in Australia?" helpId="219">
			<field:array_select items="Yes=Y,No=N" xpath="travel/liveInAus" title="do all travellers live in australia" required="true" />	
		</form:row>
		--%>
		<%--TODO: Add validation to ensure return date is after departure --%>
		
	</form:fieldset>

	<div class="clear"></div>
	<a href="javascript:;" class="cancelbtn"><span>Cancel</span></a>
	<a href="javascript:;" class="updatebtn"><span>Update</span></a>
	<div class="clear"></div>
	
	<%--TODO: Add code to capture adult ages --%>
	

<%-- VALIDATION --%>
<c:if test="${1==2}">
	<go:validate selector="travel_dates_fromDate" rule="toFromDates" parm="true" message="Please enter a departure date."/>
	<go:validate selector="travel_dates_toDate" rule="toFromDates" parm="true" message="Please enter a return date."/>
</c:if>

<go:validate selector="travel_oldest" rule="ageRange" parm="true" message="Adult travellers must be aged 16 - 99."/>
	