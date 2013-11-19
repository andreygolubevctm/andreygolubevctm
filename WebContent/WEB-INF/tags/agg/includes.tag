<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="onready">
	$('#contact_email').on('blur',function() { $(this).val($.trim($(this).val())); });
</go:script>