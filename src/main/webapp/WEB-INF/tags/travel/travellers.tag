<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

  <%-- container --%>
  <div class="form-group row fieldrow smallWidth">
    
    <%--labels  --%>
    <div class="col-sm-4 col-xs-10">
      <div>
        <p class="traveler-heading">
          Who's travelling?
        </p>
      </div>
      <span>
        The age of all travelling adults and children who will be covered under this insurance policy
      </span>
    </div>
    
    <%-- controls --%>
    <div class="col-sm-3 col-xs-12 traveler-controls">
      <div class="clearfix">
        <span class="col-sm-6 controls-heading">
          Number of travellers
        </span>
      </div>
      <div>
        <div class="col-sm-6" id="num-travellers" data-max="50">
          1
        </div>
        <div class="col-sm-6" id="plus">
          <a href="javascript:;" class="icon-add"></a>
        </div>
      </div>
      <div id="warning-label">
        Maximum number of travellers is 50
      </div>
    </div>
    
    <%-- age boxes --%>
    <div class="col-sm-5 col-xs-12 age-container">
      <div class="age-item">
        <span>
          Age(years)
        </span>
        <div class="clearfix">
          <input data-msg-required="Please add age" data-msg-range="Please add age" data-rule-range="1,99" name="travellers-age-1" required type="text" maxlength="2" />
        </div>
      </div>
    </div>
  </div>



  <field_v1:hidden xpath="travel/adults" />