<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Creates a set of radio buttons for the passed xpath using a comma separated list of name=value pairs."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="classLabel"	required="false" rtexprvalue="true"	 description="additional css class attribute for label" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>
<%@ attribute name="items" 		required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>
<%@ attribute name="defaultValue" 	required="false"  rtexprvalue="true"  description="default value to be checked" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>
<%@ attribute name="style"  	required="false" rtexprvalue="true"  description="Options: 'inline' = standard inline floating; 'group' = grouped together like buttons" %>
<%@ attribute name="additionalAttributes"  	required="false" rtexprvalue="true"  description="Additional attributes" %>
<%@ attribute name="disableErrorContainer" required="false" rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="additionalLabelAttributes"  	required="false" rtexprvalue="true"  description="Additional attributes specifically for the label element" %>
<%@ attribute name="wrapCopyInSpan" required="false" rtexprvalue="true" description="Flag to wrap text inside label with span tags" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${not empty id}">
	<c:set var="id" value=' id="${id}"' />
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required"' />
</c:if>

<c:if test="${empty value and not empty defaultValue}">
	<c:set var="value" value="${defaultValue}" />
</c:if>

<c:if test="${empty style}">
	<c:set var="style" value="group" />
</c:if>

<c:choose>
	<c:when test="${style == 'inline'}">
		<c:set var="classVar" value="radio-inline ${classLabel}" />
	</c:when>
	<c:when test="${style == 'horizontal'}">
		<c:set var="classVar" value="btn btn-form-inverse ${classLabel}" />
		<c:set var="className" value='btn-group btn-group-horizontal" data-toggle="radio' />
	</c:when>
	<c:when test="${style == 'vertical'}">
		<c:set var="classVar" value="btn btn-form-inverse ${classLabel}" />
		<c:set var="className" value='btn-group-vertical" data-toggle="radio' />
	</c:when>
	<c:when test="${style == 'group-tile'}">
		<c:set var="classVar" value="btn btn-form-inverse ${classLabel}" />
		<c:set var="className" value='btn-tile ${className}" data-toggle="radio' />
	</c:when>
	<c:when test="${style == 'radio-rounded'}">
		<c:set var="classVar" value="btn btn-form-inverse ${classLabel}" />
		<c:set var="className" value='radio-rounded ${className}" data-toggle="radio' />
	</c:when>
	<c:when test="${style == 'pill'}">
		<c:set var="classVar" value="btn btn-form-inverse-pill ${classLabel}" />
		<c:set var="className" value='btn-group btn-group-justified ${className}" data-toggle="radio' />
	</c:when>
	<c:otherwise>
		<c:set var="classVar" value="btn btn-form-inverse ${classLabel}" />
		<c:set var="className" value='btn-group btn-group-justified ${className}" data-toggle="radio' />
	</c:otherwise>
</c:choose>

<c:if test="${disableErrorContainer eq true}">
	<c:set var="additionalAttributes" value="${additionalAttributes}  data-disable-error-container='true' "/>
</c:if>

<c:choose>
	<c:when test="${empty wrapCopyInSpan or not wrapCopyInSpan}">
		<c:set var="wrapCopyInSpan" value="${false}" />
	</c:when>
	<c:otherwise>
		<c:set var="wrapCopyInSpan" value="${true}" />
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<div class="${className}" ${id}>
	<c:forTokens items="${items}" delims="," var="radio" varStatus="status">
		<c:set var="val" value="${fn:substringBefore(radio,'=')}" />
		<c:set var="des" value="${fn:substringAfter(radio,'=')}" />
		<c:set var="id" value="${name}_${val}" />

		<c:set var="checked" value="" />
		<c:set var="active" value="" />

		<c:if test="${val == value}">
			<c:set var="checked" value="checked=\"checked\"" />
			<c:set var="active" value=" active" />
		</c:if>

		<c:choose>
			<%-- FOR GROUPED STYLE --%>
			<c:when test="${style == 'group' or style == 'group-tile' or style == 'inline' or style == 'vertical' or style == 'radio-rounded' or style == 'pill'}">
				<label class="${classVar} ${active}" ${additionalLabelAttributes}>
					<input type="radio" name="${name}" id="${id}" value="${val}" ${checked} data-msg-required="Please choose ${title}" ${requiredAttribute} ${additionalAttributes}>
					<c:if test="${wrapCopyInSpan}"><c:out value="<span>" escapeXml="false" /></c:if>
					<c:out value="${des}" escapeXml="false" />
					<c:if test="${wrapCopyInSpan}"><c:out value="</span>" escapeXml="false" /></c:if>
				</label>
			</c:when>
			<%-- FOR NORMAL OR INLINE --%>
			<c:otherwise>
				<div class="${classVar} ${active}">
					<label ${additionalLabelAttributes}>
						<input type="radio" name="${name}" id="${id}" value="${val}" ${checked} data-msg-required="Please choose ${title}" ${requiredAttribute} ${additionalAttributes}>
						<c:if test="${wrapCopyInSpan}"><c:out value="<span>" escapeXml="false" /></c:if>
						<c:out value="${des}" escapeXml="false" />
						<c:if test="${wrapCopyInSpan}"><c:out value="</span>" escapeXml="false" /></c:if>
					</label>
				</div>
			</c:otherwise>
		</c:choose>
	</c:forTokens>
</div>

<c:if test="${helpId != null && helpId != ''}">
	<div class="floatLeft">
		<span class="help_icon" id="help_${helpId}">Help</span>
	</div>
</c:if>
