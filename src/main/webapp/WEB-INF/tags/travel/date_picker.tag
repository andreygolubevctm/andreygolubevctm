<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<div class="clearfix dp">
  <div class="col-sm-4 col-xs-12 row-content dp__textContainer">
    <p class="traveler-heading">
      When are you travelling?
    </p>
    <span class="traveler-age-label">
      When do you leave and on what date will you return?
    </span>
  </div>
  <div class="col-sm-6 col-xs-12 row-content">
    <div class="dp__input">
      <span class="dp__input__header">Departure</span>
      <input id="departureDisplay" class="dp__input__item" />
      <input id="departure" class="dp__input__hidden" />
      <field_v1:hidden xpath="${xpath}/dates/fromDate" defaultValue="${callId}" />
    </div>
    <div class="dp__input">
      <span class="dp__input__header">Return</span>
      <input id="returnDisplay" class="dp__input__item" />
      <input id="return" class="dp__input__hidden" />
      <field_v1:hidden xpath="${xpath}/dates/toDate" defaultValue="${callId}" />
    </div>
  </div>
</div>