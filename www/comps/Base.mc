<%shared>
$.title => ''
</%shared>

<%augment wrap>
<!doctype html>
<html>
<head>
    <title><% $.title %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="stylesheet" href="/static/css/base.css" />
    <link rel="stylesheet" href="//f.fontdeck.com/s/css/posU9Y0DYSwKyT7pZ5oMklOhSjk/automatomatromaton.com/31320.css" type="text/css" />
</head>
<body>
<div id="header">
<h1><a href="/">automa·toma·troma·ton</a></h1>
</div>

<div id="main">
    <div id="sidebar">
        <h1>Navigation</h1>
        <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/about">About</a></li>
            <li><a href="/projects">Projects</a></li>
            <li><a href="/rss">RSS</a></li>
        </ul>

        <h1>Elsewhere</h1>
        <ul>
            <li><a href="http://omniti.com/is/jon-sime">OmniTI</a></li>
            <li><a href="https://github.com/jsime">GitHub</a></li>
            <li><a href="https://metacpan.org/author/JSIME">CPAN</a></li>
            <li><a href="https://plus.google.com/u/0/101280246673690128263">Google+</a></li>
            <li><a href="https://twitter.com/bikesorbooks">Twitter</a></li>
        </ul>

        <h1>Tags</h1>
        <ol>
            <li><a href="/tag/foo">C</a></li>
            <li><a href="/tag/foo">NodeJS</a></li>
            <li><a href="/tag/foo">Erlang</a></li>
            <li><a href="/tag/foo">Lisp</a></li>
            <li><a href="/tag/foo">Scheme</a></li>
            <li><a href="/tag/foo">Disaster Porn</a></li>
            <li><a href="/tag/foo">Foo</a></li>
            <li><a href="/tag/foo">Bar</a></li>
            <li><a href="/tag/foo">Baz</a></li>
            <li><a href="/tag/foo">Fubar</a></li>
            <li><a href="/tag/foo">Perl</a></li>
            <li><a href="/tag/foo">PostgreSQL</a></li>
        </ol>
    </div>
    <div id="content">
      <% inner() %>
    </div>
</div>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-39678743-1', 'automatomatromaton.com');
  ga('send', 'pageview');

</script>
    </body>
  </html>
</%augment>
