<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Benefits group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<health_v4:benefits_switch_off_message />

<div class="benefitsOverflow">
<c:forEach items="${resultTemplateItems}" var="selectedValue">
	<health_v5_insuranceprefs:benefits_item item="${selectedValue}"  />
</c:forEach>
</div>
