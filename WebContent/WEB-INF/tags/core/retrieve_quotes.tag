<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Header for retrieve_quotes.jsp"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="email" required="false" rtexprvalue="true" description="Email Address"%>
<%@ attribute name="password" required="false" rtexprvalue="true" description="Password"%>





<core:popup id="retrieve-error" title="Retrieve Quotes Error">
	<p>Unfortunately we were unable to retrieve your insurance quotes.</p>
	<p id="retrieve-error-message"></p>
	<p>Click the button below to return to the "Retrieve Your Insurance Quotes" page and try again.</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn return-to-login"><span>Ok</span></a>
	</div>
</core:popup>
 
<core:reset-password
	returnTo="Retrieve Your Insurance Quotes"
	resetButtonId="reset-button"
	emailFieldId="login_forgotten_email"
	emailFormId="retrieveQuoteForm"
	successCallback="Retrieve.showPanel('login');"
	popup="true"
	onceResetInstructions="Once your password has been reset, follow the process to return to the \"Retrieve Your Insurance Quotes\" page and log in using your new password, to gain access to your previous quotes."
	failedResetInstructions="Click the button below to return to the \"reset your password\" page and try again."
/>

<core:popup id="new-date" title="Enter New Commencement Date">
	<p>The quote you selected has a commencement date in the past.</p>
	<p>Please enter a new commencement date and click the button below to view the latest prices for this quote.</p>

	<form:row label="Commencement Date">
		<field:commencement_date xpath="newDate" required="false" />
	</form:row>

	<div class="popup-buttons">
		<a href="javascript:void(0);" id="new-date-button"></a>
	</div>
</core:popup>

 <%-- JAVASCRIPT --%>
<go:script marker="onready">

	//Capture and do nothing on the keypress if the retrieve error modal is displayed
	//This is an error with IE. as Chrome and FF not affected
	//AGG-1366


	$(document).keypress(function(e) {
			//Close the modal as it's visible and user pressed enter
		if (e.which === 13) {
			if($('#retrieve-error').css('display') == 'block'){
			$(".return-to-login").click();
			}else{
				$("#login-button").click();
		}
		}
	});


	// User clicked "login" 
	$("#login-button").click(function(){
		if ($("#retrieveQuoteForm").validate().form()) {		
			Retrieve.loadQuotes({email: $("#login_email").val(), password:  $("#login_password").val()});
		
		}
		
	});


	// User clicked the "forgotten password" link
	$("#login-forgotten").click(function(){
		$("#login_forgotten_email").val($("#login_email").val());
		Retrieve.showPanel("forgotten-password");
	});
	
	$('#retrieve-error').on('click', '#js-too-many-attempts', function() {
		$("#login-forgotten").click();
		Popup.hide("#retrieve-error");
	});

	// User clicked the prev button, when doing forgotten password..
	$("#go-back-button").click(function(){
		Retrieve.showPanel("login");
	});	

	$(".return-to-login").click(function(){
		$("#login_password").val("");
		Popup.hide("#retrieve-error");
		$("#login_password").focus();

	});	

	$("#new-date-button").click(function(){
		if ($("#newDate").val() != '') {
			Retrieve.retrieveQuote(Retrieve._activeVert, "latest", Retrieve._activeId, null , $("#newDate").val());
		};
		Popup.hide("#new-date");
	});
	
	
	<%-- if email & pwd supplied, jump to quote list
		 if just email supplied, pre-populate email field --%>
		 

	<%-- AGG-1391 adding go:jsEscape for XSS issues on email --%>

	<c:choose>
		<c:when test="${not empty email && not empty password}">
			Retrieve.loadQuotes({email: '${go:jsEscape(email)}', password:  '${go:jsEscape(password)}'});
		</c:when>
		<c:when test="${not empty email}">
			$("#login_email").val('${go:jsEscape(email)}');
			Retrieve.showPanel("login");
		</c:when>
	</c:choose>
	
</go:script>


<go:script marker="js-head">
	
	var Retrieve = new Object();			
	
	// RETRIEVE OBJECT
	Retrieve = {
		_currentPanel : "",
		_origZ : 0,
		verticals : ["quote", "health", "ip", "life", "home", "utilities"],
		
		showPanel : function(panel){
			
			//check that the panel does not exist in the URL (and change)
			if(panel != $.address.parameter('panel')) {
				$.address.parameter("panel", panel, false);
				//return;
			};
			
			//check that the panel does not match the current one
			if(panel == Retrieve._currentPanel) {
				return;
			};
			
			//PROGRESS: with the show code
			
			$("#retrieveQuoteForm").find(":input").attr("disabled", "disabled");
					
			$("#"+panel).find(":input").removeAttr("disabled");
							
			switch(panel){
				case "login" : 
					$("#login_email").focus();
					$(".side-image").show();
					$(".side-image-results").hide();
					break;
				case "forgotten-password":
					$("#login_forgotten_email").focus();
					$(".side-image").show();
					$(".side-image-results").hide();
					break;
				default:
					$(".side-image").hide();
					$(".side-image-results").show();
			}
			
			// If we're viewing a different panel, fade effect between them
			if (this._currentPanel != "") {
				$("#"+this._currentPanel).fadeOut(300).queue("fx",function(next){
					$("#"+panel).fadeIn(300);	
					next();
				});
				
			} else {
				$("#"+panel).show();
			}
			
			this._currentPanel = panel;
			
		},
		loadQuotes : function(dat){
			Loading.show("Retrieving Your Quotes...", function() {	
				$.ajax({
					url: "ajax/json/retrieve_quotes.jsp",
					data: dat,
					type: "POST",
					async: true,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(jsonResult){
						Loading.hide(function(){
							Retrieve.handleJSONResults(jsonResult);
						});
						return false;
					},
					dataType: "json",
					error: function(obj,txt){
						Loading.hide(function(){
						Retrieve.error("A problem occurred when trying to communicate with our network.");
						});
					},
					timeout:30000
				});		
			
			});			
		},
		handleJSONResults : function(jsonResult) {
			// Check if error occurred
			if (!jsonResult || typeof(jsonResult.error) != 'undefined' || (typeof(jsonResult[0]) != 'undefined' && typeof(jsonResult[0].error) != 'undefined')) {
				var message = 'The email address or password that you entered was incorrect.';
				if(typeof jsonResult.error == 'string')
					message = jsonResult.error;
				else if(typeof jsonResult[0] != 'undefined' && typeof jsonResult[0].error == 'string') {
					if(jsonResult[0].error == 'exceeded-attempts') {
						message = "Your account has been suspended for 30 minutes or until you <a id='js-too-many-attempts' href='javascript:;'><strong>reset your password</strong></a>.";
					} else {
						message = jsonResult[0].error;
					}
				}
				Retrieve.error(message);

			} else if (typeof(jsonResult.previousQuotes) == 'undefined') {
				Retrieve.error("Sorry, you have no saved quotes to display.");
			} else {
				try {
					Retrieve.showQuotes(jsonResult.previousQuotes.result);
				} catch(e) {
					Retrieve.error("Sorry, you have no saved quotes to display. " + e);
				}
			}
		},
		_getDateTimeValue : function(data) {
			var timeString = 0;
			var dateString = 0;
			var date = '';
			var time = '';

			for (var i = 0; i < Retrieve.verticals.length; i++) {
				var vertical = Retrieve.verticals[i];
				if(data.hasOwnProperty(vertical)) {
					date = data[vertical].quoteDate;
					time = data[vertical].quoteTime;
				}
			}

			if ($.trim(date) != '') {
				date = date.split('/');
				dateString =  (date[2] + date[1] + date[0]) * 10000;
			}
			if ($.trim(time) != '') {
				var timeSplit = $.trim(time).split(' ');
				timeString =  ((timeSplit[0].replace(/:/g, ''))*1);
				if (timeSplit[1] == 'PM' && timeSplit[0].substring(0, 2) !== '12') {
					timeString += 1200;
				}
			}
			return dateString + timeString;
		},
		_compareDateTime : function(a, b) {
			var dateValueA = Retrieve._getDateTimeValue(a);
			var dateValueB = Retrieve._getDateTimeValue(b);
			return ((dateValueA < dateValueB) ? 1 : ((dateValueA > dateValueB) ? -1 : 0));
		},
		showQuotes : function(quotes) {
			if(quotes.sort) {
				quotes.sort(Retrieve._compareDateTime);
			}
			var templates = {
				<%-- AGG-818: modify to #car_quote --%>
				quote:	$("#quote_quote").html(),
				health:	$("#health_quote").html(),
				ip:		$("#ip_quote").html(),
				life:	$("#life_quote").html(),
				home:	$("#home_contents_quote").html(),
				utilities: $("#utilities_quote").html()
			};
			$("#quote-list").html("");
			var quoteCount = 0;					
			if (typeof(quotes)=='object' && !isNaN(quotes.length)) {
				$.each(quotes, function() {		
					if (quoteCount < 20) {
						if( Retrieve._drawQuote(this,templates) ) {
							quoteCount++;
						}
					}
				});
			} else if (typeof(quotes)=='object' && isNaN(quotes.length)) {
				if (Retrieve._drawQuote(quotes,templates)) {
					quoteCount = 1;
				}
			}
			
			this._quotes=quotes;
			
			if (quoteCount > 0){
				if( quoteCount == 1 ) {
					$("#quotesTitle").text("Your Insurance Quote");
				} else {
					$("#quotesTitle").text("Your Previous "+quoteCount + " Insurance Quotes");
				}
				$("#quote-list-empty").hide();
				$(".quote-details span").each(function(){
					if($(this).find('.no-title-case').length == 0 && !$(this).hasClass('no-title-case')) {
						$(this).toTitleCase();
					}
				});
				$(".quote-row:first-child").addClass("first-row");
				this._initRowButtons();
				
				$(".quote-row").each(function(){ <%-- AGG-1735 Remove get latest button for any quote before 13/03/2014 --%>
					var optinDate = new Date(2014, 03, 13);
					var quoteDate = $(this).find(".quote-date").text();
					var dateParts = [];
					if (quoteDate){
						dateParts = quoteDate.split("/");
						quoteDate = new Date(dateParts[2], dateParts[1], dateParts[0]);
						if (quoteDate.getTime() < optinDate.getTime()) {
							$(this).find('.quote-latest').remove();
						}
					}
				});

				$("#quote-list").show();
				
				if ($.browser.msie ) {
				}
				else {
					var delay = 400;
					$(".quote-row").each(function(){
						$(this).hide().delay(delay).slideDown(200);
						delay+=100;
					});
				}
			} else {
				$("#quote-list-empty").show();
			}
			this.showPanel("quotes");
		},
		_drawQuote : function(quote, templates) {
			if( quote.hasOwnProperty("health") ){
				return this._drawHealthQuote(quote, templates.health);
			} else if( quote.hasOwnProperty("life") ){
				return this._drawLifeQuote(quote, templates.life);
			} else if( quote.hasOwnProperty("ip") ) {
				return this._drawIPQuote(quote, templates.ip);
				<%-- AGG-818: modify to car (but check) --%>
			} else if( quote.hasOwnProperty("quote") ) {
				return this._drawCarQuote(quote, templates.quote);
			} else if( quote.hasOwnProperty("home") ){
				return this._drawHomeQuote(quote, templates.home);
			} else if( quote.hasOwnProperty("utilities") ) {
				return this._drawUtilitiesQuote(quote, templates.utilities);
			} else {
				return false;
			}
		},
		_drawCarQuote : function(quote, templateHtml){
			quote = quote.quote;

			quote = $.extend(true,
				{
					drivers: {
						regular: { age: '', gender: '', name: '', ncd: '' },
						young: { age: '', gender: '', exists: '' }
					},
					vehicle: {
						year: '', makeDes: '', modelDes: ''
					}
				},
				quote
			);

			// Abort
			if(typeof quote.drivers === 'undefined' || typeof quote.vehicle === 'undefined') {
				return false;
			}

			if (typeof quote.drivers !== 'undefined') {
				if(quote.fromDisc === false) {
					quote.drivers.regular.name = "";
					if(quote.drivers.regular.hasOwnProperty('firstname')) {
						quote.drivers.regular.name = quote.drivers.regular.firstname;
					}
					if(quote.drivers.regular.hasOwnProperty('surname')) {
						quote.drivers.regular.name +=  " " + quote.drivers.regular.surname;
					}
					quote.drivers.regular.gender = quote.drivers.regular.gender == "M" ? "male" : "female";
					if(!quote.drivers.regular.age && quote.drivers.regular.dob){
						quote.drivers.regular.age = this.returnAge(quote.drivers.regular.dob);
					}
					if (quote.drivers.young.exists == 'Y') {
						quote.drivers.young.gender = quote.drivers.young.gender == "M" ? "male" : "female";
						if(!quote.drivers.young.age && quote.drivers.young.dob ){
							quote.drivers.young.age = this.returnAge(quote.drivers.young.dob);
						}
					}
					switch(quote.drivers.regular.ncd) {
						case 5:
							quote.drivers.regular.ncd = "5 Years (Rating 1)";
							break;
						case 4:
							quote.drivers.regular.ncd = "4 Years (Rating 2)";
							break;
						case 3:
							quote.drivers.regular.ncd = "3 Years (Rating 3)";
							break;
						case 2:
							quote.drivers.regular.ncd = "2 Years (Rating 4)";
							break;
						case 1:
							quote.drivers.regular.ncd = "1 Years (Rating 5)";
							break;
						default:
							quote.drivers.regular.ncd = "None (Rating 6)";
							break;
					}
					if ($.trim(quote.drivers.regular.name) != ''){
						quote.drivers.regular.name = $.trim(quote.drivers.regular.name) + " - ";
					}
				}
			}

			var newRow = $(parseTemplate(templateHtml, quote));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				if ((quote.youngDriver && quote.youngDriver.age != '') || (quote.drivers && quote.drivers.young && quote.drivers.young.exists == 'Y')
					|| (quote.drivers && quote.drivers.young.age && quote.drivers.young.age != quote.drivers.regular.age && quote.drivers.young.gender != quote.drivers.regular.gender)) {
					$(newRow).find(".regDriverYoungest").hide();
				} else {
					$(newRow).find(".youngDriver").hide();
				}
				
				$("#quote-list").append(newRow);
				return true;
			}
			return false;
		},
		
		_drawHealthQuote : function(quote, templateHtml){

			if(quote.health.hasOwnProperty('healthCover')) {
				var hasDependents = quote.health.healthCover.hasOwnProperty('dependants') && quote.health.healthCover.dependants != '';
				quote.health.healthCover.dependants = hasDependents ? Number(quote.health.healthCover.dependants) : 0;
				quote.health.healthCover.income = quote.health.healthCover.incomelabel;
			} else {
				quote.health.healthCover = {"dependants" : "", "income" : ""};
			}
			
			if(!quote.health.hasOwnProperty('situation')) {
				quote.health.situation = {"healthCvr" : "", "healthSitu" : ""};
			}

			if(quote.health.hasOwnProperty('benefits')) {
			quote.health.benefits.list = []; 

				for(var i in quote.health.benefits.benefitsExtras) {
					if( quote.health.benefits.benefitsExtras[i] == "Y" ) {
					quote.health.benefits.list.push(i);
				}
			}			
			quote.health.benefits.list = quote.health.benefits.list.join(", ");
			} else {
				quote.health.benefits = {"list" : "" };
			}
			var newRow = $(parseTemplate(templateHtml, quote.health));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				if (quote.health.healthCover.dependants == "") {
					$(newRow).find(".dependants").hide();
				}
				if (quote.health.healthCover.income == "") {
					$(newRow).find(".income").hide();
				}
				$("#quote-list").append(newRow);
				return true;
			}
			return false;
		},
		
		_drawLifeQuote : function(quote, templateHtml) {

			var newRow = $(parseTemplate(templateHtml, quote.life));
			var t = $(newRow).text();
			var availableRows = 5;

			if (t.indexOf("ERROR") == -1) {
				$("#quote-list").append(newRow);
				
				$.each(quote.life.content, function(key, value) {
					if( !value || value == "," || value == "()" ) {
						$("#life_quote_" + quote.life.id).find("." + key).first().hide();
						availableRows--;
				}
				});
				
				if (availableRows < 1){
					$("#life_quote_" + quote.life.id).remove();
					return false;
				}
				
				return true;
			}
			
			return false;
		},
		
		_drawIPQuote : function(quote, templateHtml){
			var newRow = $(parseTemplate(templateHtml, quote.ip));
			var t = $(newRow).text();
			var availableRows = 4;

			if (t.indexOf("ERROR") == -1) {
				$("#quote-list").append(newRow);
				
				$.each(quote.ip.content, function(key, value) {
					if( !value || value == "," || value == "()" ) {
						$("#ip_quote_" + quote.ip.id).find("." + key).first().hide();
						availableRows--;
					}
				});

				if (availableRows < 1){
					$("#ip_quote_" + quote.ip.id).remove();
					return false;
				}

				return true;
			}
			
			return false;
		},

		_drawUtilitiesQuote : function(quote, templateHtml) {
			if(typeof quote.utilities == 'undefined' || typeof quote.utilities.householdDetails == 'undefined' || typeof quote.utilities.estimateDetails == 'undefined') {
				return false;
			}

			// Get the word representation of a given period
			var getUtilitiesPeriod = function(period) {
				switch(period) {
					case "M":
						return "Mth";
						break;
					case 2:
						return "2 Mths";
						break;
					case "Q":
						return "Qtr";
						break;
					case "Y":
					default:
						return "Yr";
						break;
				}
			};

			// Return formatted spend text
			var getEstimateSpendText = function(amountEntry, period) {
				var periodText = getUtilitiesPeriod(period);
				return amountEntry + " Per " + periodText;
			};

			// Return formatted usage text
			var getFormattedPeakText = function(productType, measurement) {
				var usage = quote.utilities.estimateDetails.usage[productType];
				var text;

				if(typeof usage.offpeak != 'undefined' && usage.offpeak.amount > 0) {
				var offPeakAmount = usage.offpeak.amount;

					// Check if Peak and OffPeak have same usage duration
					if(usage.peak.period != usage.offpeak.period) {
						// Get offpeak period as yearly amount
						switch(usage.offpeak.period) {
							case "M":
								offPeakAmount = offPeakAmount * 12;
								break;
							case 2:
								offPeakAmount = offPeakAmount * 6;
								break;
							case "Q":
								offPeakAmount = offPeakAmount * 4;
								break;
							case "Y":
							default:
								break;
						}

						// Convert offpeak value to same as peak
						switch(usage.peak.period) {
							case "M":
								offPeakAmount = offPeakAmount / 12;
								break;
							case 2:
								offPeakAmount = offPeakAmount / 6;
								break;
							case "Q":
								offPeakAmount = offPeakAmount / 4;
								break;
							case "Y":
							default:
								break;
						}
					}

					var totalUsageRounded = Math.round(usage.peak.amount + offPeakAmount);
					// Replace calculated total usage with comma separated 1000s
					var totalUsageAmount = (totalUsageRounded).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					text = getEstimateSpendText(totalUsageAmount +  "<span class='no-title-case'>" + measurement + "</span>", usage.peak.period)
				} else {
					text = getEstimateSpendText(usage.peak.amountentry + "<span class='no-title-case'>" + measurement + "</span>", usage.peak.period);
				}

				return text;
			};

			// Return household usage text
			var getFormattedHouseholdUsageText = function(people, bedrooms, propertyType) {
				if(!people) {
					people = quote.utilities.estimateDetails.household.people;
				}

				if(people >= 4) {
					people = "4+";
				}

				if(!bedrooms) {
					bedrooms = quote.utilities.estimateDetails.household.bedrooms;
				}

				if(!propertyType) {
					propertyType = quote.utilities.estimateDetails.household.propertyType;
				}

				switch(propertyType) {
					case "H":
						propertyType = "house";
						break;
					case "U":
						propertyType = "unit";
						break;
				}

				var peopleText = (people == 1) ? " person, " : " people, ";
				return people + peopleText + bedrooms + " bedroom " + propertyType;
			};

			var whatToCompare = quote.utilities.householdDetails.whatToCompare || false,
				howToEstimate = quote.utilities.householdDetails.howToEstimate || false;

			// Depending on what we are comparing... (Electricity, Gas or Both)
			if(whatToCompare == "E") {
				quote.utilities.estimateDetails.estimateType = "Electricity";

				// Change text for "estimated using" depending on scenario
				if(howToEstimate == "S") {
					var spendDetails = quote.utilities.estimateDetails.spend.electricity;
					quote.utilities.estimateDetails.howEstimated = getEstimateSpendText(spendDetails.amountentry, spendDetails.period);
				} else if(howToEstimate == "H") {
					quote.utilities.estimateDetails.howEstimated = getFormattedHouseholdUsageText();
				} else if(howToEstimate == "U") {
					quote.utilities.estimateDetails.howEstimated = getFormattedPeakText("electricity", "kWh");
				} else {
					return false;
				}
			} else if(whatToCompare == "G") {
				quote.utilities.estimateDetails.estimateType = "Gas";

				if(quote.utilities.householdDetails.howToEstimate == "S") {
					var spendDetails = quote.utilities.estimateDetails.spend.gas;
					quote.utilities.estimateDetails.howEstimated = getEstimateSpendText(spendDetails.amountentry, spendDetails.period);
				} else if(howToEstimate == "H") {
					quote.utilities.estimateDetails.howEstimated = getFormattedHouseholdUsageText();
				} else if(howToEstimate == "U") {
					quote.utilities.estimateDetails.howEstimated = getFormattedPeakText("gas", "MJ");
				} else {
					return false;
				}
			} else if(whatToCompare == "EG") {
				quote.utilities.estimateDetails.estimateType = "Electricity and Gas";

				if(quote.utilities.householdDetails.howToEstimate == "S") {
					var spendDetails = quote.utilities.estimateDetails.spend;
					quote.utilities.estimateDetails.howEstimated = "Electricity " + getEstimateSpendText(spendDetails.electricity.amountentry, spendDetails.electricity.period) + ", ";
					quote.utilities.estimateDetails.howEstimated += "Gas " + getEstimateSpendText(spendDetails.gas.amountentry, spendDetails.gas.period);
				} else if(howToEstimate == "H") {
					quote.utilities.estimateDetails.howEstimated = getFormattedHouseholdUsageText();
				} else if(howToEstimate == "U") {
					quote.utilities.estimateDetails.howEstimated = "Electricity " + getFormattedPeakText("electricity", "kWh");
					quote.utilities.estimateDetails.howEstimated += ", Gas " + getFormattedPeakText("gas", "MJ");
				} else {
					return false;
				}
			} else {
				return false;
			}

			// Set postcode to either "1234, Suburb" or "1234" if the suburb is not sent through
			if(typeof quote.utilities.householdDetails.suburb != 'undefined') {
				quote.utilities.estimateDetails.estimateLocation = quote.utilities.householdDetails.postcode + ", " + quote.utilities.householdDetails.suburb;
			} else {
				quote.utilities.estimateDetails.estimateLocation = quote.utilities.householdDetails.postcode;
			}

			var newRow = $(parseTemplate(templateHtml, quote.utilities));
			var t = $(newRow).text();

			if (t.indexOf("ERROR") == -1) {
				var estimateDetails = quote.utilities.estimateDetails;

				var isPostcodeUndefined = (estimateDetails.estimateLocation.toString().toLowerCase().indexOf("undefined") > -1);
				var isHowEstimatedUndefined = (estimateDetails.howEstimated.toString().toLowerCase().indexOf("undefined") > -1);

				if(isPostcodeUndefined || isHowEstimatedUndefined) {
					return false;
				}

				$("#quote-list").append(newRow);
				return true;
			}

			return false;
		},

		_drawHomeQuote : function(quote, templateHtml){
			var newRow = $(parseTemplate(templateHtml, quote.home));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				$("#quote-list").append(newRow);

				// We need to hide if the Home or Contents node doesn't exist
				if (typeof quote.home.coverAmounts != 'undefined' && quote.home.coverAmounts.rebuildCostentry == null){
					var contentsElement = '#home-contents_quote_'+quote.home.id+' .homeValue';
					var titleElement = '#home_quote_'+quote.home.id+' .title';
					$(contentsElement).hide();
					$(titleElement).html('Home Insurance Quote');
				}
				if (typeof quote.home.coverAmounts != 'undefined' && quote.home.coverAmounts.replaceContentsCostentry == null){
					var contentsElement = '#home_quote_'+quote.home.id+' span.contentsValue';
					var titleElement = '#home_quote_'+quote.home.id+' .title';
					$(contentsElement).hide();
					$(titleElement).html('Contents Insurance Quote');
				}
				return true;
			}

			return false;
		},
		error : function(message){
			$("#retrieve-error-message").html(message);
			Popup.show("#retrieve-error");
		},

		_initRowButtons : function(){			
			$(".quote-amend a").click(function(){
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				if(pieces.length > 3) {
					var fromDisc =	pieces[3];
				}
				vert = vert.replace("-","_"); // For any verticals which have 2+ words
				Retrieve.retrieveQuote(vert, "amend", id , fromDisc);
			});
			
			$(".quote-start-again a").click(function(){
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				Retrieve.retrieveQuote(vert, "start-again", id , null);
			});

			$(".quote-pending a").click(function(){
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				var pendingid = $(this).closest(".quote-row").attr("data-pendingid");
				Retrieve.viewPending(vert, id, pendingid);
			});

			$(".quote-latest a").click(function(){
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];

				if(pieces.length > 3) {
					var fromDisc =	pieces[3];
				}
				vert = vert.replace("-","_"); // For any verticals which have 2+ words
	
				var q = Retrieve.getQuote(id, vert);
				if (q && q.hasOwnProperty("inPast") && q.inPast && q.inPast == "Y"){
					Retrieve._activeId = id;
					Retrieve._activeVert = vert;
					//$("#new-date").val("");
					Popup.show("#new-date");
				} else {
					Retrieve.retrieveQuote(vert, "latest", id , fromDisc);
				}
			});			
		},

		retrieveQuote : function(vertical, action, id, fromDisc, newDate){
			var dat = {'vertical': vertical, 'action': action, 'transactionId': id };
			
			if(vertical == 'car') {
				dat.fromDisc = fromDisc;
			}
			if (newDate) {
				dat.newDate = newDate;
				//omnitureReporting(23);
			} else {
				//omnitureReporting(22);
			}
			
			Loading.show("Loading Your Quote: " + id + "...", function() {
				
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
					
						Loading.hide(function(){
							if (json && json.result.destUrl) {
								window.location.href = json.result.destUrl + '&ts=' + Number(new Date());
							} else {
								if (json && json.result && json.result.showToUser && json.result.error) {
									Retrieve.error(json.result.error);
								}
								else {
									Retrieve.error("A problem occurred when trying to load your quote.");
								}
							}
						});
						return false;
					
					},					
					error: function(obj,txt){
						Loading.hide(function(){
						Retrieve.error("A problem occurred when trying to communicate with our network.");
						});
					},
					timeout:30000
				});	
			});
		},

		<%-- GET A QUOTE --%>
		getQuote: function(id, vertical) {
			if(typeof this._quotes !== 'undefined' && typeof this._quotes.length === 'undefined') {
				return this._quotes.quote;
			}
			var i =0;
			while (i < this._quotes.length) {
				if (this._quotes[i].id == id ){
					if (vertical == 'home') {
						return this._quotes[i].home;
					} else {
					return this._quotes[i].quote;
				}
				}
				i++;
			}
			return false;
		},
		
		viewPending: function(vert, id, pendingid) {
			if (!pendingid || pendingid.length == 0) {
				alert('This quote is being processed. Please call us if you have any questions.');
				return false;
			}
			var url = './' + vert + '_quote.jsp?action=confirmation&PendingID=' + escape(pendingid);
			window.location.href = url;
		},

		returnDate : function(_dobString) {
			return new Date(_dobString.substring(6,10), _dobString.substring(3,5) - 1, _dobString.substring(0,2));
		},

		returnAge : function(_dobString) {
			var _now = new Date;
				_now.setHours(00,00,00);
			var _dob = this.returnDate(_dobString);
			var _years = _now.getFullYear() - _dob.getFullYear();

			if(_years < 1){
				return (_now - _dob) / (1000 * 60 * 60 * 24 * 365);
			};

			<%-- leap year offset --%>
			var _leapYears = _years - ( _now.getFullYear() % 4);
			_leapYears = (_leapYears - ( _leapYears % 4 )) /4;
			var _offset1 = ((_leapYears * 366) + ((_years - _leapYears) * 365)) / _years;

			<%-- birthday offset - as it's always so close --%>
			if(  (_dob.getMonth() == _now.getMonth()) && (_dob.getDate() > _now.getDate()) ){
				var _offset2 = -.005;
			} else {
				var _offset2 = +.005;
			};

			var _age = (_now - _dob) / (1000 * 60 * 60 * 24 * _offset1) + _offset2;
			return Math.floor(_age);
	}
	}

</go:script>


<%-- CSS --%>
<go:style marker="css-head">

	.panel {
		display:none;
	}

	#wrapper {
		background-color:white;
	}
	.retrieve #page {
		min-height:300px;
	}
	body {
		overflow:auto;
	}
	#headerShadow {
		background:url('common/images/results-shadow.png') repeat-x top left;
		height: 20px;
		position: relative;
		top: -7px;
	}
	#navigation {
		display:none;
	}
	#quotes {
		width:650px;
	}
	#quotes h3 {
		margin:0px 0px 20px 28px;
		font-weight:bold; 
		font-size:18px;
	}
	
	.full-width .header .login{
		margin-left:50px;
	}
	.full-width .header{
	    background-image: url("brand/ctm/images/main_bg_top.png");
	    background-position: left top;
	    background-repeat: no-repeat;
	    color: #0C4DA2;
	    font-family: "SunLT Bold","Open Sans",Helvetica,Arial,sans-serif;
	    font-size: 16px;
	    font-weight: bold;
	    height: 20px;
	    padding: 10px 0 4px 14px;
	    position: relative;
  	}

	.full-width .header div {
		display:inline-block;
		zoom:1;
		*display:inline;
	}
	.full-width .header .quote-date-time{
		margin-left:10px;
		width:90px;
	}
	.full-width .header .quote-details{
		margin-left:0px;
		width:230px;
	}
	.full-width .header .quote-options{
		margin-left:130px;
	}
	.full-width .content {
		background-image: url("brand/ctm/images/main_bg_nc.png");
		background-repeat: repeat-y;
		background-position: left top;
		padding: 10px 10px;
		font-size: 12px;
	}

	.full-width .footer {
		background-image: url(brand/ctm/images/main_bg_nc_bottom.png);
		background-repeat: no-repeat;
		height: 19px;
	}

	#login, #forgotten-password {
			padding-top: 6px;
	}
	.start-new {
		float: right;
		width:128px;
	}
	.start-new:hover {

	}
	#start-new-top {
		position: absolute;
		top: 15px;
		left: 755px;
	}
	#start-new-bottom {
		margin:10px 10px;
		display:none;
	}
	#login_email {
		width:200px;
	}
	#login_password {
		width:100px;
	}
	#login_forgotten {
		margin-left:160px;
		margin-top:10px;
	}

	#forgotten-password-buttons {
		margin:20px 8px 10px 40px;
	}
		
	div.first-row {
		border-top-width:0px;
	}
	
	.quote-row {
		border-top: 1px solid #DDDDDD;
		padding: 5px 0px;
		width:618px;
	}
	.quote-row div {
		display:inline-block;
		zoom:1;
		*display:inline;
	}
	.quote-options {
		width: 130px;
		vertical-align: top;
	}
	.quote-buttons {
		width:128px;
		height:50px;
	}
	
	.quote-amend {
		width:100px;
	}
	.quote-row .quote-date-time {
		width: 99px;
	}
	.quote-row .quote-date,
		.quote-row .quote-time {
		vertical-align:top;
		margin-top:2px;
		text-align:center;
	} 
	.quote-row .quote-date {
		font-size:14px;
	}
	.quote-row div.quote-amend, .quote-row div.quote-start-again, .quote-row div.quote-pending {
		vertical-align:top;
		margin-top:8px;
	}

	.quote-row .quote-pending {
		display: none;
	}
	.quote-row.editableF .quote-amend, .quote-row.editableF .quote-start-again {
		display: none;
	}
	.quote-row.editableF .quote-pending {
		display: block;
	}

	.quote-row .quote-details {
		vertical-align:top;
		margin-top:1px;
		width:330px;
	}
	.quote-row .quote-details span{
		display:block;
		color:#555555;
		line-height:14px;
		font-size:11px;
	}
	span.label{
		width:112px;
		display:inline-block;
		zoom:1;
		*display:inline;
	}
	.quote-date {
		margin-left:33px;
		font-weight:bold;
		display:block;
	}
	.quote-time {
		margin-left:33px;
		font-weight:bold;
		display:block;
	}
	
	.quote-details {
		margin-left:35px;
		width:400px;
	}
	.fieldrow_label {
		width:150px;
	}

	.fieldrow_value {
		width: 400px;
	}
	.quote-row .quote-hidden {
		display:none;
	}
	
	.quote-row .quote-details span.vehicle,
	.quote-row .quote-details span.title {
		font-size:14px;
		font-weight:bold;
		color:black;
		line-height:16px;
	}
	
	.quote-details .driver{
		display:block;
		margin-top:3px;
		font-weight:normal;
	}

	.quote-details .quote-estimated-using span {
		display: inline;
	}

	div#retrieveQuoteErrors div#errorContainer {
		top: 20px;
		right: 0px;
	}
	
	#new-date-button {
		background: transparent url("common/images/dialog/ok.gif") no-repeat;
		width:51px;
		height:36px;
		margin-left:190px;
		margin-top: 10px;
		display:inline-block;
	}
	#new-date-button:hover {
		background: transparent url("common/images/dialog/ok-on.gif") no-repeat;
	}
		#retrieve-error p, 
		#new-date p{
		font-size:13px;
		margin:15px 0px;
	}
		#retrieve-error .content, 
		#new-date .content{
		padding:10px 20px;
	}
	#new-date .fieldrow_label {
		margin-left:0px;
	}			
	.transactionId{
		color: #0CB24E;
		margin-left:36px;
		margin-top: 10px;
		font-weight:bold;
		display:block;
	}
	
</go:style>