<%@ tag description="Journey Engine Page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>
<%@ attribute name="navbar_show_back_button" required="false" rtexprvalue="true" description="Flag to show or hide the back button within the navbar" %>
<%@ attribute required="false" name="body_class_name" description="Allow extra styles to be added to the rendered body tag" %>
<%@ attribute name="ignore_journey_tracking" required="false" rtexprvalue="true" description="Ignore Journey Tracking" %>
<%@ attribute name="bundleFileName" required="false" rtexprvalue="true" description="Pass in an alternate file name" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar_save_quote" %>
<%@ attribute fragment="true" required="false" name="navbar_additional_options" %>
<%@ attribute fragment="true" required="false" name="navbar_pagination" %>

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
<c:if test="${empty navbar_show_back_button}">
    <c:set var="navbar_show_back_button">${true}</c:set>
</c:if>
<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>

<layout_v3:page title="${title}" body_class_name="${body_class_name}" bundleFileName="${bundleFileName}">

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
		<ul class="nav navbar-nav">
			<c:if test="${navbar_show_back_button eq true}">
			<li class="slide-feature-back">
                <a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
            </li>
			</c:if>
            <c:if test="${not empty navbar_save_quote}">
			<li class="dropdown dropdown-interactive slide-feature-emailquote" id="email-quote-dropdown">
                <a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span><c:choose><c:when
                        test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when><c:otherwise>Email Quote</c:otherwise></c:choose></span> <b class="caret"></b></a>
                <div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
                    <div class="dropdown-container">
                        <jsp:invoke fragment="navbar_save_quote" />
                    </div>
                </div>
            </li>
			</c:if>
            <c:if test="${not empty navbar_additional_options}">
				<jsp:invoke fragment="navbar_additional_options" />
			</c:if>
        </ul>
			<c:if test="${not empty navbar_pagination}">
				<jsp:invoke fragment="navbar_pagination" />
			</c:if>
		</ul>
	</jsp:attribute>

    <jsp:attribute name="navbar_additional">
		<jsp:invoke fragment="navbar_additional" />
	</jsp:attribute>

    <jsp:attribute name="navbar_outer">
		<jsp:invoke fragment="navbar_outer" />
	</jsp:attribute>

    <jsp:attribute name="progress_bar">
		<div class="progress-bar-row collapse navbar-collapse">
            <div class="container">
                <ul class="journeyProgressBar_v2"></ul>
            </div>
        </div>
	</jsp:attribute>

    <jsp:attribute name="xs_results_pagination">
        <jsp:invoke fragment="xs_results_pagination" />
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

            <article class="container">

                <div id="journeyEngineContainer">
                    <div id="journeyEngineLoading" class="journeyEngineLoader opacityTransitionQuick">
                        <div class="loading-logo"></div>
                        <p class="message">Please wait...</p>
                        <jsp:invoke fragment="results_loading_message" />
                    </div>

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

</layout_v3:page>