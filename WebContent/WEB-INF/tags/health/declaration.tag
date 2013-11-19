<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health_declaration">

	<form:fieldset legend=" ">
		<form:row label="Australian Government Rebate Form" className="ausgovtrebateform">
			<field:checkbox xpath="${xpath}/rebateForm" value="Y" title="Do you authorise <em class='AHM'>ahm Health Insurance</em> to lodge the rebate form on your behalf?" required="false" label="true"/>
		</form:row>

		<form:row label='Join <a href="javascript:void(0);" id="join-declaration-dialog-link">declaration</a> for <span>Provider</span>'>
			<field:checkbox xpath="${xpath}" value="Y" title="I confirm that I have read and understood the attached declaration and the information relating to my product choice. I declare that the information I have provided is true and correct." required="true" label="true"/>
		</form:row>
	</form:fieldset>

</div>

<health:popup_join_declaration />

<%-- CSS --%>
<go:style marker="css-head">
	#${name}-selection a {
		font-size:100%;
		text-transform:capitalize;
	}
	#${name}-selection h4 {
		padding:0px;
		height:5px;
	}
	#${name}-selection .fieldrow_value {
		margin-top:8px;
	}
	#${name}-selection label {
		max-width:350px;
		float:right;
		margin-left:10px;
	}
	.ausgovtrebateform {
		display:none;
	}
	<%-- Showing or Hiding the final dec. based on client/call centre --%>
	<c:choose>
		<c:when test="${not callCentre}">
			.callCentreDeclaration {
				display:none !important;
			}
		</c:when>
		<c:otherwise>
			.clientDeclaration {
				display:none !important;
			}
		</c:otherwise>
	</c:choose>
</go:style>


<go:script marker="onready">
	$("#mainform").validate().settings.messages.health_declaration.required='Please read the declaration in order to proceed';
	
	$("#join-declaration-dialog-link").on("click", function(){
		JoinDeclarationDialog.launch();
	});	
</go:script>