<%@ tag description="Travel Single Signup Form" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--HTML--%>
<c:set var="fieldXpath" value="travel/filter/excess"/>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/all"
            value="All"
            required="false"
            title="All excess levels"
            label="true"
    />
</div>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/250"
            value="$250"
            required="false"
            title="up to $250"
            label="true"
    />
</div>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/200"
            value="$200"
            required="false"
            title="up to $200"
            label="true"
    />
</div>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/150"
            value="$150"
            required="false"
            title="up to $150"
            label="true"
    />
</div>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/100"
            value="$100"
            required="false"
            title="up to $100"
            label="true"
    />
</div>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/50"
            value="$50"
            required="false"
            title="up to $50"
            label="true"
    />
</div>
<div class="dropdown-item">
    <field_v2:radio_button
            xpath="${fieldXpath}/nil"
            value="NIL"
            required="false"
            title="NIL"
            label="true"
    />
</div>