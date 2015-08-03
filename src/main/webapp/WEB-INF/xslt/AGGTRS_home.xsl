<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="homeExcess"/>
	<xsl:param name="contentsExcess"/>

	<xsl:template match="/">
		<soap-response>
			<homeExcess><xsl:value-of select="$homeExcess" /></homeExcess>
			<contentsExcess><xsl:value-of select="$contentsExcess" /></contentsExcess>
			<xsl:apply-templates />
		</soap-response>
	</xsl:template>

	<!-- "Identity" match -->
	<xsl:template match="soap-response">

			<xsl:for-each select="results">

				<xsl:variable name="serviceName"><xsl:value-of select="result/@service" /></xsl:variable>
				<xsl:variable name="responseTime"><xsl:value-of select="@responseTime" /></xsl:variable>

				<xsl:for-each select="result">
<!-- 					RESULT Node -->
					<xsl:choose>
						<xsl:when test="error">
							<xsl:element name="error">
								<xsl:attribute name="service">
									<xsl:value-of select="error/@service"></xsl:value-of>
								</xsl:attribute>
								<xsl:attribute name="type">
									<xsl:value-of select="error/@type"></xsl:value-of>
								</xsl:attribute>
								<xsl:attribute name="productId">
									<xsl:value-of select="@productId"></xsl:value-of>
								</xsl:attribute>
								<xsl:attribute name="responseTime">
									<xsl:value-of select="$responseTime" />
								</xsl:attribute>
								<code><xsl:value-of select="error/code"></xsl:value-of></code>
								<message><xsl:value-of select="error/message"></xsl:value-of></message>
								<data><xsl:value-of select="error/data"></xsl:value-of></data>
								<responseTime><xsl:value-of select="@responseTime"></xsl:value-of></responseTime>
							</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="results">
							<xsl:attribute name="service">
								<xsl:value-of select="$serviceName" />
							</xsl:attribute>
							<xsl:attribute name="responseTime">
								<xsl:value-of select="$responseTime" />
							</xsl:attribute>
							<responseTime><xsl:value-of select="$responseTime" /></responseTime>
							<price>
								<xsl:attribute name="service">
									<xsl:value-of select="$serviceName" />
								</xsl:attribute>
								<xsl:attribute name="productId">
									<xsl:value-of select="@productId" />
								</xsl:attribute>
								<productId><xsl:value-of select="@productId" /></productId>
								<productDes><xsl:value-of select="productDes" /></productDes>
								<coverType>
									<xsl:choose>
										<xsl:when test="headlineOffer = 'ONLINE'">
											<xsl:value-of select="onlinePrice/name" />
										</xsl:when>
										<xsl:when test="headlineOffer = 'OFFLINE'">
											<xsl:value-of select="offlinePrice/name" />
										</xsl:when>
									</xsl:choose>
								</coverType>
								<excess><xsl:value-of select="excess/total" /></excess>
								<quoteUrl><xsl:value-of select="quoteUrl" /></quoteUrl>
								<telNo><xsl:value-of select="telNo" /></telNo>
								<openingHours><xsl:value-of select="openingHours" /></openingHours>
								<leadNo><xsl:value-of select="leadNo" /></leadNo>
							</price>
						</xsl:element>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:for-each>
			</xsl:for-each>
			<!-- Select Error tag -->
			<xsl:for-each select="error">
				<xsl:element name="error">
					<xsl:attribute name="service">
						<xsl:value-of select="@service"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="type">
						<xsl:value-of select="@type"></xsl:value-of>
					</xsl:attribute>
					<xsl:attribute name="productId">
						<xsl:value-of select="@productId"></xsl:value-of>
					</xsl:attribute>
					<code><xsl:value-of select="code"></xsl:value-of></code>
					<message><xsl:value-of select="message"></xsl:value-of></message>
					<data><xsl:value-of select="data"></xsl:value-of></data>
					<responseTime>
							<xsl:value-of select="@responseTime"></xsl:value-of>
					</responseTime>
				</xsl:element>
			</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
