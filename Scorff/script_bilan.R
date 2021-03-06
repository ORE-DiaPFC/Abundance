#rm(list=ls())   # Clear memory

#year <- 2017

##________________________SCORFF (starting in 1994)
site <- "Scorff"
#setwd(paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",sep=""))

years <- seq(1993, year, 1)
table <- array(, dim=c(length(years), 5))
colnames(table) <- c( "Year","Parr 0+","Smolts", 	"1SW (escapment)",	"MSW (escapment)")
rownames(table) <- years
smolt.years <- years
table[,1] <- years


## PARR (from 1993 to now on)
stade <- "tacon"
dir <-  paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",stade,sep="")
if (file.exists(dir)){
  load(paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",stade,"/results/Results_",stade,"_",year,".RData",sep=""))
  n_parr <- fit$median$ntot_Sc
  table[,2] <- round(n_parr,0) # 1995 to now
}



## SMOLTS (from 1995 to now on)
stade <- "smolt"
dir <-  paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",stade,sep="")
if (file.exists(dir)){
  load(paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",stade,"/results/Results_",stade,"_",year,".RData",sep=""))
  n_smolt <- fit$median$Nesc # escapement from river
  table[3:nrow(table),3] <- round(n_smolt,0) # 1995 to now
}


## ADULTS (1984 to now)
stade <- "adult"
dir <-  paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",stade,sep="")
if (file.exists(dir)){
  load(paste("~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/",site,"/",stade,"/results/Results_",stade,"_",year,".RData",sep=""))
  e_1SW <-fit$median$e_1SW # 1SW
  e_MSW <- fit$median$e_MSW #  MSW
  table[2:nrow(table),4] <- round(e_1SW,0) # 1995 to now
  table[2:nrow(table),5] <- round(e_MSW,0) # 1995 to now
}


#write.csv(round(table,2), file=paste('~/Documents/RESEARCH/PROJECTS/ORE/Abundance/CIEM/Table9_',site,"_",year,'.csv',sep=""))
con <- file(paste('~/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abundance/',site,"/Bilan_",site,"_",year,'.csv',sep=""), open="wt")
write.csv( table, con, row.names = FALSE)
close(con)
