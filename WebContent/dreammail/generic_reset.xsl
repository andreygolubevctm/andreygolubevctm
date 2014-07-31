<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" />
	<xsl:param name="ClientName">
		BudgetDirect
	</xsl:param>
	<xsl:param name="Brand">
		CTM
	</xsl:param>
	<xsl:param name="SiteName">
		Compare_Market
	</xsl:param>
	<xsl:param name="CampaignName">
		CompareTheMarket
	</xsl:param>
	<xsl:param name="MailingName">
		Password_Reset_TS_Key
	</xsl:param>
	<xsl:param name="baseURL"></xsl:param>
	<xsl:param name="env">
		_PRO
	</xsl:param>
	<xsl:param name="sendToEmail"></xsl:param>
	<xsl:param name="token"></xsl:param>
	<xsl:param name="ClientId"></xsl:param>

	<xsl:template match="/">
		<xsl:apply-templates select="/tempSQL"/>
	</xsl:template>

<xsl:template match="/tempSQL">

	<xsl:variable name="EmailAddress">
		<xsl:value-of select="$sendToEmail" />
	</xsl:variable>

	<xsl:variable name="uppercase"><xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text></xsl:variable>
	<xsl:variable name="lowercase"><xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text></xsl:variable>
	<xsl:variable name="BrandToUppercase"><xsl:value-of select="translate($Brand, $lowercase, $uppercase)" /></xsl:variable>

	<xsl:variable name="CustomerKey">
		<xsl:choose>
			<xsl:when test="$env = '_PRO'"><xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$MailingName" /></xsl:when>
			<xsl:otherwise><xsl:text>QA_</xsl:text><xsl:value-of select="$BrandToUppercase" /><xsl:text>_</xsl:text><xsl:value-of select="$MailingName" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="ResetUrl">
		<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[',$baseURL,'reset_password.jsp?id=',$token,']]&gt;')" />
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
						<Name>ResetUrl</Name>
						<Value><xsl:value-of disable-output-escaping="yes" select="$ResetUrl" /></Value>
					</Attributes>
					<Attributes>
						<Name>Brand</Name>
						<Value><xsl:value-of select="$Brand" /></Value>
					</Attributes>

				</Subscribers>

				<TriggeredSendDefinition>
					<PartnerKey xsi:nil="true"/>
					<ObjectID xsi:nil="true"/>
					<CustomerKey>
						<xsl:value-of select="$CustomerKey" />
					</CustomerKey>
				</TriggeredSendDefinition>

			</Objects>
		</CreateRequest>
	</soapenv:Body>
</soapenv:Envelope>


	</xsl:template>
</xsl:stylesheet>


