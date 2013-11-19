<%@ tag description="Travel Annual Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<form:fieldset legend="Travellers">
			<form:row label="How many adults?" className="" helpId="216">
				<field:array_select items="1=1,2=2" xpath="travel/adults" title="how many adults" required="true" className="thinner_input" />
			</form:row>
			<form:row label="How many children?" className="" helpId="217">
				<field:array_select items="0=0,1=1,2=2,3=3,4=4,5=5,6=6,7=7,8=8,9=9,10=10" xpath="travel/children" title="how many children" required="true" className="thinner_input" />	
			</form:row>
			<form:row label="What is the age of the oldest traveller?" helpId="218">
				<field:input_age maxlength="2" xpath="travel/oldest" title="age of oldest traveller" required="true" className="age_input" />
			</form:row>
			<div class="clear"></div>
	</form:fieldset>
	
	<form:fieldset legend="Your contact details" id="contactDetails">


		<travel:name_email_opt />


		<%--
		<form:row label="Do all travellers live in Australia?" helpId="219">
			<field:array_select items="Yes=Y,No=N" xpath="travel/liveInAus" title="do all travellers live in australia" required="true" />	
		</form:row>
		 --%>
	</form:fieldset>
	
	<div class="clear"></div>
	<a href="javascript:;" class="cancelbtn"><span>Cancel</span></a>
	<a href="javascript:;" class="updatebtn"><span>Update</span></a>
	<div class="clear"></div>
	
	<%--TODO: Add code to capture adult ages --%>
