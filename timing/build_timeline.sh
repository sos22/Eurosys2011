#! /bin/sh

grep "read initial snapshot" $1
grep "have memory trace" $1
grep "built crash machine" $1
grep "built interesting addresses set" $1
grep "Done remove constant references" $1
grep "Done fold registers" $1
grep "all done" $1
