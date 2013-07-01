<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="data" value="*PARAMS" />


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="false"
	description="Parent xpath to hold individual items"%>
<%@ attribute name="xpathhidden" required="true" rtexprvalue="false"
	description="xpath to hold hidden item"%>


<%-- HTML --%>

<div class="fourcol fourcolr">

	<strong class="clear">Africa</strong>
	<field:checkbox xpath="${xpath}/af/af" value="af:af" label="true"
		title="Africa" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

	<strong class="clear">The Americas</strong>
	<field:checkbox xpath="${xpath}/am/us" value="am:us" label="true"
		title="USA" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/am/ca" value="am:ca" label="true"
		title="Canada" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/am/sa" value="am:sa" label="true"
		title="South America" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

</div>

<div class="fourcol fourcolr w120">

	<strong class="clear">Asia</strong>
	<field:checkbox xpath="${xpath}/as/ch" value="as:ch" label="true"
		title="China" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/as/hk" value="as:hk" label="true"
		title="Hong Kong" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/as/jp" value="as:jp" label="true"
		title="Japan" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/as/in" value="as:in" label="true"
		title="India" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/as/th" value="as:th" label="true"
		title="Thailand" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

</div>

<div class="fourcol fourcolr">

	<strong class="clear">Oceania / Pacific</strong>
	<field:checkbox xpath="${xpath}/au/au" value="pa:au" label="true"
		title="Australia" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/pa/ba" value="pa:ba" label="true"
		title="Bali" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/pa/in" value="pa:in" label="true"
		title="Indonesia" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/pa/nz" value="pa:nz" label="true"
		title="New Zealand" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/pa/pi" value="pa:pi" label="true"
		title="Pacific Islands" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

</div>

<div class="fourcol fourcolr">

	<strong class="clear">Europe</strong>
	<field:checkbox xpath="${xpath}/eu/eu" value="eu:eu" label="true"
		title="Europe" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>
	<field:checkbox xpath="${xpath}/eu/uk" value="eu:uk" label="true"
		title="UK" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

	<strong class="clear">Middle East</strong>
	<field:checkbox xpath="${xpath}/me/me" value="me:me" label="true"
		title="Middle East" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

	<strong class="clear">Any other country</strong>
	<field:checkbox xpath="${xpath}/do/do" value="do:do" label="true"
		title="Any other country" required="false" className="destcheckbox"></field:checkbox>
	<div class="clear"></div>

</div>

<div class="clear"></div>

<field:hidden xpath="${xpathhidden}" className="validate" required="false" validationMessage="Please select one or more countries from the list."></field:hidden>

<div class="help_icon" id="help_213"></div>

<%-- JQUERY UI --%>
<go:script marker="onready">
	
	// If at least 1 checkbox is checked, set the hidden flag
	$('.destcheckbox').change(function(){
		if($('.destcheckbox:checked').length > 0){
			$('#travel_destination').val('1');
		}else{
			$('#travel_destination').val('');
		}
		if($('.destcheckbox').parents(".content").hasClass("errorGroup")){
			QuoteEngine.validate();
		}
	});
	
	// Custom Validation
	$.validator.addMethod("countrySelected",
		function(value, element) {
		
			if($('.destcheckbox:checked').length > 0){
				$('#travel_destination').val('1');
				$('.destcheckbox').removeClass("error");
				$('.destcheckbox').parents(".content").removeClass("errorGroup");
				return true;
			}
			
				$('#travel_destination').val('');
			$('.destcheckbox').addClass("error");
			$('.destcheckbox').parents(".content").addClass("errorGroup");
			
			return false;		
		},
		"Please input your destination/s."
	);

</go:script>


<go:style marker="css-head">
	.fourcol{float:left; width:140px; height:153px; position:relative;}
	.fourcol strong{margin:8px 0 4px 0;}
	.fourcolr{margin-right:5px;}
	.twocol{float:left; width:330px;}
	.twocoln{float:left; width:285px;}
	.qe-window .content{min-height:auto;}
	#help_213{top:62px; left:590px; position:absolute;}
	.qe-window.revise #help_213{top:62px; left:423px; position:absolute;}
</go:style>

<%-- VALIDATION --%>
<go:validate selector="travel_destination" rule="countrySelected"
	parm="true" message="Please input your destination/s." />


