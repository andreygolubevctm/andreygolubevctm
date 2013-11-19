<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- SETTINGS --%>
<core:load_settings conflictMode="false" />

<c:if test="${not empty conflictProduct}">
	<c:set var="conflictDisplay"><span class="capitalize">${conflictProduct}</span></c:set>
	<c:set var="conflictDisplayAlt">: <span class="capitalize">${conflictProduct}</span></c:set>
</c:if>
<c:if test="${not empty conflictNewProduct}">
	<c:set var="conflictNewDisplay"><span class="capitalize">${conflictNewProduct}</span></c:set>
</c:if>

<go:log>Conflict product? ${conflictProduct}</go:log>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>

	<core:head quoteType="none" title="Conflict with another product detected" nonQuotePage="true" mainCss="common/normal.css" />

	<body class="conflict">
		<form:header quoteType="none" hasReferenceNo="false"/>
		<div id="wrapper">
			<div id="page">
				<div id="content">
					<slider:slideContainer className="sliderContainer">
						<slider:slide id="slide0" title="">
							<h2>Another comparison is already open${conflictDisplayAlt}</h2>
							<p><strong>I'm sorry we have detected that you already have an active session with a ${conflictDisplay} comparison.</strong></h4>
							<p>To ensure you do not lose your current progress we have stopped this new <strong>${conflictNewDisplay}</strong> comparison request.</p>
							<p>Please continue with your active browser tab/window or <a href="redirect.jsp?id=${conflictProduct}_quote.jsp">open a new ${conflictDisplay} comparison</a> here.</p>

							<c:if test="${fn:startsWith(pageContext.request.remoteAddr,'192.168.') or fn:startsWith(pageContext.request.remoteAddr,'0:0:0:') or param.preload==2}">
								<br /><br /><hr /><br />
								<h4>Internal User Feature Only</h4>
								<p><a href="redirect.jsp?id=${conflictNewProduct}_quote.jsp">Force my way onto the ${conflictNewDisplay} comparison</a> and I promise not to use any old tabs or windows!</p>
							</c:if>


						</slider:slide>
					</slider:slideContainer>
				</div>
			</div>
		</div>
		<agg:footer />
	</body>

</go:html>