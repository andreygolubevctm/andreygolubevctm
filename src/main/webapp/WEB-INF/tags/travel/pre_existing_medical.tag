<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>
<c:set var="fieldXpath" value="travel/preExistingMedical" />
<form_v2:row label="Do you have a pre-existing medical condition?" fieldXpath="${fieldXpath}" className="clear cover-type">
    <field_v2:array_radio xpath="${fieldXpath}" required="true"
        className="pre-exisiting-medical" items="Y=Yes,N=No"
        id="${go:nameFromXpath(xpath)}" title="existing conditions" />
</form_v2:row>
