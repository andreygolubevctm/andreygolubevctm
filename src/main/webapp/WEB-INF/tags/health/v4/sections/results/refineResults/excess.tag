<%@ tag description="Excess template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<section data-panel-id="excess">
    <p>Select preferred excess values.</p>

    <field_v2:array_radio xpath="health_refine_results_excess" items="1=$0,2=$1 - $250,3=$251 - $500,4=All" className="btn-group-sm" required="true" title=""/>
</section>