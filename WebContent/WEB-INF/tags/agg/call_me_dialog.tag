<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="className" 	required="true"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="true"  rtexprvalue="true"	 description="id of the surround div" %>

<c:set var="phoneNumber">1800 77 77 12</c:set>
<c:set var="openingHours">Our operating hours are Monday to Friday 8am to 6pm (AEST)</c:set>


<div class="${className}" title="${title}">
	<form:form name="contactForm" action="none" id="contactForm" method="POST">		
		<div id="contactUs_heading">Contact Us</div>
		
		<form:fullrow>
			<label>Call Us</label><span class="telephoneNumber">${phoneNumber}</span><span class="openingHours">${openingHours}</span>
		</form:fullrow>
		<form:fullrow>
			<label>Chat with Us</label><div id="chatButton">[??????]</div>
		</form:fullrow>
		<form:row label="Name">
			<field:person_name xpath="contact/name" title="what is your name" required="true" />
		</form:row>		
		<form:row label="Phone No">
			<field:contact_telno xpath="contact/telno" required="true" title="contact telephone number" className="telNo" id="contactUs_fieldrow"  />
		</form:row>		
		<form:row label="Your preferred day to call">
			<field:array_radio items="M=Morning,A=Afternoon" xpath="contact/time" title="when we should call you" required="true" />
		</form:row>
		
		<div id="contactForm_errors">
			<div class="error-panel-top small"><h3>Oops...</h3></div>
			<div class="error-panel-middle small"><ul></ul></div>
			<div class="error-panel-bottom small"></div>
		</div>
			
		<field:button xpath="contact/submit" title="Send"></field:button>		
	</form:form>
</div>
<go:script marker="onready">
	$( ".{className}" ).dialog({ 
			'show': {effect: "fadeIn",  duration: 200},
			'hide': {effect: "fadeOut", duration: 200}, 
			'modal':true, 
			'width':620, 'height':350, 
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			open: function(){},
	   		close: function(){}
		});
	});
</go:script>
<go:script marker="onready">
	$("#${id}").validate({
     	rules: { 
            contact_name: { 
            	required:true
            },
            contact_telno: {
            	required:true            	
            },
            contact_time: {
            	required:true
            }
		}, 
        messages: { 
        	contact_name: "Please enter your name",
            contact_telno: "Please enter a telephone number", 
            contact_time: "Please enter a tiem when we can contact you"
        },
        errorContainer: "#contactForm_errors",
        errorLabelContainer:"#contactForm_errors ul",
		wrapper: "li",
		debug:true
	});
	
	$("#contactUs_submit").click(function() {		
		var numberOfInvalids = 0;
		
		$("#${id}").validate().resetNumberOfInvalids();
		validation=true;
		$("#${id} :input").each(function(index) {
			if ($(this).attr("id")){
				$("#${id}").validate().element("#" + $(this).attr("id"));
			}
		});
		validation=false;
		
		if ($("#${id}").validate().numberOfInvalids()==0) {
			var dat = $("#${id} *").serialize();
			alert("AJAX CALLBACK HERE");
		}

	});

</go:script>