<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:i_d="http://internalXslt/data"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs xd" version="3.0">

  <!-- [old]
    <x.l:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
  xmlns:fox="http://xml.apache.org/fop/extensions"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:e.ch="http://www.epo.org/exchange"
  xmlns:exsl="http://exslt.org/common">
  -->

  <!--  <xd:doc scope="stylesheet/sub">
    <xd:desc>
      <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
      <xd:p><xd:b>Aim:</xd:b>convert 'pivot' to 'xsl-fo' for 'pdf' rendition.</xd:p>
      <xd:p><xd:b>Last update:</xd:b> 201911 V.O. </xd:p>
      <xd:p><xd:b>History:</xd:b> see SCM comments</xd:p>
      <xd:p><xd:b>Origin:</xd:b>UOSS new 'pivot' format (from {collection}/lgpi/notice-article.pdf.xsl) </xd:p>
      <xd:p/>
    </xd:desc>
  </xd:doc>
-->
  <!--
    <fo:block margin-top="1em">
        <fo:block id="EP_001" color="#808080" publication</fo:block>
        <fo:block margin-left="2 em"><fo:basic-link color="rgb(192,32,25)" font-weight="700" external-destination="https://...">EP 0254704 B1 19900103 [1990-01]</fo:basic-link></fo:block>
    </fo:block>
    -->



  <!-- === functions === -->


  <!-- ==== main ====  -->
  <xd:doc scope="[optional]/main">
    <xd:desc>
      <xd:p> optional root 'pivot' see 'document' </xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="pivot" mode="fo">
    <xsl:apply-templates mode="fo"/>
  </xsl:template>

<xd:doc scope="template/main">
    <xd:desc>
      <xd:p>Main</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="document[@type = 'notice']" mode="fo">
    <fo:root font-family="Helvetica" font-size="8pt">
      <fo:layout-master-set>
        <fo:simple-page-master margin-right="0.955cm" margin-left="0.955cm" margin-bottom="0.75cm" margin-top="0.75cm" page-width="21cm" page-height="29.7cm" master-name="default-page">
          <fo:region-body margin-top="0cm" margin-bottom="0cm" margin-left="0cm" margin-right="0cm"/>
          <fo:region-before extent="0cm"/>
          <fo:region-after extent="0cm"/>
        </fo:simple-page-master>

        <!-- enchainement des pages  -->
        <fo:page-sequence-master master-name="run">
          <fo:repeatable-page-master-alternatives>
            <!-- fop23  maximum-repeats="no-limit" -->
            <fo:conditional-page-master-reference master-reference="default-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <xsl:apply-templates mode="foPage"/>

    </fo:root>
  </xsl:template>

  <!-- === templates === -->

  <xd:doc scope="pi:template:fo" id="mode_foPage">
    <xd:desc> start new page</xd:desc>
  </xd:doc>
  <xsl:template match="*" mode="foPage">
    <!--  contenu de la première page  initial-page-number="1" -->
    <fo:page-sequence master-reference="default-page" format="1">
      <fo:flow flow-name="xsl-region-body">
        <xsl:apply-templates select="." mode="fo"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template match="docSection" mode="fo">
    <!-- apply sub -->
    <xsl:apply-templates mode="fo"/>
  </xsl:template>


  <xsl:template match="section" mode="fo">
    <xsl:apply-templates mode="fo"/>
  </xsl:template>


  <!-- ==== block element : div|p|... ==== -->

  <xsl:template match="div | divTitle | p" mode="fo">
    <fo:block>
      <xsl:call-template name="tplMapAttClass"/>
      <xsl:apply-templates mode="fo"/>
    </fo:block>
  </xsl:template>


  <!-- ==== inline element : span|a|... ==== -->

  <xsl:template match="span" mode="fo">
    <fo:inline>
      <xsl:call-template name="tplMapAttClass"/>
      <xsl:apply-templates mode="fo"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="a" mode="fo">
    <xsl:variable name="vHref">
      <xsl:choose>
        <xsl:when test="'' != @href">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:otherwise>#</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:basic-link color="blue" external-destination="{$vHref}">
      <?xslDoc Mantis="82058"?>

      
      <!-- TODO from  'tpl-lnkIpc7' -->
      <!--  [uossCompatibility]
          <xsl:call-template name="style">
            <xsl:with-param name="style" select="'cLnk'"/>
          </xsl:call-template>
-->
      <fo:inline>
        <xsl:apply-templates/>
      </fo:inline>
    </fo:basic-link>
  </xsl:template>


  <!-- ==== Style ====  -->
  <xsl:template name="style">
    <xsl:param name="style"/>
    <!-- TODO -->
  </xsl:template>

  <xsl:variable name="mapClass" select="document('css2fo.xml')/i_d:map"/>

  <xsl:template name="tplCss2fo">
    <xsl:param name="key"/>
    <xsl:choose>
      <xsl:when test="'' = $key"/>
      <!-- nothing -->
      <xsl:when test="$mapClass/i_d:e[@k = $key]">
        <xsl:for-each select="$mapClass/i_d:e[@k = $key]/att">
          <xsl:attribute name="{./@a}" select="./@v"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message select="concat('msg:key Not Found:', $key, '_')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc scope="template" id="tplMapAttClass">
    <xd:desc> convert css classes to fo:attribute's</xd:desc>
  </xd:doc>
  <xsl:template name="tplMapAttClass">
    <xsl:for-each select="tokenize(@class, ' ')">
      <xsl:message select="concat('msg:loop @class v:', .)"/>
      <xsl:call-template name="tplCss2fo">
        <xsl:with-param name="key" select="."/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>






  <!-- ==== LIST AS TABLE for RTF ====  -->



  <xsl:template match="ul | ol" mode="fo">
    <fo:block>
      <xsl:call-template name="tplMapAttClass"/>
      <xsl:choose>
        <xsl:when test="1 &lt; count(./li)">
          <fo:block>
            <xsl:call-template name="tplMapAttClass"/>
            <!-- muti-occurent -->
            <xsl:call-template name="tpl-liste">
              <xsl:with-param name="pBlock">
                <xsl:for-each select="li">
                  <xsl:call-template name="tpl-li">
                    <xsl:with-param name="pLstType" select="local-name()"/>
                    <xsl:with-param name="pNum" select="position()"/>
                    <xsl:with-param name="pVal">
                      <xsl:apply-templates mode="fo"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:with-param>
            </xsl:call-template>
          </fo:block>
          <xsl:if test="$pOutputFormat = 'RTF'">
            <fo:block>&#160;</fo:block>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <fo:block>
            <xsl:call-template name="tplMapAttClass"/>
            <fo:block>
              <!-- mono-occurent -->
              <xsl:apply-templates mode="fo"/>
            </fo:block>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>


  <xsl:template name="tpl-liste">
    <xsl:param name="pSizeLabelPt"/>
    <!-- size of label column in 'pt' -->
    <xsl:param name="pBlock"/>

    <xsl:variable name="vSizeLabelPt">
      <xsl:choose>
        <xsl:when test="'' != $pSizeLabelPt">
          <xsl:value-of select="$pSizeLabelPt"/>
        </xsl:when>
        <xsl:otherwise>10</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="'table' = $vListAsTable4Rtf">
        <fo:table space-before="2pt" block-progression-dimension="auto" table-layout="fixed" width="460pt">
          <fo:table-column column-width="10pt" column-number="1"/>
          <fo:table-column column-width="{concat($vSizeLabelPt, 'pt')}" column-number="2"/>
          <fo:table-column column-width="{concat((460 - 10 - $vSizeLabelPt), 'pt')}" column-number="3"/>
          <fo:table-body text-align="start" start-indent="0pt">
            <xsl:copy-of select="$pBlock"/>
          </fo:table-body>
        </fo:table>
      </xsl:when>
      <xsl:otherwise>
        <fo:list-block>
          <xsl:call-template name="style">
            <xsl:with-param name="style">sListBlock</xsl:with-param>
          </xsl:call-template>
          <xsl:copy-of select="$pBlock"/>
        </fo:list-block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="tpl-li">
    <xsl:param name="pLstType"/>
    <!-- ul|ol -->
    <xsl:param name="pNum"/>
    <xsl:param name="pVal"/>

    <xsl:variable name="vBulletOrNum">
      <xsl:choose>
        <xsl:when test="'ol' != $pLstType">
          <xsl:value-of select="$pNum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>•</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="'table' = $vListAsTable4Rtf">
        <fo:table-row>
          <fo:table-cell>
            <fo:block>&#160;</fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="left">
            <fo:block>
              <xsl:value-of select="$vBulletOrNum"/>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="left">
            <fo:block>
              <xsl:copy-of select="$pVal"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:when>
      <xsl:otherwise>
        <fo:list-item>
          <fo:list-item-label>
            <xsl:call-template name="style">
              <xsl:with-param name="style">sListItemLabel</xsl:with-param>
            </xsl:call-template>
            <fo:block>
              <xsl:value-of select="$vBulletOrNum"/>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body>
            <xsl:call-template name="style">
              <xsl:with-param name="style">sListItemBody</xsl:with-param>
            </xsl:call-template>
            <fo:block>
              <xsl:value-of select="$pVal"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!--  ======== TODO  ================ 
        
        <x.l:template match="e.ch:p">
    <fo:block>
      <xsl:if test=" name(..) = 'e.ch:abstract' and ../@lang='en' and  not ( preceding-sibling::e.ch:p ) and (../@country or ../@doc-number or ../@kind)">
        <xsl:text>[origin: </xsl:text>
        <xsl:for-each select="..">
          <xsl:call-template name="tpl-LnkInt">
            <xsl:with-param name="pStyle" select="'cLnkPcit_orange'"/>
            <xsl:with-param name="pCtry" select="@country"/>
            <xsl:with-param name="pDocNum" select="@doc-number"/>
            <xsl:with-param name="pKind" select="@kind"/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:text>] </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

-->
  <!-- ======== HIT ================ -->

  <xsl:template match="HIT">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text">
    <xsl:choose>
      <xsl:when test="HIT">
        <xsl:apply-templates select="HIT"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======== RESTE A FAIRE ================ -->
  <xsl:template match="*" priority="-1">
    <fo:block>DVP: Element non encore traite : <xsl:value-of select="name()"/></fo:block>
  </xsl:template>

  <!-- ======== TEMPLATES ================ -->
  <xsl:template name="tpl-legal_column_with">
    <xsl:param name="legalName"/>
    <xsl:param name="labelText"/>

    <?xd colWithMethod="dynamic|static" ?>
    <xsl:variable name="colWithMethod" select="'static'"/>
    <xsl:choose>
      <xsl:when test="'dynamic' = $colWithMethod">
        <?xd function=" calculate size in 'pt' of some 'text'" ?>
        <xsl:value-of select="number(5 * string-length($labelText) + 12)"/>
      </xsl:when>
      <xsl:otherwise>
        <?xd colWithMethod="static" ?>
        <xsl:choose>
          <xsl:when test="$legalName = 'L_L501EP'">76</xsl:when>
          <xsl:when test="$legalName = 'L_L503EP_DOC'">50</xsl:when>
          <xsl:when test="$legalName = 'L_L506EP'">112</xsl:when>
          <xsl:when test="$legalName = 'L_L507EP'">82</xsl:when>
          <xsl:when test="$legalName = 'L_L508EP'">64</xsl:when>
          <xsl:when test="$legalName = 'L_L509EP'">57</xsl:when>
          <xsl:when test="$legalName = 'L_L510EP'">70</xsl:when>
          <xsl:when test="$legalName = 'L_L511EP'">157</xsl:when>
          <xsl:when test="$legalName = 'L_L512EP'">50</xsl:when>
          <xsl:when test="$legalName = 'L_L513EP'">52</xsl:when>
          <xsl:when test="$legalName = 'L_L514EP'">87</xsl:when>
          <xsl:when test="$legalName = 'L_L515EP'">63</xsl:when>
          <xsl:when test="$legalName = 'L_L516EP'">26</xsl:when>
          <xsl:when test="$legalName = 'L_L517EP'">93</xsl:when>
          <xsl:when test="$legalName = 'L_L518EP'">61</xsl:when>
          <xsl:when test="$legalName = 'L_L519EP'">69</xsl:when>
          <xsl:when test="$legalName = 'L_L520EP'">84</xsl:when>
          <xsl:when test="$legalName = 'L_L521EP'">83</xsl:when>
          <xsl:when test="$legalName = 'L_L522EP'">79</xsl:when>
          <xsl:when test="$legalName = 'L_L523EP'">65</xsl:when>
          <xsl:when test="$legalName = 'L_L524EP'">86</xsl:when>
          <xsl:when test="$legalName = 'L_L525EP'">60</xsl:when>
          <xsl:when test="$legalName = 'L_L526EP'">78</xsl:when>
          <xsl:when test="$legalName = 'L_L527EP'">112</xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="tpl-font-lang">
    <xsl:choose>
      <xsl:when test="$pLang = 'ja'">
        <xsl:value-of select="'WipoUniExt'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'Helvetica'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
