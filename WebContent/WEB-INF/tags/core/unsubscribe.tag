<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Header for retrieve_quotes.jsp"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

 
 <%-- JAVASCRIPT --%>
<go:script marker="onready">

	<c:choose>
		<c:when test="${param.unsubscribe_email != null }">
			$("#contact_email").val("${param.unsubscribe_email}");	
		</c:when>
	</c:choose>

	// User clicked the reset button.. 
	$("#unsubscribe-button").click(function(){
		if ($("#unsubscribeForm").validate().form()) {
			Unsubscribe.submitEml($("#contact_email").val());
		}
	});	
	
	$("#return-to-eml").click(function(){
		Popup.hide("#email-message");
	});	
	$("#return-to-home").click(function(){
		window.location.href= "${data['settings/root-url']}";
	});
	
</go:script>


<go:script marker="js-head">

	var Unsubscribe = new Object();
	Unsubscribe = {
		
		submitEml : function(email){
			var dat = "email=" + encodeURI(email);
			$.ajax({
			url: "ajax/json/unsubscribe.jsp",
			data: "email=" + email,
			dataType: "text",
			success: function(txt){
				if ($.trim(txt) == "OK"){
					Popup.show("#confirm-unsubscribe");
				} else {
					Popup.show("#email-message");
				}
				return false;
			},					
			error: function(obj,txt){
				FatalErrorDialog.display("An error occurred :" + txt, dat);
			},
			timeout:30000
			});
		}								
	}
	
</go:script>


<!-- CSS -->
<go:style marker="css-head">

	#wrapper {
		background-color:white;
	} 
	#page {
		min-height:550px;
	}
	body {
		overflow:scroll;
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

	#emlUnsubscribe {
  		margin-left: 20px;
  		padding-top: 6px;
	}
	#emlUnsubscribe .fieldset .content{
		min-height:60px;
	}
	#emlUnsubscribe a {
		margin-top:50px;
	}
	div#unsubscribeErrors div#errorContainer {
		top: 100px;
		right: 5px;
	}
	#email-message .popup-buttons,
	#confirm-unsubscribe .popup-buttons {
	    margin-top: 60px;
    	position: relative;
    	top: 10px;
	}
</go:style>
	