<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="policyType" 	required="true"	 rtexprvalue="true"	 description="Defines if this is a single or AMT" %>

<layout:slide className="resultsSlide">
	<layout:slide_content>
		<travel:results policyType="${param.policyType}"/>
	</layout:slide_content>
</layout:slide>