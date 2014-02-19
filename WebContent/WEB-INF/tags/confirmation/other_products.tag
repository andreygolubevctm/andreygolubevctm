<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"		required="true"		rtexprvalue="true"	description="The label for the vertical" %>



<%-- HTML --%>
<div id="confirmation-compare-options">

<c:choose>
	<c:when test="${vertical eq 'homelmi'}">
			<h4>Want to compare some of our other products?</h4>
	</c:when>
	<c:otherwise>
		<h4>You may also like to compare</h4>
	</c:otherwise>
</c:choose>


	<div class="options-list"><!-- empty --></div>
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
			/*homecontents	: {
				fragment		: 'home-contents-insurance',
				title			: 'Home & Contents'
			},
			homeloan		: {
				fragment		: 'home-loan',
				title			: 'Home Loans'
			},
			*/
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

		elements.root = $('#confirmation-compare-options').find('.options-list:first').empty();
		for(var i in products) {
			if( products.hasOwnProperty(i) ) {
				if( i != active_product ) {
					var prod = products[i];
					var title = prod.title.split(' ');

					var element = $('<a/>',{
						href	: 'http://comparethemarket.com.au/' + prod.fragment + '/',
						title	: prod.title
					})
					.append(
						$('<div/>').addClass('vertical-icon').addClass(prod.fragment)
					)
					.append( title.shift() )
					.append(
						$('<span/>').append( title.length > 0 ? title.join(' ') : '&nbsp;' )
					);

					if( title.length > 0 ) {
						element.append(
						)
					}

					elements.root.append( element );
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

<%-- CSS --%>
<go:style marker="css-head">

#confirmation-compare-options a {
	display:				inline-block;
	width:					157px;
	font-family:			"SunLTBoldRegular",Helvetica,Arial,sans-serif;
	color:					#999;
	font-size:				22px;
	line-height:			20px;
	text-align:				center;
	text-decoration:		none;
	text-transform:			uppercase;
	zoom:					1;
	margin-bottom:			15px;
}

#confirmation-compare-options a span {
	display:				block;
	margin:					0 auto;
	font-size:				14px;
}

#confirmation-compare-options a:hover {
	color:					#3855A5;
}

#confirmation-compare-options a .vertical-icon {
	width:					87px;
	height:					85px;
	background:				#fff url(common/images/vertical_icons_sprite.png) 0px 0px;
	margin:					0px auto 10px auto;
}

#confirmation-compare-options a .vertical-icon.car-insurance {background-position:0px -380px;}
#confirmation-compare-options a:hover .vertical-icon.car-insurance {background-position:-93px -380px;}
#confirmation-compare-options a .vertical-icon.fuel {background-position:0px -95px;}
#confirmation-compare-options a:hover .vertical-icon.fuel {background-position:-93px -95px;}
#confirmation-compare-options a .vertical-icon.health-insurance {background-position:0px 0px;}
#confirmation-compare-options a:hover .vertical-icon.health-insurance {background-position:-93px 0px;}
#confirmation-compare-options a .vertical-icon.home-contents-insurance {background-position:0px 0px;}
#confirmation-compare-options a:hover .vertical-icon.home-contents-insurance {background-position:-93px 0px;}
#confirmation-compare-options a .vertical-icon.home-loan {background-position:0px 0px;}
#confirmation-compare-options a:hover .vertical-icon.home-loan {background-position:-93px 0px;}
#confirmation-compare-options a .vertical-icon.income-protection {background-position:0px -665px;}
#confirmation-compare-options a:hover .vertical-icon.income-protection {background-position:-93px -665px;}
#confirmation-compare-options a .vertical-icon.life-insurance {background-position:0px -475px;}
#confirmation-compare-options a:hover .vertical-icon.life-insurance {background-position:-93px -475px;}
#confirmation-compare-options a .vertical-icon.roadside-assistance {background-position:0px -285px;}
#confirmation-compare-options a:hover .vertical-icon.roadside-assistance {background-position:-93px -285px;}
#confirmation-compare-options a .vertical-icon.travel-insurance {background-position:0px -190px;}
#confirmation-compare-options a:hover .vertical-icon.travel-insurance {background-position:-93px -190px;}
#confirmation-compare-options a .vertical-icon.energy {background-position:0px -570px;}
#confirmation-compare-options a:hover .vertical-icon.energy {background-position:-93px -570px;}
</go:style>