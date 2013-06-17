IkiWiki::Plugin::mathjax
========================

IkiWiki's default support for math is rather clumsy and old-fashioned. Also, it
requires a working LaTeX installation.

A much better option is Pandoc, available to IkiWiki users through the
IkiWiki::Plugin::pandoc plugin (which can be found in a few versions on
GitHub). However, it has some drawbacks as well:

- If you are using shared hosting, Pandoc can be cumbersome to
  install. 
- If you don't need its markdown extensions, footnotes,
  extra source and target formats, bibliography support, etc., but just want to
  have some nicely formatted math on your wiki/blog, Pandoc seems like
  overkill.
- Because an external process will be called for each page, a rebuild of a
  large wiki takes an uncomfortably long time.
- It is difficult to get Pandoc with MathJax and the smiley plugin to work
  together, since the latter tends mangle the content which MathJax is supposed
  to work its magic on.
- You need to change page.tmpl, which means that you have to check for
  compatibility with the new page.tmpl every time you upgrade IkiWiki.

This simple plugin solves these issues, making it easy to use MathJax in
IkiWiki. Features:

- No changes to page.tmpl are needed -- the MathJax Javascript is only loaded
  on pages where it is needed.
- Both display ($$...$$ or \\[...\\]) and inline ($...$ or \\(...\\)) math are
  supported. Just take care that **inline math must stay on one line** in your
  markdown source.  A single literal dollar sign in a line does not need to be
  escaped, but two do.

If you want to change the MathJax configuration, you currently must edit the
source of the module. I may later add configuration hooks so that one may
control its behaviour through the setup file for the wiki. Let me know if you
need this.

