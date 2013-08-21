<%shared>
$.title => ''
</%shared>

<%augment wrap>
<!doctype html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <% $.Defer { %>
    <title><% join(' | ', grep { $_ =~ /\w+/ } ($.title, 'automatomatromaton')) %></title>
    </%>
    <!-- CREDITS
         *******
         Top-line photo, "Dead Admin" Copyright 2008, Arthur Caranta (CC-A-SA)
             http://www.flickr.com/photos/arthur-caranta/2926332140/
    -->
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel="stylesheet" href="/static/css/normalize.css" />
    <link rel="stylesheet" href="/static/css/foundation.min.css" />
    <link rel="stylesheet" href="/static/css/base.css" />
    <link rel="stylesheet" href="//f.fontdeck.com/s/css/Gy2Mre7sm5eUiAaxaTKZs6rJTxQ/automatomatromaton.com/31320.css" type="text/css" />
    <script src="/static/js/modernizr.min.js"></script>
</head>
<body>
<div id="header">
    <nav class="top-bar">
        <ul class="title-area">
            <li class="name"><a href="/">automa·toma·troma·ton</a></li>
        </ul>

        <section class="top-bar-section">
            <ul class="right">
                <li><a href="/blog">Blerg</a></li>
                <li><a href="/projects">Projax</a></li>
                <li><a href="/about">Aboot</a></li>
            </ul>
        </section>
    </nav>
</div>

<div class="blowout">
    <div class="row">
        <div class="large-12 columns">
            <div class="row">
                <div class="large-8 columns">
                    <h3>everything is ruined forever</h2>
                </div>
                <div class="large-4 columns">
                    <br />
                    <h6 class="right">
                        Photo, Arthur Caranta
                    </h6>
                </div>
            </div>
        </div>
    </div>
</div>

<section class="main">
    <div class="row">
        <div class="large-10 columns">
            <% inner() %>
        </div>
        <div class="large-2 columns">
            <ul class="side-nav">
                <li><label>Navigation</label></li>
                <li><a href="/">Home</a></li>
                <li><a href="/about">About</a></li>
                <li><a href="/projects">Projects</a></li>
                <li><a href="/rss">RSS</a></li>
                <li><label>Elsewhere</label></li>
                <li><a href="http://omniti.com/is/jon-sime">OmniTI</a></li>
                <li><a href="https://github.com/jsime">GitHub</a></li>
                <li><a href="https://metacpan.org/author/JSIME">CPAN</a></li>
                <li><a href="https://plus.google.com/u/0/101280246673690128263">Google+</a></li>
                <& /_shared/sidebar/tags.mi &>
            </ul>
        </div>
    </div>
        </div>
    </div>
</section>

<script src="/static/js/jquery.min.js"></script>
<script src="/static/js/foundation.min.js"></script>
<script>
    $(document).foundation();
</script>
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
