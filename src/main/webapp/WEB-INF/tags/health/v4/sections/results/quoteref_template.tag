<%@ tag description="The Health Quote Reference template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<div class="quote-reference">
    <p>Quote Reference:<span># {{= meerkat.modules.transactionId.get() }}</span></p>
</div>