# xmark = Markdown + Tufte CSS
## Antonio Vieiro

## A brief introduction

[Markdown](https://daringfireball.net/projects/markdown/) is a plain text format for writing structured documents, based on formatting conventions from email and usenet.  It was developed in 2004 by John Gruber.

[CommonMark](http://commonmark.org) is a proposal for a standard, **unambiguous syntax specification for Markdown**, along with a **suite of comprehensive tests** to validate Markdown implementations against this specification. It was created by a group of [Markdown fans](http://commonmark.org).

[tufte-css](https://edwardtufte.github.io/tufte-css/) provides tools to style web articles using the ideas demonstrated by Edward Tufte's books and handouts. It was created by [Dave Liepmann](http://www.daveliepmann.com/) in late 2015 and is now an Edward Tufte project.

[xmark](https://github.com/vieiro/xmark) is a simple XSLT stylesheet that transforms CommonMark compliant plain text documents ([see the source of this one here](https://raw.githubusercontent.com/vieiro/xmark/master/test.markdown)), with some additional conventions, into tufte-css styled web pages. 

This document enumerates the goals of xmark, its conventions and explains how to use it.

## xmark goals

xmark has two main goals:

### I: Generate tufte-css styled web pages

The first goal of xmark is to generate tufte-css styled web pages from plain text files that follow the CommonMark specification.

### II: Serve as an experimentation tool

The second goal of xmark is to serve as a tool to manipulate the XML structure generated with CommonMark's cmark parser. By modifying a simple XSLT one can generate all sort of structured documents out from plain CommonMark text files.

## xmark conventions

Nor Markdown nor CommonMark support document metadata so, for instance, there is no standard way to specify a title in a CommonMark document. It is not possible either to mark a paragraph as an epigraph, or as a figure caption, or as a margin note. 

[*Def. xmark convention*: a simple rule that allows emulating metadata in CommonMark markdown documents.](sidenote) These limitations in Markdown, and in the CommonMark standard, are overcome in xmark by means of conventions, that assign special meanings to paragraphs. This section lists these conventions:

### Document title convention

> The document title is the first section of the document with level one. This is, the first paragraph tagged with a single '#' in the markdown document.

It does not matter where you hide the first level one tag in your markdown document: xmark always places the title as the first paragraph of the document, using an ```<h1>``` HTML tag. The title does not appear in the Table of Contents.


``` markdown
# This is the document title
```

Of course, the document title is also set in the ```<title>``` HTML tag of the resulting document.

### Document sutbitle convention

> The document subtitle is the first section of the document with level two. This is, the first paragraph tagged with a double '##' in the document.

For instance:

``` markdown
## This is the document subtitle
```

It does not matter where you specify the subtitle in the source document, xmark always places the subtitle as the second paragraph of the document, using the ```<p class='subtitle'>``` tufte-css element. The subtitle does not appear in the Table of Contents.

### Epigraph convention

CommonMark does not support epigraphs, but allows for nested block quotes. xmark makes use of this feature, making the double-nested block quotes work as epigraphs:

> Two-level nested block quotes (i.e., a pagraph starting with ```>>```) are always transformed to epigraphs. 

So, for instance, this text:

``` markdown
>> xmark epigraphs are started with two ```>``` at the beginning of the paragraph.
```

Will generate a tufte-css epigraph like this one:

>> xmark epigraphs are started with two ```>``` at the beginning of the paragraph.

Epigraphs may also contain a footer using plain HTML, but you will have to specify the ```footer``` and ```cite``` in plain HTML, like this one:

```markdown
>> I do not paint things, I paint only the differences between things.
>> <footer>Henri Matisse, <cite>Henri Matisse Dessins: 
>> thèmes et variations</cite> (Paris, 1943), 37</footer></blockquote>
```

That gets translated in the following HTML:

>> I do not paint things, I paint only the differences between things.
>> <footer>Henri Matisse, <cite>Henri Matisse Dessins: thèmes et variations</cite> (Paris, 1943), 37</footer></blockquote>

### Sidenote convention

Nor markdown nor CommonMark support sidenotes [Sidenotes are like footnotes, except they don't force the user to scroll the page](sidenote). 

Markdown uses the ```[link text](url)``` structure to define links. xmark abuses this structure with the following convention:

> Sidenotes are normal markdown links that use the word ```sidenote``` as its url.

Sidenote numbers are automatically generated, so there's no need to worry about that detail.

``` markdown
This is a normal paragraph with a 
sidenote [Write your sidenotes 
inside square brackets and then 
add a ```(sidenote)``` 
url.](sidenote).
```

Will produce the following paragraph with a sidenote:

This is a normal paragraph with a sidenote [Write your sidenotes inside square brackets and then add a ```(sidenote)``` url.](sidenote).

As in tufte-css, sidenotes (and margin notes, below) are visible in wider screens, but are hidden in smaller screens. In these smaller screens, the symbol &#8853;  (``&#8853;``) or the sidenote number can be tapped to view the content.

### Margin note convention

Margin notes are just like sidenotes, but do not have footnote-style numbers. The xmark convention for margin notes is similar to the previous convention:

> To create a margin note write a normal markdown link, but use the word ```margin``` as the url.

So, for instance, the markdown text:

```markdown
For example, this paragraph has a 
[Margin note text here](margin)
margin note.
```

Will result in the following paragraph with a margin note:

For example, this paragraph has a [Margin note text here](margin) margin note.


### Figure convention

CommonMark supports images by using the construction:

```markdown
![alt](url "title")]
```

that gets translated by CommonMark into the following HTML:

```html
<img src='url' alt='alt' title='title' />
```

Sadly nor CommonMark nor Markdown support figures with captions [(there's an ongoing discussion, though)](http://talk.commonmark.org/t/image-tag-should-expand-to-figure-when-used-with-title/265/5). 

To overcome this limitation xmark uses the following convention

> Use the 'alt' text as the caption for the figure, and abuse the 'title' text as both the HTML alt and the title.

So, for instance, the following text:

``` markdown
![From Edward Tufte, *Visual Display of 
Quantitative Information*, 
page 92.](tufte-css/img/exports-imports.png 
"Visual Display of Quantitative Information")
```

Will be transformed in the following ```<figure>```, ```<img>``` and ```<caption>```:

![From Edward Tufte, *Visual Display of Quantitative Information*, page 92.](tufte-css/img/exports-imports.png "Visual Display of Quantitative Information")

Note that figures are automatically numbered by xmark.

### Margin and full-width figure conventions

Graphics that are ancillary to the main body of the text are placed in margin figures in tufte-css. 

But CommonMark and Markdown have just a single construct for images.  ![F.J. Cole, “The History of Albrecht Dürer’s Rhinoceros in Zooological Literature,” *Science, Medicine, and History: Essays on the Evolution of Scientific Thought and Medical Practice (London, 1953)*, ed. E. Ashworth Underwood, 337-356. From page 71 of Edward Tufte’s *Visual Explanations*.](tufte-css/img/rhino.png "margin Rhino image") 

How could xmark support margin figures easily? By abusing the construct, of course. 

xmark abuses the title part of the image (that appears when you place the mouse over the image for a while), and if the title starts with the word 'margin' then the image is placed in a margin note, and if the title starts with the word 'fullwidth' then the image will be rendered as a full-width figure. The conventions are then:

> If the title of the image starts with the word ```margin``` the figure will be placed in the margin.

> If the title of the image starts with the word ```fullwidth``` the figure will be full-width.

So any image constructed like this:

```markdown
![text caption here](image-name-or-url "margin Rhino image")
```

(note the ```margin``` word at the beginning of the title) will be considered a margin figure.

And the following markup:
    
```markdown
![Edward Tufte’s English translation of the 
Napoleon’s March data visualization. 
From *Beautiful Evidence*, page
122-124.](tufte-css/img/napoleons-march.png 
"fullwidth Napoleon's march").
```

Will be rendered as:

![Edward Tufte’s English translation of the Napoleon’s March data visualization. From *Beautiful Evidence*, page 122-124.](tufte-css/img/napoleons-march.png "fullwidth Napoleon's march").

Note that the ```margin``` and ```fullwidth``` special words are removed from the resulting HTML figure title. As in Tufte-CSS, full-width images are also numbered automaticcally with xmark.

### Source code convention

Source code is translated to tufte-css equivalents, but CommonMark's ```info-string``` tag is kept, so it is possible to remember which programming language is being used for each part of the code.

So, for instance, the markdown paragraph:

```` markdown
``` ruby
def foo(x)
        return 3
end
```
````

That is tagged as a Ruby program, will be translated to the HTML equivalent:

``` html
<pre class='code'><code class='language-ruby code'>def foo(x)
        return 3
end</code></pre>
```

## Deviations from tufte-css

### Table of Contents

xmark automatically generates a Table of Contents and places it in a marginnote at the top of the document.

You can disable this feature by setting the XSLT parameter ```generate-toc``` to ```no``` (see below for an example).

### Sections

xmark does not generate ```<section>``` HTML 5 tags.

### Syntax highlighting

xmark automatically embeds some ```<script>``` and CSS stylesheets from [highlight.js](https://github.com/isagalaev/highlight.js) to enable language-specific syntax highlighting.

You can disable this feature by setting the XSLT parameter ```highlight``` to ```no```.

## Using xmark

In order to use xmark one needs the following software:

1. A CommonMark processor that generates XML, such as the excellent [John MacFarlane's cmark](https://github.com/jgm/cmark).
2. The tufte-css project under the 'tufte-css' folder in a working directory of your liking.
3. The xmark.xsl stylesheet, [available here](https://github.com/vieiro/xmark/blob/master/xmark.xsl).
4. An XSLT processor, such as [xsltproc](http://www.xmlsoft.org). If you're using Mac OS/X, Linux or FreeBSD you may already have it installed.

If you have cloned [xmark's github repository](https://github.com/vieiro/xmark) you can issue the ```git submodule init``` command to clone CommonMark's cmark and tufte-css projects.

Once everything is set up you process your CommonMark file (```myfile.markdown```) with cmark, and then pipe that to xsltproc to generate an output file ```myfile.html```, like so:

    cmark -t xml myfile.markdown | xsltproc --novalid --nonet xmark.xsl > myfile.html

Or, if you want to disable the Table of Contents:

    cmark -t xml myfile.markdown | xsltproc --novalid --nonet \
       --stringparam generate.toc no xmark.xsl > myfile.html

And, if you want to disable syntax highlighting:

    cmark -t xml myfile.markdown | xsltproc --novalid --nonet \
       --stringparam highlight no xmark.xsl > myfile.html

### License

xmark is released under the MIT License.

## Further reading

Some links you may find of interest:

* [Tufte CSS homepage](https://edwardtufte.github.io/tufte-css/)
* [CommonMark homepage](http://commonmark.org)
* [xmark's project page at github](https://github.com/vieiro/xmark).
* [The source of this document](https://raw.githubusercontent.com/vieiro/xmark/master/test.markdown)
* [This document as rendered by GitHub](https://github.com/vieiro/xmark/blob/master/test.markdown)

## Epilogue

Many thanks go to Edward Tufte, Dave Liepmann, John Gruber, John MacFarlane, Ivan Sagalaev and the CommonMark volunteers.


