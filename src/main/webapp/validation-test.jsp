<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="GENERIC"/>

<core_new:quote_check quoteType="generic"/>
<core_new:load_preload/>

<%-- HTML --%>
<layout:journey_engine_page title="Validation Test">

    <jsp:attribute name="head"></jsp:attribute>
    <jsp:attribute name="head_meta"></jsp:attribute>
    <jsp:attribute name="header_button_left"></jsp:attribute>

	<jsp:attribute name="header">

	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav" role="menu">
            <li class="visible-xs">
                <span class="navbar-text-block navMenu-header">Menu</span>
            </li>
            <li class="slide-feature-back visible-xs">
                <a href="javascript:;" data-slide-control="previous" class="btn-back">
                    <span class="icon icon-arrow-left"></span> <span>Revise Your Details</span></a>
            </li>
        </ul>

		<div class="coverLevelTabs hidden-xs">
            <div class="currentTabsContainer">
            </div>
        </div>
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">

	</jsp:attribute>


    <jsp:attribute name="xs_results_pagination"></jsp:attribute>

    <jsp:attribute name="form_bottom"></jsp:attribute>
			
	<jsp:attribute name="footer">
	</jsp:attribute>
			
	<jsp:attribute name="vertical_settings">
		<travel:settings/>
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

    <jsp:body>

        <layout:slide formId="detailsForm" nextLabel="Next Step">

            <layout:slide_content>

                <form_new:fieldset_columns sideHidden="false">

			<jsp:attribute name="rightColumn">
			</jsp:attribute>

                    <jsp:body>

                        <form_new:fieldset legend="Dates &amp; Travellers" className="travel_details_datesTravellers" id="datestravellersfs">
                            <form_new:row label="What type of cover are you looking for?" fieldXpath="utilities/test">
                                <field:person_name xpath="utilities/test" required="true" title=" your last name" />
                            </form_new:row>

                            <form_new:row fieldXpath="utilities/postcode" label="Postcode" id="test_postCode_suburb" className="test_nonStdFieldRow">
                                <field:post_code xpath="utilities/postcode" required="true" title="your postcode" />
                            </form_new:row>

                        </form_new:fieldset>
                    </jsp:body>
                </form_new:fieldset_columns>

            </layout:slide_content>

        </layout:slide>

    </jsp:body>

</layout:journey_engine_page>