<%@ attribute name="abd" 	required="true"	 rtexprvalue="true"	 description="Returns an ADB badge" %>

<span class="abd-badge">
  ${abd ? "Receive Age-Based Discount" : "Retain Age-Based Discount"}
</span>