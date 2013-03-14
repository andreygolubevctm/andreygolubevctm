<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ext="http://switchwise.com.au/"
	xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="soapenv ext i">
	
	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<results>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<SearchID><xsl:value-of select="ext:SearchResult/ext:SearchID" /></SearchID>

			<xsl:apply-templates select="error" />
			<xsl:apply-templates select="ext:SearchResult/ext:ValidationMessages" />
			
			<xsl:apply-templates select="ext:SearchResult/ext:Products/ext:Product" />
		</results>
	</xsl:template>
	
	<xsl:template name="products">
		<xsl:for-each select="//ext:Product">
			<prices><xsl:copy-of select="*" copy-namespaces='no' /></prices>
		</xsl:for-each>
		<SearchID><xsl:value-of select="//ext:SearchID" /></SearchID>
	</xsl:template>



	<xsl:template match="ext:Product">
		<price>
			<xsl:attribute name="service"><xsl:value-of select="ext:Retailer/ext:Code" /></xsl:attribute>
			<xsl:attribute name="productId">
				<xsl:value-of select="ext:Retailer/ext:Code" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="ext:ProductID" />
			</xsl:attribute>

			<transactionId><xsl:value-of select="$transactionId" /></transactionId>

			<!-- AVAILABLE OR NOT? -->
			<xsl:choose>
				<xsl:when test="ext:CanApply = 'true'">
					<xsl:call-template name="product-available-yes" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="product-available-no" />
				</xsl:otherwise>
			</xsl:choose>
		</price>
	</xsl:template>


	<xsl:template name="product-available-yes">
			<available>Y</available>
<!-- TODO --><trackCode>17</trackCode>
			<provider><xsl:value-of select="ext:Retailer/ext:Name" /></provider>
			<thumb><xsl:value-of select="ext:Retailer/ext:Code" />/<xsl:value-of select="ext:Retailer/ext:SmallLogo" /></thumb>
			<thumbMedium><xsl:value-of select="ext:Retailer/ext:Code" />/<xsl:value-of select="ext:Retailer/ext:Code" /><xsl:text>_logo_72x64.jpg</xsl:text></thumbMedium>
			<name><xsl:value-of select="ext:Retailer/ext:Name" /></name>
			<des><xsl:value-of select="ext:ProductDescription" /></des>
			<price><xsl:value-of select="ext:EstimatedCost/ext:Minimum" /></price>
			<priceText>
				<Minimum><xsl:value-of select="ext:EstimatedCost/ext:Minimum" /></Minimum>
				<Maximum><xsl:value-of select="ext:EstimatedCost/ext:Maximum" /></Maximum>
			</price>
			<priceText>
				<xsl:choose>
					<xsl:when test="ext:EstimatedCost/ext:Minimum &lt; ext:EstimatedCost/ext:Maximum">
						<xsl:value-of select="format-number(ext:EstimatedCost/ext:Minimum, '$###,###.00')" />
						<xsl:text> - </xsl:text>
						<xsl:value-of select="format-number(ext:EstimatedCost/ext:Maximum, '$###,###.00')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(ext:EstimatedCost/ext:Minimum, '$###,###.00')" />
					</xsl:otherwise>
				</xsl:choose>
			</priceText>

			<info>
				<xsl:apply-templates select="ext:ContractLength" />
				
				<GreenPercent>
					<xsl:choose>
						<xsl:when test="ext:GreenPercent = ''">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ext:GreenPercent" />
						</xsl:otherwise>
					</xsl:choose>
				</GreenPercent>
				
				<xsl:apply-templates select="ext:GreenRating" />
				<xsl:apply-templates select="ext:StarRating" />
				
				<EstimatedSavingText>
					<xsl:value-of select="format-number(ext:EstimatedSaving/ext:Minimum, '$###,###')" />
				</EstimatedSavingText>
				<xsl:apply-templates select="ext:EstimatedSaving" />
				
				<MaxCancellationFee>
					<xsl:choose>
						<xsl:when test="starts-with(ext:MaxCancellationFee, '$')">
							<xsl:value-of select="ext:MaxCancellationFee" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(ext:MaxCancellationFee, '$###,###')" />
						</xsl:otherwise>
					</xsl:choose>
				</MaxCancellationFee>
			</info>
	</xsl:template>

	<xsl:template name="product-available-no">
			<available>N</available>
			<name />
			<des />
			<info />
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="node()" />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
