<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="additional css class attribute" %>

<p class="inc-gst ${className}">
    All prices are inclusive of GST &amp; Gov Charges
</p>