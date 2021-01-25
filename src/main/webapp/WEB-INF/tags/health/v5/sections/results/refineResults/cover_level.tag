<%@ tag description="Cover level template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<section data-panel-id="coverLevel">
    <p>Cover level.</p>

    <field_v2:array_radio xpath="health_refine_results_coverLevel" items="1=Basic,2=Bronze0,3=Silver,4=Gold,5=Any" className="btn-group-sm" required="true" title=""/>
</section>