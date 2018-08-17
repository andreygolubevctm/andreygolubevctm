<%@ tag description="Travel Single Signup Form"%> 
<%@ tag language="java" pageEncoding="UTF-8"%> 
<%@ include file="/WEB-INF/tags/taglib.tagf"%> 
 
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%> 
 
<div class="form-group row fieldrow smallWidth select-tags-row dp">
  <div class="col-sm-4 col-xs-12 row-content custom-label-block">
    <p class="traveler-heading"> 
      When are you travelling? 
    </p> 
    <span class="traveler-dates-label">
      When do you leave and on what date will you return? 
    </span>
  </div> 
  <div class="col-sm-6 col-xs-12 row-content dp__inputFields"> 
    <div class="dp__input dp__input--left"> 
      <span class="dp__input__header">Departure</span> 
      <input required data-msg-required="Please pick a departure date"  id="departureDisplay" class="dp__input__item" name="travel_dates_departure_vis" /> 
      <input id="departure" class="dp__input__hidden" name="travel_dates_departure" /> 
      <field_v1:hidden xpath="${xpath}/dates/fromDateInputD" defaultValue="" /> 
      <field_v1:hidden xpath="${xpath}/dates/fromDateInputM" defaultValue="" /> 
      <field_v1:hidden xpath="${xpath}/dates/fromDateInputY" defaultValue="" /> 
      <field_v1:hidden xpath="${xpath}/dates/fromDate" defaultValue="" /> 
    </div> 
    <div class="dp__input dp__input--right"> 
      <span class="dp__input__header">Return</span> 
      <input required data-msg-required="Please pick a return date" id="returnDisplay" class="dp__input__item" name="travel_dates_return_vis" /> 
      <input id="return" class="dp__input__hidden" name="travel_dates_return" /> 
      <field_v1:hidden xpath="${xpath}/dates/toDateInputD" defaultValue="" /> 
      <field_v1:hidden xpath="${xpath}/dates/toDateInputM" defaultValue="" /> 
      <field_v1:hidden xpath="${xpath}/dates/toDateInputY" defaultValue="" /> 
      <field_v1:hidden xpath="${xpath}/dates/toDate" defaultValue="" /> 
    </div> 
  </div> 
</div>