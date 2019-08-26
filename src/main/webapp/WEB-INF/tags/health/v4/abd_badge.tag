<%@ attribute name="abdType" 	required="true"	 rtexprvalue="A"	 description="Returns an ADB badge" %>

<div class="abd-badge">
  ${abdType === 'A' : "Receive Age-Based Discount" : ""}
  ${abdType === 'R' : "Retain Age-Based Discount" : ""}
</div>