✤ nodeready
=========

Inspired by [Joshua Frye]'s [Rails Ready], [nodeready] is a one-step installer for a fully-functioning [Node.js][node] development environment.

    ✤() { curl $*||wget -O - $*||lynx -s $*;}; ✤ http://agnoster.github.com/nodeready/ | sh

Or, if you *know* you have curl, because you're not a *neanderthal*, you're a civilized human being:

    curl http://agnoster.github.com/nodeready/ | sh

What does it install?
---------------------

1. [nvm] -- [Tim Caswell]'s Node Version Manager (currently my fork, there are some nice features for version detection and whatnot in there)
2. [node] -- The latest, greatest version (0.3.6, as of this writing)
3. [npm] -- [Isaac Z. Schlueter]'s Node Package Manager

Caveats
-------

[nodeready] installs everything to `~/.nvm/`, owned by your user. Pro: you don't need to sudo. Con: maybe you wanted a system-wide version. Wierdo.

Side-effects of [nodeready] may also include horked node installations, blurry vision, feelings of giddy elation, irresistable attractiveness to members of any and all desirable sexes, low birth weight, high birth weight, and triskaidekaphobia.

Whoa, whoa, who died and made you God?
--------------------------------------

This is [opinionated software]. I like not having to faff around with sudo, being able to test against multiple language versions at the drop of a hat, and managing my package dependencies with a `package.json` file. So this script installs [node] using [nvm], so that you can install any version you want in the future.

So what's the rundown?
----------------------

1. Create `~/.nvm`
2. Download [nvm].sh to `~/.nvm`
3. Load [nvm] in `.bashrc` or `.bash_profile`
4. Use [nvm] to install the latest version of [node]
5. [nvm] installs [npm] in the latest [node]
6. Set latest version of node to be loaded by default

[Rails Ready]:      https://github.com/joshfng/railsready
[node]:             http://nodejs.org/
[nvm]:              https://github.com/creationix/nvm
[npm]:              http://npmjs.org/
[nodeready]:        https://github.com/agnoster/nodeready
[opinionated software]: http://gettingreal.37signals.com/ch04_Make_Opinionated_Software.php
[Joshua Frye]:      https://github.com/joshfng
[Tim Caswell]:      https://github.com/creationix
[Isaac Z. Schlueter]:   https://github.com/isaacs
