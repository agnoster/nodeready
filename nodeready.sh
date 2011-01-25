# MESSAGING primitives
LOGFILE=".nodeready.log"

say() { echo "# [nodeready] $*" | tee -a $LOGFILE; }
yay() { say "$*"; }
hmm() { say "$*"; }
die() { say "$*"; say "diagnostic information in .nodeready.log"; exit -1; }

echo
echo
say "strap yourself in, this could get bumpy..."
say "hint: if you want more detail, tail -f .nodeready.log"

# BOOTSTRAPINATOR
has() { which $1 >/dev/null 2>&1; }
use() { has $1 || return; export $2="$3" && yay "using '$1' $4"; }
use_curl() { use $1 CURL "$*" "to download files"; }
use_inst() { use $1 INST "$*" "to install new packages"; }
inst() {
	say "installing $*"
	$INST $* >>$LOGFILE 2>&1 && yay "installed successfully" || hmm "install failed"
}

# Let's see what we have...
use_inst apt-get -y install || \
use_inst brew install || \
use_inst yum -y install || \
hmm "no package manager found, attempting to continue without one"

# Well, we need a way to download files for sure
if has curl; then
	use_curl curl -s -C - -o
elif has wget; then
	use_curl wget -q -c -O
else
	hmm "did not find curl or wget, trying to install curl..."
	if inst curl; then
		use_curl curl -s -C - -o
	elif inst wget; then
		use_curl wget -q -c -O
	else
		die "cannot proceed without either curl or wget!"
	fi
fi

# Start with nvm
say "installing nvm"
NVM_DIR="$HOME/.nvm"
if mkdir "$NVM_DIR" >/dev/null 2>&1; then
	$CURL - 'https://github.com/agnoster/nvm/raw/master/nvm.sh' > "$NVM_DIR/nvm.sh"
	grep "nvm.sh" ~/.bashrc ~/.bash_profile >/dev/null 2>&1 || \
		(cat <<-NVMLOAD
		[[ -s "\$HOME/.nvm/nvm.sh" ]] && source "\$HOME/.nvm/nvm.sh" # Load nvm into shell session
		NVMLOAD
) | cat >> ~/.bash_profile
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
	VERSION=`$CURL - http://nodejs.org/ | grep -i -A 1 unstable | tail -n1 | sed -e 's/.*node-//' -e 's/.tar.gz.*//'`
	hmm "couldn't use 'nvm sync' to get latest version"
	if [ "$VERSION" = "" ]; then
		VERSION="v0.3.6"
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

