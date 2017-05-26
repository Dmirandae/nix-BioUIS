#
# the awsome b-bourbaki team
# Junio 1 2010
# ILD project
# dmiranda@uis.edu.co
#
# awk to convert a xread (DNA) to phylip 
# TNT output as a xread-;
# 
# usage:
# tnt2phyml <in >out
#

awk '(NR==2) {s=$2+2; print $2,$1};(NR>2 && NR<=s) {print $0}'
