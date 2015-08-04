<%@ tag description="Competition Journey's 'Entry' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="reference" required="true"	 rtexprvalue="true"	 description="competition reference" %>
<%@ attribute name="cid" required="true"	 rtexprvalue="true"	 description="campaign id" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}" />

<layout:slide formId="mainForm" firstSlide="true" nextLabel="Enter Competition" offsetRight="True">
	<layout:slide_content>
		<competition:contact_details xpath="${xpath}" cid="${cid}" reference="${reference}" />
	</layout:slide_content>
</layout:slide>