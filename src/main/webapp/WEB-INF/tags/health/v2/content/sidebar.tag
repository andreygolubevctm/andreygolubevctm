<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- <health_content:xxx /> --%>
<simples:snapshot />
<simples:clinical_category_selections />
<health_v2_content:snapshot/>
<coupon:promo_tile />
<%-- TODO Temporarily disabled until part 2 --%>
<%--<health_v2_content:benefits_help />--%>
<health_v1_content:call_centre_help />