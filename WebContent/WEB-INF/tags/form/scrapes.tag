<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="id"        required="true"  rtexprvalue="true" description="required id for this scrapes display"%>
<%@ attribute name="group"     required="true"  rtexprvalue="true" description="required group for this scrapes display"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="optional additional css class attribute"%>

<!-- our scrapes container -->
<div class="right-panel ${className}" id="${id}">
	<div class="right-panel-top"></div>
	<div class="right-panel-middle">
		<ul></ul>
	</div>
	<div class="right-panel-bottom"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">

	#${id} {
		display:			none;
	}

	#${id} h1 {
		font-family: 		"SunLT Light", "Open Sans", Helvetica, Arial, sans-serif;
		font-size: 			19px;
		font-weight: 		300;
		color: 				#0CB24E;
	}

	#${id} h3 {
		margin-top:			10px;
		margin-bottom: 		3px;
		font-size: 			13px;
		color: 				#113594;
	}

	#${id} p {
	}

	#${id} ul {}

	#${id} ul li {
		display: 			block;
	}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

/**
 * Scrapes class handles the rendering of scrape content into
 * the right-panel.
 * Scrapes are rendered by calling: scrape.render and providing
 * the ID of the scrape record.
 */
var Scrapes = function()
{
	var that =			this,
		group =			"${group}",
		data =			[],
		elements =		{},
		current_slide =	false;

	// init()
	// ===========================================
	var init = function()
	{
		elements.root =		$("#${id}");
		elements.list =		$("#${id}" + " > div > ul");
		retrieveData();
	}

	// retrieveData
	// ===========================================
	var retrieveData = function()
	{
		$.ajax({
			url: "ajax/json/retrieve_scrapes.jsp",
			data: {group:group},
			type: "GET",
			async: true,
			dataType: "json",
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: onDataRetrieved
		});
	};

	// onDataRetrieved
	// ===========================================
	var onDataRetrieved = function(response)
	{
		var results = response.results;

		if(results.success)
		{
			data = results.data;
		}
		else
		{
			data = [];
		}

		$(document).ready(updateDOM());
	};

	// updateDOM()
	// ===========================================
	var updateDOM = function()
	{
		// Inject and hide all the scrape content items

		elements.list.empty();

		for(var i in data)
		{
			elements.list.append("<li id='scrapes_item_" + data[i].id + "'>" + data[i].html + "<" + "/li>");
		}

		elements.list.children().each(function(){
			$(this).hide();
		});
	};

	// render()
	// ===========================================
	this.render = function( index )
	{
		if(current_slide)
		{
			// Fade between the 2 slides
			$("#scrapes_item_" + current_slide).fadeOut(100, function(){
				$("#scrapes_item_" + index).fadeIn(200, function(){
					current_slide = index;
				});
			});
		}
		else
		{
			// Slide up all the original right panel content
			// and slide down the required scrape

			$("#page .right-panel").each(function(){
				$(this).slideUp(100);
			});

			$(elements.root).slideDown(200, function(){
				$("#scrapes_item_" + index).fadeIn(100);
				current_slide = index;
			});
		}
	};

	// unRender()
	// ===========================================
	this.unRender = function()
	{
		// Slide up the scrape and slide down any
		// original right panel content

		$(elements.root).slideUp(100, function(){
			//$("#scrapes_item_" + index).hide();
		});

		$("#page .right-panel").each(function(index){
			if( current_slide && index != current_slide - 1)
			{
				$(this).slideDown(200);
			}
		});

		current_slide = false;
	};

	init();
};

</go:script>

<go:script marker="onready">
scrapes = new Scrapes();
</go:script>