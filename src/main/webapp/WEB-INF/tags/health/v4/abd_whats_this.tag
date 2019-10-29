<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="shortTitle" 	required="true"	 rtexprvalue="true"	 description="determines if we should render the short link" %>

<c:set var="abdModalContent" scope="request"><content:get key="abdModalContent"/></c:set>

<div class="abd-modal-trigger">
  <a class="dialogPop" data-content="${abdModalContent}" title="What is the Age-Based Discount?">${shortTitle ? "What's this?" : "What is an Age-Based Discount?" }</a>
</div>