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

	<xsl:template name="description">
		<xsl:param name="productId" />
		<xsl:param name="productType" />

		<xsl:choose>
			<xsl:when test="$productId = 'BUDD-05-29'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						You've worked hard to put a roof over your head. Now it's time to protect it with simply smarter Home Insurance.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						The things you've bought for your house are what make it a home. Protect them with simply smarter Contents Insurance.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Winner Money magazines cheapest Home &amp; Contents Insurance 2014.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'VIRG-05-26'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Protect the things you love with a great range of benefits and affordable, flexible cover from Virgin Money.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Protect the things you love with a great range of benefits and affordable, flexible cover from Virgin Money.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Protect your home and things you love with affordable and flexible Home &amp; Contents cover.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'EXDD-05-21'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						When you insure your building with Dodo you'll get an insurance policy tailored to your needs at a competitive price.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						When you insure your contents with Dodo you'll get an insurance policy tailored to your needs at a competitive price.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Dodo Combined Home and Contents Insurance is designed to offer a broad range of policy benefits.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

		</xsl:choose>
	</xsl:template>

	<xsl:template name="offer">
		<xsl:param name="productId" />
		<xsl:param name="productType" />

		<xsl:choose>
			<xsl:when test="$productId = 'BUDD-05-29'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Save 20% when you buy online.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Save 20% when you buy online.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Save 35% on combined Smart Home &amp; Contents Insurance when you buy online.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'VIRG-05-26'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Your quote for Virgin Home Insurance includes our 10% online discount.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Your quote for Virgin Home Insurance includes our 10% online discount.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Save 25% on combined Home &amp; Contents Insurance when you buy online from 17 July 2014.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'EXDD-05-21'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Receive a 10% discount when you purchase online from 1st April 2014.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Receive a 10% discount when you purchase online from 1st April 2014.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Purchase a combined home and contents policy online and save up to 25%*. Receive a FREE wireless alarm and phone system.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>