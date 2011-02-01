✣ nodeready
=========

**[nodeready]** is a **one-step installer** for a fully-functioning **[node.js][node] development environment**.

    U=http://agnoster.github.com/nodeready/;(curl $U||wget -O - $U||lynx -source $U)|bash

Just copy-and-paste that crazy little snippet into your terminal, and watch the magic\* begin!

> \* Magic only available on POSIX-compliant systems. If you have to ask: Yes, it works on Macs, and no, it doesn't work on Windows. If you try running this on Windows, the best you can hope for is herpes.

What does it install?
---------------------

1. [nvm] -- [Tim Caswell]'s Node Version Manager
2. [node] -- The latest, greatest version (0.3.6, as of this writing)
3. [npm] -- [Isaac Z. Schlueter]'s Node Package Manager

> NB: [nodeready] currently uses [my fork][agnoster/nvm] of [nvm], as there are some nice features for version detection and whatnot in there. These features have been deemed unsafe for mass consumption as of yet, though, so... you might want to put on lead underpants before using it.

And then?
---------

Run [node]!

    $ node
    > process.version
    'v0.3.6'
    > function fib(n){return (n>2)?(fib(n-1)+fib(n-2)):n;}; fib(10);
    89

> I can't believe how evented that is!

And then?
---------

Install packages with [npm]!

    $ npm ls installed
    npm info it worked if it ends with ok
    npm info using npm@0.2.15
    npm info using node@v0.3.6
    npm@0.2.15                A package manager for node    =isaacs active installed remote package manager modules install package.json
    npm ok
    $ npm install zappa #amirite?
    ...

And then and then and then and then?
------------------------------------

Use [nvm] to get the latest node!

    $ nvm sync
    # syncing with nodejs.org... done.
    NEW latest: v0.3.7
    $ nvm install latest
    $ nvm alias default v0.3.7

And much, much more! Use `nvm help` and `npm help`, they are your friend. Remember: [nvm] manages your installs of [node], and [npm] manages the packages.

Caveats
-------

[nodeready] installs everything to `~/.nvm/`, owned by your user.

- **Pro**: you don't need to sudo, and it's easy to clean up (just `rm -rf ~/.nvm`)
- **Con**: maybe you wanted a system-wide version. Weirdo.

> [nodeready] is highly experimental, and comes with no guarantee, express or implied, that your use of it won't result in adverse effects up to and including the end of life as we know it.

> Side-effects of [nodeready] may also include horked node installations, blurry vision, feelings of giddy elation, irresistable attractiveness to members of any and all desirable sexes, low birth weight, high birth weight, and triskaidekaphobia.

Whoa, whoa, who died and made you God?
--------------------------------------

This is [opinionated software][opinionated]. I like not having to faff around with sudo, being able to test against multiple language versions at the drop of a hat, and managing my package dependencies with a `package.json` file. So this script installs [node] using [nvm], so that you can install any version you want in the future.

So what exactly does it do?
---------------------------

1. Create `~/.nvm`
2. Download [nvm.sh] to `~/.nvm`
3. Load [nvm] in `.bashrc` or `.bash_profile`
4. Use [nvm] to install the latest version of [node]
5. [nvm] installs [npm] in the latest [node]
6. Set latest version of node to be loaded by default

It broke
--------

Comrade, you should know that [nodeready] is infallible. But before you are escorted by our friendly agents to your new home in the JSON mines, please share the output from `.nodeready.log`, preferably on the [issues] page. Or email the log to [nodeready@agnoster.net][email]. Or if you just want to vent you can yell [@nodeready][twitter] on twitter.

I meant, my wife's water broke
------------------------------

Oh! That's different. You're lucky that [nodeready] is also a trained obstetrician.

Thanks
------

To [Joshua Frye], creator of [Rails Ready] and, unless I'm misremembering, the [spleen]. Both were great inspirations for [nodeready].

Tinkering
---------

Please do. [Fork off!][github/nodeready] It's under the [MIT License][license] - I tried to make a license that required offerings in slinkies, but my lawyers assure me that neither they, nor any such licenses, exist.

Don't be evil, or at least, not in a bad way. And whenever possible, make html pages that are also shell scripts, or shell commands that are also tweets.


[Rails Ready]:      https://github.com/joshfng/railsready
[node]:             http://nodejs.org/
[nvm]:              https://github.com/creationix/nvm
[agnoster/nvm]:     https://github.com/agnoster/nvm
[npm]:              http://npmjs.org/
[nodeready]:        http://agnoster.github.com/nodeready/
[opinionated]:      http://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php
[Joshua Frye]:      https://github.com/joshfng
[Tim Caswell]:      https://github.com/creationix
[Isaac Z. Schlueter]:   https://github.com/isaacs
[issues]:           https://github.com/agnoster/nodeready/issues
[github/nodeready]: https://github.com/agnoster/nodeready/
[spleen]:           http://en.wikipedia.org/wiki/Spleen
[nvm.sh]:           https://github.com/agnoster/nvm/blob/master/nvm.sh
[email]:            mailto:nodeready@agnoster.net
[twitter]:          http://twitter.com/nodeready
[license]:      https://github.com/agnoster/nodeready/blob/master/LICENSE.md
