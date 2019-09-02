<%@ attribute name="abd" 	required="true"	 rtexprvalue="true"	 description="Returns an ADB badge" %>

<span class="abd-badge">
  ${abd ? "Includes Age-Based Discount" : "Retains Age-Based Discount"}
</span>