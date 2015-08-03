<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the age the driver obtained their full Australian driver licence "%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 			required="true"	 rtexprvalue="true"	 description="slider's id" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="true"  rtexprvalue="true"	 description="title of slider" %>
<%@ attribute name="helpId" 		required="true"  rtexprvalue="true"	 description="the slider's helpId" %>
<%@ attribute name="value" 			required="true"  rtexprvalue="true"	 description="the slider's initial value" %>

<%-- VARIABLES --%>

<%-- HTML --%>
<div class="sliderWrapper">
	<label>${title}</label><span>Not important</span>
	<div class="slider ui-slider ui-slider-horizontal ui-widget ui-corner-all" style="background-color:transparent"><a style="left: 0%;" class="ui-slider-handle ui-state-default ui-corner-all" href="javascript:void(0);"></a></div>
	<input name="${id}" value="${value}" id="${id}" type="hidden">
	<div class="help_icon" id="help_${helpId}"> </div>
</div>