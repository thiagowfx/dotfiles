#!/bin/bash

. assert.sh/assert.sh

# assert.sh tests
assert "echo 42" "42"
assert_raises "exit 10" "10"
assert_end assert.sh

#
# .alias tests
#
source .alias

# addenv tests
assert 'addenv DUMMYVAR "42"; echo $DUMMYVAR' '42'
assert 'addenv DUMMYVAR ""; echo $DUMMYVAR' ''
assert 'addenv EDITOR "vi" vi; command -v &>/dev/null vi && echo $EDITOR' 'vi'
assert 'addenv EDITOR "vifake_" vifakefake; command -v vifake_ && echo $EDITOR' ''
assert 'addenv MYPATH "dummypath" "" "/qwqw_qwqw_az"; echo $MYPATH' ''
assert 'mkdir /tmp/qwqw_; addenv MYPATH "dummypath" "" "/tmp/qwqw_"; echo $MYPATH' 'dummypath'
assert 'mkdir /tmp/qwqw_; addenv MYPATH "dummypath" fake_ "/tmp/qwqw_"; echo $MYPATH' ''
assert 'mkdir /tmp/qwqw_; addenv MYPATH "dummypath" vi "/tmp/qwqw_"; echo $MYPATH' 'dummypath'
assert_end addenv

# addalias tests
# it is not possible to do more tests with assert.sh
assert 'addalias hello "echo world" fake_; hello' ''
assert_end addalias
