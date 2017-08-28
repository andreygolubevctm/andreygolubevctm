<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form label"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true" rtexprvalue="true"	 description="optional id for this row"%>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="widthClass"			required="false" rtexprvalue="true"	 description="The Bootstrap width class" %>
<%@ attribute name="value" 				required="false" rtexprvalue="true"	 description="Label value" %>
<%@ attribute name="addForAttr" 		required="false" rtexprvalue="true"	 description="Bool to add or not the for attribute" %>
<%@ attribute name="helpId"   			required="false" rtexprvalue="true"	 description="Help tooltip ID" %>
<%@ attribute name="showHelpText"		required="false" rtexprvalue="true"	 description="Trigger to display help icon as text rather than icon" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="className"><c:out value="${className} ${widthClass} control-label" /></c:set>
<c:if test="${not empty name}"><c:set var="forAttr" value='for="${name}"' /></c:if>
<c:set var="showHelpIcon" value="${true}" />
<c:if test="${empty helpId}"><c:set var="showHelpIcon" value="${false}" /></c:if>

<label <c:if test="${addForAttr eq 'true'}">${forAttr}</c:if> class="${className}">${value}<c:if test='${showHelpIcon eq true}'> <span class="help-icon-with-label hidden-xs"><field_v2:help_icon helpId="${helpId}" showText="${showHelpText}" /></span></c:if></label>
