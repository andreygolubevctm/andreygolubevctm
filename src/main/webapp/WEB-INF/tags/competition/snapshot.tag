<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="additionalClass" required="false" description="additionalClass"%>
<%@ attribute name="vertical" required="true" description="vertical"%>


<div class="octoberComp${additionalClass}">
  <div class="octoberComp__snapshot">
    <div class="octoberComp__snapshot_center">
      <h1>A winner every day!</h1>
      <p>Buy ${vertical} insurance this October for your chance to win a share of $81,000</p>
    </div>
    <div class="octoberComp__snapshot_prize">
      <div class="octoberComp__snapshot_prize__textContainer">
        <img src="./assets/brand/ctm/competition/octoberComp/money-symbol.svg" />
        <span>Daily prize: </span>
        <span><b>$1,000</b></span>
      </div>
      <div class="octoberComp__snapshot_prize__textContainer">
        <img src="./assets/brand/ctm/competition/octoberComp/money-symbol.svg" />
        <span>Grand prizes: </span>
        <span><b>5 x $10,000</b></span>
      </div>
    </div>
    <div class="octoberComp__snapshot_tcs"><a target="_blank" href="https://www.comparethemarket.com.au/competition/october_promotion_2017.pdf
">T&C's apply.</a></div>
    <img class="octoberComp__snapshot__aleksandr" src="./assets/brand/ctm/competition/octoberComp/aleksandr.png" />
  </div>
</div>
