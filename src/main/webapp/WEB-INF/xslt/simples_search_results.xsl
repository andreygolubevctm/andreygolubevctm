<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template match="/search_results">
	<search_results>
		<!-- Use * to target the vertical node e.g. <health> -->
		<xsl:for-each select="quote/*">
			<xsl:if test="string-length(id) &gt; 0">
				<quote>
					<id><xsl:value-of select="id" /></id>
					<rootid><xsl:value-of select="rootid" /></rootid>
					<email><xsl:value-of select="email" /><!-- TODO check TD fields --></email>
					<applicationEmail><xsl:value-of select="application/email" /></applicationEmail>
					<quoteBrandName><xsl:value-of select="quoteBrandName" /></quoteBrandName>
					<quoteBrandId><xsl:value-of select="quoteBrandId" /></quoteBrandId>
					<quoteDate><xsl:value-of select="quoteDate" /></quoteDate>
					<quoteTime><xsl:value-of select="quoteTime" /></quoteTime>
					<quoteType><xsl:value-of select="quoteType" /></quoteType>
                    <policyNo><xsl:value-of select="policyNo" /></policyNo>
					<editable><xsl:value-of select="editable" /></editable>

					<contacts>
						<xsl:variable name="primary">
							<xsl:value-of select="translate(application/primary/title, $LOWERCASE, $UPPERCASE)" /><xsl:text> </xsl:text><xsl:value-of select="translate(application/primary/firstname, $LOWERCASE, $UPPERCASE)" /><xsl:text> </xsl:text><xsl:value-of select="translate(application/primary/surname, $LOWERCASE, $UPPERCASE)" />
						</xsl:variable>
						<xsl:variable name="partner">
							<xsl:value-of select="translate(application/partner/title, $LOWERCASE, $UPPERCASE)" /><xsl:text> </xsl:text><xsl:value-of select="translate(application/partner/firstname, $LOWERCASE, $UPPERCASE)" /><xsl:text> </xsl:text><xsl:value-of select="translate(application/partner/surname, $LOWERCASE, $UPPERCASE)" />
						</xsl:variable>

						<name>
							<xsl:choose>
								<xsl:when test="string-length($primary) &gt; 2">
									<xsl:value-of select="$primary" />
									<xsl:if test="string-length($partner) &gt; 2">
										<xsl:text> and </xsl:text>
										<xsl:value-of select="$partner" />
									</xsl:if>
								</xsl:when>
								<xsl:when test="string-length(contactDetails/name) &gt; 0">
									<xsl:value-of select="translate(contactDetails/name, $LOWERCASE, $UPPERCASE)" />
								</xsl:when>
								<xsl:otherwise>CUSTOMER NAME UNKNOWN</xsl:otherwise>
							</xsl:choose>
						</name>
						<primary>
							<name><xsl:value-of select="$primary" /></name>
							<yourDtlsName><xsl:value-of select="translate(contactDetails/name, $LOWERCASE, $UPPERCASE)" /></yourDtlsName>
							<dob><xsl:value-of select="application/primary/dob" /></dob>
							<yourDtlsDob><xsl:value-of select="healthCover/primary/dob" /></yourDtlsDob>
						</primary>
						<partner>
							<name><xsl:value-of select="$partner" /></name>
							<dob><xsl:value-of select="application/partner/dob" /></dob>
							<yourDtlsDob><xsl:value-of select="healthCover/partner/dob" /></yourDtlsDob>
						</partner>
						<yourDtlsEmail><xsl:value-of select="contactDetails/email" /></yourDtlsEmail>
					</contacts>

					<resultData>
						<phone>
							<xsl:choose>
								<xsl:when test="string-length(application/mobile) &gt; 0">
									<xsl:value-of select="application/mobile" />
								</xsl:when>
								<xsl:when test="string-length(contactDetails/contactNumber/mobile) &gt; 0">
									<xsl:value-of select="contactDetails/contactNumber/mobile" />
								</xsl:when>
								<xsl:when test="string-length(contactDetails/contactNumber/other) &gt; 0">
									<xsl:value-of select="contactDetails/contactNumber/other" />
								</xsl:when>
								<xsl:when test="string-length(application/other) &gt; 0">
									<xsl:value-of select="application/other" />
								</xsl:when>
							</xsl:choose>
						</phone>
						<situation><xsl:value-of select="situation/healthCvr" /><xsl:text> - </xsl:text><xsl:value-of select="situation/healthSitu" /></situation>
						<income><xsl:value-of select="healthCover/incomelabel" /></income>
						<state><xsl:value-of select="situation/state" /></state>
						<location><xsl:value-of select="situation/state" /><xsl:text> </xsl:text><xsl:value-of select="situation/postcode" /></location>
						<dependants>
							<xsl:choose>
								<xsl:when test="string-length(healthCover/dependants) &gt; 0"><xsl:value-of select="healthCover/dependants" /></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</dependants>
						<benefitCount><xsl:value-of select="count(benefits/benefitsExtras/*)" /></benefitCount>
						<benefits>
							<xsl:for-each select="benefits/benefitsExtras/*">
								<xsl:choose>
									<xsl:when test="local-name(.) = 'PrHospital'">Private Hospital</xsl:when>
									<xsl:when test="local-name(.) = 'Puhospital'">Private Patient in Public Hospital</xsl:when>
									<xsl:when test="local-name(.) = 'DentalGeneral'">General Dental</xsl:when>
									<xsl:otherwise><xsl:value-of select="local-name(.)" /></xsl:otherwise>
								</xsl:choose>
								<xsl:if test="position() &lt; last()">, </xsl:if>
							</xsl:for-each>
						</benefits>
						<address>
							<xsl:variable name="street">
								<xsl:call-template name="get_street_name">
									<xsl:with-param name="address" select="application/address" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$street" />
							<xsl:if test="string-length(normalize-space($street)) &gt; 0">, </xsl:if>

							<xsl:if test="string-length(application/address/suburbName) &gt; 0">
								<xsl:value-of select="application/address/suburbName" />
								<xsl:text>, </xsl:text>
							</xsl:if>

							<xsl:if test="string-length(application/address/state) &gt; 0">
								<xsl:value-of select="application/address/state" />
								<xsl:text> </xsl:text>
							</xsl:if>

							<xsl:value-of select="application/address/postCode" />
						</address>
						<coverStart><xsl:value-of select="payment/details/start" /></coverStart>
					</resultData>
				</quote>
			</xsl:if>
		</xsl:for-each>
	</search_results>
</xsl:template>



<xsl:template name="get_street_name">
	<xsl:param name="address" />

	<xsl:choose>
		<!-- Non-Standard -->
		<xsl:when test="$address/nonStd='Y'">
			<xsl:choose>
				<!-- Has a unit/shop? -->
				<xsl:when test="$address/unitShop!=''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/streetNum, ' ', $address/nonStdStreet)" />
				</xsl:when>

				<!-- No Unit/shop -->
				<xsl:otherwise>
					<xsl:value-of select="concat($address/streetNum, ' ', $address/nonStdStreet)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

		<!-- Standard Address -->
		<xsl:otherwise>
			<xsl:choose>
				<!-- Smart capture unit and street number -->
				<xsl:when test="$address/unitSel != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitSel, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture unit, Smart capture street number -->
				<xsl:when test="$address/unitShop != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture unit and street number -->
				<xsl:when test="$address/unitShop != '' and $address/streetNum != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/streetNum, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Smart capture street number (only, no unit) -->
				<xsl:when test="$address/houseNoSel != ''">
					<xsl:value-of select="concat($address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture street number (only, no unit) -->
				<xsl:otherwise>
					<xsl:value-of select="concat($address/streetNum, ' ', $address/streetName)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
