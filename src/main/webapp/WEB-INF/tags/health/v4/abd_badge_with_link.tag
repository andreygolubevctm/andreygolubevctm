<%@ attribute name="abd" 	required="true"	 rtexprvalue="true"	 description="Returns an ADB badge" %>

<c:set var="abdModalContent" scope="request"><content:get key="abdModalContent"/></c:set>

<div class="abd-badge ${abd ? '': 'retains'} abd-modal-trigger">
  <a class="dialogPop" data-content="${abdModalContent}" title="What is the Age-Based Discount?">${abd ? "Includes Age-Based Discount" : "Retains Age-Based Discount"}<span class="help-icon icon-info"></span></a>
</div>
