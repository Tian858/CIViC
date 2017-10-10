## read civic database from mysql
library(RMySQL)
library(dplyr)
mskdb <- dbConnect(MySQL(), user="predicine", password="predicine", dbname="predicine", host="joy")
query <- dbSendQuery(mskdb, "select primarysite, count(*) from sample where sourceid=13 group by 1;")    
      ## by 1 means to group by the first column regardless of what it is called
msksamp<- fetch(query, n=-1)


cosmicdb <- dbConnect(MySQL(), user="predicine", password="predicine", dbname="predicine", host="joy")
query <- dbSendQuery(cosmicdb, "select primarysite, count(*) from sample where sourceid in (2,5) group by 1;")
cosmicsamp<- fetch(query, n=-1)
### write out table
# write.csv(cosmicsamp,file="cosmic.csv",row.names=FALSE)
# write.csv(merged,file="msk.csv",row.names=FALSE)

### merge table
msksamp$primarysite <- tolower(msksamp$primarysite)
merged <- left_join(msksamp,cosmicsamp, by='primarysite')

### read in tumor tree
tree <- read.table('tumor_tree.txt', sep='\t', fill=TRUE,header=T)
