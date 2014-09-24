<%@ tag description="Generic Confirmation Page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>
<%@ attribute name="header" fragment="true" required="true" %>
<%@ attribute name="form_bottom" fragment="true" required="true" %>
<%@ attribute name="footer" fragment="true" required="true" %>
<%@ attribute name="body_end" fragment="true" required="true" %>


<layout:page sessionPop="false" kampyle="false" title="${title}">

	<jsp:attribute name="head">
		<%-- Required to fix base path for resources --%>
		<base href="${pageSettings.getBaseUrl()}" />
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav">
		<li><a href="javascript:window.print();" class="btn-email"><span
					class="icon icon-blog"></span> <span>Print Page</span></a></li>
		<c:if test="${empty callCentre && pageSettings.hasSetting('quoteUrl')}">
			<li>
				<a href="${pageSettings.getBaseUrl()}${pageSettings.getSetting('quoteUrl')}"
				class="btn-cta needsclick"><span class="icon icon-undo"></span> <span>Start a new quote</span> <span class="icon icon-arrow-right hidden-xs"></span></a>
			</li>
		</c:if>
		</ul>
	</jsp:attribute>

	<jsp:body>
		<article id="page" class="container">
			<layout:slide formId="confirmationForm" className="displayBlock">
				<layout:slide_content>
					<div id="confirmation" class="more-info-content">
						<layout:slide_columns>

							<jsp:attribute name="rightColumn">
							</jsp:attribute>

							<jsp:body>

								<layout:slide_content>

									<ui:bubble variant="chatty">
										<jsp:doBody />
									</ui:bubble>

									<confirmation:other_products />
									<c:if test="${pageSettings.getVerticalCode() ne 'generic'}">
										<confirmation:optin email="${data.confirmationOptIn.emailAddress}" />
									</c:if>

								</layout:slide_content>

							</jsp:body>
						</layout:slide_columns>
					</div>
				</layout:slide_content>
			</layout:slide>
		</article>

		<agg:footer_outer>
			<jsp:invoke fragment="footer" />
		</agg:footer_outer>
	</jsp:body>

</layout:page>