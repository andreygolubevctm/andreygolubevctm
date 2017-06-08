<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_v2:fieldset className="lead-capture" legend="Interested in comparng other insurance products?">
  <div class="info">After comparing Home and Contents insurance products</div>
  <ui:bubble variant="help">
    <h4>Hi</h4>
    <p>We noticed you're moving house. If you need your power connected, select "Energy" and we'll help you find the best price for your next energy bill!</p>
  </ui:bubble>
  <div>
    <div class="radioBtn">
      <input name="health-insurance-xpath" id="health-insurance-xpath" type="checkbox" />
      <label for="health-insurance-xpath">
        <i class="icon-health"></i>
      </label>
      <div class="product-name">Health insurance</div>
    </div>
    <div class="radioBtn">
      <input name="energy-insurance-xpath" id="energy-insurance-xpath" type="checkbox" />
      <label for="energy-insurance-xpath">
        <i class="icon-energy"></i>
      </label>
      
      <div class="product-name">Energy comparision</div>
    </div>
    <div class="radioBtn">
      <input name="life-insurance-xpath" id="life-insurance-xpath" type="checkbox" />
      <label for="life-insurance-xpath">
        <i class="icon-heart-solid"></i>
      </label>
      
      <div class="product-name">Life insurance</div>
    </div>
    <div class="radioBtn">
      <input name="home-insurance-xpath" id="home-insurance-xpath" type="checkbox" />
      <label for="home-insurance-xpath"> 
        <i class="icon-home"></i>
      </label>
      
      <div class="product-name">Home loans</div>
    </div>
  </div>
</form_v2:fieldset>

















