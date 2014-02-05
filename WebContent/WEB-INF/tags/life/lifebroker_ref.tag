<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" 	required="true"	 rtexprvalue="true"	 description="Label for elements - life or ip" %>

<%-- HTML --%>
<field:hidden xpath="${label}/client/reference" defaultValue="" />
<field:hidden xpath="${label}/api/reference" defaultValue="" />
<field:hidden xpath="${label}/primary/productid" defaultValue="" />
<field:hidden xpath="${label}/partner/productid" defaultValue="" />
<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var LifebrokerRef = {

	<%-- Update the form field - PRJAGGL-99 --%>
	updateAPIFormFields : function( api_reference, type, product_id ) {
		if( api_reference && api_reference != null ) {
			$("#${label}_api_reference").val( api_reference );
		}
		if( product_id && product_id != null ) {
			$("#${label}_${type}_productid").val( product_id );
		}
	},

	updateClientRefField : function( client_reference ) {
		if( client_reference && client_reference != null ) {
			$("#${label}_client_reference").val( client_reference );
		}
	},

	updateDataBucket : function() {

		var dat = $("#mainform").serialize() + "&vertical=${label}";
		$.ajax({
			url: "ajax/json/life_update_bucket.jsp",
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
</go:script>