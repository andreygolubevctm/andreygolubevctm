<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 	required="true"	 rtexprvalue="true"	 description="Label for elements - life or ip" %>

<%-- HTML --%>
<field:hidden xpath="${label}/client/reference" defaultValue="" />
<field:hidden xpath="${label}/client/productid" defaultValue="" />
			
<%-- JAVASCRIPT --%>
<script marker="js-head">

var LifebrokerRef = {

	// Update the form field - PRJAGGL-99
	updateClientFormFields : function( client_reference, product_id ) {	
		if( client_reference && client_reference != null ) {
			$("#${label}_client_reference").val( client_reference );
		}
		if( product_id && product_id != null ) {
			$("#${label}_client_productid").val( product_id );
		}
	},
	
	updateDataBucket : function() {
	
		var dat = $("#mainform").serialize();
		$.ajax({
			url: "ajax/json/${label}_update_bucket.jsp",
			data: dat,
			type: "POST",
			async: true,
			dataType: "json",
			timeout:60000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			success: function(jsonResult){
				// Nothing to do
				return false;
			},
			error: function(obj,txt){
				// Nothing to do
			}
		});
	}
};
</script>