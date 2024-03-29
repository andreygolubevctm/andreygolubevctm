<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${octoberComp eq true && !callCentre}">
  <div class="octoberComp">
    <div class="octoberComp__confirm">
      <div class="octoberComp__confirm__header">
        <img src="./assets/brand/ctm/competition/octoberComp/money-symbol.svg" />
        <h3>You're now in the draw to win a share of $81,000</h3>
      </div>
      <p>Follow us on <a href="https://www.facebook.com/Comparethemarket.com.au/">Facebook</a> as we announce the winners</p>
      <p>Want more chances to win? Simply buy <a href="https://www.comparethemarket.com.au/car-insurance/">car</a> or <a href="https://www.comparethemarket.com.au/home-contents-insurance/">home and/or contents</a> insurance before the end of October to go into the draw again!</p>
      <a class="octoberComp__confirm__tcs" target="_blank" href="https://www.comparethemarket.com.au/competition/october_promotion_2017.pdf
  ">T&C's apply.</a>
    </div>
  </div>
</c:if>
