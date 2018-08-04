<?xml version="1.0" encoding="UTF-8"?>
<!--
XMARK
XSLT Stylesheet to generate tufte-css styled web pages from CommonMark documents.
(C) 2016 Antonio Vieiro. MIT License.
-->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:cm='http://commonmark.org/xml/1.0' xmlns:html='http://www.w3.org/1999/xhtml' version='1.1' exclude-result-prefixes='xsl cm html'>
        <xsl:output indent='no' version='1.0' omit-xml-declaration='yes' encoding='UTF-8' method='xml'  />
        <xsl:strip-space elements='cm:heading cm:paragraph cm:text cm:link cm:emph pre'/>

        <!-- options to generate table of contents and to include syntax highlighting -->
        <xsl:param name="generate.toc" select="'yes'"/>
        <xsl:param name='highlight' select="'yes'" />

        <!-- title and subtitle -->
        <xsl:variable name='title' select='/cm:document/cm:heading[@level = "1"][1]' />
        <xsl:variable name='subtitle' select='/cm:document/cm:heading[@level = "2"][1]' />

        <!-- entry point to common mark document (cm:document) -->
        <xsl:template match="cm:document">
                <!-- <!DOCTYPE html> -->
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
                <html>
                        <head>
                                <xsl:if test='not($highlight = "no")'>
                                        <link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.1.0/styles/default.min.css" />
                                </xsl:if>
                                <link rel="stylesheet" href="tufte-css/tufte.css"/>
                                <meta charset="UTF-8" />
                                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                                <title><xsl:value-of select='$title/cm:text/text()' /></title>
                                <style type="text/css">
                                        .toc-3 { margin-left: 2rem; }
                                        .toc-4 { margin-left: 4rem; }
                                </style>
                        </head>
                        <body>
                                <article>
                                        <h1><xsl:value-of select='$title/cm:text/text()' /></h1>
                                        <p class='subtitle'><xsl:value-of select='$subtitle/cm:text/text()'/></p>
                                        <!-- Include TOC or not as a margin note -->
                                        <xsl:if test='not($generate.toc = "no")'>
                                                <p>
                                                        <label for='toc' class='margin-toggle'>⊕ Table of Contents</label>
                                                        <xsl:element name='input'>
                                                                <xsl:attribute name='id'>toc</xsl:attribute>
                                                                <xsl:attribute name='type'>checkbox</xsl:attribute>
                                                                <xsl:attribute name='class'>margin-toggle</xsl:attribute>
                                                        </xsl:element>
                                                        <span class='marginnote'>
                                                                <strong>Table of Contents</strong><br />
                                                                <xsl:apply-templates select="//cm:heading" mode="toc"/>
                                                        </span>
                                                </p>
                                        </xsl:if>
                                        <xsl:apply-templates/>
                                </article>
                                <xsl:if test='not($highlight = "no")'>
                                        <script src='http://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.1.0/highlight.min.js'>//</script>
                                        <script>
                                                try {
                                                        hljs.initHighlightingOnLoad();
                                                } catch(e) {
                                                        console.log(e);
                                                        }
                                        </script>
                                </xsl:if>
                        </body>
                </html>
        </xsl:template>
        <!-- heading entry for toc -->
        <xsl:template match="cm:heading" mode="toc">
                <!-- Ignore title and subtitle headings -->
                <xsl:if test='. != $title and . != $subtitle'>
                        <xsl:element name="a">
                                <xsl:attribute name='class'>toc-<xsl:value-of select='@level' /></xsl:attribute>
                                <xsl:attribute name="href">#<xsl:value-of select="generate-id(.)"/></xsl:attribute>
                                <xsl:for-each select="cm:text">
                                        <xsl:value-of select="text()"/>
                                </xsl:for-each>
                        </xsl:element>
                        <br />
                </xsl:if>
        </xsl:template>
        <!-- heading entry for normal processing -->
        <xsl:template match="cm:heading">
                <!-- Ignore title and subtitle headings -->
                <xsl:if test='. != $title and . != $subtitle'>
                        <xsl:element name="h{@level}">
                                <xsl:attribute name="id">
                                        <xsl:value-of select="generate-id(.)"/>
                                </xsl:attribute>
                                <xsl:apply-templates/>
                        </xsl:element>
                </xsl:if>
        </xsl:template>
        <!-- paragraphs -->
        <xsl:template match="cm:paragraph">
                <p><xsl:apply-templates/></p>
        </xsl:template>
        <!-- block quotes and epigraphs -->
        <xsl:template match='cm:block_quote'>
                <xsl:choose>
                        <!-- if block_quote followed by another block_quote then this is an epigraph -->
                        <xsl:when test='*[self::cm:block_quote]'>
                                <div class='epigraph'>
                                        <blockquote>
                                                <xsl:apply-templates select='*[self::cm:block_quote]/*' />
                                        </blockquote>
                                </div>
                        </xsl:when>
                        <!-- if block_quote followed by non block_quote then 'blockquote' -->
                        <xsl:otherwise>
                                <blockquote>
                                        <xsl:apply-templates select='*[not(self::cm:block_quote)]' />
                                </blockquote>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- text nodes -->
        <xsl:template match="cm:text">
                <xsl:value-of select="text()"/>
        </xsl:template>
        <!-- links -->
        <xsl:template match="cm:link">
                <xsl:choose>
                        <!-- sidenote urls -->
                        <xsl:when test='starts-with(@destination, "sidenote")'>
                                <xsl:variable name='sidenote-id'>
                                        <xsl:value-of select='generate-id(.)' />
                                </xsl:variable>
                                <label for='{$sidenote-id}' class='margin-toggle sidenote-number'></label>
                                <xsl:element name='input'>
                                        <xsl:attribute name='id'><xsl:value-of select='$sidenote-id' /></xsl:attribute>
                                        <xsl:attribute name='type'>checkbox</xsl:attribute>
                                        <xsl:attribute name='class'>margin-toggle</xsl:attribute>
                                        <span class='sidenote'>
                                                <xsl:apply-templates />
                                        </span>
                                </xsl:element>
                        </xsl:when>
                        <!-- margin urls -->
                        <xsl:when test='starts-with(@destination, "margin")'>
                                <xsl:variable name='sidenote-id'>
                                        <xsl:value-of select='generate-id(.)' />
                                </xsl:variable>
                                <label for='{$sidenote-id}' class='margin-toggle'>⊕</label>
                                <xsl:element name='input'>
                                        <xsl:attribute name='id'><xsl:value-of select='$sidenote-id' /></xsl:attribute>
                                        <xsl:attribute name='type'>checkbox</xsl:attribute>
                                        <xsl:attribute name='class'>margin-toggle</xsl:attribute>
                                        <span class='marginnote'>
                                                <xsl:apply-templates />
                                        </span>
                                </xsl:element>
                        </xsl:when>
                        <!-- other normal urls -->
                        <xsl:otherwise>
                                <xsl:element name="a">
                                        <xsl:attribute name="href">
                                                <xsl:value-of select="@destination"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="title">
                                                <xsl:value-of select="@title"/>
                                        </xsl:attribute>
                                        <xsl:apply-templates/>
                                </xsl:element>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- code spans (inline) -->
        <xsl:template match='cm:code'>
                <span class='code'>
                        <xsl:value-of select='text()' />
                </span>
        </xsl:template>
        <!-- code blocks -->
        <xsl:template match='cm:code_block'>
                <pre class='code'>
                        <xsl:element name='code'>
                                <xsl:choose>
                                        <xsl:when test='@info != ""'>
                                                <xsl:attribute name='class'>language-<xsl:value-of select='@info'/> code</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:attribute name='class'>nohighlight code</xsl:attribute>
                                        </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select='text()' />
                        </xsl:element>
                </pre>
        </xsl:template>
        <!-- lists -->
        <xsl:template match="cm:list">
                <xsl:choose>
                        <xsl:when test="@type = &quot;ordered&quot;">
                                <xsl:element name="ol">
                                        <xsl:attribute name="start">
                                                <xsl:value-of select="@start"/>
                                        </xsl:attribute>
                                        <xsl:apply-templates/>
                                </xsl:element>
                        </xsl:when>
                        <xsl:when test="@type = &quot;bullet&quot;">
                                <ul>
                                        <xsl:apply-templates/>
                                </ul>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <!-- list items -->
        <xsl:template match="cm:item">
                <li>
                        <xsl:apply-templates/>
                </li>
        </xsl:template>

        <!-- softbreaks -->
        <xsl:template match="cm:softbreak">
                <xsl:text> 
</xsl:text>
        </xsl:template>

        <!-- images -->
        <xsl:template match="cm:image">
                <!-- figure number -->
                <xsl:variable name="fignumber" select="1+count(./preceding::cm:image)"/>
                <xsl:choose>
                        <!-- margin figures -->
                        <xsl:when test='starts-with(@title, "margin")'>
                                <xsl:variable name='sidenote-id'><xsl:value-of select='generate-id(.)' /></xsl:variable>
                                <label for='{$sidenote-id}' class='margin-toggle'>⊕</label>
                                <xsl:element name='input'>
                                        <xsl:attribute name='id'><xsl:value-of select='$sidenote-id' /></xsl:attribute>
                                        <xsl:attribute name='type'>checkbox</xsl:attribute>
                                        <xsl:attribute name='class'>margin-toggle</xsl:attribute>
                                        <span class='marginnote'>
                                                <xsl:element name="img">
                                                        <xsl:attribute name="src">
                                                                <xsl:value-of select="@destination"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="title">
                                                                <xsl:value-of select='substring-after(@title, "margin")'/>
                                                        </xsl:attribute>
                                                </xsl:element>
                                                <xsl:apply-templates />
                                        </span>
                                </xsl:element>

                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:element name='figure'>
                                        <!-- full width figures -->
                                        <xsl:if test='starts-with(@title, "fullwidth")'>
                                                <xsl:attribute name='class'>fullwidth</xsl:attribute>
                                        </xsl:if>
                                        <xsl:element name="img">
                                                <xsl:attribute name="src">
                                                        <xsl:value-of select="@destination"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="title">
                                                        <xsl:choose>
                                                                <xsl:when test='starts-with(@title, "fullwidth")'>
                                                                        <xsl:value-of select='substring-after(@title, "fullwidth")'/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="@title"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:attribute>
                                        </xsl:element>
                                        <figcaption>
                                                Fig. <xsl:value-of select='$fignumber' />. <xsl:apply-templates/>
                                        </figcaption>
                                </xsl:element>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- strong and em -->
        <xsl:template match="cm:strong">
                <strong>
                        <xsl:apply-templates/>
                </strong>
        </xsl:template>
        <xsl:template match="cm:emph">
                <em>
                        <xsl:apply-templates/>
                </em>
        </xsl:template>
        <!-- 
             Hack template to generate HTML elements from escaped stuff 
             &gt;/hola> will generate </hola>
        -->
        <xsl:template name='html-end'>
                <xsl:param name='text' />
                <xsl:choose>
                        <xsl:when test='contains($text, "&gt;")'>
                                <xsl:value-of select='substring-before($text, "&gt;")' />
                                <xsl:text disable-output-escaping='yes'>&gt;</xsl:text>
                                <xsl:call-template name='html-start'>
                                        <xsl:with-param name='text' select='substring-after($text, "&gt;")' />
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:call-template name='html-start'>
                                        <xsl:with-param name='text' select='$text' />
                                </xsl:call-template>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- 
             template function to generate a start element 
             &myhtml; will generate <myhtml>
        -->
        <xsl:template name='html-start'>
                <xsl:param name='text' />
                <xsl:choose>
                        <xsl:when test='contains($text, "&lt;")'>
                                <xsl:value-of select='substring-before($text, "&lt;")' />
                                <xsl:text disable-output-escaping='yes'>&lt;</xsl:text>
                                <xsl:call-template name='html-end'>
                                        <xsl:with-param name='text' select='substring-after($text, "&lt;")' />
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select='$text' />
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- custom HTML entries in markdown are processed here -->
        <xsl:template match="cm:html_block">
                <xsl:call-template name='html-start'>
                        <xsl:with-param name='text' select='text()' />
                </xsl:call-template>
                <xsl:apply-templates />
                <!--
                     Commonmark translates escapes HTML stuff in the XML tree, so, for instance
                     <aside> becomes &lt;aside&gt;
                     We would like to replace all &lt; with < and &gt; with > but this is challenging in XSL.
                     Mainly because XSL forbits '<' in attribute values to avoid the resulting XML being
                     malformed.
    -->
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>
