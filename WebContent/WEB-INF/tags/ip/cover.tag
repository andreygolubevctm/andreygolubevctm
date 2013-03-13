<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="life_cover">
	
	<form:fieldset legend="Please select one or more areas you want to cover">
		
		<h5>Your Family</h5>
		
		<form:row label="A lump sum payment to cover all your debts and provide future financial security to your family if you were to pass away">
			<field:checkbox xpath="${xpath}/term" value="Y" title="term cover" required="false" />
		</form:row>
		
		<form:row label="A lump sum payment to assist your family if you were to suffer permanent disability">
			<field:checkbox xpath="${xpath}/tpd" value="Y" title="term cover" required="false" />
		</form:row>

		<form:row label="A lump sum payment to assist your family if you were diagnosed with a critical illness">
			<field:checkbox xpath="${xpath}/trauma" value="Y" title="term cover" required="false" />
		</form:row>
		
	</form:fieldset>

</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	
	// Custom Validation
	$.validator.addMethod("coverAreaSelected",
		function(value, element) {	
			if(  $('#life_cover').find('input:checked').length > 0 )
			{
				return true;
			}
			return false;		
		},
		"Please select at lease one cover area"
	);

</go:script>

<go:script marker="onready">
	$(function() {
		$("#${name}_tpd, #${name}_term, #${name}_trauma").buttonset();
	});
	
	// Apply defaults to fields
	LifeEngine.setTerm();
	LifeEngine.setTPD();
	LifeEngine.setTrauma();
	
	// Add listeners to checkboxes
	$('#${name}_term').on('change', function(){
		LifeEngine.setTerm();
	});
	$('#${name}_tpd').on('change', function(){
		LifeEngine.setTPD();
	});
	$('#${name}_trauma').on('change', function(){
		LifeEngine.setTrauma();
	});		
	
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} .qe-window .fieldrow_label {
		width:360px;
		margin-left:10px;
	}
	#${name} .qe-window.fieldset h5 {
		padding-left:10px;
	}
	#${name} .qe-window .fieldrow_value {
		margin-top:8px;
	}
	#${name} .qe-window .content {
		background-image: url(brand/ctm/images/main_bg_wide.png);
	}
	#${name} .qe-window .footer {
		background-image: url(brand/ctm/images/main_bg_wide_bottom.png);
	}
</go:style>

<%-- VALIDATION --%>
<go:validate selector="${go:nameFromXpath(xpath)}_trauma" rule="coverAreaSelected" parm="true" message="Please select at lease one cover area" />
