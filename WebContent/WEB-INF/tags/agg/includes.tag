<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="onready">
	$('#contact_email').on('blur',function() { $(this).val($.trim($(this).val())); });
</go:script>