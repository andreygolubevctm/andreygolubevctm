<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="source"	required="true"	rtexprvalue="true"	description="The source label which matches a url element in settings xml - external-url" %>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
<c:choose>
	<c:when test="${source eq 'ctp-nsw'}">
(function(){

	var wrapper = $('<div/>')
	.addClass('header-links');

	var text = $('<div/>')
	.addClass('head-line')
	.append("Remember CTP doesn't cover everything! Compare great<br>value car insurance policies to help drive your dollar further.");

	var button = $('<a/>',{
		href:	"http://www.comparethemarket.com.au/car-insurance/",
		text :	"Compare Car Insurance"
	})
	.addClass('related-link standardButton blueButton')
	.append(
		$('<div/>').addClass('icon')
	);


	wrapper.append(button);
	wrapper.append(text);
	wrapper.insertAfter('#header h1:first');
}())
	</c:when>
</c:choose>
</go:script>