<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%--HTML--%>
<c:set var="fieldXpath" value="travel/tripType" />
<form_v2:row label="Will you be participating in any of the following activities?" className="clear trip-type">
    <div class="row">
        <div class="col-xs-12 row-content">
            <div class="btn-group btn-group-justified thinner_input trip_type roundedCheckboxIcons">
                <label class="btn btn-form-inverse icon-trip-type-cruise">
                    <input data-attach="true" type="checkbox" name="travel_tripType_cruising" id="travel_tripType_cruising" value="cruising" data-msg-required="Please choose trip types" aria-required="true">
                    Cruising
                </label>
                <field_v2:help_icon helpId="577" tooltipClassName="" />
                <label class="btn btn-form-inverse icon-trip-type-snow">
                    <input data-attach="true" type="checkbox" name="travel_tripType_snowSports" id="travel_tripType_snowSports" value="snowSports" data-msg-required="Please choose trip types" aria-required="true">
                    Snow sports
                </label>
                <field_v2:help_icon helpId="576" tooltipClassName="" />
            </div>
        </div>
    </div>
</form_v2:row>