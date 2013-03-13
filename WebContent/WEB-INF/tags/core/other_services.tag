<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="vertical" 	required="true"		rtexprvalue="true"	 description="Name of the vertical to match the li item" %>

<%-- HTML --%>
<div id="ctm_other_services" class="${className}">
	<p>Have you considered you other insurance needs?</p>
	<p>Compare the Market also does</p>
	<ul>
		<li class="cos_car">Car Insurance</li>
		<li class="cos_health">Health Insurance</li>
		<li class="cos_ip">Income Protection Insurance</li>
		<li class="cos_life">Life Insurance</li>
		<li class="cos_roadside">Roadside Assistance</li>
		<li class="cos_fuel">Fuel price comparison and more</li>
	</ul>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#ctm_other_services ul li {
	font-size:					120%;
	font-weight:				normal;
	padding:					2px 0 2px 10px;
	background:					transparent url(brand/ctm/images/bullet_edit.png) center left no-repeat;
}
</go:style>

<go:script marker="onready">
$('#ctm_other_services').find('li.cos_${vertical}').each(function(){
	$(this).hide();
});
</go:script>