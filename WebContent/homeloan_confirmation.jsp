<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="HOMELOAN" authenticated="true" />

<core:quote_check quoteType="homeloan" />

<layout:journey_engine_page title="Homeloan Confirmation" sessionPop="false">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav confirmation">
		<li><a href="javascript:window.print();" class="btn-email"><span class="icon icon-blog"></span> <span>Print Page</span></a></li>
		<c:if test="${empty callCentre}">
			<li>
				<a href="${pageSettings.getBaseUrl()}homeloan_quote.jsp" class="btn-cta needsclick"><span class="icon icon-undo"></span> <span>Start a new quote</span> <span class="icon icon-arrow-right hidden-xs"></span></a>
			</li>
		</c:if>
		</ul>
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<homeloan:footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<homeloan:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:attribute name="before_close_body">
		<%-- get specific beforeCloseBody content for confirmmation. e.g tracking code for white-label brand --%>
		<content:get key="beforeCloseBody" suppKey="confirmation" />
	</jsp:attribute>

	<jsp:body>
		<homeloan_layout:slide_confirmation />
	</jsp:body>

</layout:journey_engine_page>
