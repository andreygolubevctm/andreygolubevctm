<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<go:style marker="css-head">
	#sidePanel h1 {
		font-family: "SunLT Light", "Open Sans", Helvetica, Arial, sans-serif;
		font-size: 19px;
		font-weight: 300;
		color: #0CB24E;
	}
	#sidePanel ul{
		margin-top:30px;
	}
	#sidePanel ul li{
		list-style-image: url(brand/ctm/images/bullet_edit.png);
		list-style-position: outside;
		margin: 10px 0 1.6em 14px;
		
		font-size:13px;
		font-weight: bold;
		color:#113594; 
	}
	#sidePanel ul li a{
		font-size:13px;
		font-weight: bold;
		color:#113594;
		text-decoration: underline;
	}

	
	.energyConsumptionDialogContainer,
	.stateEnergyConcessionDialogContainer,
	.switchwiseCalculatorDialogContainer{
		font-family: Arial, Helvetica, sans-serif;
		font-size: 13px;
	}
	.energyConsumptionDialogContainer h2,
	.stateEnergyConcessionDialogContainer h2,
	.switchwiseCalculatorDialogContainer h2 {
		color: #1c3f94;
		padding-bottom: 2px;
		font-weight: normal;
		font-family: "SunLt Bold", Arial, Helvetica, sans-serif;
		
		font-size: 1.384615384615385em;
		margin: 0.83em 0 0em 0;
	}
	.energyConsumptionDialogContainer h3,
	.stateEnergyConcessionDialogContainer h3,
	.switchwiseCalculatorDialogContainer h3 {
		color: #0db14b;
		padding-bottom: 2px;
		font-weight: normal;
		font-family: "SunLt Bold", Arial, Helvetica, sans-serif;
		
		font-size: 1.384615384615385em;
		margin: 2em 0 0 0;
	}
	.energyConsumptionDialogContainer h4,
	.stateEnergyConcessionDialogContainer h4,
	.switchwiseCalculatorDialogContainer h4 {
		color: #1c3f94;
		padding-bottom: 2px;
		font-weight: normal;
		font-family: "SunLt Bold", Arial, Helvetica, sans-serif;
		
		font-size: 1.230769230769231em;
		margin: 2.2em 0 0 0;
	}
	
	.energyConsumptionDialogContainer ul li,
	.stateEnergyConcessionDialogContainer ul li,
	.switchwiseCalculatorDialogContainer ul li {
		list-style-image: url(brand/ctm/images/bullet_edit.png);
		list-style-position: outside;
		margin: 0 0 0em 14px;
		line-height: 29px;
	}
	
	.energyConsumptionDialogContainer a,
	.stateEnergyConcessionDialogContainer a,
	.switchwiseCalculatorDialogContainer a {
		color: #1c3f94;
		text-decoration: none;
		font-size: 13px;
	}
			
	.energyConsumptionDialogContainer p,
	.stateEnergyConcessionDialogContainer p,
	.switchwiseCalculatorDialogContainer p {
		line-height: 20px;
		margin: 0 0 1em 0;
	}

	#stateEnergyConcessionDialog {
		line-height: 20px;
	}
</go:style>

<agg:panel>
	<div id="sidePanel">
		<h1>How we compare</h1>
		<ul>
			<li>Find out more about the <a class="modal" id="energyConsumption" href="javascript:void(0);">assumptions made about your energy consumption</a></li>
			<li>Find out more about <a class="modal" id="stateEnergyConcession" href="${pageSettings.getSetting('brochureUrl')}energy/state-energy-concession-information/">State Energy Concessions</a></li>
			<li>Find out more about comparing with the <a class="modal" id="switchwiseCalculator" href="${pageSetting.getSetting('brochureUrl')}energy/things-you-should-know/ ">Switchwise calculator</a></li>
		</ul>
	</div>
</agg:panel>

<ui:dialog title="Energy Consumption Assumptions" id="energyConsumption" width="700">
	<form:scrape id="68" />
</ui:dialog>

<ui:dialog title="State Energy Concession" id="stateEnergyConcession" width="700">
	<form:scrape id="69" />
</ui:dialog>

<ui:dialog title="Switchwise Calculator" id="switchwiseCalculator" width="700">
	<form:scrape id="70" />
</ui:dialog>

<go:script marker="onready">
    $('#sidePanel a.modal').on('click', function() {
        var href = $(this).attr('href');
        var id = $(this).attr('id');
		var dialogId = id+"Dialog";
        
		$('#' + dialogId).find('a').attr('target', '_blank');
        
		eval(dialogId).open();

        return false;
    });
</go:script>