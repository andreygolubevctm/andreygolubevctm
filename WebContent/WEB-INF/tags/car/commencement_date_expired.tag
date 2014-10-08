<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Smaller Templates to reduce duplicate code --%>
<core:js_template id="expired-commencement-date-template">
	<h6>Please note:</h6>
	<div>
		The commencement date you entered for your car insurance comparison has now expired. In order to receive quotes, we have automatically updated this commencement date to reflect today's date: <strong>{{= obj.updatedDate}}</strong> (AEST)
	</div>
</core:js_template>