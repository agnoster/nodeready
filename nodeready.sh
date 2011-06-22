# MESSAGING primitives
LOGFILE=".nodeready.log"

say() { echo "# [nodeready] $*" | tee -a $LOGFILE; }
yay() { say "$*"; }
hmm() { say "$*"; }
die() { say "$*"; diagnostics >>$LOGFILE; say "diagnostic information in .nodeready.log"; exit -1; }

diagdo () {
	echo '$' $*
	$* 2>&1
	echo "= $?"
}

run () {
	echo '$' $* >> $LOGFILE
	$* >> $LOGFILE 2>&1
}

diagnostics () {
	echo "########## BEGIN DIAGNOSTICS ################"
	diagdo "date"
	diagdo "uname -a"
	diagdo "which curl wget lynx"
	diagdo "which brew apt-get yum"
	diagdo "which node"
	diagdo "which gcc"
	echo "$ echo \$BASH_VERSION"
	echo $BASH_VERSION
	echo "########## BEGIN env ########################"
	env
	echo "########## BEGIN ~/.nvm #####################"
	ls -al $HOME/.nvm 2>&1
	echo "########## BEGIN nvm.sh #####################"
	cat $HOME/.nvm/nvm.sh 2>&1
	echo "########## END DIAGNOSTICS ##################"
}

echo
echo
diagnostics >>$LOGFILE
say "strap yourself in, this could get bumpy..."
say "hint: if you want more detail, tail -f .nodeready.log"

# BOOTSTRAPINATOR
has() { which $1 >/dev/null 2>&1; }
use() { has $1 || return; export $2="$3" && yay "using '$1' $4"; }
use_curl() { use $1 CURL "$*" "to download files"; }

install_buildtools() {
	test `uname` = "Darwin" && die "install XCode first: http://developer.apple.com/technologies/xcode.html"
	if has apt-get; then
		say "We have to install build tools to compile node, which requires sudo:"
		run sudo apt-get -y install build-essential libssl-dev || die "could not install build tools"
	elif has yum; then
		say "We have to install build tools to compile node, which requires sudo:"
		run "(sudo yum groupinstall 'Development Tools' && sudo yum -y install openssl-devel)" || die "could not install build tools"
	else
		hmm "Couldn't find apt-get or yum to install build tools."
		hmm "You'll need g++, make, libssl-dev or their equivalents for your plaftform before we can continue"
		die "cannot continue without build tools"
	fi
}

if has gcc make; then
	say "using 'gcc' to compile"
else
	install_buildtools
fi

# Well, we need a way to download files for sure
if has curl; then
	use_curl curl -C - -o
elif has wget; then
	use_curl wget --no-check-certificate -c -O
else
	hmm "did not find curl or wget, trying to install curl..."
	if inst curl; then
		use_curl curl -L -C - -o
	elif inst wget; then
		use_curl wget --no-check-certificate -c -O
	else
		die "cannot proceed without either curl or wget!"
	fi
fi

# Start with nvm
say "installing nvm"
NVM_DIR="$HOME/.nvm"

run mkdir -p "$NVM_DIR"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
	$CURL - 'https://github.com/creationix/nvm/raw/master/nvm.sh' > "$NVM_DIR/nvm.sh" 2>>$LOGFILE || die "could not download nvm.sh"
	if ! grep "nvm.sh" ~/.bashrc ~/.bash_profile >/dev/null 2>&1; then
                if [ -r ~/.bash_profile ] ; then
                        BK=".bash_profile.$RANDOM"
                        say "backing up ~/.bash_profile to ~/$BK"
                        run cp ~/.bash_profile ~/$BK || die "could not copy... to your own home dir. huh."
                fi
		(cat <<-NVMLOAD
		[[ -s "\$HOME/.nvm/nvm.sh" ]] && source "\$HOME/.nvm/nvm.sh" # Load nvm into shell session
		NVMLOAD
		) | cat >> ~/.bash_profile
		yay "loaded nvm in ~/.bash_profile"
	fi
else
	hmm "nvm seems to already be installed - if you want to re-install, run the following and try again:"
	echo "    rm -rf ~/.nvm"
fi

source "$NVM_DIR/nvm.sh" >>$LOGFILE 2>&1
type nvm 2>&1 | grep "function" >>$LOGFILE 2>&1 || {
	head -n1 "$NVM_DIR/nvm.sh" | grep "\<html" >>$LOGFILE 2>&1 && hmm "maybe github is down?"
	die "failed to load nvm"
	}

# Get the latest and greatest node
if nvm sync; then
	VERSION=`nvm version latest`
else
	VERSION=`$CURL - http://nodejs.org/ 2>>$LOGFILE | grep -i -A 1 unstable | tail -n1 | sed -e 's/.*node-//' -e 's/.tar.gz.*//'`
	hmm "couldn't use 'nvm sync' to get latest version"
	if [ "$VERSION" = "" ]; then
		VERSION="v0.4.2"
		hmm "falling back to installing $VERSION"
	else
		yay "the website says latest is $VERSION, so we'll just trust them"
	fi
fi
say "installing latest node ($VERSION)"
say "(this could take a while, maybe get a coffee?)"
nvm install $VERSION >>$LOGFILE 2>&1 || die "crap, node install failed!"
yay "node $VERSION installed"
say "setting it as your default..."
nvm alias default $VERSION >>$LOGFILE 2>&1 || (hmm "your version of nvm doesn't seem to support that..."; hmm "oh well, no biggie. just 'nvm use $VERSION' every time you want node")
yay "all done!"
say "to load node, just start a new shell or type:"
echo "    source ~/.nvm/nvm.sh"

echo
say "Thank you for using nodeready, still in testing. If everything seemed to work,"
say "I'd appreciate a tweet @nodeready or an email to nodeready@agnoster.net"
say "letting me know what system you installed it on."
echo

