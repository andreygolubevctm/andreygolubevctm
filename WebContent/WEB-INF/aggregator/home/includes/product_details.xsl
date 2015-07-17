<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="productDetails">
		<xsl:param name="productId" />
		<xsl:param name="productType" />

		<xsl:choose>

			<xsl:when test="$productId = 'BUDD-05-29'">
				<disclaimer>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history: Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details.
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history: Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details.
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history: Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details.
						</xsl:when>
					</xsl:choose>
				</disclaimer>
				<specialConditions>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
					</xsl:choose>
				</specialConditions>
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'VIRG-05-26'">
				<disclaimer>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							<![CDATA[
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history.<br/>
							Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details. Not available in Northern Territory, North Queensland and Northern Western Australia.<br />
							If you cancel the policy within 21 days from the date of purchase and do not make a claim on the policy, Virgin Money will give you a full refund.
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							<![CDATA[
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history.<br/>
							Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details. Not available in Northern Territory, North Queensland and Northern Western Australia.<br/>
							If you cancel the policy within 21 days from the date of purchase and do not make a claim on the policy, Virgin Money will give you a full refund
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							<![CDATA[
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history.<br/>
							Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details. Not available in Northern Territory, North Queensland and Northern Western Australia.<br/>
							If you cancel the policy within 21 days from the date of purchase and do not make a claim on the policy, Virgin Money will give you a full refund
							]]>
						</xsl:when>
					</xsl:choose>
				</disclaimer>
				<specialConditions>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
					</xsl:choose>
				</specialConditions>
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'EXDD-05-21'">
				<disclaimer>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history: Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details.
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history: Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details.
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							This quote includes any applicable online discounts and is subject to meeting the insurer's underwriting criteria and may change due to other factors such as claim or loss history: Exclusions (such as flood) and conditions apply. See the Product Disclosure Statement for full details.
						</xsl:when>
					</xsl:choose>
				</disclaimer>
				<specialConditions>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							Exclusions (such as flood) and conditions apply. Not available in Northern Territory, North Queensland and Northern Western Australia.
						</xsl:when>
					</xsl:choose>
				</specialConditions>
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHC'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
						<xsl:when test="$productType = 'HHZ'">
							<![CDATA[
							<ul>
								<li>Earthquake - $500</li>
								<li>Personal effects - $100</li>
							</ul>
							]]>
						</xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'REIN-02-01'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'REIN-02-02'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-01'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-02'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

	<!-- DEFAULT -->
			<xsl:otherwise>
				<disclaimer></disclaimer>
				<specialConditions></specialConditions>
				<additionalExcess></additionalExcess>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>