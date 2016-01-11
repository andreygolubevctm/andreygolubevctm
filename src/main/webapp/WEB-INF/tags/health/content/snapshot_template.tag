<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core:js_template id="snapshots-step1-template">
  {{ if(obj.comingFromWebsite) { }}
  <div class="row snapshot">
    <div class="col-md-5">
      <span class="snapshot-title">Cover for:</span>
    </div>
    <div class="col-md-7">
                    <span class="hidden-xs hidden-sm">
                        <span data-source="#health_situation_healthCvr"></span>
                    </span>
    </div>
  </div>

  <div class="row snapshot">
    <div class="col-md-5">
      <span class="snapshot-title">Living in:</span>
    </div>
    <div class="col-md-7">
                    <span class="snapshot-items hidden-xs hidden-sm">
                        <span data-source="#health_situation_location"></span>
                    </span>
    </div>
  </div>
  {{ } else if(obj.renderAll) { }}
  <div class="row snapshot">
    <div class="col-md-5">
      <span class="snapshot-title">Cover for:</span>
    </div>
    <div class="col-md-7">
              <span class="snapshot-items hidden-xs hidden-sm">
                   <span data-source="#health_situation_healthCvr"></span>
              </span>
    </div>
  </div>
  <div class="row snapshot">
    <div class="col-md-5">
      <span class="snapshot-title">Living in:</span>
    </div>
    <div class="col-md-7">
              <span class="snapshot-items hidden-xs hidden-sm">
                  <span data-source="#health_situation_location"></span>
              </span>
    </div>
  </div>
  <div class="row snapshot">
    <div class="col-md-5">
      <span class="snapshot-title">Looking to:</span>
    </div>
    <div class="col-md-7">
                <span class="snapshot-items hidden-xs hidden-sm">
                      <span data-source="#health_situation_healthSitu"></span>
                </span>
    </div>
  </div>
  {{ } else  { }}
  <div class="row">
    <div>
      <p>We compare policies from seven of the top ten funds in Australia (as well as some smaller ones),
        saving you time and effort when searching for the right policy.
      </p>
    </div>
  </div>
  {{ } }}

</core:js_template>



<core:js_template id="snapshots-covertype-template">
  {{ if(obj.renderIt) { }}
  <div class="row snapshot cover-type ">
    <div class="col-md-5">
      <span class="snapshot-title">Cover type:</span>
    </div>
    <div class="col-md-7">
                <span class="snapshot-items hidden-xs hidden-sm">
                     <span data-source="#health_situation_coverType"></span>
                 </span>
    </div>
  </div>
  {{ } }}
</core:js_template>


<core:js_template id="snapshots-benefits-template">
  {{ if(obj.benefitList.length > 0 && obj.renderIt) { }}
  <div class="row snapshot ">
    <div class="col-md-5">
      <span class="snapshot-title">Benefits</span>
    </div>
    <div class="col-md-7">
                <span class="snapshot-items hidden-xs hidden-sm">
                    <ul class="snapshot-list">
                      <li>{{=obj.benefitList.join('</li><li>')}} </li>
                    </ul>
                </span>
    </div>
  </div>
  {{ } }}
</core:js_template>

<core:js_template id="snapshots-extras-template">
  {{ if(obj.extrasList.length > 0 && obj.renderIt) { }}
  <div class="row snapshot ">
    <div class="col-md-5">
      <span class="snapshot-title">Extras</span>
    </div>
    <div class="col-md-7">
                  <span class="snapshot-items hidden-xs hidden-sm">
                      <ul class="snapshot-list">
                        <li>{{=obj.extrasList.join('</li><li>')}} </li>
                      </ul>
                  </span>
    </div>
  </div>
  {{ } }}
</core:js_template>