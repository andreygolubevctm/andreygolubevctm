<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Number of travellers row --%>
<div class="form-group row fieldrow smallWidth traveller-num-controls">
  <%-- label --%>
  <label class="col-sm-4 col-xs-10 control-label">Number of travellers?</label>

  <%-- controls --%>
  <div class="col-sm-3 col-xs-12">
    <div class="col-xs-6" id="num-travellers" data-max="25">1</div>
    <div class="col-xs-6" id="plus">
      <a href="javascript:;" class="icon-add"></a>
    </div>
    <div class="warning-label-hidden">Maximum number of travellers is 25</div>
  </div>
</div>

<%-- Ages row --%>
<div class="form-group row fieldrow smallWidth">
  <%--labels  --%>
  <label class="col-sm-4 col-xs-10 control-label traveler-age-label">The age of the travelling adult?</label>
  <%-- default age box --%>
  <div class="col-sm-5 col-xs-12 age-container">
    <div class="age-item col-md-5 col-lg-3">
        <span class="age-label">
          Age(years)
        </span>
      <div class="clearfix">
        <input data-msg-required="Please add age" data-msg-range="Age must be between 16-99" data-rule-range="16,99" name="travellers-age-1" required type="text" maxlength="2" />
      </div>
    </div>
  </div>
  <field_v1:hidden xpath="travel/travellers/travellersAge" />
</div>