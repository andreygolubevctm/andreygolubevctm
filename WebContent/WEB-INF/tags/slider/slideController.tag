<%--
	Represents the navigation buttons between panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for the navigation container"%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="optional css class attribute bor buttons" %>

<div id="${id}" class="button-wrapper">
	<a href="javascript:void(0);" class="button prev ${className}" id="prev-step"><span>Previous step</span></a>
	<a href="javascript:void(0);" class="button next ${className}" id="next-step"><span>Next step</span></a>
</div>