<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes" />

	<!-- This code is absolute insanity. You would think that it wouldn't be so hard to just remove multiple named nodes from XML but thats actually the case. It be crazy. -->
	<!-- I never want to touch this again. Don't ask me to do it. -->

	<xsl:template match="/">
		<settings>

			<xsl:variable name="allSettings" select="*" />
			<xsl:for-each select="settings/*">
				<xsl:variable name="node"><xsl:value-of select="node()"/></xsl:variable>
				<xsl:variable name="name"><xsl:value-of select="name()"/></xsl:variable>
				<xsl:variable name="count"><xsl:value-of select="count(preceding-sibling::*[name()=$name])"/></xsl:variable>
				<xsl:if test="$count = 0">
					<xsl:for-each select="$allSettings/*">
						<xsl:variable name="node2"><xsl:value-of select="node()"/></xsl:variable>
						<xsl:variable name="name2"><xsl:value-of select="name()"/></xsl:variable>
						<xsl:variable name="count2"><xsl:value-of select="count(preceding-sibling::*[name()=$name2])"/></xsl:variable>
						<xsl:if test="($name = $name2) and ($count2 = 0)">
								<xsl:choose>
									<xsl:when test="$node2 != '' and $node2 != ' ' and not(normalize-space($node2)='') and not(normalize-space($node2)=' ')">
										<xsl:element name="{$name2}"><xsl:value-of select="$node2"/></xsl:element>
									</xsl:when>

									<xsl:otherwise>
										<xsl:element name="{$name2}">
											<xsl:variable name="newpath"><xsl:value-of select="$name2"/></xsl:variable>
											<xsl:for-each select="*">
												<xsl:variable name="node3"><xsl:value-of select="node()"/></xsl:variable>
												<xsl:variable name="name3"><xsl:value-of select="name()"/></xsl:variable>
												<xsl:element name="{$name3}">
													<!-- If anyone introduces a crazy new level of nodes then this would probably need another loop.  -->
													<!-- In that case, good luck to you buddy. -->
													<xsl:value-of select="$node3"/>
													<xsl:for-each select="*">
														<xsl:variable name="node4"><xsl:value-of select="node()"/></xsl:variable>
														<xsl:variable name="name4"><xsl:value-of select="name()"/></xsl:variable>
														<xsl:element name="{$name4}"><xsl:value-of select="$node4"/></xsl:element>
													</xsl:for-each>
												</xsl:element>
											</xsl:for-each>

										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>

		</settings>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
</xsl:transform>