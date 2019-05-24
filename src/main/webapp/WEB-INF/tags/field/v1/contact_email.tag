<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's email address."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="size" 		required="false" rtexprvalue="true"	 description="size of the input box" %>
<%@ attribute name="helptext" 	required="false" rtexprvalue="true"	 description="additional help text" %>
<%@ attribute name="onKeyUp" required="false" rtexprvalue="true"	 description="onKeyUp attribute" %>
<%@ attribute name="placeHolder" required="false" rtexprvalue="true"  description="html5 placeholder" %>
<%@ attribute name="tabIndex"	required="false" rtexprvalue="true"  description="TabIndex of the field" %>

<c:choose>

	<c:when test="${not empty size}">
		<c:set var="size" value="${size}" />
	</c:when>
	<c:otherwise>
		<c:set var="size" value="50" />
	</c:otherwise>
</c:choose>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Only include the classname 'email' when field is required.
	a silent error occurs when field is empty and not required --%>
<c:set var="fieldClasses">
	<c:choose>
		<c:when test="${not required}">${className}</c:when>
		<c:otherwise>email ${className}</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${not empty onKeyUp}">
	<c:set var="onkeypressAttribute" value=" onkeyup='${onKeyUp}'" />
</c:if>

<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderAttribute" value=' placeholder="${placeHolder}"' />
	<c:set var="fieldClasses" value="${fieldClasses} placeholder" />
</c:if>

<c:if test="${not empty tabIndex}">
	<c:set var="tabIndexValue" value=' tabindex=${tabIndex}' />
</c:if>

<%-- VALIDATION --%>
<c:if test="${required}">
	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>email address</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute" value=' required="required"' />
</c:if>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<span>
	<input name="${name}" id="${name}" class="form-control ${fieldClasses}" value="${value}" size="${size}" ${onkeypressAttribute}${placeHolderAttribute}${tabIndexValue}${requiredAttribute} type="email" data-msg-required="Please enter ${titleText}" />
</span>
<c:if test="${not empty helptext}">
	<i class="helptext">${helptext}</i>
</c:if>

<go:script marker="css-head">
	.helptext { display:block;font-size:12px;font-family:Arial, sans-serif; color: #808080;margin-top:2px;margin-bottom: 10px; }
</go:script>

<go:script marker="onready">

	var emailSetup = function(element) {
		var timer = null;
		var validateEmail = function() {
			var valid = element.valid();
			if(valid && element.val() != "") {
				shared.state.success(element.parent());
			} else if(valid) {
				shared.state.clear(element.parent());
			} else {
				shared.state.error(element.parent());
			}
		}
		element.on('blur', function() {
			element.val($.trim(element.val()));
			if(timer != null) {
				clearInterval(timer);
				timer = null;
			}
			validateEmail();
		});

		element.on('focus', function() {
			if($(this).val() != "" && !$(this).valid()) {
				if(timer == null) {
					timer = setInterval(validateEmail, 600);
				}
			}
		});
	}
	emailSetup($('#${name}'));
	<c:if test="${not empty placeHolder and pageSettings.getVerticalCode() != 'health'}">
		<%-- handle browsers that don't support place holders --%>
		if (document.createElement("input").placeholder == undefined) {
				var inputElement = $('#${name}');
				inputElement.val('${placeHolder}');

				inputElement.on('focus', function() {
					var currValue = $(this).val();
					if(currValue == '${placeHolder}'){
						$(this).val('');
					}

				});
				inputElement.on('blur', function() {
					var currValue = $(this).val();
					if(currValue == ''){
						$(this).val('${placeHolder}');
					}
				});
		}
	</c:if>
</go:script>