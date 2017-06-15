<%@ tag description="Container for testimonials" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%-- VARIABLES --%>
<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="contactDtlsTestimonials"><content:get key="contactDtlsTestimonial" /></c:set>



<c:if test="${journeyVertical eq 'health'}">

    <c:if test="${not empty contactDtlsTestimonials}">
        <div class="testimonial-tile-container"></div>
        <core_v1:js_template id="testimonial-template">
            ${contactDtlsTestimonials}
        </core_v1:js_template>
    </c:if>

</c:if>