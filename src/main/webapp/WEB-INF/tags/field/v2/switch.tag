<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="On/off toggle switch"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	Currently implementation of this tag uses Bootstrap Switch http://www.bootstrap-switch.org/
	Plugin files:
		framework/modules/less/bootstrap-switch.less
		framework/jquery/plugins/bootstrap-switch-xxx.min.js

	Checkbox property changes:
		CHECKED:
			$(element).prop('checked', true|false).change(); //change() will trigger the plugin to update classes etc.
			or
			$(element).bootstrapSwitch('toggleState');
			or
			$(element).bootstrapSwitch('setState', true|false);

		DISABLED:
			$(element).bootstrapSwitch('setDisabled', true|false);

	Events:
		CHANGE:
			$(element).on('switch-change', function (e, data) {
				var $element = $(data.el),
					value = data.value;
				console.log(e, $element, value);
			});
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="value" 		required="true"	 rtexprvalue="true"	 description="The switch's value"%>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="The switch's title"%>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="css class attribute" %>
<%@ attribute name="required" 	required="false" rtexprvalue="true"  description="is this switch required?" %>
<%@ attribute name="onText" 	required="false" rtexprvalue="true"  description="Text for the on state. Default: ON" %>
<%@ attribute name="offText" 	required="false" rtexprvalue="true"  description="Text for the off state. Default: OFF" %>
<%@ attribute name="additionalAttributes"	required="false" rtexprvalue="true"  description="Additional Attributes" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="xpathval"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="checked" value="" />

<c:if test='${xpathval==value}'>
	<c:set var="checked" value=" checked='checked'" />
</c:if>

<c:if test="${empty className}">
	<%-- Default implementation styles this class --%>
	<c:set var="className" value="switch-small" />
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required" data-msg-required="Please select ${title}"' />
</c:if>

<c:if test="${empty onText}">
	<c:set var="onText" value="ON" />
</c:if>

<c:if test="${empty offText}">
	<c:set var="offText" value="OFF" />
</c:if>


<%-- HTML --%>
<input type="checkbox" name="${name}" id="${name}" class="checkbox-switch ${className}" value="${value}"${checked}${requiredAttribute} data-text-label="" data-on-label="${onText}" data-off-label="${offText}" ${additionalAttributes}>
