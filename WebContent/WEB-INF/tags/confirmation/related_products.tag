<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"		required="true"		rtexprvalue="true"	description="The transaction ID" %>

<%-- HTML --%>
<div id="confirmation-other-products">
	<h4>You may also like to compare</h4>
	<div class="products-list"><!-- empty --></div>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var OtherProducts = function() {

	var elements = {},
		active_product = '${vertical}',
		products = {
			car				: {
				fragment		: 'car-insurance',
				title			: 'Car Insurance'
			},
			fuel			: {
				fragment		: 'fuel',
				title			: 'Fuel'
			},
			health			: {
				fragment		: 'health-insurance',
				title			: 'Health Insurance'
			},
			homecontents	: {
				fragment		: 'home-contents-insurance',
				title			: 'Home & Contents'
			},
			homeloan		: {
				fragment		: 'home-loan',
				title			: 'Home Loans'
			},
			ip				: {
				fragment		: 'income-protection',
				title			: 'Income Protection'
			},
			life			: {
				fragment		: 'life-insurance',
				title			: 'Life Insurance'
			},
			roadside		: {
				fragment		: 'roadside-assistance',
				title			: 'Roadside'
			},
			travel			: {
				fragment		: 'travel-insurance',
				title			: 'Travel Insurance'
			},
			utilities		: {
				fragment		: 'energy',
				title			: 'Energy'
			}
	};

	var init = function() {

		elements.root = $('#confirmation-other-products').find('.products-list:first').empty();
		for(var i in products) {
			if( products.hasOwnProperty(i) ) {
				if( i != active_product ) {
					var prod = products[i];
					elements.root.append(
						$('<a/>',{
							text	: prod.title,
							href	: 'http://comparethemarket.com.au/' + prod.fragment + '/'
						})
						.addClass('standardButton greenButton')
					);
				}
			}
		}
	};

	init();
}


</go:script>

<go:script marker="onready">
(function(){
	new OtherProducts();
}());
</go:script>