<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
	<a href="javascript:void(0);" class="tab-button next" id="slide-next">Next</a>
</div>	


<%-- JAVASCRIPT --%>
<go:script marker="onready">
	initQuoteEngineScreens();
	initFormElements();
	var nav = $("#qe-wrapper").data("scrollable");
	$("#next-step,#slide-next").click(function(){ validate_form(true); });	
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
				fuel.fetchPrices();
				$("#revise").show();
			}
		}
	}

</go:script>