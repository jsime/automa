<%init>
$.title('Projects');
</%init>

<h1>Automatomatromatonical Projects</h1>

<p>There are a few things I tinker on from time to time. I make a feeble attempt to
keep that list of things here, and hopefully not too horribly out of date.</p>

<h2>DBIx::DataStore</h2>

<h3>GitHub: <a href="https://github.com/jsime/dbix-datastore">https://github.com/jsime/dbix-datastore</a></h3>

<p>A relatively simple (from the end developer's perspective) wrapper around Perl's DBI. Its
primary advantages lay in simplified configuration, easy handling of hot-standby read-only
replicants, more flexible placeholders (ever wanted to just jam an array into your IN clauses,
or a hash into your SETs? DataStore lets you do that), and a few other conveniences.
<em>It is not an ORM, and never will be.</em> Though you're welcome to write your own ORM and
use DataStore as the underlying database accessor.</p>

<p>The legacy version is production stable, and has been in use for well over a decade at
various companies I've tainted with my presence. I'm currenly rewriting the library to
drop a couple design choices made in the past, streamline the code, make it a little more
maintainable, and slip in a few new features I've wanted for a long time.</p>

<p>The rewrite is not yet complete, but you can get the legacy/stable version at
<a href="https://github.com/jsime/dbix-datastore-legacy">https://github.com/jsime/dbix-datastore-legacy</a>.</p>

<h2>RoboBot</h2>

<h3>GitHub: <a href="https://github.com/jsime/robobot">https://github.com/jsime/robobot</a></h3>

<p>An IRC bot written in Perl (because everyone ends up writing their own IRC bot), using
POE::Component::IRC for event handling and Module::Pluggable to provide a simple way to develop
a variety of commands and features. Supports macroing, infobot functionality, output chaining
and redirection, and a slew of included command plugins.</p>

<p>RoboBot will connect to any number of servers and channels, and it is possible to limit use
of any of the commands to specific nicks (presumably your server will offer some sort of basic
nick protection, but even so this shouldn't be considered foolproof... because it isn't).</p>
