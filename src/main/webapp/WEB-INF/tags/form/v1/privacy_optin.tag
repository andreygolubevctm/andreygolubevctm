<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form."%>


<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="true"	 rtexprvalue="true"	 description="the root xpath for the vertical" %>

<%-- VARIABLES --%>
<c:set var="suffix"  value="privacyoptin" />
<c:set var="name"  value="${vertical}_${suffix}" />
<c:set var="xpath"  value="${vertical}/${suffix}" />
<c:set var="error_text" value="Please confirm you have read the privacy statement" />
<c:set var="privacyLink" value="<a href='javascript:void(0);' onclick='${name}InfoDialog.open()'>privacy statement</a>" />
<c:set var="brandedName"><content:optin key="brandDisplayName" useSpan="true"/></c:set>
<c:choose>
	<c:when test="${vertical eq 'utilities'}">
		<c:set var="label_text">
			I understand ${brandedName} compares energy plans based on peak tariffs from a range of participating retailers. By providing my contact details I agree that ${brandedName} and its partner Thought World may contact me about the services they provide.
			I confirm that I have read the <form_v1:link_privacy_statement/>.</c:set>
	</c:when>

	<c:otherwise>
		<c:set var="label_text" value="I have read the ${privacyLink}" />
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<c:choose>

	<c:when test="${vertical eq 'life' or vertical eq 'ip'}">
		<%-- This is here to prevent Life/IP from using the checkbox here because we have to position it elsewhere on the form. --%>
	</c:when>
	<%-- Only render a hidden field when the checkbox has already been selected --%>
	<c:when test="${data[xpath] eq 'Y'}">
		<field_v1:hidden xpath="${xpath}" defaultValue="Y" constantValue="Y" />
	</c:when>
	<%-- OTHERS --%>
	<c:otherwise>
		<form_v1:row label="" id="${name}-row">
			<field_v1:checkbox
				xpath="${xpath}"
				value="Y"
				title="${label_text}"
				errorMsg="${error_text}"
				required="true"
				label="true"
			/>
		</form_v1:row>
	</c:otherwise>
</c:choose>

<ui:dialog id="${name}Info" width="400" titleDisplay="false">
Your privacy is important to us. And you may be wondering about the information we are collecting when you get quotes and compare products on our site.<br/><br/>
<c:choose>
	<c:when test="${vertical eq 'life' or vertical eq 'ip'}">
		The information we collect depends on what products and quotes you are comparing and without this information, we wouldn&#39;t be able to offer our service. Information about persons named must be given with their consent. We use your information, some of which may be sensitive, to provide you with quotes and/or comparisons. If you choose to apply for a product, we&#39;ll pass this information on to the chosen product provider or their broker. If you consent, we may also pass your contact details to a provider to contact you. We may also use it to keep you up&#45;to&#45;date with our services and products.
	</c:when>
	<c:otherwise>
		The information we collect depends on what products and quotes you are comparing and without this information, we wouldn&#39;t be able to offer our service. Information about persons named must be given with their consent. We use your information, some of which may be sensitive, to provide you with quotes and/or comparisons. If you choose to apply for a product, we&#39;ll pass this information on to the chosen product provider. We may also use it to keep you up&#45;to&#45;date with our services and products.
	</c:otherwise>
</c:choose>
<br/><br/>
Your personal information (but not your sensitive information) may be held by some of our service providers in an overseas location, the details of which can be found in our privacy policy. In this privacy policy, you can also find out more about the information we hold and how to correct it, as well as how to make a complaint and how this complaint will be handled.&nbsp;&nbsp;<a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank">View Privacy Policy</a>
</ui:dialog>

<ui:dialog id="participatingSuppliers" width="400" titleDisplay="false">
<c:choose>
<c:when test="${vertical eq 'life'}">
	${brandedName} compares life insurance products from the following brands:
</c:when>
<c:otherwise>
	${brandedName} compares life insurance and income protection products from the following insurers:
</c:otherwise>
</c:choose>
<ul>
	<li>AIA</li>
	<li>AMP</li>
	<li>Asteron Life</li>
	<li>CommInsure</li>
	<li>OnePath</li>
	<c:if test="${vertical eq 'life'}">
		<li>Ozicare</li>
	</c:if>
	<li>TAL</li>
	<li>Zurich</li>
</ul>
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

	.${name}InfoDialogContainer.ui-dialog .ui-dialog-content,
	#participatingSuppliersDialog {
		padding: 22px;
	}

	.${name}InfoDialogContainer.ui-dialog .ui-dialog-content {
		text-align: justify;
	}

	#participatingSuppliersDialog {
		line-height: 18px;
	}

		#participatingSuppliersDialog ul {
			margin-top: 10px;
			list-style: disc;
			padding-left: 10px;
			margin-left: 8px;
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