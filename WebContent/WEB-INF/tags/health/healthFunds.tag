<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load in the Assets --%>
<go:script href="/${data.settings.styleCode}/common/js/healthFunds.js" />
<link rel='stylesheet' type='text/css' href='/${data.settings.styleCode}/common/healthFunds.css'>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var healthFunds = {
		_fund: false,		
		
		<%-- Create the 'child' method over-ride --%>
		load: function(fund){
			
			<%-- set the main object's function calls to the specific provider --%>
			if(typeof window['healthFunds_' + fund] == 'undefined' || fund == '' || !fund){
				FatalErrorDialog.display("Unable to load the fund's application questions");
				return false;
			};
			
			if(fund == healthFunds._fund){
				return; //no need to re-apply the rules
			};			
						
			var O_method = window['healthFunds_' + fund];
			healthFunds.set = O_method.set;
			healthFunds.unset = O_method.unset;
			
			<%-- action the provider --%>
			$('body').addClass(fund);
			healthFunds.set();			
			healthFunds._fund = fund;
			return true;
		},
		
		<%-- Remove the main provider piece --%>
		unload: function(){
			healthFunds.unset();
			$('body').removeClass( healthFunds._fund );
			healthFunds._fund = false;
		},
		
		<%-- Fund customisation setting, used via the fund 'child' object --%>
		set: function(){
		},
				
		<%-- Unpicking the fund customisation settings, used via the fund 'child' object --%>
		unset: function(){
		}
	};	
</go:script>