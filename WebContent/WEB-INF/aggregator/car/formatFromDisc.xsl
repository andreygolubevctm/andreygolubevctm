<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="time">
		11:11 am
	</xsl:param>
	<xsl:param name="date">
		11/11/11
	</xsl:param>
	<xsl:param name="email">thisShouldNotBeNull@fake.com</xsl:param>
	<xsl:param name="id">0</xsl:param>

	<xsl:template match="/">
		<quote>
			<id><xsl:value-of select="$id" /></id>
			<email><xsl:value-of select="$email" /></email>
			<quoteDate><xsl:value-of select="$date" /></quoteDate>
			<quoteTime><xsl:value-of select="$time" /></quoteTime>
			<quoteType>quote</quoteType>
			<fromDisc>true</fromDisc>
			<inPast><xsl:value-of select="*/inPast" /></inPast>
			<vehicle>
				<year><xsl:value-of select="*/vehicle/year" /></year>
				<makeDes><xsl:value-of select="*/vehicle/make" /></makeDes>
				<modelDes><xsl:value-of select="*/vehicle/model" /></modelDes>
			</vehicle>
			<drivers>
				<regular>
					<xsl:copy-of select="*/driver/*" />
				</regular>
				<young>
					<xsl:copy-of select="*/youngDriver/*" />
				</young>
			</drivers>
		</quote>
	</xsl:template>
</xsl:stylesheet>