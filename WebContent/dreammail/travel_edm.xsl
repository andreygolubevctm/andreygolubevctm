<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" />
	<xsl:param name="ClientName">
		BudgetDirect
	</xsl:param>
	<xsl:param name="SiteName">
		Compare_Market
	</xsl:param>
	<xsl:param name="CampaignName">
		CompareTheMarket
	</xsl:param>
	<xsl:param name="MailingName">
		RTM_CTM_TRAVEL_QUOTE
	</xsl:param>
	<xsl:param name="env">
		_PRO
	</xsl:param>
	<xsl:param name="server">https://secure.comparethemarket.com.au/</xsl:param>
	<xsl:param name="tranId">
		000000000
	</xsl:param>
	<xsl:param name="SessionId">
		000000000
	</xsl:param>
	<xsl:param name="InsuranceType">
		Quote
	</xsl:param>
	<xsl:param name="hashedEmail">
		XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	</xsl:param>

	<xsl:template name="format_date">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$day"/>-<xsl:choose>
			<xsl:when test="$month = '01'">Jan</xsl:when>
			<xsl:when test="$month = '02'">Feb</xsl:when>
			<xsl:when test="$month = '03'">Mar</xsl:when>
			<xsl:when test="$month = '04'">Apr</xsl:when>
			<xsl:when test="$month = '05'">May</xsl:when>
			<xsl:when test="$month = '06'">Jun</xsl:when>
			<xsl:when test="$month = '07'">Jul</xsl:when>
			<xsl:when test="$month = '08'">Aug</xsl:when>
			<xsl:when test="$month = '09'">Sep</xsl:when>
			<xsl:when test="$month = '10'">Oct</xsl:when>
			<xsl:when test="$month = '11'">Nov</xsl:when>
			<xsl:when test="$month = '12'">Dec</xsl:when>
		</xsl:choose>-<xsl:value-of select="$year"/>

	</xsl:template>

	<!-- Wendy.Trieu@permission.com.au -->
	<!-- ceire.oneill@permission.com.au -->
	<!-- suwandi.djan@permission.com.au -->
	<!-- Elvin.Singh@captaincompare.com.au -->
	<!-- Lorraine.Cruickshank@permission.com.au -->

	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL"/>
	</xsl:template>

	<xsl:template match="/tempSQL">

<xsl:variable name="EmailAddress">
	<xsl:choose>
		<xsl:when test="save/email != ''">
			<xsl:value-of select="save/email" />
		</xsl:when>
		<xsl:when test="travel/application/email != ''">
			<xsl:value-of select="travel/application/email" />
		</xsl:when>
		<xsl:when test="travel/contactDetails/email != ''">
			<xsl:value-of select="travel/contactDetails/email" />
		</xsl:when>
		<xsl:when test="travel/email != ''">
			<xsl:value-of select="travel/email" />
		</xsl:when>
	</xsl:choose>
</xsl:variable>

		<xsl:variable name="tripType">
			<xsl:choose>
				<xsl:when test="travel/policyType != ''">
					<xsl:value-of select="travel/policyType" />
				</xsl:when>
				<xsl:otherwise>S</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<RTMWeblet>
			<RTMEmailToEmailAddress>
				<AcknowledgementsTo>
					<EmailAddress>shaun.stephenson@comparethemarket.com.au</EmailAddress>
					<Option>2</Option>
				</AcknowledgementsTo>
				<ClientName>
					<xsl:value-of select="$ClientName" />
				</ClientName>
				<SiteName>
					<xsl:value-of select="$SiteName" />
				</SiteName>
				<CampaignName>
					<xsl:value-of select="$CampaignName" />
					<xsl:value-of select="$env" />
				</CampaignName>
				<MailingName>
					<xsl:value-of select="$MailingName" />
					<xsl:value-of select="$env" />
				</MailingName>
				<ToEmailAddress>
					<EventEmailAddress>
						<EmailAddress>
							<xsl:value-of select="$EmailAddress" />
						</EmailAddress>

						<EventVariables>
							<Variable>
								<Name>EventVar:EmailAddr</Name>
								<Value>
									<xsl:value-of select="$EmailAddress" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:FirstName</Name>
								<Value><xsl:value-of select="travel/firstName" /></Value>
							</Variable>
							<Variable>
								<Name>EventVar:LastName</Name>
								<Value><xsl:value-of select="travel/surname" /></Value>
							</Variable>
							<Variable>
								<Name>EventVar:OKToCall</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="travel/call != ''">
											<xsl:value-of select="travel/call" />
										</xsl:when>
										<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:OptIn</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="travel/application/optInEmail != ''">
											<xsl:value-of select="travel/application/optInEmail"/>
										</xsl:when>
										<xsl:when test="travel/marketing != ''">
											<xsl:value-of select="travel/marketing"/>
										</xsl:when>
										<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:CoverType</Name>
								<Value><xsl:choose>
											<xsl:when test="travel/policyType = 'S'"><![CDATA[Single Trip]]></xsl:when>
											<xsl:otherwise><![CDATA[Annual Trip]]></xsl:otherwise>
										</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:HeaderImageURL</Name>
								<Value><![CDATA[http://images.permission.com.au/CTM/CTM6112/hdrBanner.gif]]></Value>
							</Variable>

							<xsl:for-each select="travel/destinations/*/*">
								<xsl:if test="position() &lt; 6">
									<Variable>
										<Name>EventVar:Destination<xsl:value-of select="position()" /></Name>
										<Value>
											<xsl:choose>
												<xsl:when test=". = 'af:af'">Africa</xsl:when>
												<xsl:when test=". = 'am:us'">USA</xsl:when>
												<xsl:when test=". = 'am:ca'">Canada</xsl:when>
												<xsl:when test=". = 'am:sa'">South America</xsl:when>
												<xsl:when test=". = 'as:ch'">China</xsl:when>
												<xsl:when test=". = 'as:hk'">Hong Kong</xsl:when>
												<xsl:when test=". = 'as:jp'">Japan</xsl:when>
												<xsl:when test=". = 'as:in'">India</xsl:when>
												<xsl:when test=". = 'as:th'">Thailand</xsl:when>
												<xsl:when test=". = 'pa:au'">Australia</xsl:when>
												<xsl:when test=". = 'pa:ba'">Bali</xsl:when>
												<xsl:when test=". = 'pa:in'">Indonesia</xsl:when>
												<xsl:when test=". = 'pa:nz'">New Zealand</xsl:when>
												<xsl:when test=". = 'pa:pi'">Pacific Islands</xsl:when>
												<xsl:when test=". = 'eu:eu'">Europe</xsl:when>
												<xsl:when test=". = 'eu:uk'">UK</xsl:when>
												<xsl:when test=". = 'me:me'">Middle East</xsl:when>
												<xsl:when test=". = 'do:do'">Any other country</xsl:when>
												<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
											</xsl:choose>
										</Value>
									</Variable>
								</xsl:if>
							</xsl:for-each>

							<Variable>
								<Name>EventVar:CoverDurationStart</Name>
								<Value><xsl:call-template name="format_date"><xsl:with-param name="eurDate" select="travel/dates/fromDate" /></xsl:call-template></Value>
							</Variable>
							<Variable>
								<Name>EventVar:CoverDurationEnd</Name>
								<Value><xsl:call-template name="format_date"><xsl:with-param name="eurDate" select="travel/dates/toDate" /></xsl:call-template></Value>
							</Variable>
							<Variable>
								<Name>EventVar:NoOfAdults</Name>
								<Value><xsl:value-of select="travel/adults"/></Value>
							</Variable>
							<Variable>
								<Name>EventVar:NoOfChildren</Name>
								<Value><xsl:value-of select="travel/children"/></Value>
							</Variable>
							<Variable>
								<Name>EventVar:OldestAge</Name>
								<Value><xsl:value-of select="travel/oldest"/></Value>
							</Variable>
							<Variable>
								<Name>EventVar:QuotePrice</Name>
								<Value><xsl:value-of select="translate(price,'$','')" /></Value>
							</Variable>
							<Variable>
								<Name>EventVar:CTAURL</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="$env = '_PRO'"><![CDATA[https://secure.comparethemarket.com.au/ctm/travel_quote.jsp?action=load&id=]]><xsl:value-of select="$tranId" /><![CDATA[&hash=]]><xsl:value-of select="$hashedEmail" /><![CDATA[&type=]]><xsl:value-of select="$tripType" /></xsl:when>
										<xsl:otherwise><xsl:value-of select="$server" /><![CDATA[ctm/travel_quote.jsp?action=load&id=]]><xsl:value-of select="$tranId" /><![CDATA[&hash=]]><xsl:value-of select="$hashedEmail" /><![CDATA[&type=]]><xsl:value-of select="$tripType" /></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:UpsellURL</Name>
								<Value><![CDATA[http://www.comparethemarket.com.au/travel-insurance/]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:ContactUsURL</Name>
								<Value><![CDATA[http://www.comparethemarket.com.au/contact-us/]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:UnsubscribeURL</Name>
								<Value><xsl:choose>
										<xsl:when test="$env = '_PRO'"><![CDATA[https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?DISC=true&unsubscribe_email=]]><xsl:value-of select="$EmailAddress" /></xsl:when>
										<xsl:otherwise><xsl:value-of select="$server" /><![CDATA[ctm/unsubscribe.jsp?DISC=true&unsubscribe_email=]]><xsl:value-of select="$EmailAddress" /></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:UpdateDetailsURL</Name>
								<Value><![CDATA[http://www.comparethemarket.com.au/updatemydetails]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:QuoteRef</Name>
								<Value>
									<xsl:value-of select="$tranId" />
								</Value>
							</Variable>
						</EventVariables>
					</EventEmailAddress>
				</ToEmailAddress>
			</RTMEmailToEmailAddress>
		</RTMWeblet>

	</xsl:template>
</xsl:stylesheet>