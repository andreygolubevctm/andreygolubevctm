<%@ tag description="Journey Engine Page - Full width" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>
<%@ attribute required="false" name="body_class_name" description="Allow extra styles to be added to the rendered body tag" %>
<%@ attribute name="ignore_journey_tracking" required="false" rtexprvalue="true" description="Ignore Journey Tracking" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_additional" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="progress_bar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>
<%@ attribute fragment="true" required="true" name="vertical_settings" %>

<%@ attribute fragment="true" required="false" name="results_loading_message" %>
<%@ attribute fragment="true" required="false" name="before_close_body" %>

<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
<c:set var="verticalCode" value="${pageSettings.getVerticalCode()}" />
<c:if test="${verticalCode eq 'car'}">
    <c:set var="verticalCode" value="quote" />
</c:if>

<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>

<layout_v1:page_fluid title="${title}" body_class_name="${body_class_name}">

	<jsp:attribute name="head">
		<jsp:invoke fragment="head" />
	</jsp:attribute>

    <jsp:attribute name="head_meta">
		<jsp:invoke fragment="head_meta" />
	</jsp:attribute>

    <jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

    <jsp:attribute name="header_button_left"><jsp:invoke fragment="header_button_left" /></jsp:attribute>

    <jsp:attribute name="navbar">
		<jsp:invoke fragment="navbar" />
	</jsp:attribute>

    <jsp:attribute name="navbar_additional">
		<jsp:invoke fragment="navbar_additional" />
	</jsp:attribute>

    <jsp:attribute name="navbar_outer">
		<jsp:invoke fragment="navbar_outer" />
	</jsp:attribute>

    <jsp:attribute name="progress_bar">
		<jsp:invoke fragment="progress_bar" />
	</jsp:attribute>

    <jsp:attribute name="xs_results_pagination">
        <div class="navbar navbar-default xs-results-pagination navMenu-row-fixed visible-xs">

            <div class="container">
                <ul class="nav navbar-nav ">
                    <li class="navbar-text center hidden" data-results-pagination-pagetext="true"></li>

                    <li>
                        <a data-results-pagination-control="previous" href="javascript:;" class="btn-pagination"><span class="icon icon-arrow-left"></span> Prev</a>
                    </li>

                    <li class="right">
                        <a data-results-pagination-control="next" href="javascript:;" class="btn-pagination ">Next <span class="icon icon-arrow-right"></span></a>
                    </li>
                </ul>
            </div>
        </div>
	</jsp:attribute>

    <jsp:attribute name="vertical_settings">
		<jsp:invoke fragment="vertical_settings" />
	</jsp:attribute>

    <jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
		<jsp:invoke fragment="additional_meerkat_scripts" />
	</jsp:attribute>

    <jsp:attribute name="before_close_body">
		<content:get key="beforeCloseBody" suppKey="journey" />
		<jsp:invoke fragment="before_close_body" />
	</jsp:attribute>

    <jsp:body>

        <div id="pageContent">

            <article class="container-fluid no-padding">

                <div id="journeyEngineContainer">

                    <div id="mainform" class="form-horizontal">

                        <c:if test="${ignore_journey_tracking != 'true'}">
                            <core_v2:journey_tracking />
                        </c:if>

                        <core_v2:tracking_key />
	                    <core_v2:gaClientId />
	                    <core_v2:affiliateProperties />

                        <div id="journeyEngineSlidesContainer">
                            <jsp:doBody />
                        </div>

                        <input
                                type="hidden"
                                id="${verticalCode}_journey_stage"
                                name="${verticalCode}_journey_stage"
                                value="${data[verticalCode]['journey/stage']}"
                                class="journey_stage"
                        />

                        <jsp:invoke fragment="form_bottom" />

                        <c:if test="${pageSettings.hasSetting('sendBestPriceSplitTestingEnabled')}">
                            <c:if test="${pageSettings.getSetting('sendBestPriceSplitTestingEnabled') eq 'Y' && not empty param.splitEmail }">
                                <field_v1:hidden xpath="${verticalCode}/bestPriceSplitTest" defaultValue="${param.splitEmail eq 2 ? 2 : 1 }" />
                            </c:if>
                        </c:if>
                    </div>
                </div>

            </article>

        </div>


        <agg_v1:footer_outer>
            <jsp:invoke fragment="footer" />
        </agg_v1:footer_outer>

    </jsp:body>

</layout_v1:page_fluid>