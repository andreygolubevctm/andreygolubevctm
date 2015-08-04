<%--
	Radio button group validation fix
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="onready">
	// Fix for button groups not showing as valid after a result is chosen
	$(document).on('change', "input[type='radio']", function() {
		$("input[name='" + $(this).attr('name') + "']").valid();
	});
</go:script>