<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Postcode and state disambiguation fields"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="the subject of the field" %>
<%@ attribute name="stateRow"	required="false" rtexprvalue="true"	 description="if the state refining fields should be displayed in a row or not" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="splitXpath" value="${fn:split(xpath, '/')}" />
<c:set var="parentXpath">
	<c:forEach var="node" items="${splitXpath}" varStatus="loop">
		<c:if test="${not loop.last}">${node}/</c:if>
	</c:forEach>
</c:set>
<c:set var="parentXpath" value="${fn:substring(parentXpath, 0, fn:length(parentXpath)-1 )}" />
<c:set var="parentName" value="${go:nameFromXpath(parentXpath)}" />

<c:if test="${empty stateRow}">
	<c:set var="stateRow" value="true" />
</c:if>

<c:choose>
	<c:when test="${stateRow == true}">
		<c:set var="stateHtml">
			<form:row label="State">
				<field:array_radio items="A=A,B=B" id="${parentName}_state_refine" xpath="${parentXpath}/state_refine" title="the applicable state." required="true" className="" />
			</form:row>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="stateHtml">
			<field:array_radio items="A=A,B=B" id="${parentName}_state_refine" xpath="${parentXpath}/state_refine" title="the applicable state." required="true" className="" />
		</c:set>
	</c:otherwise>
</c:choose>
<c:set var="newLine" value="\r\n" />
<c:set var="stateHtml" value="${go:replaceAll(stateHtml, newLine, '')}" />

<%-- HTML --%>
<field:hidden xpath="${parentXpath}/state" required="false" />
<field:post_code xpath="${xpath}" title="${title}" required="${required}" className="${className}" />

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="${name}__validateState" parm="true" message="Must enter a valid 4 digit postcode." />
<go:validate selector="${parentName}_state" rule="required" parm="true" message="No state has been found." />

<go:script marker="js-head">
var ${name}__PostCodeStateHandler = {
	current_state : '',
	state_html : '${stateHtml}'
};
</go:script>

<go:script marker="onready">
	$("#${name}").on("change", function(){
		$(this).valid();
	});

	$.validator.addMethod("${name}__validateState",
		function(value, element) {
			var passed = true;

			if( String(value).length > 3 && value != ${name}__PostCodeStateHandler.current_state )
			{
				$.ajax({
					url: "ajax/json/get_state.jsp",
					data: {postCode:value},
					type: "POST",
					async: true,
					cache: false,
					success: function(jsonResult){
						var count = Number(jsonResult[0].count);
						var state = jsonResult[0].state;
						${name}__PostCodeStateHandler.current_state = state;
						switch( count )
						{
							case 2:
								if( $('#${parentName}_state_refine').length == 0){
									if( $('#${name}').parents('.fieldrow').length != 0 ){
										$('#${name}').parents('.fieldrow').after(${name}__PostCodeStateHandler.state_html);
									} else {
										$('#${name}').after(${name}__PostCodeStateHandler.state_html);
									}
								}

								$("#${parentName}_state_refine").parents(".fieldrow").show('fast', function(){
									$("#${parentName}_state_refine").buttonset();
								});

								var states = state.split(", ");

								$("#${parentName}_state_refine_A").val(states[0]);
								$('#${parentName}_state_refine label:first span').empty().append(states[0]);

								$("#${parentName}_state_refine_B").val(states[1]);
								$('#${parentName}_state_refine label:last span').empty().append(states[1]);

								$("input[name=${parentName}_state_refine]").on('change', function(){
									$("#${parentName}_state").val($(this).val()).trigger('change');
								});
								passed = true;
								break;
							case 1:
								$("#${parentName}_state").val( state );
								$("#${parentName}_state_refine").parents(".fieldrow").hide();
								passed = true;
								break;
							default:
								$("#${parentName}_state").val("");
								$("#${parentName}_state_refine").parents(".fieldrow").hide();
								passed = false;
								break;
						}
						$("#${parentName}_state").trigger('change');
					},
					dataType: "json",
					error: function(obj,txt){
						passed = false;
					},
					timeout:60000
				});
			} else {
				$("#${parentName}_state_refine").parents(".fieldrow").hide();
				$("#${parentName}_state").val("").trigger('change');
			}

			return passed;
		},
		"Replace this message with something else"
	);
</go:script>