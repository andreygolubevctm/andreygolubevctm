<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="HOMELOAN" authenticated="true" />

<core_v2:quote_check quoteType="homeloan" />

<layout_v1:journey_engine_page title="Home Loan Confirmation">

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
		<core_v1:whitelabeled_footer/>
	</jsp:attribute>

    <jsp:attribute name="xs_results_pagination">
		<div class="navbar navbar-default xs-results-pagination navMenu-row-fixed visible-xs">
            <div class="container">
                <ul class="nav navbar-nav ">
                    <li class="navbar-text center hidden" data-results-pagination-pagetext="true"></li>

                    <li>
                        <a data-results-pagination-control="previous" href="javascript:;" class="btn-pagination" data-analytics="pagination previous"><span class="icon icon-arrow-left"></span>
                            Prev</a>
                    </li>

                    <li class="right">
                        <a data-results-pagination-control="next" href="javascript:;" class="btn-pagination " data-analytics="pagination next">Next <span class="icon icon-arrow-right"></span></a>
                    </li>
                </ul>
            </div>
        </div>
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

</layout_v1:journey_engine_page>
