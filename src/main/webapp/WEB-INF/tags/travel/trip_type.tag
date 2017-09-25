<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%--HTML--%>
<c:set var="fieldXpath" value="travel/tripType" />
<form_v2:row label="Will you be participating in any of the following activities?" fieldXpath="${fieldXpath}" className="clear trip-type">
    <div class="row">
        <div class="col-xs-6 col-sm-5">
            <field_v2:checkbox
                    xpath="travel/activity/snowSports"
                    value="snowSports"
                    required="false"
                    title="Snow sports"
                    label="true" />
        </div>
        <div class="col-xs-6 col-sm-7">
            <field_v2:help_icon helpId="576" tooltipClassName="" />
        </div>
    </div>
    <div class="row">
        <div class="col-xs-6 col-sm-5">
            <field_v2:checkbox
                    xpath="travel/activity/cruising"
                    value="cruising"
                    required="false"
                    title="Cruising"
                    label="true" />
        </div>
        <div class="col-xs-6 col-sm-7">
            <field_v2:help_icon helpId="577" tooltipClassName="" />
        </div>
    </div>
    <div class="row">
        <div class="col-xs-6 col-sm-5">
            <field_v2:checkbox
                    xpath="travel/activity/adventureSports"
                    value="adventureSports"
                    required="false"
                    title="Adventure Sports"
                    label="true" />
        </div>
        <div class="col-xs-6 col-sm-7">
            <field_v2:help_icon helpId="578" tooltipClassName="" />
        </div>
    </div>
</form_v2:row>