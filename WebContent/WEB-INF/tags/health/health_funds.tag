<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load in the Assets --%>
<go:script href="/${data.settings.styleCode}/common/js/healthFunds.js" />
<link rel='stylesheet' type='text/css' href='/${data.settings.styleCode}/common/healthFunds.css'>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var healthFunds = {
		_fund: false,
		name: 'the fund',		
		
		<%-- Create the 'child' method over-ride --%>
		load: function(fund, callbackOnSuccess, performProcess) {
			if (fund == '' || !fund) {
				healthFunds.loadFailed('Empty or false');
				return false;
			};

			if (performProcess !== false) performProcess = true;
			
			<%-- Load separate health fund JS --%>
			if (typeof(window['healthFunds_' + fund]) == 'undefined' || window['healthFunds_' + fund] == false) {
				Loading.show();
				$.ajax({
					url: 'common/js/health/healthFunds_'+fund+'.jsp',
					dataType: 'script',
					async: true,
					timeout: 30000,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function() {
						<%-- Process --%>
						if (performProcess) {
							healthFunds.process(fund);
						}
						<%-- Callback --%>
						if (typeof(callbackOnSuccess) == 'function') {
							callbackOnSuccess();
						}
						Loading.hide();
						return true;
					},
					error: function() {
						Loading.hide();
						healthFunds.loadFailed(fund);
						return false;
					}
				});
				return true;
			}

			<%-- If same fund then don't need to re-apply the rules --%>
			if (fund != healthFunds._fund && performProcess) {
				healthFunds.process(fund);
			};
			
			<%-- Success callback --%>
			if (typeof(callbackOnSuccess) == 'function') {
				callbackOnSuccess();
			}
			return true;
		},
						
		process: function(fund) {
			<%-- set the main object's function calls to the specific provider --%>
			var O_method = window['healthFunds_' + fund];
			healthFunds.set = O_method.set;
			healthFunds.unset = O_method.unset;
			
			<%-- action the provider --%>
			$('body').addClass(fund);
			healthFunds.set();			
			healthFunds._fund = fund;

			<%-- Trigger payment type radio which is tied to things like claims --%>
			$('#health_payment_details_type input:radio').trigger('change');
		},

		loadFailed: function(fund) {
			FatalErrorDialog.exec({
				message:		"Unable to load the fund's application questions",
				page:			"health:health_funds.tag",
				description:	"healthFunds.update(). Unable to load fund questions for: " + fund,
				data:			null
			});
		},
		
		<%-- Remove the main provider piece --%>
		unload: function(){
			healthFunds.unset();
			$('body').removeClass( healthFunds._fund );
			healthFunds._fund = false;
				healthFunds.set = function(){};
				healthFunds.unset = function(){};
		},
		
		<%-- Fund customisation setting, used via the fund 'child' object --%>
		set: function(){
		},
				
		<%-- Unpicking the fund customisation settings, used via the fund 'child' object --%>
		unset: function(){
		},
		
			<%-- Additional sub-functions to help render application questions --%>
			
			applicationFailed: function(){
				return false;
			},		
		
			_dependants: function(message){
				if(message !== false){
					<%-- SET and ADD the dependant definition --%>			
					healthFunds.$_dependantDefinition = $('#mainform').find('.health-dependants').find('.definition');
					healthFunds.HTML_dependantDefinition = healthFunds.$_dependantDefinition.html();
					healthFunds.$_dependantDefinition.html(message);
				} else {
					healthFunds.$_dependantDefinition.html( healthFunds.HTML_dependantDefinition );
					delete healthFunds.$_dependantDefinition;
					delete healthFunds.HTML_dependantDefinition;			
				};
			},
			
			_authority: function(message){
				if(message !== false){
					<%-- SET and ADD the authority 'label' --%>			
					healthFunds.$_authority = $('#mainform').find('.health_previous_fund_authority').find('label').find('span');
					healthFunds.$_authorityText = healthFunds.$_authority.text();
					healthFunds.$_authority.text( Results._selectedProduct.info.providerName );	
				} else {
					healthFunds.$_authority.text( healthFunds.$_authorityText );
					delete healthFunds.$_authority;
					delete healthFunds.$_authorityText;			
				};
			},			

			<%-- Create payment day options on the fly - min and max are in + days from the selected date;
			NOTE: max - min cannot be a negative number --%>			
			_paymentDays: function( euroDate ){
				<%-- main check for real value --%>
				if( euroDate == ''){
					return false;
				};
				
				var _baseDate = returnDate(euroDate);

				var _count = 0;
				var _limit = healthFunds._payments.max - healthFunds._payments.min;
				var _days = healthFunds._payments.min;
				var _html = '<option value="">Please choose...</option>';
				
				<%-- The loop to create the payment days --%>
				while ( _count < _limit) {
				
					var _date = new Date( _baseDate.getTime() + (_days * 24 * 60 * 60 * 1000));
					var _day = _date.getDay();

					<%-- Parse out the weekends --%>
					if( !healthFunds._payments.weekends && ( _day == 0 || _day == 6 ) ){
						_days++;
					} else {
						var _dayString = leadingZero( _date.getDate() );
						var _monthString = leadingZero( _date.getMonth() + 1 );								
						_html += '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'">'+ healthFunds._getNiceDate(_date) +'</option>';
						_days++;
						_count++;					
					};
				};
				
				<%-- Return the html --%>
				return _html;
			},
			
			<%-- Creates the earliest date based on any of the matching days (not including an exclusion date) --%>
			_earliestDays: function(euroDate, a_Match, _exclusion){			
					if( !$.isArray(a_Match) || euroDate == '' ){
						return false;
					};								
					<%-- creating the base date from the exclusion --%>
					var _now = returnDate(euroDate);
					var _exclusion = 7;
					var _date = new Date( _now.getTime() + (_exclusion * 24 * 60 * 60 * 1000));
					var _html = '<option value="">No date has been selected for you</option>';					
					<%-- Loop through 31 attempts to match the next date --%>
					for (var i=0; i < 31; i++) {
						var _date = new Date( _date.getTime() + (1 * 24 * 60 * 60 * 1000));					
						<%-- Loop through the selected days and attempt a match  --%>
						for(a=0; a < a_Match.length; a++) {
							if(a_Match[a] == _date.getDate() ){
								var _dayString = leadingZero( _date.getDate() );
								var _monthString = leadingZero( _date.getMonth() + 1 );
								var _html = '<option value="'+ _date.getFullYear() +'-'+ _monthString +'-'+ _dayString +'" selected="selected">'+ healthFunds._getNiceDate(_date) +'</option>';
								i = 99;
								break;															
							};
						};
					};					
					return _html;					
			},
			
			<%-- Renders the payment days text --%>
			_paymentDaysRender: function($_object,_html){
				if(_html === false){
					healthFunds._payments = { 'min':0, 'max':5, 'weekends':false };
					_html = '<option value="">Please choose...</option>';	
				};
				$_object.html(_html);
				$_object.siblings('span').text( 'Your payment will be deducted on: ' + $_object.find('option').first().text() );
				//$('.health-bank_details-policyDay, .health-credit-card_details-policyDay').html(_html);				
			},
	
			_getNiceDate : function( dateObj ) {
			
				var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
				var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
				var day = dateObj.getDate();
				var dayLabel = days[dateObj.getDay()];
				var month = months[dateObj.getMonth()];
				var year = dateObj.getFullYear();
				
				return dayLabel + ", " + day + " " + month + " " + year;
			}
	};	
</go:script>

<%-- If retrieving a quote and a product had been selected, load the fund's application set. --%>
<%-- This is in case any custom form fields need access to the data bucket, because write_quote will erase the data when it's not present in the form. --%>
<c:if test="${param.action eq 'amend' and not empty data['health/application/provider']}">
	<go:script marker="onready">
		if ($('body').hasClass('amend') && $('body').hasClass('stage-0')) {
			healthFunds.load('${data["health/application/provider"]}', function() {
				if (window['healthFunds_${data["health/application/provider"]}'].processOnAmendQuote && window['healthFunds_${data["health/application/provider"]}'].processOnAmendQuote === true) {
					window['healthFunds_${data["health/application/provider"]}'].set();
					window['healthFunds_${data["health/application/provider"]}'].unset();
				}
			}, false);
		}
	</go:script>
</c:if>