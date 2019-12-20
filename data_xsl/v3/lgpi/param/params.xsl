<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>collection parameters</xd:p>
            <xd:p>To complete with collection or 'data input' specific parameters</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- 'embedded' in Pise application or 'standalone' for indexation-->
    <xsl:param name="pHtmlType">embedded</xsl:param>

    <!-- URL de l'application espacenet pour le pdf -->
    <xsl:param name="pUrlPdfEspacenet">http://worldwide.espacenet.com/publicationDetails/originalDocument?CC={COUNTRY}&amp;NR={DOC_NUMBER}&amp;KC={KIND_CODE}&amp;locale={LOCALE_LANG}&amp;date=&amp;FT=D</xsl:param>
    <!-- Add "/gpi/" prefix for gpi documents -->
    <xsl:param name="pUrlPrefix"/>
    <!-- Total number of documents in database -->
    <xsl:param name="pNbDocuments"/>
    <!-- Total number of new documents added in database during current week-->
    <xsl:param name="pNbAddedDocuments"/>
    <!-- Total number of new documents amended in database during current week-->
    <xsl:param name="pNbAmendedDocuments"/>
    <!-- Publication date of the current database -->
    <xsl:param name="pPublicationDate"/>
    <!-- Document URI -->
    <xsl:param name="pSelfUri"/>
    
    <!-- Human Readable Document ID -->
    <xsl:param name="pHumanReadableDocumentId"/>
    
    
    <!-- 2019 Epab EuroPct -->
    <xsl:param name="pHideAutoNumbering_Description">false</xsl:param>
    <xsl:param name="pHideAutoNumbering_Claims">false</xsl:param>
    
</xsl:stylesheet>
