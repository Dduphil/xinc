<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Common parameters</xd:p>
        </xd:desc>
    </xd:doc>
    

    <xd:doc scope="param" id="vDbgXslt">
        <xd:desc>
            <xd:ul>
                <xd:li> {empty} : production mode</xd:li>
                <xd:li> _d_NoJavaExt : no java extension </xd:li>
                <xd:li> _d_keyOnly : no label resolution</xd:li>
                <xd:li> _d_{objet} : debug for {objet} </xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:param name="vDbgXslt"/>

    <xd:doc scope="param/pdf" id="pOutputFormat">
        <xd:desc>
            <xd:p>Final output format</xd:p>
            <xd:ul>
                <xd:li> 'RTF' : produce RTF</xd:li>
                <xd:li> 'PDF' : produce PDF</xd:li>
                <xd:li> Others format : 'PIVOT', 'PIVOT_PARTIAL' 'HTML5', 'STANDALONE', ... </xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pOutputFormat"/>


    <xd:doc scope="param" id="pUseResourceBundle">
        <xd:desc>
            <xd:ul>
                <xd:li> 'true' : production mode</xd:li>
                <xd:li> 'false' : display key</xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pUseResourceBundle" select="true()"/>

    <xd:doc scope="param" id="pResourceBundle">
        <xd:desc>
            <xd:ul>
                <xd:li> java </xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pResourceBundle"/>



    <xd:doc scope="param" id="pServiceRootUrl">
        <xd:desc>
            <xd:p>Root URL : <xd:a href="https://data.epo.org/expert-services/">Pise</xd:a></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pServiceRootUrl"/>
    
    <xd:doc scope="param" id="pDatabaseID">
        <xd:desc>
            <xd:p>the collection name : EPAB, GPI, ...</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pDatabaseID" />

    <xd:doc scope="param" id="pDocumentId">
        <xd:desc>
            <xs:p>pDocumentId</xs:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pDocumentId" />
    
    <xd:doc scope="param" id="pLang">
        <xd:desc>
            <xd:p>User Interface Langage</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pLang" select="'en'"/>


    <xd:doc scope="param" id="pDocPosition">
        <xd:desc>
            <xd:p>added for [uoss] in 201911 </xd:p>
            <xd:p>position of the document in the list</xd:p>
            <xd:p> prefix used to build uniq ID, ...</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="pDocPosition" select="'001'"/>

    <xsl:param name="pThumbnailFilesHeight"/>
    
    <!-- //C.KME -->
    <!-- [NOR] -/->
    <xsl:param name="pHideAutoNumbering_Description">false</xsl:param>
    <xsl:param name="pHideAutoNumbering_Claims">false</xsl:param>
    <xsl:param name="pBoldNumbering_Description">true</xsl:param>
    <xsl:param name="pBoldNumbering_Claims">true</xsl:param>
    <!-/- [/NOR] -->
    <!-- [DBG] -/->
  <xsl:param name="pHideAutoNumbering_Description">true</xsl:param>
  <xsl:param name="pHideAutoNumbering_Claims">true</xsl:param>
  <xsl:param name="pBoldNumbering_Description">false</xsl:param>
  <xsl:param name="pBoldNumbering_Claims">false</xsl:param>
  <!-/- [/DBG] -->
    
    
</xsl:stylesheet>