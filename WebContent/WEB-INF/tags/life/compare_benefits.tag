<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- HTML --%>
<div id="compare-benefits-wrapper" class="clearFix">
	<div class="innertube"><%-- empty --%></div>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var CompareBenefits = function() {

	var that		= this,
		data 		= {},
		elements	= {};

	elements.root = $('#compare-benefits-wrapper');
	elements.tube = elements.root.find('.innertube').first();

	this.show = function( json, callback ) {
		data = $.extend(true, {}, json);

		elements.tube.empty();
		renderBenefitsCol();
		var products_in_order = getTrueProductOrder(json.type);
		for(var i in products_in_order) {
			if( products_in_order.hasOwnProperty(i) ) {
			renderProductCol( data.products[products_in_order[i]] );
		}
		}
		$('#compare-benefits-wrapper .col.benefit .row').first().addClass('first-child');
		$('#compare-benefits-wrapper .col.benefit .row').last().addClass('last-child');
		$('#compare-benefits-wrapper .col.yesno').each(function(){
			$(this).find('.row').first().addClass('first-child');
			$(this).find('.row').last().addClass('last-child');
		});
		elements.tube.append( $("<div/>",{'class':'clear'}) );
		showHideResultsContent(false, function(){
			elements.root.slideDown('fast', function(){
				if( typeof callback == "function" ) {
					callback();
				}
				resize();
			});
		});
	};

	this.hide = function( callback ) {
		if( $.browser.msie && parseInt($.browser.version, 10) <= 8 ) {
			elements.root.hide();
			showHideResultsContent(true, callback);
		} else {
		elements.root.slideUp('fast', function(){
			showHideResultsContent(true, callback);
		});
		}
	};

	var renderBenefitsCol = function() {
		elements.benefits = $("<div/>",{'class':'col benefit'})
		.append( renderColHeader() );

		for(var i in data.features) {
			var rowText = data.features[i];
			var rowHTML = $("<div/>",{
				id:		'product-feature-' + i,
				'class':	'row'
			});

			// Because IE8 is naughty and throws an exception error (due to the Array Filter shim)
			// we need to check if the row heading is a string (IE8 likes to load up our shim...)
			if(typeof rowText == 'string') {
				rowHTML.append(rowText);
			}

			elements.benefits.append(rowHTML);
		}

		elements.tube.append(elements.benefits);
	};

	var renderProductCol = function( product ) {
		col = $("<div/>",{
					id: 'compare-col-' + product.info.type + '-' + product.info.id, 
					"class": 'container col yesno'
				})
				.data('productId', product.info.id)
		.append( renderColHeader(product.info) );

		for(var i in product.features) {
			var rowHTML = $("<div/>",{
				'class':	'row ' + (product.features[i] == 1 ? 'Y' : 'N')
			});

			// Because IE8 is naughty and throws an exception error (due to the Array Filter shim)
			// we need to check if the row heading is a string (IE8 likes to load up our shim...)
			if(typeof data.features[i] == 'string') {
				col.append(rowHTML);
			}
		}

		elements.tube.append(col);
	};

	var renderColHeader = function( info ) {
		var $heading = $("<div/>",{'class':'heading'});
		var person = $('#compare-form-wrapper').data('compare');

		if( info ) {
			var $close = $("<a/>",{'class':'close',href:'javascript:void(0);',title:''}).on('click', function(){
				that.dropColumn(info.type, info.id, function(){
					$('#comparebox-' + info.type + '-' + info.id + ' .close').trigger('click');
				});
			});

			$heading.append( $close )
				.append($("<div/>",{'class':'company',style:'background-image:url("' + info.logo + '");'}))
				.append(
				$("<div/>",{'class':'premium'})
				.append($("<h4/>").append(info.price))
				.append($("<p/>").append(info.freq))
				.append($("<a/>",{'class':'link inf',href:'javascript:void(0);',title:'view the Product Disclosure Statement'}).append('pds').on('click', function(){
					ui_popup_window.open('pds', info.pds, '_blank', {location:0,status:0});
				}))
			)
			.append($("<h5/>").append(info.name))
				.append($("<h6/>").append(info.desc))
				.append($("<a/>", {
						"class": "new-btn btn-primary",
						"href": "javascript:void(0);"
					}).append('Enquire Now')
					.on('click', function() {
						var productId = $(this).parents('.container').data('productId');

						$('#addtocart_' + person + '_' + productId).trigger('click');
						compare.toggleCompareButton(person, true);
					})
				);
		} else {
			var column = (person == 'partner') ? 'right' : 'left',
				personInfo = $('#results-mast-wrapper').find('.client.' + column).html(),
				headingHTML = [
					personInfo,
					'<a id="compare-back-to-results" class="new-btn btn-tertiary" href="javascript:void(0);">Back to Results</a>'
				].join('');

			$('#results-mast-wrapper .primary .client.' + column + ' .drop-selected-product').trigger('click');

			$(document).on("click", "#compare-back-to-results", function(e) {
				compare.toggleCompareButton(person, true);
			});

			$heading.addClass('empty')
				.append(headingHTML)
				.find('.select, .selected')
				.remove();
		}

		return $heading;
	};

	var showHideResultsContent = function( show, callback ) {
		if( show ) {
			$('#results-rows-wrapper').slideDown('fast', function(){
				$('#results-mast-wrapper').slideDown('slow', callback);
			});
		} else {
			$('#results-rows-wrapper').slideUp('fast', function(){
				$('#results-mast-wrapper').slideUp('fast', callback);
			});
		}
	};

	this.dropColumn = function( type, product_id, callback ) {
		$('#compare-col-' + type + '-' + product_id).animate({width:1}, 'fast', function() {
			$(this).remove();
			resize();
			if( typeof callback == "function" ) {
				callback();
			}
		});
	};

	var getTrueProductOrder = function( type ) {
		var products = [];
		$('#compare-form-wrapper .' + type).find('.product.active').each(function(){
			products.push( $(this).attr('id').split('-')[2] );
		});
		return products;
	};

	var resizeWrapper = function() {
		var new_min_height = $('#compare-benefits-wrapper').height();
		$('#resultsPage').css({
			minHeight: new_min_height
		});
	};

	var resize = function() {
		elementSearch = '#compare-benefits-wrapper';

		var width = 0;
		$(elementSearch + ' .col').each(function(){
			width += $(this).outerWidth(true);
		});

		$(elementSearch + ' .innertube').animate({width:width},250);
		<%-- Resize the group rows --%>
		$(elementSearch + ' .col.benefit').find('.row').each(function(i){
			var h = $(this).innerHeight();
			$('#compare-benefits-wrapper .col.yesno').each(function(){
				$(this).find('.row').eq(i).css({height:h});
			});
		});

		$('.details-toggle').removeClass('open');

		var delay = window.setTimeout( resizeWrapper, 400 );
	};
};
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#compare-benefits-wrapper {
		display:				none;
		position:				relative;
		background:				#ededed;
		border-top:				1px solid #ffffff;
		border-bottom:			1px solid #b0b0b0;
	}

	#compare-benefits-wrapper .innertube {
		max-width: 				980px;
		margin:					15px auto 15px auto;
	}

	#compare-benefits-wrapper .col .heading div {
		text-align: left;
	}

	#compare-benefits-wrapper .col {
		float:					left;
		width: 					180px;
		margin:					0 20px 0 0;
	}

	#compare-benefits-wrapper .col.benefit {
		width: 					360px;
		margin:					0 0 0 20px;
	}

	#compare-benefits-wrapper .col div {
		width: 					auto;
		text-align:				right;
		border-top:				1px solid #ffffff;
		border-bottom:			1px solid #b6b6b6;
	}

	#compare-benefits-wrapper .col .row.first-child {
		border-top-color: #ededed;
	}

	#compare-benefits-wrapper .col .row.last-child {
		border-bottom-color: #ededed;
	}

	#compare-benefits-wrapper .col.yesno .row.first-child {
		border-top-color: #dcdcdc;
	}

	#compare-benefits-wrapper .col.yesno .row.last-child {
		border-bottom-color: #dcdcdc;
	}

	#compare-benefits-wrapper .col.benefit .row {
		padding:				10px 20px 10px 0;
		text-align: right;
	}

	#compare-benefits-wrapper .col.yesno .row {
		min-height:				20px;
		background:				#dcdcdc url("brand/ctm/images/results_Life_IP/grey_Cross.png") 50% 50% no-repeat;
	}

	#compare-benefits-wrapper .col.yesno .row.feature.moreinfo,
	#compare-benefits-wrapper .col.yesno .row.description {
		cursor:					pointer;
	}

	#compare-benefits-wrapper .col.yesno .row.Y {
		background-image:		url("brand/ctm/images/results_Life_IP/green_tick.png");
	}

	#compare-benefits-wrapper .col .heading {
		position:				relative;
		height:	180px;
		background:				#ffffff;
		border:					none;
		border-bottom:			1px dashed #b6b6b6;
		-webkit-border-top-left-radius: 5px;
		-webkit-border-top-right-radius: 5px;
		-moz-border-radius-topleft: 5px;
		-moz-border-radius-topright: 5px;
		border-top-left-radius: 5px;
		border-top-right-radius: 5px;
	}

	#compare-benefits-wrapper .new-btn.btn-primary {
		margin: 8px;
	}

	#compare-benefits-wrapper .col .heading.empty {background:#ededed;border-bottom: 1px solid #b6b6b6;}

	#compare-benefits-wrapper .col .heading .close {
		position: 				absolute;
		width: 					14px;
		height: 				14px;
		top: 					-7px;
		right: 					-7px;
		background: 			url('brand/ctm/images/results_Life_IP/closeIcon.png') 50% 50% no-repeat;
		overflow: 				hidden;
		text-indent: 			-10000px;
	}

	#compare-benefits-wrapper .col .heading .company,
	#compare-benefits-wrapper .col .heading .premium {
		position: 				absolute;
		top:					5px;
	}

	#compare-benefits-wrapper .col .heading .company {
		left:					5px;
		width: 					83px;
		height: 72px;
		background-color: 		#ffffff;
		background-position: 	50% 50%;
		background-repeat: 		no-repeat;
		border: 				1px solid #b6b6b6;
	}

	#compare-benefits-wrapper .col .heading .premium {
		width: 					85px;
		height: 				46px;
		right: 					5px;
		top:					15px;
		border:					none;
	}

	#compare-benefits-wrapper .col .heading .premium h4 {
		color: 					#ff6600;
		font-size: 19.5pt;
		line-height: 			14pt;
		text-align: 			right;
		font-weight: 			bold;
		padding: 				0;
	}
	#compare-benefits-wrapper .col .heading .premium h4.sml {
		font-size: 				14pt;
	}

	#compare-benefits-wrapper .col .heading .premium h4 span {
		font-size: 				70%;
	}

	#compare-benefits-wrapper .col .heading .premium p {
		text-align: 			right;
		color:					#666666;
		padding:				0;
		font-size: 12px;
		line-height: 12px;
		margin-top: 2px;
	}

	#compare-benefits-wrapper .col .heading .premium .link {
		font-size:				8pt;
		font-weight:			bold;
		text-transform:			uppercase;
		color:					#999999;
		text-decoration:		none;
		display: block;
		margin-top: 4px;
	}

	#compare-benefits-wrapper .col .heading .premium .link:hover {
		color:					#009934;
	}

	#compare-benefits-wrapper .col .heading .premium .link.pds {
		text-align:				left;
		left:					5px;
	}

	#compare-benefits-wrapper .col .heading .premium .link.inf {
		text-align:				right;
		right:					0px;
	}

	#compare-benefits-wrapper .col .heading h5,
	#compare-benefits-wrapper .col .heading h6 {
		font-size: 9.5pt;
		line-height:			9pt;
		text-align:	center;
		padding: 90px 5px 0 5px;
		font-weight: bold;
	}

	#compare-benefits-wrapper .col .heading h6 {
		font-weight: normal;
		color:					#999999;
		padding-top: 3px;
		font-size: 8pt;
	}

	#compare-benefits-wrapper .col .heading .btn-primary {
		position: absolute;
		bottom: 0;
		width: 120px;
	}

</go:style>