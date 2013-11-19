<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price starting point filter for the health search."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="id" 		required="true"	 rtexprvalue="true"	 description="field group's id" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<div>
<%-- HTML --%>
<h5 class="lt">Starting price</h5>
	<div id="${id}" class="health-price-filter">
		<div><field:slider helpId="16" title="Minimum price: " id="${name}" value="10" /></div>
</div>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	// Add the slider ui for adjusting the prices
	// ==========================================
	var priceMinSlider = {
		_max: 600,
		_min: 0,
		_value: 0,
		_init: false,
		init: function(){
			if(priceMinSlider._init === false){
			priceMinSlider.$_obj = $('#${id}').find('.sliderWrapper');
			priceMinSlider.$_label = $('#${id}').find('label, span');
				priceMinSlider._init = true;
			priceMinSlider.reset();
			priceMinSlider.update({value:0});
			};
		},
		update: function(ui){
			if( ui.value != 0){
				var _rebateFactor = 1 - (priceMinSlider._rebate / 100);
				var _frequencyFactor = 12 / Results.getFrequencyNumber();
				priceMinSlider.$_label.text('from $' + Math.round( (ui.value * _frequencyFactor) * _rebateFactor) );
			} else {
				priceMinSlider.$_label.text('All prices');
			};
			$(priceMinSlider.$_obj).find('input').val(Math.round(ui.value));
		},
		<%-- This ensures when changing criteria, the selected value is not outside the new min/max --%>
		checkMax: function(newMinimum,newMaximum){
			priceMinSlider._min = newMinimum;
			priceMinSlider._max = newMaximum;
			if( newMaximum < priceMinSlider._value ){
				priceMinSlider._value = newMaximum;
			} else if (newMinimum > priceMinSlider._value){
				priceMinSlider._value = newMinimum;
			};
			priceMinSlider.update({value:priceMinSlider._value});
		},
		<%-- Reset the slider to pick up changes in the form --%>
		reset: function(){
			if(priceMinSlider._init === false){ <%-- Needs to be called once --%>
				priceMinSlider.init();
				return false;
			};
			if(typeof Results._rates == 'undefined'){
				priceMinSlider._rebate = 0;
			} else {
				priceMinSlider._rebate = Results._rates.rebate;
			};
			var category = healthChoices.benefitCategory();
			<%-- Create the price range based on the matrix of product category and cover type
				see results_benefits.tag
			--%>
			if(healthChoices._cover == 'S'){
				switch(category)
				{
				case 'GeneralHealth':
					priceMinSlider.checkMax(0,80);
					break;
				case 'Hospital':
					priceMinSlider.checkMax(25,185);
					break;
				case 'Combined':
					priceMinSlider.checkMax(50,280);
					break;
				default: <%-- The default from PHIO Outbound is Hospital, so match the max to it --%>
					priceMinSlider.checkMax(0,185);
					break;
				};
				$(priceMinSlider.$_obj).removeClass('multi');
			} else { <%-- C, SP, F --%>
				if(healthChoices._cover == 'C'){
					switch(category)
					{
					case 'GeneralHealth':
						priceMinSlider.checkMax(25,160);
						break;
					case 'Hospital':
						priceMinSlider.checkMax(50,370);
						break;
					case 'Combined':
						priceMinSlider.checkMax(100,560);
						break;
					default:
						priceMinSlider.checkMax(0,370);
						break;
					};
				} else if(healthChoices._cover == 'SPF'){
					switch(category)
					{
					case 'GeneralHealth':
						priceMinSlider.checkMax(25,155);
						break;
					case 'Hospital':
						priceMinSlider.checkMax(75,350);
						break;
					case 'Combined':
						priceMinSlider.checkMax(100,550);
						break;
					default:
						priceMinSlider.checkMax(0,350);
						break;
					};
			} else {
					switch(category)
					{
					case 'GeneralHealth':
						priceMinSlider.checkMax(25,160);
						break;
					case 'Hospital':
						priceMinSlider.checkMax(100,375);
						break;
					case 'Combined':
						priceMinSlider.checkMax(125,560);
						break;
					default:
						priceMinSlider.checkMax(0,375);
						break;
					};
				};
				$(priceMinSlider.$_obj).addClass('multi');
			};
			$(priceMinSlider.$_obj).find('.slider').slider({
				'min': priceMinSlider._min,
				'max': priceMinSlider._max,
				'value': priceMinSlider.$_obj.find('input').val(),
				'animate': true,
				'change': function(event, ui) {
					priceMinSlider.update(ui);
					if(priceMinSlider._init && (ui.value != priceMinSlider._value)){
						priceMinSlider._value = ui.value;
						Health.fetchPrices();
					};
				},
				'slide': function( event, ui ) {
					priceMinSlider.update(ui);
				}
			});
			priceMinSlider.update( { 'value':priceMinSlider._value } );
		}
	};

	slide_callbacks.register({
		mode:		'before',
		direction: 'forward',
		slide_id:	2,
		callback:	function() {
			priceMinSlider.reset();
		}
	});
</go:script>

<go:script marker="onready">
	priceMinSlider.init();
	<%-- Reset on any of the form changes --%>
	$('#show-price').on('change', function(){
		priceMinSlider.update( { 'value':priceMinSlider._value } );
	});
</go:script>