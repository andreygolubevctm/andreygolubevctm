<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="true"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="optional id for this slide container"%>

<%-- HTML --%>
<div id="qe-wrapper">
	<div class="scrollable">
		<div id="qe-main">
			<jsp:doBody />
		</div>
	</div>
</div>	


<%-- JAVASCRIPT --%>
<go:script marker="onready">
	var nav = $("#qe-wrapper").data("scrollable");
	
	
	$("#next-step").click(function(){
		Results.fetchPrices(); 
		//if (validate_form()){
			//History.showStage(History._RESULTS);
		//}
	});
</go:script>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	function validate_form(dosub){
		validation = true;
		
		//$("#mainform").validate().resetNumberOfInvalids();
		var numberOfInvalids = 0;
	
		$('#slide'+slideIdx + ' :input').each(function(index) {
			if($(this).attr("id")){
				$("#mainform").validate().element("#" + $(this).attr("id"));
			}
		});
		
		if($("#mainform").validate().numberOfInvalids() == 0) {
		
			if(!$("#helpPanel").is(':hidden')){ 
				$("#helpPanel").fadeOut(300);
			}
			if(typeof(dosub)!='undefined' && dosub){						
				Health.fetchPrices();
				$("#revise").show();
			}
		}
	}

</go:script>

