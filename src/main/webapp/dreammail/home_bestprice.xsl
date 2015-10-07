<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ddate="http://exslt.org/dates-and-times"
	extension-element-prefixes="ddate">
	<xsl:output indent="yes" />
	<xsl:param name="ClientName">
		BudgetDirect
	</xsl:param>
	<xsl:param name="Brand"></xsl:param>
	<xsl:param name="SiteName">
		Compare_Market
	</xsl:param>
	<xsl:param name="CampaignName">		CompareTheMarket
	</xsl:param>
	<xsl:param name="env">
		_PRO
	</xsl:param>
	<xsl:param name="tranId">
		000000000
	</xsl:param>
	<xsl:param name="SessionId">
		000000000
	</xsl:param>
	<xsl:param name="InsuranceType">
		Quote
	</xsl:param>
	<xsl:param name="MailingName"></xsl:param>
	<xsl:param name="OptInMailingName"></xsl:param>
	<xsl:param name="sendToEmail"></xsl:param>
	<xsl:param name="hashedEmail"></xsl:param>
	<xsl:param name="callCentrePhone"></xsl:param>
	<xsl:param name="ClientId"></xsl:param>
	<xsl:param name="baseURL"></xsl:param>

	<xsl:param name="ImageUrlPrefix"></xsl:param>
	<xsl:param name="ImageUrlSuffix"></xsl:param>
	<xsl:param name="unsubscribeToken"></xsl:param>

	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL"/>
	</xsl:template>

	<xsl:template match="/tempSQL">


	<!-- SET THE VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

		<xsl:variable name="address">
			<xsl:value-of select="home/property/address/fullAddress" />
		</xsl:variable>
		<xsl:variable name="productType">
			<xsl:choose>
				<xsl:when test="home/coverType = 'Home Cover Only'">H</xsl:when>
				<xsl:when test="home/coverType = 'Contents Cover Only'">C</xsl:when>
				<xsl:otherwise>HC</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="productLabel"><xsl:value-of select="home/coverType" /> Insurance</xsl:variable>

		<xsl:variable name="EmailAddress">
			<xsl:choose>
				<xsl:when test="home/policyHolder/email != ''">
					<xsl:value-of select="home/policyHolder/email" />
				</xsl:when>
				<xsl:otherwise>shaun.stephenson@aihco.com.au</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="optinMarketing">
			<xsl:choose>
				<xsl:when test="home/policyHolder/marketing = 'Y'">
					<xsl:value-of select="home/policyHolder/marketing"/>
				</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="uppercase"><xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text></xsl:variable>
		<xsl:variable name="lowercase"><xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text></xsl:variable>
		<xsl:variable name="BrandToUppercase"><xsl:value-of select="translate($Brand, $lowercase, $uppercase)" /></xsl:variable>
		<xsl:variable name="CustomerKey">
			<xsl:choose>
				<xsl:when test="$env = '_PRO'">
					<xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$productType" /><xsl:text>_</xsl:text><xsl:value-of select="$MailingName" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>QA_</xsl:text><xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$productType" /><xsl:text>_</xsl:text><xsl:value-of select="$MailingName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="OptInCustomerKey">
			<xsl:choose>
				<xsl:when test="$env = '_PRO'">
					<xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$productType" /><xsl:text>_</xsl:text><xsl:value-of select="$OptInMailingName" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>QA_</xsl:text><xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$productType" /><xsl:text>_</xsl:text><xsl:value-of select="$OptInMailingName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="actionURL">
			<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'load_from_email.jsp?action=load&amp;type=bestprice&amp;id=',$tranId,'&amp;hash=',$hashedEmail,'&amp;vertical=home')" />
		</xsl:variable>

		<xsl:variable name="unsubscribeURL">
			<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'unsubscribe.jsp?vertical=home&amp;token=',$unsubscribeToken,']]&gt;')" />
		</xsl:variable>
		<xsl:variable name="callcentreHours">
			<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',results/product0/openingHours,']]&gt;')" />
		</xsl:variable>




	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns:xsd="http://www.w3.org/2001/XMLSchema"
					xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
					xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
					xmlns:ns1="http://exacttarget.com/wsdl/partnerAPI">
			<soapenv:Header>
				<wsse:Security soapenv:mustUnderstand="1">
					<wsse:UsernameToken>
					<wsse:Username>6212063_API_User</wsse:Username>
					<wsse:Password>c039@r3t3</wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>
			<soapenv:Body>
				<CreateRequest xmlns="http://exacttarget.com/wsdl/partnerAPI">

					<Options/>

					<Objects xsi:type="ns1:TriggeredSend">

						<Client>
							<ID><xsl:value-of select="$ClientId" /></ID>
						</Client>

						<TriggeredSendDefinition>
							<CustomerKey>
								<xsl:choose>
									<xsl:when test="$optinMarketing = 'Y'">
										<xsl:value-of select="$OptInCustomerKey" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$CustomerKey" />
									</xsl:otherwise>
								</xsl:choose>
							</CustomerKey>
						</TriggeredSendDefinition>

						<Subscribers>

							<Attributes>
								<Name>ProductType</Name>
								<Value><xsl:value-of select="$productType" /></Value>
							</Attributes>
							<Attributes>
								<Name>ProductLabel</Name>
								<Value><xsl:value-of select="$productLabel" /></Value>
							</Attributes>
							<Attributes>
								<Name>Brand</Name>
								<Value><xsl:value-of select="$Brand" /></Value>
							</Attributes>
							<Attributes>
								<Name>FirstName</Name>
								<Value><xsl:value-of select="home/policyHolder/firstName" /></Value>
							</Attributes>
							<Attributes>
								<Name>LastName</Name>
								<Value><xsl:value-of disable-output-escaping="yes" select="home/policyHolder/lastName" /></Value>
							</Attributes>
							<Attributes>
								<Name>EmailAddress</Name>
								<Value><xsl:value-of select="$EmailAddress" /></Value>
							</Attributes>
							<Attributes>
								<Name>OptIn</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="$optinMarketing != 'N'">Y</xsl:when>
										<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Attributes>
							<Attributes>
								<Name>UnsubscribeURL</Name>
								<Value><xsl:value-of disable-output-escaping="yes" select="$unsubscribeURL" /></Value>
							</Attributes>

							<Attributes>
								<Name>CallcentreHours_Text</Name>
								<Value><xsl:value-of disable-output-escaping="yes" select="$callcentreHours" /></Value>
							</Attributes>
							<Attributes>
								<Name>CallcentreHours</Name>
								<Value><xsl:value-of disable-output-escaping="yes" select="$callcentreHours" /></Value>
							</Attributes>


							<xsl:call-template name="product">
								<xsl:with-param name="index">1</xsl:with-param>
								<xsl:with-param name="currentProduct" select="results/product0" />
							</xsl:call-template>

							<xsl:if test="results/product1/headline/name != ''">
								<xsl:call-template name="product">
									<xsl:with-param name="index">2</xsl:with-param>
									<xsl:with-param name="currentProduct" select="results/product1" />
								</xsl:call-template>
							</xsl:if>

							<xsl:if test="results/product2/headline/name != ''">
								<xsl:call-template name="product">
									<xsl:with-param name="index">3</xsl:with-param>
									<xsl:with-param name="currentProduct" select="results/product2" />
								</xsl:call-template>
							</xsl:if>

							<xsl:if test="results/product3/headline/name != ''">
								<xsl:call-template name="product">
									<xsl:with-param name="index">4</xsl:with-param>
									<xsl:with-param name="currentProduct" select="results/product3" />
								</xsl:call-template>
							</xsl:if>

							<xsl:if test="results/product4/headline/name != ''">
								<xsl:call-template name="product">
									<xsl:with-param name="index">5</xsl:with-param>
									<xsl:with-param name="currentProduct" select="results/product4" />
								</xsl:call-template>
							</xsl:if>

							<Attributes>
								<Name>SubscriberKey</Name>
								<Value><xsl:value-of select="$EmailAddress" /></Value>
							</Attributes>
							<Attributes>
								<Name>Address</Name>
								<Value><xsl:value-of select="$address" /></Value>
							</Attributes>
							<Attributes>
								<Name>PremiumFrequency</Name>
								<Value>Annual</Value>
							</Attributes>

							<SubscriberKey><xsl:value-of select="$EmailAddress" /></SubscriberKey>
							<EmailAddress><xsl:value-of select="$EmailAddress" /></EmailAddress>

						</Subscribers>
					</Objects>
				</CreateRequest>
			</soapenv:Body>
		</soapenv:Envelope>
	</xsl:template>

	<xsl:template name="getPremiumLabel">
		<xsl:param name="headlineOffer"/>

		<xsl:variable name="premiumLabel">
			<xsl:choose>
				<xsl:when test="$headlineOffer = 'OFFLINE'"><xsl:text> </xsl:text></xsl:when>
				<xsl:otherwise>Online<xsl:text> </xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[','Annual ',$premiumLabel,'Premium',']]&gt;')" />
	</xsl:template>

	<xsl:template name="product" xmlns="http://exacttarget.com/wsdl/partnerAPI">

		<xsl:param name="index" />
		<xsl:param name="currentProduct" />

		<xsl:variable name="imageURL_prefix"><xsl:value-of select="$ImageUrlPrefix" /></xsl:variable>
		<xsl:variable name="imageURL_suffix"><xsl:value-of select="$ImageUrlSuffix" /></xsl:variable>

		<xsl:variable name="uppercase"><xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text></xsl:variable>
		<xsl:variable name="lowercase"><xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text></xsl:variable>

		<xsl:variable name="productId"><xsl:value-of select="$currentProduct/productId" /></xsl:variable>

		<Attributes>
			<Name>CoverType<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of select="$currentProduct/headline/name" /></Value>
		</Attributes>

		<Attributes>
			<Name>ValidDate<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of select="$currentProduct/validateDate/display" /></Value>
		</Attributes>

		<Attributes>
			<Name>Provider<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of select="$currentProduct/productDes" /></Value>
		</Attributes>

		<Attributes>
			<Name>SmallLogo<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of select="$imageURL_prefix"/><xsl:value-of select="translate($currentProduct/brandCode, $uppercase, $lowercase)" /><xsl:value-of select="$imageURL_suffix"/></Value>
		</Attributes>

		<Attributes>
			<Name>Premium<xsl:value-of select="$index" /></Name>
			<Value>$<xsl:value-of select="$currentProduct/price/annual/total" /></Value>
		</Attributes>

		<xsl:variable name="homeExcess" select="$currentProduct/HHB/excess/amount" />
		<Attributes>
			<Name>ExcessHome<xsl:value-of select="$index" /></Name>
			<Value><xsl:if test="$homeExcess > 0">$<xsl:value-of select="$homeExcess" /></xsl:if></Value>
		</Attributes>

		<xsl:variable name="contentsExcess" select="$currentProduct/HHC/excess/amount" />
		<Attributes>
			<Name>ExcessContents<xsl:value-of select="$index" /></Name>
			<Value><xsl:if test="$contentsExcess > 0">$<xsl:value-of select="$contentsExcess" /></xsl:if></Value>
		</Attributes>

		<Attributes>
			<Name>ApplyURL<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'email/incoming/gateway.json?token=',$currentProduct/loadQuoteToken,']]&gt;')"/></Value>
		</Attributes>

		<Attributes>
			<Name>PremiumLabel<xsl:value-of select="$index" /></Name>
			<Value>
				<xsl:call-template name="getPremiumLabel">
					<xsl:with-param name="headlineOffer" select="$currentProduct/headlineOffer" />
				</xsl:call-template>
			</Value>
		</Attributes>

		<Attributes>
			<Name>PhoneNumber<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of select="$currentProduct/telNo" /></Value>
		</Attributes>

		<Attributes>
			<Name>QuoteRef<xsl:value-of select="$index" /></Name>
			<Value><xsl:value-of select="$currentProduct/leadNo" /></Value>
		</Attributes>

	</xsl:template>


</xsl:stylesheet>