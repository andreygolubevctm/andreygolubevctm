<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Kamplye button" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--

	See associated kampyle.js module and kampyle.less

--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="formId" 	required="true"	 rtexprvalue="true"	 description="Kampyle Form Id" %>



<%-- HTML --%>
<div id="kampyle" data-kampyle-formid="${formId}"><a href="https://www.kampyle.com/feedback_form/ff-feedback-form.php?site_code=7343362&amp;lang=en&amp;form_id=${formId}"  target="kampyleWindow" id="kampylink" class="k_static btn btn-primary"><span class="visible-xs">Feedback</span></a></div>

<go:style marker="css-href" href="common/kampyle/css/k_button.css" />
<script src="common/kampyle/js/k_button.js" type="text/javascript"></script>
<script src="common/kampyle/js/k_push.js" type="text/javascript"></script>