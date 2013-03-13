<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
							xmlns:health="http://admin.privatehealth.gov.au/ws/Schemas">
<xsl:output omit-xml-declaration="yes" indent="no"></xsl:output>
	
	<!-- WRITE TO PRODUCT_PROPERTIES TABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template name="start-write-prop">
	INSERT IGNORE INTO <xsl:value-of select="$schema"/>.product_properties (ProductId, PropertyId, SequenceNo, Value, Text, Date)
	VALUES</xsl:template>
	<xsl:template name="write-prop">
		<xsl:param name="name"></xsl:param>
		<xsl:param name="seq">0</xsl:param>
		<xsl:param name="txt"> </xsl:param>
		<xsl:param name="amt">0.00</xsl:param>
		<xsl:param name="dat">null</xsl:param>
	
		<xsl:variable name="dateString">
			<xsl:choose>
				<xsl:when test="$dat = 'null'">null</xsl:when>
				<xsl:otherwise>date('<xsl:value-of select="$dat" />')</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
	
		 
		<xsl:text>(</xsl:text><xsl:value-of select="$productId" /><xsl:text>,</xsl:text>
				<xsl:text>"</xsl:text><xsl:value-of select="$name" /><xsl:text>",</xsl:text>
				<xsl:value-of select="$seq" /><xsl:text>,</xsl:text>
				<xsl:value-of select="$amt" /><xsl:text>,</xsl:text>
				<xsl:text>"</xsl:text><xsl:value-of select="$txt" /><xsl:text>",</xsl:text>
				<xsl:value-of select="$dateString" /><xsl:text>),
</xsl:text>
	</xsl:template>
	
	
	<!-- WRITE TO PRODUCT_PROPERTIES_EXT TABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template name="write-ext-prop">
		<xsl:param name="txt"></xsl:param>

	    <xsl:variable name="quote">'</xsl:variable>
	    <xsl:variable name="dquote">''</xsl:variable>
	
	    <xsl:variable name="cleaned-txt">
		    <xsl:call-template name="string-replace-all">
		      <xsl:with-param name="text" select="$txt" />
		      <xsl:with-param name="replace" select="$quote" />
		      <xsl:with-param name="by" select="$dquote" />
		    </xsl:call-template>
	    </xsl:variable>
  
		INSERT IGNORE INTO `<xsl:value-of select="$schema"/>`.`product_properties_ext` (`ProductId`, `Text`,`Type`)
		VALUES (<xsl:value-of select="$productId" />,
				'<xsl:value-of select="$cleaned-txt" />','E'); |
	</xsl:template>
	
	<xsl:template name="string-replace-all">
	    <xsl:param name="text" />
	    <xsl:param name="replace" />
	    <xsl:param name="by" />
	    <xsl:choose>
	      <xsl:when test="contains($text, $replace)">
	        <xsl:value-of select="substring-before($text,$replace)" />
	        <xsl:value-of select="$by" />
	        <xsl:call-template name="string-replace-all">
	          <xsl:with-param name="text"
	          select="substring-after($text,$replace)" />
	          <xsl:with-param name="replace" select="$replace" />
	          <xsl:with-param name="by" select="$by" />
	        </xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="$text" />
	      </xsl:otherwise>
	    </xsl:choose>
  	</xsl:template>
	
</xsl:stylesheet>