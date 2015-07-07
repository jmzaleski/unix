
exec > ~/.x11AppStart.log

echo '=========== ' `date` ' =========='
echo $PATH

. ~/.bashrc
. ~/.kenv

echo start proposal lyx
( rprop ) &

echo start xemacs on bibtex
( cdd prop/../bib/;\
   xemacs matzdiss.bib )&
