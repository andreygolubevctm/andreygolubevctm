<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--HTML--%>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_all" class="radioButton-custom  radio" data-excess="10000000000" value="All excess levels">
        <label for="travel_filter_excess_all">All excess levels</label>
    </div>
</div>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_250" class="radioButton-custom  radio" data-excess="250" value="Excess up to $250">
        <label for="travel_filter_excess_250">Excess up to $250</label>
    </div>
</div>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_200" class="radioButton-custom  radio" data-excess="200" value="Excess up to $200" checked>
        <label for="travel_filter_excess_200">Excess up to $200</label>
    </div>
</div>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_150" class="radioButton-custom  radio" data-excess="150" value="Excess up to $150">
        <label for="travel_filter_excess_150">Excess up to $150</label>
    </div>
</div>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_100" class="radioButton-custom  radio" data-excess="100" value="Excess up to $100">
        <label for="travel_filter_excess_100">Excess up to $100</label>
    </div>
</div>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_50" class="radioButton-custom  radio" data-excess="50" value="Excess up to $50">
        <label for="travel_filter_excess_50">Excess up to $50</label>
    </div>
</div>
<div class="dropdown-item">
    <div class="radio">
        <input type="radio" name="radio-group" id="travel_filter_excess_nil" class="radioButton-custom  radio" data-excess="0" value="Nil excess">
        <label for="travel_filter_excess_nil">Nil excess</label>
    </div>
</div>