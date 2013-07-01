<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price starting point filter for the health search."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="id" 		required="true"	 rtexprvalue="true"	 description="field group's id" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<div style="visibility:hidden;">
<%-- HTML --%>
<h5 class="lt">Starting price</h5>
	<div id="${id}" class="health-price-filter">
	<div><field:slider helpId="16" title="Excess: " id="${name}" value="10" /></div>
</div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${id} {
		visibility:hidden;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	// Add the slider ui for adjusting the prices
	// ==========================================
	var priceMinSlider = {
		_max: 0,
		_value: 0,
		_init: true,
		init: function(){
			priceMinSlider.$_obj = $('#${id}').find('.sliderWrapper');
			priceMinSlider.$_label = $('#${id}').find('label, span');
			priceMinSlider.reset();
			priceMinSlider.update({value:0});
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
		<%-- Reset the slider to pick up changes in the form --%>
		reset: function(){
			priceMinSlider._init = true;
			if(typeof Results._rates == 'undefined'){
				priceMinSlider._rebate = 0;
			} else {
				priceMinSlider._rebate = Results._rates.rebate;
			};
			if(healthChoices._cover == 'S'){
				<%-- FIX, put in a switch statement here --%>
				priceMinSlider._max = 300;
				//if General Health, max = 100
				//if Hospital, max = 200
				//if Combined, max = 300
				$(priceMinSlider.$_obj).removeClass('multi');
			} else {
				priceMinSlider._max = 700;
				//if General Health, max = 200
				//if Hospital, max = 400
				//if Combined, max = 700
				$(priceMinSlider.$_obj).addClass('multi');
			};
			$(priceMinSlider.$_obj).find('.slider').slider({
				'min': 0,
				'max': priceMinSlider._max,
				'value': priceMinSlider.$_obj.find('input').val(),
				'animate': true,
				'change': function(event, ui) {
					priceMinSlider.update(ui);
					if(!priceMinSlider._init && (ui.value != priceMinSlider._value)){
						priceMinSlider._value = ui.value;
						Health.fetchPrices();
					};
				},
				'slide': function( event, ui ) {
					priceMinSlider.update(ui);
				}
			});
			priceMinSlider.update( { 'value':priceMinSlider._value } );
			priceMinSlider._init = false;
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