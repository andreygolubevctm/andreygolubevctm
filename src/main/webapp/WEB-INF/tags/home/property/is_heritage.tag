<%@ tag description="Is Heritage" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- Heritage Listed --%>
<c:set var="fieldXpath" value="${xpath}/isHeritage" />
<form_v2:row fieldXpath="${fieldXpath}" label="Is the home heritage listed?" className="heritage">
    <field_v2:array_radio xpath="${fieldXpath}"
                          required="true"
                          className="pretty_buttons"
                          items="Y=Yes,N=No"
                          title="if the home is heritage listed?"/>
</form_v2:row>