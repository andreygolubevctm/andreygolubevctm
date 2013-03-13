<%@ tag language="java" pageEncoding="ISO-8859-1" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="countId" 	required="true"  rtexprvalue="true" description="Count ID" %>
<%@ attribute name="idIns" 		required="true"  rtexprvalue="true" description="Insert text for id" %>
<%@ attribute name="maxRows" 	required="false" rtexprvalue="true" description="Max number of rows allowed" %>



<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">


	<%-- User clicked the 'Add another' row link --%>
	$('#add_${idIns}_${countId}').click(function(){

		<%-- Hide buttons --%>
		$('.add_${idIns}').hide();

		<%-- Select the next row to show --%>
		var nextrow = $('#${idIns}_${countId}').siblings('.${idIns}:hidden:first');
		if('${idIns}' == 'driver') 
			nextrow = $('#driver_driver1').siblings('.driver:hidden:first');
		
		if(typeof(nextrow)!='undefined'){
			nextrow.slideDown(500, function(){

				<%-- Get next row --%>
				var nextrow = $('#${idIns}_${countId}').siblings('.${idIns}:hidden:first');
				if('${idIns}' == 'driver')
					nextrow = $('#driver_driver1').siblings('.driver:hidden:last');

				<%-- Display the next (last) row --%>
				if(typeof(nextrow)!='undefined' && typeof(nextrow.attr('id'))!='undefined'){
				
					<%-- Get the possible 2 rows (last) for next to be displayed --%>
					var lastrowid = $('#${idIns}_${countId}').siblings('.${idIns}:visible:last').attr('id');
					var possrowid = '${idIns}_${countId}';
					var row_a = parseInt(lastrowid.substring(lastrowid.length-1, lastrowid.length));
					var row_b = parseInt(possrowid.substring(possrowid.length-1, possrowid.length));
					
					<%-- Display the TRUE last row --%>
					if(row_a > row_b){
						$('#'+lastrowid+' .add_link').fadeIn(300);
					}else{
						$('#${idIns}_${countId} .add_link').fadeIn(300);
					}

				}
				
			});
		}

	});
	
	
	<%-- User clicked the 'Remove' row link --%>
	$('#remove_${idIns}_${countId}').click(function(){
		var answer = confirm("Are you sure you want to delete this?");
		if(answer){
		
			<%-- Clear fields inside removed row --%>
			if( $('#${idIns}_${countId} input').attr('id').indexOf('driverFault') == -1)
				$('#${idIns}_${countId} input').val('');
			$('#${idIns}_${countId} select').val('');
			
			<%-- Hide the removed row --%>
			$('#${idIns}_${countId}').slideUp(500, function(){
			
				<%-- Get last visible row & show its 'Add another' link --%>
				$('.add_${idIns}').hide();
				var lastrowid = $('#${idIns}_${countId}').siblings('.${idIns}:visible:last').attr('id');
				$('#'+lastrowid+' .add_link').fadeIn(300);
				
				<%-- Set radio to NO if no rows remaining --%>
				if( $('.remove_${idIns}:visible').length < 1 )
					$("[for='quote_avea_incidentsClaimsOther_${idIns}_N']").click();
		
				<%-- Set driver radio to NO if no additional drivers remaining --%>
				if('${idIns}' == 'driver' && $('.remove_driver:visible').length < 1 ){
					$("[for='quote_avea_drivers_additional_N']").click(); 
					$('#add_driver_driver0').show(); 
				}
				
				<%-- Clean up offences and refresh --%>
				cleanupDriverOffences();
	
			});
		}
	});
	
</go:script>


