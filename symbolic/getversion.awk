#!/usr/bin/awk -f

/^ *AC_INIT/ {
 split($0, acinit, ",");
 sub("[[]", "", acinit[2]);
 sub("]", "", acinit[2]);
 sub(":", ".", acinit[2]);
 printf "%s", acinit[2];
}
