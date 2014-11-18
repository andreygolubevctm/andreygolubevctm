<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" />
	<xsl:param name="ClientName">
		BudgetDirect
	</xsl:param>
	<xsl:param name="Brand"></xsl:param>
	<xsl:param name="SiteName">
		Compare_Market
	</xsl:param>
	<xsl:param name="CampaignName">
		CompareTheMarket
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
	<xsl:param name="emailSubscribed"></xsl:param>
	<xsl:param name="callCentrePhone"></xsl:param>
	<xsl:param name="ClientId"></xsl:param>
	<xsl:param name="baseURL"></xsl:param>

	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL"/>
	</xsl:template>

	<xsl:template match="/tempSQL">

<xsl:variable name="EmailAddress">
	<xsl:choose>
		<xsl:when test="$sendToEmail != ''">
			<xsl:value-of select="$sendToEmail" />
		</xsl:when>
		<xsl:otherwise>shaun.stephenson@aihco.com.au</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="optinMarketing">
	<xsl:choose>
		<xsl:when test="$emailSubscribed != ''">
			<xsl:value-of select="$emailSubscribed"/>
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
			<xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$MailingName" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>QA_</xsl:text><xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$MailingName" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="OptInCustomerKey">
	<xsl:choose>
		<xsl:when test="$env = '_PRO'">
			<xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$OptInMailingName" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>QA_</xsl:text><xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$OptInMailingName" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="actionURL">
	<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'load_from_email.jsp?action=load&amp;type=bestprice&amp;id=',$tranId,'&amp;hash=',$hashedEmail,'&amp;vertical=health]]&gt;')" />
</xsl:variable>

<xsl:variable name="unsubscribeURL">
	<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'unsubscribe.jsp?unsubscribe_email=',$hashedEmail,'&amp;vertical=health&amp;email=',$EmailAddress,']]&gt;')" />
</xsl:variable>

<xsl:variable name="imageURL_prefix"><![CDATA[http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/health_]]></xsl:variable>
<xsl:variable name="imageURL_suffix"><![CDATA[.png]]></xsl:variable>

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
					<ClientID><xsl:value-of select="$ClientId" /></ClientID>
				</Client>
				<TriggeredSendDefinition>
					<PartnerKey xsi:nil="true"/>
					<ObjectID xsi:nil="true"/>
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

					<SubscriberKey><xsl:value-of select="$EmailAddress" /></SubscriberKey>
					<EmailAddress><xsl:value-of select="$EmailAddress" /></EmailAddress>

					<Attributes>
						<Name>SubscriberKey</Name>
						<Value><xsl:value-of select="$EmailAddress" /></Value>
					</Attributes>
					<Attributes>
						<Name>EmailAddress</Name>
						<Value><xsl:value-of select="$EmailAddress" /></Value>
					</Attributes>
					<Attributes>
						<Name>FirstName</Name>
						<Value>
							<xsl:choose>
								<xsl:when test="not(health/contactDetails/firstName)" >
									<xsl:value-of select="health/contactDetails/name" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="health/contactDetails/firstName" />
								</xsl:otherwise>
							</xsl:choose>
						</Value>
					</Attributes>
					<Attributes>
						<Name>LastName</Name>
						<Value></Value>
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
						<Name>Brand</Name>
						<Value><xsl:value-of select="$Brand" /></Value>
					</Attributes>
					<Attributes>
						<Name>QuoteReference</Name>
						<Value><xsl:value-of select="$tranId" /></Value>
					</Attributes>
					<Attributes>
						<Name>PhoneNumber</Name>
						<Value><xsl:value-of select="$callCentrePhone" /></Value>
					</Attributes>
					<Attributes>
						<Name>ApplyURL1</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$actionURL" /></Value>
					</Attributes>
					<Attributes>
						<Name>ApplyURL2</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$actionURL" /></Value>
					</Attributes>
					<Attributes>
						<Name>ApplyURL3</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$actionURL" /></Value>
					</Attributes>
					<Attributes>
						<Name>ApplyURL4</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$actionURL" /></Value>
					</Attributes>
					<Attributes>
						<Name>ApplyURL5</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$actionURL" /></Value>
					</Attributes>
					<Attributes>
						<Name>CallcentreHours</Name>
						<Value><xsl:value-of select="results/callCentreHours" /></Value>
					</Attributes>
					<Attributes>
						<Name>CoverType1</Name>
						<Value><xsl:value-of select="results/product0/productName" /></Value>
					</Attributes>
					<Attributes>
						<Name>PhoneNumber1</Name>
						<Value><xsl:value-of select="$callCentrePhone" /></Value>
					</Attributes>
					<Attributes>
						<Name>PhoneNumber2</Name>
						<Value><xsl:value-of select="$callCentrePhone" /></Value>
					</Attributes>
					<Attributes>
						<Name>PhoneNumber3</Name>
						<Value><xsl:value-of select="$callCentrePhone" /></Value>
					</Attributes>
					<Attributes>
						<Name>PhoneNumber4</Name>
						<Value><xsl:value-of select="$callCentrePhone" /></Value>
					</Attributes>
					<Attributes>
						<Name>PhoneNumber5</Name>
						<Value><xsl:value-of select="$callCentrePhone" /></Value>
					</Attributes>
					<Attributes>
						<Name>Premium1</Name>
						<Value><xsl:value-of select="results/product0/premium" /></Value>
					</Attributes>
					<Attributes>
						<Name>Premium2</Name>
						<Value><xsl:value-of select="results/product1/premium" /></Value>
					</Attributes>
					<Attributes>
						<Name>Premium3</Name>
						<Value><xsl:value-of select="results/product2/premium" /></Value>
					</Attributes>
					<Attributes>
						<Name>Premium4</Name>
						<Value><xsl:value-of select="results/product3/premium" /></Value>
					</Attributes>
					<Attributes>
						<Name>Premium5</Name>
						<Value><xsl:value-of select="results/product4/premium" /></Value>
					</Attributes>
					<Attributes>
						<Name>PremiumFrequency</Name>
						<Value><xsl:value-of select="results/product0/frequency" /></Value>
					</Attributes>
					<Attributes>
						<Name>PremiumLabel1</Name>
						<Value><xsl:value-of select="results/product0/premiumText" /></Value>
					</Attributes>
					<Attributes>
						<Name>PremiumLabel2</Name>
						<Value><xsl:value-of select="results/product1/premiumText" /></Value>
					</Attributes>
					<Attributes>
						<Name>PremiumLabel3</Name>
						<Value><xsl:value-of select="results/product2/premiumText" /></Value>
					</Attributes>
					<Attributes>
						<Name>PremiumLabel4</Name>
						<Value><xsl:value-of select="results/product3/premiumText" /></Value>
					</Attributes>
					<Attributes>
						<Name>PremiumLabel5</Name>
						<Value><xsl:value-of select="results/product4/premiumText" /></Value>
					</Attributes>
					<Attributes>
						<Name>Provider1</Name>
						<Value><xsl:value-of select="results/product0/providerName" /></Value>
					</Attributes>
					<Attributes>
						<Name>Provider2</Name>
						<Value><xsl:value-of select="results/product1/providerName" /></Value>
					</Attributes>
					<Attributes>
						<Name>Provider3</Name>
						<Value><xsl:value-of select="results/product2/providerName" /></Value>
					</Attributes>
					<Attributes>
						<Name>Provider4</Name>
						<Value><xsl:value-of select="results/product3/providerName" /></Value>
					</Attributes>
					<Attributes>
						<Name>Provider5</Name>
						<Value><xsl:value-of select="results/product4/providerName" /></Value>
					</Attributes>
					<Attributes>
						<Name>SmallLogo1</Name>
						<Value><xsl:value-of select="$imageURL_prefix"/><xsl:value-of select="translate(results/product0/provider, $uppercase, $lowercase)" /><xsl:value-of select="$imageURL_suffix"/></Value>
					</Attributes>
					<Attributes>
						<Name>SmallLogo2</Name>
						<Value><xsl:value-of select="$imageURL_prefix"/><xsl:value-of select="translate(results/product1/provider, $uppercase, $lowercase)" /><xsl:value-of select="$imageURL_suffix"/></Value>
					</Attributes>
					<Attributes>
						<Name>SmallLogo3</Name>
						<Value><xsl:value-of select="$imageURL_prefix"/><xsl:value-of select="translate(results/product2/provider, $uppercase, $lowercase)" /><xsl:value-of select="$imageURL_suffix"/></Value>
					</Attributes>
					<Attributes>
						<Name>SmallLogo4</Name>
						<Value><xsl:value-of select="$imageURL_prefix"/><xsl:value-of select="translate(results/product3/provider, $uppercase, $lowercase)" /><xsl:value-of select="$imageURL_suffix"/></Value>
					</Attributes>
					<Attributes>
						<Name>SmallLogo5</Name>
						<Value><xsl:value-of select="$imageURL_prefix"/><xsl:value-of select="translate(results/product4/provider, $uppercase, $lowercase)" /><xsl:value-of select="$imageURL_suffix"/></Value>
					</Attributes>
					<Attributes>
						<Name>UnsubscribeURL</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$unsubscribeURL" /></Value>
					</Attributes>

				</Subscribers>

			</Objects>
		</CreateRequest>
	</soapenv:Body>
</soapenv:Envelope>

	</xsl:template>
</xsl:stylesheet>