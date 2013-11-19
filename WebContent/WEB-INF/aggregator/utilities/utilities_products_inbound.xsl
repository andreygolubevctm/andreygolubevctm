<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ext="http://switchwise.com.au/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="soapenv ext i">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<!-- Check response for problems -->
		<xsl:choose>
			<xsl:when test="count(error) &gt; 0">
				<xsl:call-template name="ResultError" />
			</xsl:when>

			<xsl:when test="count(ext:SearchResult/ext:ValidationMessages/ValidationMessage) &gt; 0">
				<xsl:call-template name="ResultError">
					<xsl:with-param name="message" select="'Form validation issues:'" />
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="count(ext:SearchResult/ext:Products/ext:Product) = 0">
				<xsl:call-template name="ResultError">
					<xsl:with-param name="message" select="'No products were found.'" />
				</xsl:call-template>
			</xsl:when>

			<!-- Response passes our error checking -->
			<xsl:otherwise>
				<xsl:call-template name="ResultOk" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template name="ResultError">
		<xsl:param name="status">ERROR</xsl:param>
		<xsl:param name="message"></xsl:param>

		<results>
			<status><xsl:value-of select="$status" /></status>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<searchId><xsl:value-of select="ext:SearchResult/ext:SearchID" /></searchId>
			<errors>
				<xsl:if test="$message != ''">
					<error>
						<code><xsl:text>0</xsl:text></code>
						<message><xsl:value-of select="$message" /></message>
					</error>
				</xsl:if>

				<xsl:for-each select="ext:SearchResult/ext:ValidationMessages/ValidationMessage">
					<error>
						<code><xsl:text>0</xsl:text></code>
						<message><xsl:value-of select="PropertyName" />: <xsl:value-of select="ErrorMessage" /></message>
					</error>
				</xsl:for-each>

				<xsl:for-each select="error">
					<error>
						<code><xsl:value-of select="code" /></code>
						<message><xsl:value-of select="message" /></message>
					</error>
				</xsl:for-each>
			</errors>
		</results>
	</xsl:template>



	<xsl:template name="ResultOk">
		<xsl:param name="status">OK</xsl:param>

		<results>
			<status><xsl:value-of select="$status" /></status>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<searchId><xsl:value-of select="ext:SearchResult/ext:SearchID" /></searchId>
			<errors />

			<!-- List all products that can be applied for -->
			<xsl:apply-templates select="ext:SearchResult/ext:Products/ext:Product" />
		</results>
	</xsl:template>



	<xsl:template match="ext:Product">
		<price>
			<xsl:attribute name="service"><xsl:value-of select="ext:Retailer/ext:Code" /></xsl:attribute>
			<xsl:attribute name="productId"><xsl:value-of select="ext:ProductID" /></xsl:attribute>

			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<searchId><xsl:value-of select="../../ext:SearchID" /></searchId>

			<available>
				<xsl:choose>
					<xsl:when test="ext:CanApply = 'true'">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</available>
			<provider><xsl:value-of select="ext:Retailer/ext:Name" /></provider>
			<thumb><xsl:value-of select="ext:Retailer/ext:Code" />/<xsl:value-of select="ext:Retailer/ext:SmallLogo" /></thumb>
			<thumbMedium><xsl:value-of select="ext:Retailer/ext:Code" />/<xsl:value-of select="ext:Retailer/ext:Code" /><xsl:text>_logo_72x64.jpg</xsl:text></thumbMedium>
			<name><xsl:value-of select="ext:Retailer/ext:Name" /></name>
			<des><xsl:value-of select="ext:ProductDescription" /></des>
			<price>
				<Minimum><xsl:value-of select="ext:EstimatedCost/ext:Minimum" /></Minimum>
				<Maximum><xsl:value-of select="ext:EstimatedCost/ext:Maximum" /></Maximum>
			</price>
			<priceText>
				<xsl:choose>
					<xsl:when test="ext:EstimatedCost/ext:Minimum != ext:EstimatedCost/ext:Maximum">
						<xsl:value-of select="format-number(ext:EstimatedCost/ext:Minimum, '$###,###')" />
						<xsl:text> - </xsl:text>
						<xsl:value-of select="format-number(ext:EstimatedCost/ext:Maximum, '$###,###')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(ext:EstimatedCost/ext:Minimum, '$###,###')" />
					</xsl:otherwise>
				</xsl:choose>
			</priceText>

			<info>

				<xsl:apply-templates select="ext:ContractLength" />
				<xsl:apply-templates select="ext:ProductClassPackage" />

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
					<xsl:choose>
						<xsl:when test="ext:EstimatedSaving/ext:Minimum != ext:EstimatedSaving/ext:Maximum">
							<xsl:value-of select="format-number(ext:EstimatedSaving/ext:Minimum, '$###,###')" />
							<xsl:text> - </xsl:text>
							<xsl:value-of select="format-number(ext:EstimatedSaving/ext:Maximum, '$###,###')" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(ext:EstimatedSaving/ext:Minimum, '$###,###')" />
						</xsl:otherwise>
					</xsl:choose>
				</EstimatedSavingText>
				<xsl:apply-templates select="ext:EstimatedSaving" />

				<MaxCancellationFee>
					<xsl:choose>
						<xsl:when test="ext:MaxCancellationFee = ''">
							<xsl:text>$0</xsl:text>
						</xsl:when>
						<xsl:when test="starts-with(ext:MaxCancellationFee, '$')">
							<xsl:value-of select="ext:MaxCancellationFee" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(ext:MaxCancellationFee, '$###,###')" />
						</xsl:otherwise>
					</xsl:choose>
				</MaxCancellationFee>

				<xsl:apply-templates select="ext:CallRetailerPhone" />
				<xsl:apply-templates select="ext:IdentificationRequired" />
				<xsl:apply-templates select="ext:PaymentInformationRequired" />
				<xsl:apply-templates select="ext:HasAddOnFeature" />

			</info>
		</price>
	</xsl:template>



	<!-- A recursive copy -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="node()" />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
