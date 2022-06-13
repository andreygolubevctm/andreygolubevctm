<%@ tag description="Returns an ADB badge a dialog link"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ var frequency = obj._selectedFrequency; }}
{{ var frequencyPremium = obj.premium[frequency]; }}
{{ var isConfirmation = false; }}
{{ var showABD = false; }}
{{ var abd = true; }}
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
{{ var showLhcFreePricingText = true; }}
{{ if (frequencyPremium.lhcfreepricing.indexOf('premium') === -1) { showLhcFreePricingText = false; } }}
{{ if (showABD) { }}
<c:set var="abdModalContent" scope="request"><content:get key="abdModalContent"/></c:set>
<div class="abd-badge {{=abd ? '': 'retains'}} abd-modal-trigger">
  <a class="dialogPop" data-content="${abdModalContent}" title="What is the Age-Based Discount?">{{=abd ? "Includes Age-Based " : "Retains Age-Based "}}<span class="abd-badge-discount-and-icon-group">Discount<span class="help-icon icon-info"></span></span></a>
</div>
{{ } }}
{{ if (showLhcFreePricingText) { }}
  <div class="lhcText">The premium may be affected by LHC</div>
{{ } }}
