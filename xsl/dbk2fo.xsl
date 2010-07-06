<?xml version="1.0" ?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0">

<xsl:import href="debug.xsl"/>
<xsl:import href="../docbook-xsl/fo/docbook.xsl"/>
<xsl:import href="dbkplus.xsl"/>

<xsl:output indent="yes" method="xml"/>

<!-- Number the sections 1 level deep. See http://docbook.sourceforge.net/release/xsl/current/doc/html/ -->
<xsl:param name="section.autolabel" select="1"></xsl:param>
<xsl:param name="section.autolabel.max.depth">1</xsl:param>
<xsl:param name="chunk.section.depth" select="0"></xsl:param>
<xsl:param name="chunk.first.sections" select="0"></xsl:param>

<xsl:param name="section.label.includes.component.label">1</xsl:param>
<xsl:param name="xref.with.number.and.title">0</xsl:param>
<xsl:param name="toc.section.depth">0</xsl:param>

<xsl:param name="insert.xref.page.number">yes</xsl:param>


<!-- Add a template for newlines.
     The cnxml2docbook adds a processing instruction named <?cnx.newline?>
     and is matched here
     see http://www.sagehill.net/docbookxsl/LineBreaks.html
-->
<xsl:template match="processing-instruction('cnx.newline')">
	<fo:block>
		<xsl:comment>cnx.newline</xsl:comment>
	</fo:block>
</xsl:template>


<!-- Print the current module that is being worked on.
	Converting Docbook to XSL-FO may take hours so 
	it's useful to see that progress is being made
 -->
<xsl:template match="*[@xml:id or @id]" priority="1000000">
	<xsl:if test="@id and not(contains(@id, '.'))">
		<xsl:message>
			<xsl:text>LOG: Converting </xsl:text>
			<xsl:choose>
				<xsl:when test="@xml:id">
					<xsl:value-of select="@xml:id"/>
				</xsl:when>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
			</xsl:choose>
		</xsl:message>
	</xsl:if>
	<xsl:apply-imports select="."/>
</xsl:template>

<!-- ORIGINAL: docbook-xsl/fo/lists.xsl
	Changes: In addition to outputting "???" if a link is broken, 
	  also generate debug message so the author can fix it
 -->

</xsl:stylesheet>
