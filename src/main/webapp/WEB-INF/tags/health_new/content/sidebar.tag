<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- <health_content:xxx /> --%>
<health_content:snapshot/>
<content:get_random_content cssClass="sidebar-box" contentKey="healthTestimonials" />
<health_content:call_centre_help />