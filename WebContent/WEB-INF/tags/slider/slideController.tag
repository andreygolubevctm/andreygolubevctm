<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="true"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="true"  rtexprvalue="true"	 description="optional id for this slide controller"%>

<%-- HTML
<div id="${id}">
	<span class="${className}"></span>
	<span class="${className}"></span>
	<span class="${className}"></span>
	<span class="${className}"></span>
	<span class="${className}"></span>
	<span class="${className}"></span>	
</div>
 
<span class="jFlowPrev"></span>
<span class="jFlowNext"></span>
 --%>
 
<a href="javascript:void(0);" class="button prev" id="prev-step">Previous step</a>
<a href="javascript:void(0);" class="button next" id="next-step">Next step</a>