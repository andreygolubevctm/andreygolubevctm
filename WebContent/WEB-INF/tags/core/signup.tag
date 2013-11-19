<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<go:script marker="js-head">
$(document).ready(function() {

	$(':input[type=text]','#signupForm').val('');

	// User clicked the reset button.. 
	var currentProduct="";
	$('.product').click(function(){
		$('.product').each(function(){
			$(':input[name=' + this.name + ']').attr('checked', false);
		});
		$(':input[name=' + this.name + ']').attr('checked', ((currentProduct==this.name)?false:true));
		if (currentProduct==this.name) {
			currentProduct="";
		} else {
			currentProduct=this.name;
		}				
	});
	
	$("#signup-button").click(function(){
		validation=true;
		if ($("#signupForm").validate().form()) {
			Loading.show("Signing you up<br />Back in a tick...");
			var dat = $("#signupForm").serialize();					
			$.ajax({
				url: "ajax/json/signup.jsp",
				data: dat,
				dataType: "text",
				success: function(txt){
					Loading.hide();
					if ($.trim(txt) == "OK"){
						Popup.show("#confirm-signup");
					} else {
						Popup.show("#signup-failed");
					}
					return false;
				},					
				error: function(obj,txt){
					Loading.hide();
					Popup.show("#signup-failed");
				},
				timeout:30000
			});						
		}
	});	
	$("#return-to-eml").click(function(){
		Popup.hide("#signup-failed");
	});		
			
	$("#confirm-signup .close-button").click(function(){
		window.location.href= "${data['settings/root-url']}";
	});			
	$("#return-to-home").click(function(){
		window.location.href= "${data['settings/root-url']}";
	});				
	$("#compTerms").click(function(){
		PromoTerms.show();
	});	
	
	
	s.pageName="CC:Email-Signup-iPad2"
	s.prop3="CC"
	s.eVar26="CC"
	s.channel="CC:main"
	s.server=location.host
	
	var s_code=s.t();
	if(s_code)document.write(s_code);
	

});
</go:script>