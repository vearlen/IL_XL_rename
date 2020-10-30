library(readr)
getwd()
setwd("~/Documents/IL_XL_files")

#reading file into R 
IL4252_facies <- read_delim("~/Documents/IL_XL_files/IL4252_facies.csv", 
                              +     ";", escape_double = FALSE, col_types = cols(X5 = col_skip(), 
                                                                                 +         X6 = col_skip()), trim_ws = TRUE)
names(IL4252_facies)
summary(IL4252_facies)

library(dplyr)


#enter parameters of seismic survey
# x'=(x-x.or)*cos.phi+(y-y.or)*sin.phi - equation for new X coord
# y'=-(x-x.or)*sin.phi +(y-y.or)*cos.phi - for new Y coord
#http://mathhelpplanet.com/static.php?p=pryeobrazovaniya-pryamougolnyh-koordinat

# grad - rotation of new X(Inline) axis to horizontal line
grad <- 65.939
rad <- grad*(pi/180)
cos.phi <- cos(r)
sin.phi <- sin(r)

#x.or, y.or - origin of seismic survey
#xl_st, in_st - inline and xline start number
x.or <- 614839.98
xl_st <- 380
in_st <-1528
y.or <- 8141868.96
tmp <- IL4252_facies


#calculate new X&Y for rotated coordinates
tmp.IL <- (tmp$X-x.or)*cos.phi + (tmp$Y-y.or)*sin.phi
tmp.XL <- -(tmp$X-x.or)*sin.phi + (tmp$Y-y.or)*cos.phi

#calculate Inline/Xline ranges taking into account step newX/binsize*step + inline_start
tmp$IL <- round(tmp.IL/12.5*4 +in_st,0)
tmp$XL <- round(tmp.XL/12.5*4 +xl_st,0)


#write combined  IL/XL/Time file
il_xl_t <- as.data.frame(cbind(IL=tmp$IL, XL=tmp$XL, T=tmp$Z, F=tmp$F))


#split into separate files based on facies and write text
for(i in 1:9) {
        x <- as.data.frame(filter(il_xl_t, F == i)) 
        assign( paste("facies", i, sep = "_") , x,envir = globalenv()  )
        write.table(x, paste("train_fac",i, sep = "_"), row.names = F)
}


rm(tmp,x)
rm(ILXL_fac7)
