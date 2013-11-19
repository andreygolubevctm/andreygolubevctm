<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="The additional what is next question"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="health_whats-next">

	<form:fieldset legend=" ">
		<form:row label='What\'s Next?'>
			<div class="fieldrow_value"><p>Find out more about your <a href="javascript:void(0);">next steps here</a></p></div>
		</form:row>
	</form:fieldset>

</div>




<%-- CSS --%>
<go:style marker="css-head">
.health_whats-next .fieldrow_value p {
	margin-top:10px;
}
#${name} h4 {
	height:4px;
	padding:0px;
}
</go:style>

<go:script marker="onready">
 $('#${name}').find('a').on('click', function(){
	$('#more_snapshotDialog').dialog({ 'dialogTab':3 }).dialog('open');
  }); 
</go:script>