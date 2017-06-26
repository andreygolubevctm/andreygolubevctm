<%@ tag description="Container for testimonials" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="contactDtlsTestimonials"><content:get key="contactDtlsTestimonial" /></c:set>

<c:if test="${not empty contactDtlsTestimonials}">
    <core_v1:js_template id="testimonial-template">
        ${contactDtlsTestimonials}
    </core_v1:js_template>
</c:if>