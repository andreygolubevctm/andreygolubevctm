<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="life_contactDetails">

	<form:fieldset legend="Your Contact Details">	
	
		<form:row label="Your email address" className="clear">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="true" />
		</form:row>
	
		<form:row label="Your phone number">
			<field:contact_telno xpath="${xpath}/contactNumber" required="true" title="your phone number"  />
		</form:row>
		
		<form:row label="Is it ok for us to call you">
			<field:array_radio items="Y=Yes,N=No" id="${name}_call" xpath="${xpath}/call" title="if we can call you" required="true" className="" />				
		</form:row>
		
		<form:row label='Please keep me informed via email of news and other offers'>
			<field:checkbox xpath="${xpath}/optIn" value="Y" title="I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" required="false" label="true"/>
		</form:row>		
	
	</form:fieldset>	

</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
</go:script>

<go:script marker="onready">
	$(function() {
		$("#${name}_call").buttonset();
	});	
	
	$("#${name}_optIn").parent().css({marginTop:'5px'});
	
	$("#life_contactDetails .fieldrow_legend").first().empty().append("For confirming quote and transaction details");
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
#life_contactDetails .fieldrow_legend {
	float:		right;
	width:		125px;
	margin: 	4px 0px 0px 3px;
	font-size:	95%;
}

#life_contactDetails #life_contactDetails_email {
	width:		250px !important;
}
</go:style>