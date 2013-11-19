<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ext="http://switchwise.com.au/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:a="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
	exclude-result-prefixes="soapenv ext i a">

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

			<xsl:when test="count(ext:ProductDetail/ext:Product) = 0 or count(ext:ProductDetail/ext:PaymentOptions) = 0 or count(ext:ProductDetail/ext:Rates) = 0">
				<xsl:call-template name="ResultError">
					<xsl:with-param name="message" select="'Failed to fetch all the product details.'" />
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
			<messages />

			<xsl:apply-templates select="ext:ProductDetail/ext:Product" />
		</results>
	</xsl:template>



	<xsl:template match="ext:Product">
		<price>
			<info>
				<Downloads>
					<xsl:for-each select="/ext:ProductDetail/ext:Downloads/ext:DocumentLink">
						<Download>
							<Name><xsl:value-of select="ext:Name" /></Name>
							<FileName>
								<xsl:call-template name="urlencode">
									<xsl:with-param name="text"><xsl:value-of select="ext:FileName" /></xsl:with-param>
								</xsl:call-template>
							</FileName>
							<xsl:apply-templates select="ext:DocumentType" />
						</Download>
					</xsl:for-each>
				</Downloads>

				<Features>
					<xsl:for-each select="/ext:ProductDetail/ext:Features/ext:FeatureGroup">
						<Feature>
							<Name><xsl:value-of select="ext:Name" /></Name>
							<xsl:if test="count(ext:Lines) &gt; 0">
								<Lines>
									<xsl:for-each select="ext:Lines/ext:FeatureLine">
										<xsl:if test="ext:Content != '' or ext:Prompt != ''">
											<FeatureLine>
												<xsl:apply-templates select="node()" />
											</FeatureLine>
										</xsl:if>
									</xsl:for-each>
								</Lines>
							</xsl:if>
						</Feature>
					</xsl:for-each>
				</Features>

				<PaymentOptions>
					<xsl:apply-templates select="/ext:ProductDetail/ext:PaymentOptions/node()" />
				</PaymentOptions>

				<Rates>
					<xsl:apply-templates select="/ext:ProductDetail/ext:Rates/node()" />
				</Rates>

				<TermConditions>
					<xsl:for-each select="/ext:ProductDetail/ext:TermConditions/a:string">
						<TermCondition><xsl:value-of select="." /></TermCondition>
					</xsl:for-each>
				</TermConditions>
			</info>
		</price>
	</xsl:template>



	<!-- A recursive copy -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<!-- <xsl:copy-of select="@*" /> -->
			<xsl:apply-templates select="node()" />
		</xsl:element>
	</xsl:template>

	<xsl:template name="urlencode">
		<xsl:param name="text" />
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="$text" />
					<xsl:with-param name="replace" select="'&amp;'" />
					<xsl:with-param name="by" select="'%26'" />
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="replace" select="' '" />
			<xsl:with-param name="by" select="'%20'" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
