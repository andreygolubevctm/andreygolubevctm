<%@ tag description="Simples Confirm all data is correct before submit modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<core_v1:js_template id="payment-confirm-details-modal-template">

    <div class="simples-dialogue">
        <p>Just before I submit your application, I want to check I have all of your information in correctly</p>
    </div>

    <%--your details  health_v2_confirmation  --%>
    <health_v2_confirmation:your_details />

    <%--others details--%>
    <health_v2_confirmation:others_details />

    <%--the form--%>
    <health_v2_confirmation:form />

    <div class="phonetic-alphabet">
      <ul></ul>
    </div>

</core_v1:js_template>
