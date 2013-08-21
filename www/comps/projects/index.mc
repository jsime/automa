<%init>
$.title('Projects');
</%init>

<h1>Automatomatromatonical Projects</h1>

<p>There are a few things I tinker on from time to time. I make a feeble attempt to
keep that list of things here, and hopefully not too horribly out of date.</p>

<h2>Games::EVE::APIv2</h2>

<h3>GitHub: <a href="https://github.com/jsime/games-eve-apiv2">https://github.com/jsime/games-eve-apiv2</a></h3>

<p>A Perl library for making use of CCP's API for EVE Online, a massively-multiplayer space
simulation game, spanning thousands of solar systems. Most operations are designed to be
lazy-loaded, reducing the number of remote API calls incurred by the library.</p>

<p>While the raw API provides a relatively self-consistent bastardization of Object-to-XML
mappings, this library aims to provide a slightly most natural OO-Perl interface to game
data. Still under very heavy development, most of which currently assumes full API masks.</p>

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

<h2>pgcrond</h2>

<h3>GitHub: <a href="https://github.com/jsime/pgcrond">https://github.com/jsime/pgcrond</a></h3>

<p>Intended to allow or a simpler way to run schedule tasks against PostgreSQL clusters. The
<code>master</code> branch on GitHub currently has the original version, which has been used in production
environments, but needs a serious rewrite. Which just happens to be going in the <code>rewrite</code>
branch. When I have time, that is.</p>

<p>The gist of the tool is to allow a cron-like method of running anything from raw SQL, to Perl
modules (that are automatically handed a working DBIx::DataStore object), <code>psql</code>
client commands, or just generic Bash scripts (which may or may not actually interact with the
database, though they will have the various <code>PG*</code> environment variables set).</p>

<p>Credentials are able to be stored centrally (all job types are intended to support <code>~/.pgpass</code>
and <code>datastore.yml</code> (homedir, system wide, etc.) so that you aren't forced to keep
connection information in multiple locations just so that you can have multiple job types run
against your databases.</p>
