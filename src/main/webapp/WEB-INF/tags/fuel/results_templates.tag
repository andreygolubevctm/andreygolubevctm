<%@ tag description="Fuel Templates" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- NO RESULTS --%>
<div class="hidden">
    <agg_v2:no_quotes id="blocked-ip-address"/>
</div>
<%-- FETCH ERROR --%>
<div class="resultsFetchError displayNone">
    Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later</a>.
</div>