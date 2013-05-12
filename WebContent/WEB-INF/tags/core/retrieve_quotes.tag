<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Header for retrieve_quotes.jsp"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

 
 <%-- JAVASCRIPT --%>
<go:script marker="onready">


	//$(".panel").hide();
	
	Retrieve.showPanel("login");
	
	$("#errorContainer").show();

	// User clicked "login" 
	$("#login-button").click(function(){
		if ($("#retrieveQuoteForm").validate().form()) {		
			Retrieve.loadQuotes($("#login_email").val(), $("#login_password").val());
		};
		
	});
	// User pressed enter on password
	$("#login_password").keypress(function(e) {
		if(e.keyCode == 13) {
			$("#login-button").click();
		};
	});
	// User clicked the "forgotten password" link
	$("#login-forgotten").click(function(){
		$("#login_forgotten_email").val($("#login_email").val());
		Retrieve.showPanel("forgotten-password");
	});
	
	// User clicked the reset button.. 
	$("#reset-button").click(function(){
		if ($("#retrieveQuoteForm").validate().form()) {
			Retrieve.resetPassword($("#login_forgotten_email").val());
		};
	});	
	
	// User clicked the prev button, when doing forgotten password..
	$("#go-back-button").click(function(){
		Retrieve.showPanel("login");
	});	

	$(".return-to-login").click(function(){
		$("#login_password").val("");
		$("#login_email").val("");
		Popup.hide("#confirm-reset");
		Popup.hide("#retrieve-error");
		$("#login_email").focus();				
	});	

	$("#new-date-button").click(function(){
		if ($("#newDate").val() != '') {
			Retrieve.retrieveQuote(Retrieve._activeVert, "latest", Retrieve._activeId, $("#newDate").val());
		};
		Popup.hide("#new-date");
	});
	
	
	<%-- if email & pwd supplied, jump to quote list
		 if just email supplied, pre-populate email field --%>
		 
	<c:choose>
		<c:when test="${param.email != null && param.password != null }">
			Retrieve.loadQuotes('${param.email}', '${param.password}');
		</c:when>
		<c:when test="${param.email != null }">
			$("#login_email").val("${param.email}");
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
		loadQuotes : function(email,pass){		
		
			Loading.show("Retrieving Your Quotes...", function() {	
			
				var dat = "email=" + encodeURI(email) 
							+ "&password=" + encodeURI(pass);
				$.ajax({
					url: "ajax/json/retrieve_quotes.jsp",
					data: dat,
					type: "GET",
					async: false,
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
						// Check if error occurred
							if (!jsonResult || typeof(jsonResult.error) != 'undefined' || (typeof(jsonResult[0]) != 'undefined' && typeof(jsonResult[0].error) != 'undefined')) {
							Retrieve.error("The email address or password that you entered was incorrect");
						} else {
							try {
								Retrieve.showQuotes(jsonResult.previousQuotes.quote);
							} catch(e) {
								Retrieve.error("Sorry, you have no saved quotes to display.");
							}
						}
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
		showQuotes : function(quotes) {
		
			var templates = {
				quote:	$("#quote_quote").html(),
				health:	$("#health_quote").html(),
				ip:		$("#ip_quote").html(),
				life:	$("#life_quote").html()
			}
			
			$("#quote-list").html("");
			var quoteCount = 0;					
			if (typeof(quotes)!='undefined' && quotes instanceof Array) {
				$.each(quotes, function() {		
					if (quoteCount < 8) {
						if( Retrieve._drawQuote(this,templates) ) {
							quoteCount++;
						}
					}
				});
			} else if (typeof(quotes)!='undefined' && quotes.length != 0) {
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
				$(".quote-details span").toTitleCase();
				$(".quote-row:first-child").addClass("first-row");
				this._initRowButtons();
				
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
				
			} else if( quote.hasOwnProperty("vehicle") ) {
			
				return this._drawCarQuote(quote, templates.quote);
			} else {
				return false;
			}
		},
		_drawCarQuote : function(quote, templateHtml){
			quote.driver.name = quote.driver.firstname + " " + quote.driver.surname;  
			if ($.trim(quote.driver.name) != ''){
				quote.driver.name = $.trim(quote.driver.name) + " - ";
			} 
			var newRow = $(parseTemplate(templateHtml, quote));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				var qd= $(newRow).find(".quote-date");
				qd.text(qd.text().replace(/\./g,"/"));
				
				if (quote.youngDriver.age != '') {
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
			quote.health.quoteDate = quote.health.quoteDate.replace(/-/g, "/");
			quote.health.quoteTime = quote.health.quoteTime.replace(/:/g,".");
			quote.health.id = quote.health.id;
			quote.health.healthCover.dependants = (quote.health.healthCover.hasOwnProperty('dependants') && quote.health.healthCover.dependants != '') ? Number(quote.health.healthCover.dependants) : 0;
			
			quote.health.benefits.list = []; 
			for(var i in quote.health.benefits.benefitsExtras)
			{
				if( quote.health.benefits.benefitsExtras[i] == "Y" )
				{
					quote.health.benefits.list.push(i);
				}
			}			
			quote.health.benefits.list = quote.health.benefits.list.join(", ");
			quote.health.healthCover.income = quote.health.healthCover.incomelabel;
			
			var newRow = $(parseTemplate(templateHtml, quote.health));
			var t = $(newRow).text();
			if (t.indexOf("ERROR") == -1) {
				$("#quote-list").append(newRow);
				return true;
			}
			return false;
		},
		
		_drawLifeQuote : function(quote, templateHtml) {
			quote.life.quoteDate = quote.life.quoteDate.replace(/-/g, "/");
			quote.life.quoteTime = quote.life.quoteTime.replace(/:/g,".");
		
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
				$("#quote-list").append(newRow);
				
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
		},
		
		_drawIPQuote : function(quote, templateHtml){
			quote.ip.quoteDate = quote.ip.quoteDate.replace(/-/g, "/");
			quote.ip.quoteTime = quote.ip.quoteTime.replace(/:/g,".");
		
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
				$("#quote-list").append(newRow);
				
				return true;
			}
			
			return false;
		},
		error : function(message){
			$("#retrieve-error-message").text(message);
			Popup.show("#retrieve-error");
		},
		_initRowButtons : function(){			
			
			$(".quote-amend a").click(function(){
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
				Retrieve.retrieveQuote(vert, "amend", id);
			});
			
			$(".quote-latest a").click(function(){
				var pieces = $(this).closest(".quote-row").attr("id").split("_");
				var vert =	pieces[0];
				var id =	pieces[2];
	
				var q = Retrieve.getQuote(id);
				if (q && q.hasOwnProperty("inPast") && q.inPast && q.inPast == "Y"){
					Retrieve._activeId = id;
					Retrieve._activeVert = vert;
					$("#new-date").val("");
					Popup.show("#new-date");
				} else {
					Retrieve.retrieveQuote(vert, "latest",id);
				}
			});			
		},
		resetPassword : function(email) {			
			if( $('#reset-button.disabled').length > 0) {
				return; //highlander rule
			};
			$('#reset-button').addClass('disabled');
			
			Loading.show("Resetting your password...", function() {
				$.ajax({
					url: "ajax/json/forgotten_password.jsp",
					data: "email=" + email,
					dataType: "text",
					async: false,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(txt){
						Loading.hide(function(){
						if ($.trim(txt) == "OK"){
							Retrieve.showPanel("login");
							$("#confirm-reset-email").text(email);
							Popup.show("#confirm-reset");
						} else {
							Retrieve.error("We were unable to find your email address on file.");
						};
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
				
			$('#reset-button').removeClass('disabled'); //finished		
		},
		retrieveQuote : function(vertical, action,id,newDate){
			
			var dat = "vertical=" + vertical + "&action=" + action + "&id=" + id;					
			if (newDate) {
				dat += "&newDate="+newDate;
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
								var url = json.result.destUrl+'&ts='+ +new Date();
								window.location.href = json.result.destUrl+'&ts='+ +new Date();
							} else {
								Loading.hide();
								if(json && json.result.error)
								{
									Retrieve.error(json.result.error);
								}
								else
								{
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
		// GET A QUOTE
		getQuote : function(id){		
			var i =0;
			while (i < this._quotes.length) {
				if (this._quotes[i].id == id ){
					return this._quotes[i];
				}
				i++;
			}
			return false;
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
	.quote-latest-button {
	}
	.quote-latest-button:hover {
	}
	.quote-amend-button {
	}
	.quote-amend-button:hover {
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
	.quote-row .quote-amend {
		vertical-align:top;
		margin-top:8px;
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
	#confirm-reset p, 
		#retrieve-error p, 
		#new-date p{
		font-size:13px;
		margin:15px 0px;
	}
	#confirm-reset .content,
		#retrieve-error .content, 
		#new-date .content{
		padding:10px 20px;
	}
	#new-date .fieldrow_label {
		margin-left:0px;
	}			
	#confirm-reset-email {
		font-weight:bold;
	}
	.transactionId{
		color: #0CB24E;
		margin-left:36px;
		margin-top: 10px;
		font-weight:bold;
		display:block;
	}
	
</go:style>
<go:script marker="js-head">
var Transaction = new Object(); 
Transaction = {
	_transId : 0,
	_reset : false,

	init: function() {
		this._reset = true;
	},
	
	getId: function() {
		
		this._transId=Track._getTransactionId( this._reset );
		this._reset = false;
		return this._transId;
	}
};
</go:script>

<go:script marker="onready">
Transaction.init();
Track.startSaveRetrieve(Transaction.getId(), 'Retrieve');
</go:script>

