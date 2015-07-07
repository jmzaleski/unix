DIRS="
jit_*/      \
jitdebug_*/ \
codert_*/   \
jitrt_*/    \
codegen_*/  \
"

echo do you want to clean all the .obj files out of $DIRS?
echo newline to continue..
read xx

for i in $DIRS
do
	echo remove all .obj in $i
	rm -f $i*.obj
done
