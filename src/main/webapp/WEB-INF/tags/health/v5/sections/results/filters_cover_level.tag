<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for level of excess."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARS --%>
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="filter coverLevel" quoteChar="\"" /></c:set>
<c:set var="fieldRef" value="health_filterBar_coverLevel" />

<%-- HTML --%>
<div id="health_coverLevel_container" class="health-filter-coverLevel">
	<field_v2:array_radio xpath="${fieldRef}" title="your preferred cover level" required="true" items="1=Basic||2=Bronze||3=Silver||4=Gold||5=Any" delims="||" style="radio-as-checkbox" wrapCopyInSpan="true" outerWrapperClassName="col-xs-12 col-sm-12 col-md-12 col-lg-12 vertical" className="${fieldRef} radio-as-checkbox" additionalAttributes="${analyticsAttr} data-attach=true" />
	<input name="health_coverLevel" value="" type="hidden">
</div>
