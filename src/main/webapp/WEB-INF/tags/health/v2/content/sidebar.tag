<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- <health_content:xxx /> --%>
<health_v2_content:snapshot/>
<health_v1_content:call_centre_help />
<content:get_random_content cssClass="sidebar-box testimonials" contentKey="healthTestimonials" />
<health_v2_content:price_promise />