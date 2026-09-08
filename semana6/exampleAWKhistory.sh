## como manejar la historia 
cat historia 
## field $2
cat historia | awk '{print $2}' 

## last field
cat historia | awk '{print $NF}' 

## NF
cat historia | awk '{print "$NF"}' 

## number of the last field
cat historia | awk '{print NF}' 

## history without first field
cat historia | awk '{for(i=2; i<=NF; i++) printf "%s ", $i; print ""}' 

## cheking history
history | tail -4 
history | tail -10 
history | tail -11 >> historia
