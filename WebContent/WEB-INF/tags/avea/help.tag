<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 		required="false"  rtexprvalue="true"	 description="title for the slide"%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<div id="helpPanel">
	<div id="helpHeader"><div id="helpTitle"></div></div>
	<div id="helpContent"><div id="helpText"></div></div>	
</div>

<%-- CSS --%>
<go:style marker="css-head">		

	
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	var globalHelpId = 0;
	var slideSpeed = 300;
	$("#helpPanel, #helpHide").hide();
	$("#helpPanel").bgiframe();
		
	$("#helpPanel").click(function(){	
		  $("#helpPanel").fadeOut(slideSpeed);	
		  globalHelpId = 0;
	});	

	var showHelp = function(id,p){

		if (globalHelpId != id) {
			globalHelpId = id;

			$.ajax({
			   url: "ajax/xml/help.jsp",
			   data: "id=" + id,
			
			   success: function(data){
			  
			   	 var helpHeader = '';
				 var helpBody = '';		
				 var helpText = '';
				 
			     $(data).find("help").each(function() { 
			     	helpHeader = $(this).attr("header");
			     	helpText   = $(this).text();
				 });
	 
				 if (helpText.length>0) {

					if ($("#helpPanel").is(':hidden')) {
						$("#helpPanel").css({ "left":(p.left-140)+"px", 
											  "top":(p.top+110)+"px"
						});
						$("#helpTitle").html(helpHeader);
						$("#helpText").html(helpText);
						$("#helpPanel").fadeIn(slideSpeed);	
									  
					} else {

						$("#helpPanel").fadeOut(slideSpeed, function() {
							$("#helpPanel").css({ "left":(p.left-140)+"px", 
												  "top":(p.top+110)+"px"
							});		
							$("#helpTitle").html(helpHeader);
							$("#helpText").html(helpText);				
							$("#helpPanel").fadeIn(slideSpeed);	
						});
	
					}
	
				}
				
			   },
			   error: function() {
			     alert( "Ooops Ajax Request Failed");
			   }
			 });	

		} else {
			$("#helpPanel").fadeOut(slideSpeed);
			globalHelpId = 0;
		}
		
	}
	
	$(".help_icon").each(function(){
		$(this).click(function(){
			var p = $(this).position();
			var id=$(this).attr("id").substring(5); 
			showHelp(id,p);
		});
	});
</go:script>