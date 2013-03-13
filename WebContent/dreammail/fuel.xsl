<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" />
  
	<xsl:template match="/data">
	
		<record>
			<emailAddress><xsl:value-of select="emailAddress" /></emailAddress>
			<theFirstname><xsl:value-of select="firstName" /></theFirstname>
			<theLastName><xsl:value-of select="lastName" /></theLastName>
			<createdOn><xsl:value-of select="createDate" /></createdOn>
		</record>
				
	</xsl:template>
</xsl:stylesheet>


