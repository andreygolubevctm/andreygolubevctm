<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="productDetails">
		<xsl:param name="productId" />
		<xsl:param name="productType" />

		<xsl:choose>

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
			<xsl:when test="$productId = 'REIN-02-01'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Protect the home that keeps your family safe.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Protect your belongings against damage and theft.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Insurance to protect your home inside and out.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'REIN-02-02'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Protect the home that keeps your family safe.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Protect your belongings against damage and theft.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Insurance to protect your home inside and out.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-01'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Super Insurance at a low supermarket price.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Super Insurance at a low supermarket price.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Save up to 20% when you apply for a new building and contents policy online.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-02'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Super Insurance at a low supermarket price.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Super Insurance at a low supermarket price.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Save up to 20% when you apply for a new building and contents policy online.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

		</xsl:choose>
	</xsl:template>

	<xsl:template name="offer">
		<xsl:param name="productId" />
		<xsl:param name="productType" />

		<xsl:choose>
			<xsl:when test="$productId = 'REIN-02-01'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Save up to 10%† when you buy a home policy online.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Save up to 10%† when you buy a contents policy online.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Save up to 20%† when you buy a combined home and contents policy online.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'REIN-02-02'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Save up to 10%† when you buy a home policy online.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Save up to 10%† when you buy a contents policy online.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						Save up to 20%† when you buy a combined home and contents policy online.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-01'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Get a $100 WISH Gift Card when you take out a Woolworths Home Insurance policy by 30 September 2014.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Get a $100 WISH Gift Card when you take out a Woolworths Home Insurance policy by 30 September 2014.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						PLUS get a $100 WISH Gift Card when you take out a policy by 30 September 2014.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-02'">
				<xsl:choose>
					<xsl:when test="$productType = 'HHB'">
						Get a $100 WISH Gift Card when you take out a Woolworths Home Insurance policy by 30 September 2014.
					</xsl:when>
					<xsl:when test="$productType = 'HHC'">
						Get a $100 WISH Gift Card when you take out a Woolworths Home Insurance policy by 30 September 2014.
					</xsl:when>
					<xsl:when test="$productType = 'HHZ'">
						PLUS get a $100 WISH Gift Card when you take out a policy by 30 September 2014.
					</xsl:when>
				</xsl:choose>
			</xsl:when>

		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>