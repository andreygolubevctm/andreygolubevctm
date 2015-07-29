<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- MORE INFO POPUP --%>
<simples:popup_moreinfo />

<%-- HTML --%>
<div id="search-quotes-dialog" class="search-quotes-dialog" title="Search Health Quotes">
	<div class="wrapper">
		<div class="search-bar">
			<input type="text" name="search-quotes-terms" id="search-quotes-terms" />
			<button id="search-quotes-terms-submit">Search</button>
		</div>
		<div class="search-quotes">
			<div class="header">
				<div class="quote-brand">Brand</div>
				<div class="quote-date-time">Date/time</div>
				<div class="quote-details">Details</div>
				<div class="quote-options">Options</div>
			</div>
			<div id="search-quote-list" class="content"><!-- empty --></div>
			<div id="search-quote-list-empty" class="content">
				<p>No search results found to display...</p>
			</div>
			<div class="footer"><!-- empty --></div>
		</div>
	</div>
	<div class="dialog_footer"></div>
</div>

<core:js_template id="found_health_quote">
	<div class="quote-row [#=available#] editable[#=editable#]" data-brandId="[#=quoteBrandId#]" id="health_quote_[#=id#]_[#=available#]" style="display: block; ">
		<div class="quote-brand">
			[#=quoteBrandName#]
		</div>
		<div class="quote-date-time">
			<span class="quote-date">[#=quoteDate#]</span>
			<span class="quote-time">[#=quoteTime#]</span>
			<span class="transactionId">[#=id#]</span>
			<span class="rootId">(&nbsp;[#=rootid#]&nbsp;)</span>
		</div>
		<div class="quote-details">
			<div class="editable editableC">SOLD</div>
			<div class="editable editableF">PENDING</div>
			<div class="editable editable1">AVAILABLE</div>
			<div class="title">[#=contacts.name#]</div>
			<div class="subtitle"><em>[#=email#]</em></div>
			<ul>
				<li class="situation"><strong>Situation:</strong> [#=resultData.situation#]</li>
				<li class="income"><strong>Income:</strong> [#=resultData.income#]</li>
				<li class="dependants"><strong>Dependants:</strong> [#=resultData.dependants#]</li>
				<li class="benefits"><strong>Benefits:</strong> ([#=resultData.benefitCount#]) [#=resultData.benefits#]</li>
			</ul>
		</div>
		<div class="quote-options">
			<div class="quote-moreinfo"><a href="javascript:void(0);" class="quote-moreinfo-button tinybtn blue"><span>More Info</span></a></div>
			<div class="quote-comments"><a href="javascript:void(0);" class="quote-comments-button tinybtn blue"><span>Comments</span></a></div>
			<div class="quote-amend [#=available#]"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
		</div>
	</div>
</core:js_template>

<core:js_template id="found_life_quote">
	<div class="quote-row" id="life_quote_[#=id#]_[#=available#]" style="display: block; ">
		<div class="quote-brand">
			[#=quoteBrandName#]
		</div>
		<div class="quote-date-time">
			<span class="quote-date">[#=quoteDate#]</span>
			<span class="quote-time">[#=quoteTime#]</span>
			<span class="transactionId">[#=id#]</span>
			<span class="rootId">(&nbsp;[#=rootid#]&nbsp;)</span>
		</div>
		<div class="quote-details">
			<div class="title">Life Insurance Quote</div>
			<span class="situation">Situation: [#=content.situation#]</span>
			<span class="term"><span class="label">Term Life Cover: $</span>[#=content.term#]</span>
			<span class="tpd"><span class="label">TPD Cover: $</span>[#=content.tpd#]</span>
			<span class="trauma"><span class="label">Trauma Cover: $</span>[#=content.trauma#]</span>
			<span class="premium"><span class="label">Premium: </span>[#=content.premium#]</span>
		</div>
		<div class="quote-options">
			<!--<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest ResultsObj</span></a></div>-->
			<div class="quote-amend [#=available#]"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
		</div>
	</div>
</core:js_template>

<core:js_template id="found_ip_quote">
	<div class="quote-row" id="ip_quote_[#=id#]_[#=available#]" style="display: block; ">
		<div class="quote-brand">
			[#=quoteBrandName#]
		</div>
		<div class="quote-date-time">
			<span class="quote-date">[#=quoteDate#]</span>
			<span class="quote-time">[#=quoteTime#]</span>
			<span class="transactionId">[#=id#]</span>
			<span class="rootId">(&nbsp;[#=rootid#]&nbsp;)</span>
		</div>
		<div class="quote-details">
			<div class="title">Income Protection Insurance Quote</div>
			<span class="situation">Situation: [#=content.situation#]</span>
			<span class="income"><span class="label">Income: $</span>[#=content.income#]</span>
			<span class="amount"><span class="label">Benefit Amount: $</span>[#=content.amount#]</span>
			<span class="premium"><span class="label">Premium: </span>[#=content.premium#]</span>
		</div>
		<div class="quote-options">
			<!--<div class="quote-latest"><a href="javascript:void(0);" class="quote-latest-button tinybtn blue"><span>Get Latest ResultsObj</span></a></div>-->
			<div class="quote-amend [#=available#]"><a href="javascript:void(0);" class="quote-amend-button tinybtn"><span>Amend this Quote</span></a></div>
		</div>
	</div>
</core:js_template>


<%-- CSS --%>
<go:style marker="css-head">
#search-quotes-dialog {
	min-width:				737px;
	max-width:				737px;
	width:					737px;
	display: 				none;
	overflow:				hidden;
}
#search-quotes-dialog h2 {
	margin:					12px 3px;
}
#search-quotes-dialog .wrapper {
	margin: 				0 15px;
}
#search-quotes-dialog .search-bar {
	text-align: 			right;
	margin-bottom: 			8px;
}
#search-quotes-dialog .search-bar input#search-quotes-terms {
	width: 					200px;
	padding-left:			5px;
	padding-right:			5px;
}

#search-quotes-dialog .search-quotes {
	width:					707px;
}
#search-quotes-dialog .search-quotes h3 {
	margin:					0px 0px 20px 28px;
	font-weight:			bold;
	font-size:				18px;
}
#search-quotes-dialog #search-terms.error {
	border-color:			red;
}
#search-quotes-dialog .search-quotes .header{
	background: 			transparent url("brand/ctm/images/main_bg_707_top.png") top left no-repeat;
	color: 					#0C4DA2;
	font-family: 			"SunLT Bold","Open Sans",Helvetica,Arial,sans-serif;
	font-size: 				16px;
	font-weight: 			bold;
	height: 				20px;
	padding: 				10px 0 4px 14px;
	position: 				relative;
}

#search-quotes-dialog .search-quotes .footer {
	background-image: 		url(brand/ctm/images/main_bg_707_bottom.png);
	background-repeat: 		no-repeat;
	height: 				19px;
}

#search-quotes-dialog .search-quotes .quote-row.no {
	background:				#f9f9f9;
}

<%-- SOLD/PENDING labels --%>
#search-quotes-dialog .editable {
	display: none;
}
#search-quotes-dialog .editableC .editableC,
#search-quotes-dialog .editableF .editableF {
	display: block;
	float: left;
	margin-right: 1em;
	font-weight: bold;
	color: #fff;
	padding: 0.2em 0.5em;
	background: #999;
	border-radius: 3px;
}
#search-quotes-dialog .editableC .editableC {
	background: #0CB24E;<%-- green --%>
}
#search-quotes-dialog .editableF .editableF {
	background: #E54200;<%-- orange --%>
}

#search-quotes-dialog .search-quotes .header div,
#search-quotes-dialog .search-quotes .quote-row > div {
	display:				inline-block;
	zoom:					1;
	*display:				inline;
}
#search-quotes-dialog .search-quotes .quote-row > div {
	vertical-align: 		top;
}
#search-quotes-dialog .search-quotes .quote-brand{
	margin-left:			2px;
	width:					100px;
	text-align: 			left;
}

#search-quotes-dialog .search-quotes .quote-date-time{
	margin-left:			2px;
	width:					100px;
	text-align: 			center;
}
#search-quotes-dialog .search-quotes .quote-details{
	margin-left:			0px;
	width:					320px;
}
#search-quotes-dialog .search-quotes .quote-options{
	margin-left:			0px;
	width:					120px;
}
#search-quotes-dialog .search-quotes .content {
	overflow: 				auto;
	background: 			white;
	padding: 				10px 14px;
	border-left: 			1px solid #E3E8EC;
	border-right: 			1px solid #E3E8EC;
	font-size: 				12px;
	display:				none;
}
#search-quotes-dialog .search-quotes #search-quote-list {
	height: 				395px;
}
#search-quotes-dialog .search-quotes .content .quote-row {
	border-bottom: 			1px solid #E3E8EC;
	padding: 				5px 0;
}
#search-quotes-dialog .search-quotes .quote-row span{
	color: 					#555;
	display: 				block;
	margin-top: 			2px;
}
#search-quotes-dialog .search-quotes .quote-date-time span{
	font-weight: 			bold;
	text-align: 			center;
}
#search-quotes-dialog .search-quotes .quote-row .quote-details{
	font-size: 				11px;
	line-height:			14px;
}
#search-quotes-dialog .search-quotes .quote-brand,
#search-quotes-dialog .search-quotes .quote-date,
#search-quotes-dialog .search-quotes .title,
#search-quotes-dialog .search-quotes .subtitle{
	font-size: 				14px;
	line-height: 			16px;
	font-weight: 			bold;
}
#search-quotes-dialog .search-quotes .subtitle{
	font-size: 				13px;
	clear: left;<%-- clear editable label --%>
}
#search-quotes-dialog .search-quotes .subtitle em{
	color:					blue !important;
	font-style:				normal;
	display:				block;
}
#search-quotes-dialog .search-quotes .quote-date-time .transactionId{
	color: 					#0CB24E;
	margin-top:				10px;
}
#search-quotes-dialog .search-quotes .quote-date-time .rootId{
	color: 					#A0A0A0;
	font-size:				95%;
	margin-top:				10px;
}
#search-quotes-dialog .search-quotes .quote-options span{
	color: 					#FFF;
}
#search-quotes-dialog .search-quotes .quote-moreinfo,
#search-quotes-dialog .search-quotes .quote-amend,
#search-quotes-dialog .search-quotes .quote-comments{
	margin-top: 			8px;
}
#search-quotes-dialog .search-quotes .quote-amend.no{
	display: 				none;
}
#search-quotes-dialog .search-quotes .highlight{
	display: 				inline !important;
	background:				yellow !important;

}
#search-quotes-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_737.gif") no-repeat scroll left top transparent;
	width: 					737px;
	height: 				14px;
	clear: 					both;
}

#search-quote-list .quote-latest-button {
	display:				none;
}

#search-quotes-dialog .search-quotes #search-quote-list .quote-row .quote-amend-button span,
#search-quotes-dialog .search-quotes #search-quote-list .quote-row .quote-moreinfo-button span,
#search-quotes-dialog .search-quotes #search-quote-list .quote-row .quote-comments-button span {
	margin-top:				0;
}

.ui-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog .message-form, .ui-dialog #search-quotes-dialog{
	padding:				0;
}

.search-quotes-dialog .ui-dialog-titlebar {
	background-image:		url("common/images/dialog/header_737.gif") !important;
	height:					34px;
	-moz-border-radius-bottomright: 0;
	-webkit-border-bottom-right-radius: 0;
	-khtml-border-bottom-right-radius: 0;
	border-bottom-right-radius: 0;
	-moz-border-radius-bottomleft: 0;
	-webkit-border-bottom-left-radius: 0;
	-khtml-border-bottom-left-radius: 0;
	border-bottom-left-radius: 0;
}

.search-quotes-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_737.png") !important;
}

#search-quotes-error-message,
#retrieve-quotes-error-message {
	padding-top:			10px;
	padding-bottom:			10px;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var SearchQuotes = new Object();
SearchQuotes = {

	_search_terms: null,
	_quotes: false,

	init: function() {

		// Initialise the search quotes dialog box
		// =======================================
		$('#search-quotes-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip',
			'modal':true,
			'width':737, 'height':580,
			'minWidth':737, 'minHeight':580,
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'search-quotes-dialog',
			'title':'Search Quotes',
			open: function() {
				SearchQuotes.getQuotes();
			},
			close: function(){
				// Maybe something for later
			}
		});

		// Error popup close button listeners
		// ==================================
		$("#retrieve-quote-error .close-error").first().on("click", function(){
			Popup.hide("#retrieve-quote-error");
		});

		$("#search-quotes-error .close-error").first().on("click", function(){
			Popup.hide("#search-quotes-error");
		});

		$("#search-quotes-terms-submit").on("click", function(){
			SearchQuotes.submitSearch();
		});

		$("#search-quotes-terms").on("keypress", function(e){
			if( e.which == 13 ) {
				SearchQuotes.submitSearch();
			}
		});
	},

	search: function( search_terms ) {
		SearchQuotes._search_terms = $.trim(String(search_terms));
		$("#search-quotes-terms").val(search_terms);
		if($("#search-quotes-dialog").dialog( "isOpen" ))
		{
			SearchQuotes.getQuotes();
		}
		else
		{
			$('#search-quotes-dialog').dialog("open");
		}
	},

	submitSearch: function() {
		var search_terms = String($("#search-quotes-terms").val());
		$("#search-quotes-terms").removeClass("error");
		SearchQuotes.search( search_terms );
	},

	handleErrors : function( errors, default_text ) {
		default_text = default_text || "Apologies: There was a fatal error.";
		var message = "";
		var force_login = false;
		try {
			for(var i in errors) {
				if( errors.hasOwnProperty(i) ) {
					if( errors[i].error == "login" ) {
						force_login = true;
					} else {
						message += "<p>" + errors[i].error + "</p>";
					}
				}
			}
		} catch(e) {
			message = "<p>" + default_text + "</p>";
		}
		if( force_login ) {
			SearchQuotes.forceLogin();
		} else {
			$("#search-quotes-error-message").empty().append(message);
			Popup.show("#search-quotes-error", "#loading-overlay");
		}
	},

	getQuotes: function() {

		Loading.show("Searching for Quotes...", function() {

			var dat = "";

			if( SearchQuotes._search_terms.length )	{
				dat = {simples:true,search_terms:SearchQuotes._search_terms};
			}

			var error_text = "Apologies: There was a fatal error retrieving more info.";

			$.ajax({
				type: 		'GET',
				async: 		false,
				timeout: 	30000,
				url: 		"ajax/json/search_quotes.jsp",
				data:		dat,
				dataType: 	"json",
				cache: 		false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				error: 		function(data){
					Loading.hide();
					var errors;
					try {
						errors = JSON.parse(data.responseText).errors;
					} catch(e) {
						errors = [{error:error_text}];
					}
					$("#search-quote-list").hide();
					$("#search-quote-list-empty").show();
					SearchQuotes.handleErrors( errors, error_text );
				},
				success: 	function(json){
					Loading.hide();
					try {
						SearchQuotes.display(json.search_results.quote);
					} catch(e) {
						$("#search-quote-list").hide();
						$("#search-quote-list-empty").show();
						if( json.hasOwnProperty('errors') ) {
							SearchQuotes.handleErrors(json.errors, error_text);
						} else {
							SearchQuotes.handleErrors( [{error:"Sorry, you have no quotes to display."}], "Sorry, you have no quotes to display." );
						}
					}
				}
			});
		});
	},

	getMoreInfo: function( id ) {
		<%-- Get the quote from the search results --%>
		var quote = false;
		$.each(SearchQuotes._quotes, function(i, value) {
			if (value.id && value.id == id) {
				quote = value;
				return false;<%-- exits the each loop --%>
			}
		});

		var error_text = "Apologies: There was a fatal error retrieving more info.";

		if (!quote) {
			SearchQuotes.handleErrors([{error:error_text}], error_text);
			return false;
		}
	//	MoreInfoDialog.launch(quote);
	//	return false;

		Loading.show("Loading More Info...", function() {

			var dat = {transactionid:id};

			$.ajax({
				type: 		'GET',
				async: 		false,
				timeout: 	30000,
				url: 		"ajax/json/search_moreinfo.jsp",
				data:		dat,
				dataType: 	"json",
				cache: 		false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				error: 		function(data, txt){
					Loading.hide();
					var errors;
					try {
						errors = JSON.parse(data.responseText).errors;
					} catch(e) {
						errors = [{error:error_text}];
					}
					SearchQuotes.handleErrors( errors, error_text );
				},
				success: 	function(json){
					Loading.hide();
					try {
						if (json && typeof json === 'object' && !json.errors && json.quote) {
							<%-- Push all the additional data onto the quote object --%>
							json = json.quote;
							for (var p in json) {
								if (json.hasOwnProperty(p)) {
									quote[p] = json[p];
								}
							}
							MoreInfoDialog.launch(quote);
						} else {
							SearchQuotes.handleErrors(json.errors, error_text);
						}
					} catch(e) {
						SearchQuotes.handleErrors([{error:"Sorry, an invalid response was received."}], "Sorry, an invalid response was received.");
					}
				}
			});
		});
	},

	display: function(search_results) {

		var templates = {
			health:	$("#found_health_quote").html(),
			ip:		$("#found_ip_quote").html(),
			life:	$("#found_life_quote").html()
		}

		$("#search-quote-list").empty();

		var quoteCount = 0;
		var quoteType = false;

		if (typeof search_results == 'object')
		{
			<%-- If only one result, convert into array --%>
			if (!$.isArray(search_results)) {
				search_results = [search_results];
			}

			for (var i in search_results) {
				if (typeof search_results[i] == "object" && quoteCount < 8) {
					<%-- Use quoteType to determine which template to render result --%>
					quoteType = false;
					if (search_results[i].hasOwnProperty('quoteType')) {
						quoteType = search_results[i].quoteType;
					}

					switch (quoteType) {
						case 'health':
							if (SearchQuotes._drawHealthQuote(search_results[i], templates.health)) {
								quoteCount++;
							}
							break;
						case 'life':
							if (SearchQuotes._drawLifeQuote(search_results[i], templates.life)) {
								quoteCount++;
							}
							break;
						case 'ip':
							if (SearchQuotes._drawIPQuote(search_results[i], templates.ip)) {
								quoteCount++;
							}
							break;
						default:
							// ignore
					}
				}
			};
		}

		this._quotes = search_results;

		if (quoteCount > 0)
		{
			$("#search-quote-list-empty").hide();

			$(".quote-details span").toTitleCase();
			$(".quote-row:first-child").addClass("first-row");

			var delay = 400;
			$(".quote-row").each(function(){
				$(this).hide().delay(delay).fadeIn(200);
				delay+=100;
			});

			SearchQuotes._initRowButtons();

			$("#search-quote-list").show('fast');
			<%--
			$("#search-quote-list").show("fast", function(){
				$(".quote-row .quote-details").each(function(){
					SearchQuotes.highlightTerms($(this));
				});
			});
			--%>
		}
		else
		{
			$("#search-quote-list").hide("fast");
			$("#search-quote-list-empty").show();
		}
	},

	_drawHealthQuote: function(quote, templateHtml) {
		try {
			quote.available = (quote.editable == 'C') ? 'no' : 'yes';

			var newRow = $(parseTemplate(templateHtml, quote));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				$("#search-quote-list").append(newRow);
				return true;
			}

			return false;
		} catch(e) {
			return false;
		}
	},

	_drawLifeQuote: function(quote, templateHtml) {
		try {
			quote.life.available = !Number(quote.life.editable) ? 'no' : 'yes';

			var age =		quote.life.details.primary.age;
			var smoker =	quote.life.details.primary.smoker == "N" ? "non-smoker" : "smoker";
			var gender =	quote.life.details.primary.gender == "M" ? "male" : "female";
			var premium_f = quote.life.details.primary.insurance.frequency;
			var premium_t = quote.life.details.primary.insurance.type;
			var term =		quote.life.details.primary.insurance.term ? quote.life.details.primary.insurance.termentry : false;
			var tpd =		quote.life.details.primary.insurance.tpd ? quote.life.details.primary.insurance.tpdentry : false;
			var trauma =	quote.life.details.primary.insurance.trauma ? quote.life.details.primary.insurance.traumaentry : false;

			switch(premium_f) {
				case "A":
					premium_f = "Annual";
					break;
				case "H":
					premium_f = "Half Yearly";
					break;
				default:
					premium_f = "Monthly"
			}

			switch(premium_t) {
				case "L":
					premium_t = "Level";
					break;
				default:
					premium_t = "Stepped"
			}

			quote.life.content = {
				situation:	age + " year old " + gender + ", " + smoker,
				term: 		term,
				tpd:		tpd,
				trauma:		trauma,
				premium:	premium_f + " (" + premium_t + ")"
			}

			var newRow = $(parseTemplate(templateHtml, quote.life));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				$("#search-quote-list").append(newRow);

				if( !quote.life.content.term ) {
					$("#life_quote_" + quote.life.id).find(".term").first().hide();
				}

				if( !quote.life.content.tpd ) {
					$("#life_quote_" + quote.life.id).find(".tpd").first().hide();
				}

				if( !quote.life.content.trauma ) {
					$("#life_quote_" + quote.life.id).find(".trauma").first().hide();
				}

				return true;
			}

			return false;
		} catch(e) { return false; }
	},

	_drawIPQuote: function(quote, templateHtml) {
		try {
			quote.ip.available = !Number(quote.ip.editable) ? 'no' : 'yes';

			var age =		quote.ip.details.primary.age;
			var smoker =	quote.ip.details.primary.smoker == "N" ? "non-smoker" : "smoker";
			var gender =	quote.ip.details.primary.gender == "M" ? "male" : "female";
			var premium_f = quote.ip.details.primary.insurance.frequency;
			var premium_t = quote.ip.details.primary.insurance.type;
			var income =	quote.ip.details.primary.insurance.incomeentry;
			var amount =	quote.ip.details.primary.insurance.amountentry;

			switch(premium_f) {
				case "A":
					premium_f = "Annual";
					break;
				case "H":
					premium_f = "Half Yearly";
					break;
				default:
					premium_f = "Monthly"
			}

			switch(premium_t) {
				case "L":
					premium_t = "Level";
					break;
				default:
					premium_t = "Stepped"
			}

			quote.ip.content = {
				situation:	age + " year old " + gender + ", " + smoker,
				income: 	income,
				amount:		amount,
				premium:	premium_f + " (" + premium_t + ")"
			}

			var newRow = $(parseTemplate(templateHtml, quote.ip));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				$("#search-quote-list").append(newRow);
				return true;
			}

			return false;
		} catch(e) { return false; }
	},

	error: function(message){
		$("#retrieve-quote-error-message").empty().append("<p>" + message + "</p>");
		Popup.show("#retrieve-quote-error", "#loading-overlay");
	},

	highlightTerms: function( element ) {
		if( SearchQuotes._search_terms.length )	{
			var terms = SearchQuotes._search_terms.split(" ");
			for(var i = 0; i < terms.length; i++) {
				var t = $.trim(String(terms[i]));
				if( t.length ) {
					element.highlight(terms[i], "highlight");
				}
			}
		}
	},

	_initRowButtons: function(){

		$(".quote-amend").find("a").each(function(){
			$(this).on("click", function() {
				$quoteRow = $(this).closest(".quote-row");
				var pieces = $quoteRow.attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				var available = pieces[3];
				if (available == 'yes') {
					SearchQuotes.retrieveQuote(vert, "amend", id, null, $quoteRow.attr("data-brandId"));
				}
			});
		});

		$(".quote-moreinfo").find("a").each(function(){
			$(this).on("click", function() {
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				SearchQuotes.getMoreInfo(id);
			});
		});

		$(".quote-comments").find("a").each(function(){
			$(this).on("click", function() {
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				QuoteComments.show(id);
			});
		});
	},

	retrieveQuote: function(vertical, action, id, newDate, brandId) {

		var dat = {
			simples:'true', 
			vertical:vertical, 
			action:action, 
			id:id,
			brandId:brandId
		};
		if (newDate) {
			dat.newDate = newDate;
			//omnitureReporting(23);
		} else {
			//omnitureReporting(22);
		}

		$('#search-quotes-dialog').dialog("close");
		// Alternate idea, we only pass transaction id and call the database to get the brand and vertical.
		loadSafe.loader( $('#main'), 2000, "simples/loadQuote.jsp?brandId="+brandId+"&verticalCode="+vertical+"&transactionId="+id+"&action="+action);
		/*
		$.ajax({
			url: "ajax/json/load_quote.jsp",
			data: dat,
			dataType: "json",
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(json){
				Loading.hide();
				if (json && json.result.destUrl) {
					$('#search-quotes-dialog').dialog("close");
					var URL = json.result.destUrl;
					loadSafe.loader( $('#main'), 2000, URL);
				} else {
					if (json.result.error) {
						if (json.result.error == "login") {
							SearchQuotes.forceLogin();
						} else {
							SearchQuotes.error(json.result.error);
						}
					}
					else {
						SearchQuotes.error("A problem occurred when trying to load the quote. Please try again later.");
					}
				}
				return false;
			},
			error: function(obj,txt){
				Loading.hide();
				SearchQuotes.error("A problem occurred when trying to communicate with our network.");
			},
			timeout:30000
		});
		*/
	},

	forceLogin: function() {
		document.location.href = "simples.jsp?r=" + Math.floor(Math.random()*10001);
	}
};
</go:script>
<go:script marker="onready">
SearchQuotes.init();

jQuery.fn.highlight = function (str, className) {
	var regex = new RegExp(str, "gi");

	return this.each(function () {
		jQuery(this).html(
			jQuery(this).html().replace(regex, function(matched) {return "<span class='" + className + "'>" + matched + "</span>";})
		)
	});
};
</go:script>