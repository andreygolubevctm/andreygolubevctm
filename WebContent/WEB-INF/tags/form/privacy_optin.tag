<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="true"	 rtexprvalue="true"	 description="the root xpath for the vertical" %>

<%-- VARIABLES --%>
<c:set var="suffix"  value="privacyoptin" />
<c:set var="name"  value="${vertical}_${suffix}" />
<c:set var="xpath"  value="${vertical}/${suffix}" />
<c:set var="label_text" value="I have read the <a href='javascript:void(0);' onclick='${name}InfoDialog.open()'>privacy statement</a>" />
<c:set var="error_text" value="Please confirm you have read the privacy statement" />

<%-- HTML --%>
<c:choose>

	<%-- Only render a hidden field when the checkbox has already been selected --%>
	<c:when test="${data[xpath] eq 'Y'}">
		<field:hidden xpath="${xpath}" defaultValue="Y" constantValue="Y" />
	</c:when>

	<%-- FUEL --%>
	<c:when test="${vertical eq 'fuel'}">
		<div class="terms ${suffix}">
			<field:checkbox xpath="${xpath}" className="required validate" label="true" value="Y" title="${label_text} *" errorMsg="${error_text}" required="true" />
		</div>
	</c:when>

	<%-- HEALTH --%>
	<c:when test="${vertical eq 'health'}">

		<form:row label="" className="health-privacy-statement-group">
			<c:set var="label_text_health">
				<div class="readPrivacyStatementLabel">${label_text}</div>
			</c:set>
			<div class="readPrivacyStatementError">
				<span>${error_text}</span>
			</div>
			<field:customisable-checkbox
				xpath="${xpath}"
				theme="replicaLarge"
				value="Y"
				className="validate"
				required="false"
				label="${true}"
				title="${label_text_health}"
				errorMsg="${error_text}"
			/>
		</form:row>

		<%-- Validation --%>
		<c:if test="${vertical eq 'health'}">
			<go:script marker="js-head">
				$.validator.addMethod('readPrivacyStatementMessage', function(value, element, param) {
					if( $(element).is(':checked') ){
						$('.readPrivacyStatementError').hide();
						return true;
					} else {
						$('.readPrivacyStatementError').show();
						return false;
					};
				});
			</go:script>
			<go:validate selector="${name}" rule="readPrivacyStatementMessage" parm="true" message="${error_text}" />
		</c:if>
	</c:when>

	<%-- OTHERS --%>
	<c:otherwise>
		<form:row label="" id="${name}-row">
			<field:checkbox
				xpath="${xpath}"
				value="Y"
				title="${label_text}"
				errorMsg="${error_text}"
				required="true"
				label="true"
			/>
		</form:row>
	</c:otherwise>
</c:choose>

<ui:dialog id="${name}Info" width="400" titleDisplay="false">
Your privacy is important to us. And you may be wondering about the information we are collecting when you get quotes and compare products on our site.<br/><br/>
The information we collect depends on what products and quotes you are comparing and without this information, we wouldn&#39;t be able to offer our service. Information about persons named must be given with their consent. We use your information, some of which may be sensitive, to provide you with quotes and/or comparisons. If you choose to apply for a product, we&#39ll pass this information on to the chosen product provider. We may also use it to keep you up&#45;to&#45;date with our services and products.
<br/><br/>
Your personal information (but not your sensitive information) may be held by some of our service providers in an overseas location, the details of which can be found in our privacy policy. In this privacy policy, you can also find out more about the information we hold and how to correct it, as well as how to make a complaint and how this complaint will be handled.&nbsp;&nbsp;<a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank">View Privacy Policy</a>
</ui:dialog>

<%-- CSS --%>
<go:style marker="css-head">
	#${name}InfoDialog a,
	#${name}-row a {
		font-size: 100% !important;
	}
	#${name}-row label {
		margin-left: 5px;
	}
	.${name}InfoDialogContainer.ui-dialog .ui-dialog-content {
		text-align: justify;
		padding: 22px;
	}

	<%-- VERTICAL SPECIFIC STYLING --%>
	<c:choose>

		<%-- CAR --%>
		<c:when test="${vertical eq 'quote'}">
			#${name}-row label {
				color: #808080;
			}
		</c:when>

		<%-- HOME & CONTENTS --%>
		<c:when test="${vertical eq 'home'}">
			#${name}-row {
				margin-top: 15px;
			}
			#${name}-row label {
				color: #808080;
			}
		</c:when>

		<%-- TRAVEL --%>
		<c:when test="${vertical eq 'travel'}">
			#${name}-row {
				margin-top: -10px;
			}
			#${name}-row label {
				color: #777777;
				margin-left: 0;
			}
		</c:when>

		<%-- HOMELOAN --%>
		<c:when test="${vertical eq 'homeloan'}">
			#${name}-row label {
				margin-left: 0;
			}
		</c:when>

		<%-- FUEL --%>
		<c:when test="${vertical eq 'fuel'}">
			#quickForm .terms.${suffix} {
				width: 100px;
			}
		</c:when>

		<%-- HEALTH --%>
		<c:when test="${vertical eq 'health'}">
			.health-privacy-statement-group {
				width: 425px;
				margin-left: 195px;
				margin-top: 10px;
				margin-bottom: 5px;
			}
			.health-privacy-statement-group .fieldrow_value label {
				float: right;
				width: 370px;
				font-size: 88%;
			}
			.health-privacy-statement-group .fieldrow_label {
				display: none;
			}
			.health-privacy-statement-group .fieldrow_value {
				width: 400px;
			}
			.health-privacy-statement-group .fieldrow_value input {
				float: left;
				margin-left: 5px;
			}

			.health-privacy-statement-group .readPrivacyStatementLabel {
				margin-left: 1em;
			}

			.health-privacy-statement-group .readPrivacyStatementError {
				width: 176px;
				height: 61px;
				background: url("common/images/error/terms_and_conditions_box_alt.png") left top no-repeat;
				text-align: center;
				position: absolute;
				left: -165px;
				top: -12px;
				display: none;
			}

			.health-privacy-statement-group .readPrivacyStatementError span {
				color: #EB5300;
				font-size: 12px;
				line-height: 120%;
				padding: 7px 46px 0 20px;
				display: block;
			}
		</c:when>
	</c:choose>
</go:style>