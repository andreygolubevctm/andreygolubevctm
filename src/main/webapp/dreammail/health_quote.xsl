<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" />
	<xsl:include href="/WEB-INF/aggregator/includes/utils.xsl"/>
	<xsl:param name="ClientName">
		BudgetDirect
	</xsl:param>
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
	<xsl:param name="Brand"></xsl:param>
	<xsl:param name="MailingName"></xsl:param>
	<xsl:param name="hashedEmail"></xsl:param>
	<xsl:param name="callCentrePhone"></xsl:param>
	<xsl:param name="ClientId"></xsl:param>
	<xsl:param name="baseURL"></xsl:param>
	<xsl:param name="unsubscribeToken"></xsl:param>
	
	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL"/>
	</xsl:template>
	
	<xsl:template match="/tempSQL">
	
<xsl:variable name="EmailAddress">
	<xsl:choose>
		<xsl:when test="save/email != ''">
			<xsl:value-of select="save/email" />
		</xsl:when>
		<xsl:when test="health/application/email != ''">
			<xsl:value-of select="health/application/email" />
		</xsl:when>
		<xsl:when test="health/contactDetails/email != ''">
			<xsl:value-of select="health/contactDetails/email" />
		</xsl:when>
			<xsl:otherwise>shaun.stephenson@aihco.com.au</xsl:otherwise>
		</xsl:choose>
</xsl:variable>

<xsl:variable name="escapedEmailAddress">
	<xsl:call-template name="util_replace">
		<xsl:with-param name="text" select="$EmailAddress" />
		<xsl:with-param name="replace" select="'+'" />
		<xsl:with-param name="with" select="'%2B'" />
	</xsl:call-template>
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

<xsl:variable name="actionURL">
	<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'retrieve_quotes.jsp?email=',$escapedEmailAddress,'&amp;hashedEmail=',$hashedEmail,'&amp;transactionId=',$tranId,'&amp;vertical=health]]&gt;')" />
</xsl:variable>

<xsl:variable name="unsubscribeURL">
	<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'unsubscribe.jsp?token=',$unsubscribeToken,']]&gt;')" />
</xsl:variable>

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
				<CustomerKey><xsl:value-of select="$CustomerKey" /></CustomerKey>
			</TriggeredSendDefinition>
			<Subscribers>

				<SubscriberKey><xsl:value-of select="$EmailAddress" /></SubscriberKey>
				<EmailAddress><xsl:value-of select="$EmailAddress" /></EmailAddress>

				<Attributes>
					<Name>SubscriberKey</Name>
					<Value><xsl:value-of select="$EmailAddress" /></Value>
				</Attributes>
				<Attributes>
					<Name>EmailAddr</Name>
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
					<Name>OptIn</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="health/application/optInEmail != ''">
											<xsl:value-of select="health/application/optInEmail"/>
										</xsl:when>
										<xsl:when test="health/save/marketing != ''">
											<xsl:value-of select="health/save/marketing"/>
										</xsl:when>
										<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
				</Attributes>
				<Attributes>
					<Name>OKToCall</Name>
								<Value>
									<xsl:choose>
							<xsl:when test="health/contactDetails/call != ''">
								<xsl:value-of select="health/contactDetails/call" />
							</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
										</xsl:choose>
								</Value>
				</Attributes>
				<Attributes>
					<Name>PhoneNumber</Name>
					<Value><xsl:value-of select="$callCentrePhone" /></Value>
				</Attributes>
				<Attributes>
					<Name>QuoteRef</Name>
								<Value>
									<xsl:value-of select="$tranId" />
								</Value>
				</Attributes>
				<Attributes>
					<Name>CTAUrl</Name>
					<Value><xsl:value-of disable-output-escaping="yes" select="$actionURL" /></Value>
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