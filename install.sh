#!/bin/bash
# The previous line forces this script to be run with bash, regardless of user's 
# shell.
#
# EPN, Mon Nov 19 09:49:21 2018 [v0.04]
#
# A shell script for installing dnaorg_build.pl, dnaorg_classify.pl
# and dnaorg_annotate.pl for viral genome annotation, along with the
# dependencies of those scripts.
#
# The following line Have the script fail if any commands fail
set -e
#
echo "------------------------------------------------"
echo "Installing dnaorg_scripts version 0.38"
echo "------------------------------------------------"
echo "Determining current directory ... "
DNAORGDIR=$PWD
echo "Set DNAORGDIR as current directory ($DNAORGDIR)."

echo "------------------------------------------------"
echo "Cloning github repos with required code ... "
# Clone what we need from GitHub (these are all public)
# dnaorg_scripts
git clone https://github.com/nawrockie/dnaorg_scripts.git
(cd dnaorg_scripts; git checkout tags/0.38; rm -rf .git)
#
# epn-options
git clone https://github.com/nawrockie/epn-options.git
(cd epn-options; git checkout tags/dnaorg_scripts-0.38; rm -rf .git)
#
# esl-epn-translate
git clone https://github.com/nawrockie/esl-epn-translate.git
(cd esl-epn-translate; git checkout tags/dnaorg_scripts-0.38; rm -rf .git)
# 
# esl-fetch-cds
git clone https://github.com/nawrockie/esl-fetch-cds.git
(cd esl-fetch-cds; git checkout tags/dnaorg_scripts-0.38; rm -rf .git)
#
# Bio-Easel
git clone https://github.com/nawrockie/Bio-Easel.git
(cd Bio-Easel; git checkout tags/dnaorg_scripts-0.38; rm -rf .git)
#
echo "Finished cloning github repos with required code."
echo "------------------------------------------------"
echo "Cloning github repo with virus models ... "
# esl-epn-translate
git clone https://github.com/nawrockie/dnaorg-build-directories.git
#
# Build Bio-Easel:
echo "Building Bio-Easel ... "
cd $DNAORGDIR/Bio-Easel
# clone Easel subdir
mkdir src
(cd src; git clone https://github.com/EddyRivasLab/easel.git easel)
(cd src/easel; git checkout tags/Bio-Easel-0.06; rm -rf .git)
perl Makefile.PL
make
make test
echo "Finished building Bio-Easel."
echo "------------------------------------------------"
#
# Other software that we need to install:
# Infernal (develop branch, specific commit)
# HMMER 3.1b2
cd $DNAORGDIR
echo "Installing Infernal ... "
git clone https://github.com/EddyRivasLab/infernal.git infernal-dev
cd infernal-dev
git checkout b748e2c
rm -rf .git
git clone https://github.com/EddyRivasLab/hmmer
(cd hmmer; git checkout 498ec7c)
git clone https://github.com/EddyRivasLab/easel
(cd easel; git checkout 5288a95)
autoconf
sh ./configure 
make
# uncomment to install system wide
#make install
echo "Finished installing Infernal"
echo "------------------------------------------------"

cd $DNAORGDIR
echo "Installing HMMER 3.1b2 ... "
wget eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz 
tar xf hmmer-3.1b2.tar.gz
cd hmmer-3.1b2
sh ./configure 
make
# uncomment to install system wide
#make install
cd $DNAORGDIR
echo "Finished installing HMMER 3.1b2."
echo "------------------------------------------------"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Output the final message:
echo "The final step is to update your environment variables:"
echo ""
echo "If you are using the bash shell, add the following two"
echo "lines to the '.bashrc' file in your home directory:"
echo ""
echo "export DNAORGDIR=\"$DNAORGDIR\""
echo 'export PERL5LIB="$DNAORGDIR/dnaorg_scripts:$DNAORGDIR/epn-options:$DNAORGDIR/Bio-Easel/blib/lib:$DNAORGDIR/Bio-Easel/blib/arch:$PERL5LIB"'
echo 'export PATH="$DNAORGDIR/dnaorg_scripts:$PATH"'
echo ""
echo "And then source that file to update your current"
echo "environment with the command:"
echo ""
echo "source ~/.bashrc"
echo ""
echo "If you are using the C shell, add the following two"
echo "lines to the '.cshrc' file in your home directory:"
echo ""
echo "setenv DNAORGDIR \"$DNAORGDIR\""
echo 'setenv PERL5LIB "$DNAORGDIR/dnaorg_scripts:$DNAORGDIR/epn-options:$DNAORGDIR/Bio-Easel/blib/lib:$DNAORGDIR/Bio-Easel/blib/arch:$PERL5LIB"'
echo 'setenv PATH "$DNAORGDIR/dnaorg_scripts:$PATH"'
echo ""
echo "And then source that file to update your current"
echo "environment with the command:"
echo ""
echo "source ~/.cshrc"
echo ""
echo "(To determine which shell you use, type: 'echo \$$SHELL')"
echo ""
