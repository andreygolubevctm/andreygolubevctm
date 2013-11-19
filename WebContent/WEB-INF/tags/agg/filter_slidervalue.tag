<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the age the driver obtained their full Australian driver licence "%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="productCat" 	required="true"	 rtexprvalue="true"	 description="product Category" %>
<%@ attribute name="propertyId" 	required="true"	 rtexprvalue="true"	 description="slider's property id" %>
<%@ attribute name="id" 			required="true"	 rtexprvalue="true"	 description="slider's id" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="true"  rtexprvalue="true"	 description="title of slider" %>
<%@ attribute name="helpId" 		required="true"  rtexprvalue="true"	 description="the slider's helpId" %>
<%@ attribute name="initValue" 		required="true"  rtexprvalue="true"	 description="the slider's initial value" %>
<%@ attribute name="toolTipHelp"	required="false"  rtexprvalue="true"	 description="should the slider use tooltips for help" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- JAVASCRIPT --%>
<%-- Slider Value init function --%>
<go:script marker="onready">	
	FilterSet.sliderValue = function(sliderWrapper){	
		var related = $(sliderWrapper).find('input');
		var label = $(sliderWrapper).find('span');
	
		// Value sliders 
		$(sliderWrapper).find('.sliderValue').slider({
			'min': 0,
			'max': 100,
			'value': related.val(),
			'animate': true,
			change: function(event, ui) {
				$(related).val(ui.value);
				
				if (event.originalEvent!=undefined) {
					sliderId = $(event.target).closest(".sliderWrapper").find("input");
					FilterSet.filterChanged(sliderId);
				}
			},
			slide: function(event, ui){
				if (ui.value==$(this).slider('option','max')){
					$(label).html("Unlimited");	
				} else {
					$(label).html("$"+ui.value);
				}
			}
			
		});					
	}
</go:script>

<%-- Set up this slider --%>
<go:script marker="onready">
	FilterSet.sliderValue($('#sliderWrapper_${id}'));
	
	<%-- Does the value slider have a step? --%>
	<sql:query var="result">
		SELECT get_property_input_value( '${productCat}', '${propertyId}', 'SLIDERVALUE', 'STEP') as step
	</sql:query>
	
	<c:if test="${result.rowCount > 0}">
		$('#sliderWrapper_${id}').slider('option','step',${result.rows[0].step});
	</c:if>
</go:script>

<%-- HTML --%>
<div class="sliderWrapper sliderValue" id="sliderWrapper_${id}">
	<label>${title}</label><span>${description}</span>
	<div class="slider sliderValue ui-slider ui-slider-horizontal ui-widget ui-corner-all" style="background-color:transparent"><a style="left: 0%;" class="ui-slider-handle ui-state-default ui-corner-all" href="#"></a></div>
	<input name="${id}" value="${value}" id="${id}" type="hidden">
	<%--
	<c:choose>
		<c:when test="${not empty toolTipHelp && toolTipHelp == 'true'}">
		
			<sql:setDataSource dataSource="jdbc/test"/>
			<sql:query var="result">SELECT header, des FROM help WHERE id = "${helpId}" LIMIT 1</sql:query>
			<c:if test="${result.rowCount > 0}">
				<div class="help_icon" id="help_${helpId}" title="&lt;h3&gt;${result.rows[0].header}&lt;/h3&gt;${result.rows[0].des}"></div>
			</c:if>
					
		</c:when>
		<c:otherwise>
			<div class="help_icon" id="help_${helpId}"> </div>
		</c:otherwise>
	</c:choose>
 	--%>
</div>