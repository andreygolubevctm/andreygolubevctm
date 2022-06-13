<%@ tag description="Returns an ADB badge a dialog link"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var frequency = obj._selectedFrequency; }}
{{ var frequencyPremium = obj.premium[frequency]; }}
{{ var isConfirmation = false; }}
{{ var showABD = false; }}
{{ var abd = true; }}
{{ var isDualPricingActive = meerkat.modules.healthDualPricing.isDualPricingActive() === true;}}
{{ try { }}
  {{ isConfirmation = _.isNumber(meerkat.modules.healthConfirmation.getPremium()); }}
{{ } catch(err) { console.warn('Bad premium number', err); } }}
{{ if (obj.custom.reform.yad !== "N" && frequencyPremium.abd > 0 ) { }}
  {{ showABD = true; }}
  {{ if (isConfirmation && obj.info.abdRequestFlag === 'A' || !isConfirmation && meerkat.modules.healthRABD.isABD()) { }}
    {{ abd = true; }}
  {{ } else { }}
    {{ abd = false; }}
  {{ } }}
{{ } }}

{{ if (showABD) { }}
<c:set var="abdModalContent" scope="request"><content:get key="abdModalContent"/></c:set>

<div class="abd-badge {{=abd ? '': 'retains'}} abd-modal-trigger">
  <a class="{{= !meerkat.site.isCallCentreUser ? dialogPop : '' }}" data-content="${abdModalContent}" title="What is the Age-Based Discount?">{{=abd ? "Includes Age-Based " : "Retains Age-Based "}}<span class="abd-badge-discount-and-icon-group">Discount<span class="help-icon icon-info"></span></span></a>
</div>
{{ } else { }}
  {{ if(Results.isAnyResultContainsABD(isDualPricingActive, obj._selectedFrequency)) { }}
    <div class="empty-abd-badge dual-price"></div>
  {{ } }}
{{ } }}