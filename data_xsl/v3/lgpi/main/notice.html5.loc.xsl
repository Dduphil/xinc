<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"

 xmlns:exch="http://www.epo.org/exchange"
 
 xmlns:i_f="http://internalXslt/function"

 xmlns:emf="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleContainsKeyExtFct"
 xmlns:emg="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleGetStringExtFct"
 xmlns:emp="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPubServerExtFct"
 xmlns:emq="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlRegisterLinkExtFct"
 xmlns:ems="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPattentscopePublicationExtFct"
 
 exclude-result-prefixes="xd xs exch i_f emf emg emp emq ems"
    
    version="3.0">
<!-- [namespace-min]
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xd"
-->

<!-- [namespace-all]
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"

 xmlns:exch="http://www.epo.org/exchange"
 
 xmlns:i_f="http://internalXslt/function"

 xmlns:emf="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleContainsKeyExtFct"
 xmlns:emg="http://org.epo.mimosaserver.core.saxonextfct.ResourceBundleGetStringExtFct"
 xmlns:emp="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPubServerExtFct"
 xmlns:emq="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlRegisterLinkExtFct"
 xmlns:ems="http://org.epo.mimosaserver.core.saxonextfct.URLToolGetTypUrlPattentscopePublicationExtFct"
 
 exclude-result-prefixes="xd xs exch i_f emf emg emp emq ems"
    -->

    <xd:doc scope="stylesheet/lgpi">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> syntaxe xsl</xd:p>
            <xd:p>Display LGPI notice</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:output indent="no" encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>

    <!-- ==== Gestion des espaces ==== -->
    <xsl:strip-space elements="date"/>
    <xsl:preserve-space elements="text str snm"/>
    
    
    <!-- ==== number format ==== -->
    <xsl:decimal-format name="de" decimal-separator=","
        grouping-separator="." />
    <xsl:decimal-format name="fr" decimal-separator=","
        grouping-separator=" " />
    <xsl:decimal-format name="en" decimal-separator="."
        grouping-separator="," />

    <!-- ==== all include ==== -->
    <xsl:include href="../../../v3/commons/param/params.xsl"/>
    <xsl:include href="../../../v3/commons/param/vars.xsl"/>

    <xsl:include href="../../../v3/lgpi/param/params.xsl"/>
    <xsl:include href="../../../v3/lgpi/param/vars.xsl"/>

    <xsl:include href="../../../v3/commons/lib/trace.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/text.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/patent.lib.xsl"/>
    <xsl:include href="../../../v3/commons/lib/label.lib.loc.xsl"/>
    <xsl:include href="../../../v3/commons/lib/anchorExtension.lib.loc.xsl"/>
    <xsl:include href="../../../v3/commons/lib/anchor.lib.xsl"/>
    <xsl:include href="../../../v3/pivot/lib/pivot.lib.xsl"/>

    <xsl:include href="../../../v3/lgpi/sub/lgpi.lib.xsl"/>
    <xsl:include href="../../../v3/lgpi/sub/article.pivot.xsl"/>
    <xsl:include href="../../../v3/lgpi/sub/notice.standalone.xsl"/>
    <xsl:include href="../../../v3/lgpi/sub/notice.pivot.xsl"/>


    <xd:doc scope="template">
        <xd:desc>
            <xd:p>main</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <pivot collection="LGPI">
            <!--<div debug="pivot_CHKME"> debug notice.html5.xsl cc </div>-->
            <!-- WARNING !! one 'document' only -->
            <xsl:apply-templates select="documents/document[@type='notice'][1]" mode="pi"/>
        </pivot>
    </xsl:template>

</xsl:stylesheet>
