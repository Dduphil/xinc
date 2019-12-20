<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    
     xmlns:exch="http://www.epo.org/exchange"
 xmlns:ops="http://ops.epo.org"

    exclude-result-prefixes="xs xd exch ops" version="3.0">
    
    
    <xd:doc scope="stylesheet/ops">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p>Return sub part for 'family' (dynamic call)</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201812</xd:p>
            <xd:p><xd:b>History:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/family.html.html5-embedded.xsl</xd:p>
        </xd:desc>
    </xd:doc>

    
    <xsl:template match="IFAM">
    	<p class="skiptranslate">
   			<xsl:choose>
   				<xsl:when test="//fault or not(//ops:patent-family)">
   					<!-- Do not display the error message if the document is not present on OPS -->
   					<xsl:text>Data not found</xsl:text>
   				</xsl:when>
   				<xsl:otherwise>
   					<!--[DVP]>DVP data <![/DVP]-->
   					<xsl:for-each select="//ops:world-patent-data/ops:patent-family/ops:family-member/exch:publication-reference/exch:document-id[@document-id-type='docdb']">
   						<xsl:call-template name="tpl-LnkInt">
   						    <xsl:with-param name="pStyle" select="'cFamilyMemberOth'"/>
                            <xsl:with-param name="pCtry" select="./exch:country"/>
                            <xsl:with-param name="pDocNum" select="./exch:doc-number"/>
   						    <xsl:with-param name="pKind" select="./exch:kind"/>
   						    <xsl:with-param name="pType">document</xsl:with-param>
   						</xsl:call-template>
   						<xsl:if test="position() != last()">; </xsl:if>
   					</xsl:for-each>

   				</xsl:otherwise>
   			</xsl:choose>
            <!-- prise en compte du cas des family tronqués -->
            <xsl:if test="//ops:patent-family/@truncatedFamily = 'true'">
                <span>; ...</span>
            </xsl:if>
   		</p>
		</xsl:template>

</xsl:stylesheet>
