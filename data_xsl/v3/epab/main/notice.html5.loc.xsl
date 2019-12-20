<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 22, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> dduphil</xd:p>
            <xd:p>Display EPAB notice</xd:p>
            <xd:p> History: see SCM commit comment.</xd:p>
            <xd:p> Last update: 2019-11-25 [uoss] templating </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:output indent="no" encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>

    <xsl:include href="../../../v3/commons/param/params.xsl"/>
    <xsl:include href="../../../v3/commons/param/vars.xsl"/>
    
    <xsl:include href="../../../v3/epab/param/params.xsl"/>
    <xsl:include href="../../../v3/epab/param/vars.xsl"/>
    
    <xsl:include href="../../../v3/commons/lib/trace.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/text.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/patent.lib.xsl"/>

    <xsl:include href="../../../v3/commons/lib/label.lib.loc.xsl"/>
    <xsl:include href="../../../v3/commons/lib/anchorExtension.lib.loc.xsl"/>
    <xsl:include href="../../../v3/commons/lib/anchor.lib.xsl"/>

    <xsl:include href="../../../v3/epab/sub/bibliographie.pivot.xsl"/>
    <xsl:include href="../../../v3/epab/sub/notice.pivot.xsl"/>


    <xd:doc scope="template">
        <xd:desc>
            <xd:p>main</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <pivot collection="EPAB">
            <xsl:apply-templates select="document" mode="pi"/>
        </pivot>
    </xsl:template>

</xsl:stylesheet>
