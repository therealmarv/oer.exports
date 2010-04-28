<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:c="http://cnx.rice.edu/cnxml"
xmlns:md="http://cnx.rice.edu/mdml/0.4" xmlns:bib="http://bibtexml.sf.net/"
    exclude-result-prefixes="c">

<xsl:import href="debug.xsl"/>
<xsl:output indent="yes" method="xml"/>

<!-- Convert Content MathML to Presentation MathML -->
<xsl:include href="c2p.xsl"/>

<!-- Identity Transform -->
<xsl:template match="@*|node()">
   <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>

<xsl:template match="root">
	<xsl:apply-templates/>
</xsl:template>

<!--  Fix some CNXML 0.5 stuff -->
<xsl:template match="c:link[@src]">
	<c:link url="{@src}">
		<xsl:apply-templates/>
	</c:link>
</xsl:template>

<xsl:template match="c:media[@src]">
	<xsl:copy>
		<xsl:apply-templates select="@*"/>
		<xsl:if test="c:param[@name='alt']">
			<xsl:attribute name="alt"><xsl:value-of select="c:param[@name='alt']/@value"/></xsl:attribute>
		</xsl:if>
		<c:image>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="c:param[@name='print-width']">
				<xsl:attribute name="print-width"><xsl:value-of select="c:param[@name='print-width']/@value"/></xsl:attribute>
			</xsl:if>
		</c:image>
	</xsl:copy>
</xsl:template>

<xsl:template match="c:media/@type|c:image/@type">
	<xsl:call-template name="cnx.mime-type">
		<xsl:with-param name="mime-type" select="@type"/>
	</xsl:call-template>
</xsl:template>
<xsl:template name="cnx.mime-type" match="c:image/@mime-type">
	<xsl:param name="mime-type" select="@mime-type"/>
	<xsl:attribute name="mime-type">
		<xsl:choose>
			<xsl:when test="$mime-type='image/jpg'">image/jpeg</xsl:when>
			<xsl:when test="$mime-type=''">image/jpeg</xsl:when>
			<xsl:otherwise><xsl:value-of select="$mime-type"/></xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>
</xsl:template>


<xsl:template match="c:cnxn">
	<c:link>
		<xsl:apply-templates select="@*"/>
		<xsl:if test="@target"><xsl:attribute name="target-id">
			<xsl:value-of select="@target"/></xsl:attribute></xsl:if>
		<xsl:apply-templates/>
	</c:link>
</xsl:template>

<xsl:template match="c:name">
	<c:title>
		<xsl:apply-templates select="@*|node()"/>
	</c:title>
</xsl:template>


<xsl:template match="c:list[@type='inline']">
	<xsl:copy>
		<xsl:attribute name="display">inline</xsl:attribute>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="c:para//c:div">
	<xsl:call-template name="cnx.log"><xsl:with-param name="msg">WARNING: Removing c:div</xsl:with-param></xsl:call-template>
	<xsl:apply-templates/> 
</xsl:template>

<!-- Word importer does not detect these. -->
<xsl:template match="c:list[c:item[1]/c:label/text()='a']">
	<xsl:call-template name="format-list"><xsl:with-param name="numberStyle">lower-alpha</xsl:with-param></xsl:call-template>
</xsl:template>
<xsl:template match="c:list[c:item[1]/c:label/text()='A']">
	<xsl:call-template name="format-list"><xsl:with-param name="numberStyle">upper-alpha</xsl:with-param></xsl:call-template>
</xsl:template>
<xsl:template match="c:list[c:item[1]/c:label/text()='i']">
	<xsl:call-template name="format-list"><xsl:with-param name="numberStyle">lower-roman</xsl:with-param></xsl:call-template>
</xsl:template>
<xsl:template match="c:list[c:item[1]/c:label/text()='I']">
	<xsl:call-template name="format-list"><xsl:with-param name="numberStyle">upper-roman</xsl:with-param></xsl:call-template>
</xsl:template>
<xsl:template name="format-list">
	<xsl:param name="numberStyle">arabic</xsl:param>
	<xsl:call-template name="cnx.log"><xsl:with-param name="msg">WARNING: Inferring the @number-style on a list (probably imported from Word)</xsl:with-param></xsl:call-template>
	<xsl:copy>
		<xsl:attribute name="list-type">enumerated</xsl:attribute>
		<xsl:attribute name="number-style"><xsl:value-of select="$numberStyle"/></xsl:attribute>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>
<xsl:template match="c:list[c:item[1]/c:label[text()='A' or text()='a' or text()='I' or text()='i']]/c:item/c:label">
	<!-- Intentionally ignore. -->
</xsl:template>

</xsl:stylesheet>
