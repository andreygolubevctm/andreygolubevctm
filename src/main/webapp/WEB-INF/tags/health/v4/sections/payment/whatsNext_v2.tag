<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="The additional what is next question"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class='next-steps_v2'>
    <h3>What's Next?</h3>
    <p>You are so close to purchasing health insurance! Want to know what happens next?</p>
</div>

<health_v4:accordion id="whats_next_accordion">
    <jsp:attribute name="title">
        <div class="inline">Here is some information from your provider about what happens next.</div>
    </jsp:attribute>
    <jsp:body>
        <div class='next-steps-content'></div>
    </jsp:body>
</health_v4:accordion>