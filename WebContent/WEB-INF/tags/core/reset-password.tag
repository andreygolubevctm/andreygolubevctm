<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="reset password interface"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="returnTo" required="false" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="resetButtonId" required="true" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="emailFieldId" required="true" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="emailFormId" required="true" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="onceResetInstructions" required="true" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="failedResetInstructions" required="false" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="successCallback" required="false" rtexprvalue="true"	 description="constant value" %>
<%@ attribute name="className" required="false" rtexprvalue="true"	 description="class attribute" %>

<%@ attribute name="popup" required="false" rtexprvalue="true"	 description="constant value" %>

<%-- CSS --%>
<go:style marker="css-head">
	#reset-outcome .content {
		padding: 10px 20px;
	}
</go:style>


	<c:set var="content">
		<div id="reset-outcome-success-content" class="reset-password-outcome">
			<p>Your password reset email has been sent to <span class="confirm-reset-email"></span></p>
			<p>To reset your password click the link provided in that email and follow the process provided on our secure website.</p>
			<p>${onceResetInstructions}</p>
		</div>
		<div id="reset-outcome-error-content" class="reset-password-outcome">
			<p>Unfortunately we were unable to send you a reset email.</p>
			<p id="reset-error-message"></p>
			<c:if test="${not empty failedResetInstructions}">
				<p>${failedResetInstructions}</p>
			</c:if>
		</div>

		<c:if test="${popup}">
			<div class="popup-buttons">
				<a href="javascript:void(0);" class="bigbtn reset-return-to-login" id="reset-return-to-login"><span>Ok</span></a>
			</div>
		</c:if>
	</c:set>
	<c:choose>
		<c:when test="${popup}">
			<core:popup id="reset-outcome" title="Reset Password" className="${className}">
				<c:out value="${content}" escapeXml="false"></c:out>
			</core:popup>
			<c:set var="popup" value="true" />
		</c:when>
		<c:otherwise>
			<div id="reset-outcome"  title="Reset Password" class="${className}" style="display:none;" >
				<c:out value="${content}" escapeXml="false"></c:out>
			</div>
			<c:set var="popup" value="false" />
		</c:otherwise>
</c:choose>

<go:script marker="js-head">
	var ResetPassword = new Object();

	ResetPassword = {
		successCallback : function() {},
		popup : false,
		resetPassword : function(email) {
			if( $('#reset-button.disabled').length > 0) {
				return; //highlander rule
			};
			$('#reset-button').addClass('disabled');

			Loading.show("Resetting your password...");
				$.ajax({
					url: "ajax/json/forgotten_password.jsp",
					data: {email: email},
					dataType: "text",
					async: false,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(txt){
							if ($.trim(txt) == "OK") {
								ResetPassword.success(email);
							} else {
								ResetPassword.error("We were unable to find your email address on file.");
							};
						return false;
					},
					error: function(obj,txt){
						ResetPassword.error("A problem occurred when trying to communicate with our network.");
					},
					timeout:30000
			});

			$('#reset-button').removeClass('disabled'); //finished
		},
		success : function(email){
			$(".confirm-reset-email").text(email);
			$("#reset-outcome-popup h5").text("Reset Password");
			$("#reset-outcome-success-content").show();
			$("#reset-outcome-error-content").hide();
			$('#reset-button').removeClass('disabled');
			Loading.hide(function(){
				if(ResetPassword.popup) {
					Popup.show("#reset-outcome", "#loading-overlay");
				} else {
					$("#reset-outcome").show();
				}
			});
			ResetPassword.successCallback();
		},
		error : function(message){
			$("#reset-outcome h5").text("Reset Password Error");
			$("#reset-error-message").text(message);
			$("#reset-outcome-error-content").show();
			$("#reset-outcome-success-content").hide();
			Loading.hide(function() {
				if(ResetPassword.popup) {
					Popup.show("#reset-outcome", "#loading-overlay");
				} else {
						$("#reset-outcome").show();
				}
			});
		}
	}
</go:script>
<go:script marker="onready">
	ResetPassword.successCallback = function() {
		${successCallback}
	};
	ResetPassword.popup = ${popup};
	<%-- User clicked the reset button.. --%>
	$("#${resetButtonId}").click(function(){
		if ($("#${emailFormId}").validate().element("#${emailFieldId}")) {
			ResetPassword.resetPassword($("#${emailFieldId}").val());
		};
	});

	if(ResetPassword.popup) {
		$("#reset-return-to-login").click(function(){
			Popup.hide("#reset-outcome");
		});
	}
</go:script>
