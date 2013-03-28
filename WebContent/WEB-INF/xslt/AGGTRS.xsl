<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 	<xsl:param name="excess"/>

	<xsl:template match="/">
		<soap-response>
			<excess><xsl:value-of select="$excess" /></excess>
			<xsl:apply-templates />
		</soap-response>
	</xsl:template>
	
	<!-- "Identity" match --> 
	<xsl:template match="soap-response">
			
			<xsl:for-each select="results">
			
				<xsl:variable name="serviceName"><xsl:value-of select="price/@service" /></xsl:variable>
				<xsl:variable name="responseTime"><xsl:value-of select="@responseTime" /></xsl:variable>
			
				<xsl:for-each select="price">
					<xsl:choose>
						<xsl:when test="error">
							<xsl:element name="error">
								<xsl:attribute name="service">
									<xsl:value-of select="price/error/@service"></xsl:value-of>
								</xsl:attribute>
								<xsl:attribute name="type">
									<xsl:value-of select="price/error/@type"></xsl:value-of>
								</xsl:attribute>
								<xsl:attribute name="productId">
									<xsl:value-of select="price/@productId"></xsl:value-of>
								</xsl:attribute>
								<code><xsl:value-of select="price/error/code"></xsl:value-of></code>
								<message><xsl:value-of select="price/error/message"></xsl:value-of></message>
								<responseTime><xsl:value-of select="@responseTime"></xsl:value-of></responseTime>
							</xsl:element>			
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="results">
							<xsl:attribute name="service">
								<xsl:value-of select="$serviceName" />
							</xsl:attribute>
							<responseTime><xsl:value-of select="$responseTime" /></responseTime>					
							<price>
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
					<responseTime>
							<xsl:value-of select="@responseTime"></xsl:value-of>
					</responseTime>
				</xsl:element>
			</xsl:for-each>
			
	</xsl:template>
</xsl:stylesheet>
