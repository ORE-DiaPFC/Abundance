## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------
wdir <- "/media/hdd/mbuoro/ORE-DiaPFC/Abundance/"
#setwd(wdir)

site <- "Scorff"
year <- 2019

#COL <- c("yellowgreen","hotpink2","steelblue1","black")
mycol=c("#787878", "#1E90FF", "#a1dab4", "#FF6A6A")
#mycol <- paste0(COL, 50)
#mycol <- COL
##________________________SCORFF (starting in 1994)





## ---- echo = FALSE----------------------------------------------------------------------------------------------------------------
years <- seq(1993, year, 1)
table <- array(, dim=c(length(years), 7))
colnames(table) <- c( "Year","Parr 0+","Smolts","1SW (tot returns)",	"MSW (tot returns)", 	"1SW (escapment)",	"MSW (escapment)")
rownames(table) <- years
smolt.years <- years
table[,1] <- years


## PARR (from 1993 to now on)
stade <- "tacon"
dir <-  paste(wdir,site,"/",stade,sep="")
if (file.exists(dir)){
  load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
  n_parr <- fit$median$ntot_Sc
  table[,2] <- round(n_parr,0) # 1995 to now
}



## SMOLTS (from 1995 to now on)
stade <- "smolt"
dir <-  paste(wdir,site,"/",stade,sep="")
if (file.exists(dir)){
  load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
  n_smolt <- fit$median$Nesc # escapement from river
table[3:nrow(table),3] <- round(n_smolt,0) # 1995 to now
}


## ADULTS (1994 to now)
stade <- "adult"
dir <-  paste(wdir,site,"/",stade,sep="")
if (file.exists(dir)){
  load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
  
  # n returns
  n_1SW <- fit$median$n_1SW # 1SW
  n_MSW <- fit$median$n_MSW #  MSW
  table[2:nrow(table),4] <- round(n_1SW,0) # 1995 to now
  table[2:nrow(table),5] <- round(n_MSW,0) # 1995 to now
  
  # escapment
e_1SW <- fit$median$e_1SW # 1SW
e_MSW <- fit$median$e_MSW #  MSW
table[2:nrow(table),6] <- round(e_1SW,0) # 1995 to now
table[2:nrow(table),7] <- round(e_MSW,0) # 1995 to now
}


#write.csv(round(table,2), file=paste('~/Documents/RESEARCH/PROJECTS/ORE/Abundance/CIEM/Table9_',site,"_",year,'.csv',sep=""))
con <- file(paste0("Bilan_",site,"_",year,'.csv'), open="wt")
write.csv( table, con, row.names = FALSE)
close(con)

library(knitr)
kable(table, row.names = FALSE, caption = paste0("Tableau bilan pour le ",site,". Seules les valeurs médianes sont reportées"))



## ----pressure, echo=FALSE---------------------------------------------------------------------------------------------------------
#### RETURNS

stade <- "adult"
#dir <-  paste(wdir,site,"/",stade,sep="")
#if (file.exists(dir)){
# load dataset
load(paste(stade,"/data/data_",stade,"_",year,'.Rdata',sep="")) # chargement des données
load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
#}


tmp <- as.matrix(fit$sims.matrix)

#png(paste0(site,"/total_return.png"),width = 780, height = 480)
par(mfrow=c(1,1)) 

### Total number of returns
plot(NULL,xlim=c(1,data$Y),ylim=c(0,1500),bty="n",ylab="Total number of fish",xaxt="n",xlab="")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)

# N total
mcmc <- as.matrix(tmp[,paste0("n_tot[",1:data$Y,"]")]) # 1984 to now)
n <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Y,n[,"2.5%"], 1:data$Y,n[,"97.5%"], col=paste0(mycol[3]))
lines(n[,"50%"],lty=1,lwd=2,col=mycol[3],type="o")
points(1:data$Y,n[,"50%"],col=mycol[3],pch=21,bg=paste0(mycol[3]))

# Escapement
mcmc <- as.matrix(tmp[,paste0("e_tot[",1:data$Y,"]")]) # 1984 to now)
e <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Y,e[,"2.5%"], 1:data$Y,e[,"97.5%"], col=paste0(mycol[4]))
lines(e[,"50%"],lty=1,lwd=2,col=mycol[4],type="o")
points(1:data$Y,e[,"50%"],col=mycol[4],pch=21,bg=paste0(mycol[4]))

legend("topright", legend=c("Nombre total de retour", "Echappement"), col=mycol[3:4],lty=1,lwd=2,bty="n")


## ---- echo=FALSE------------------------------------------------------------------------------------------------------------------


plot(NULL,xlim=c(1,data$Y),ylim=c(0,1500),bty="n",ylab="Total number of returns",xaxt="n",xlab="")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)
mycol=c("#787878", "#1E90FF", "#a1dab4", "#FF6A6A")

# 1SW
mcmc <- as.matrix(tmp[,paste0("n_1SW[",1:data$Y,"]")]) # 1984 to now)
n_1SW <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Y,n_1SW[,"2.5%"], 1:data$Y,n_1SW[,"97.5%"], col=paste0(mycol[1]))
lines(n_1SW[,"50%"],lty=1,lwd=2,col=mycol[1],type="o")
points(1:data$Y,n_1SW[,"50%"],col=mycol[1],pch=21,bg=paste0(mycol[1]))

# MSW
mcmc <- as.matrix(tmp[,paste0("n_MSW[",1:data$Y,"]")]) # 1984 to now)
n_MSW <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Y,n_MSW[,"2.5%"], 1:data$Y,n_MSW[,"97.5%"], col=paste0(mycol[2]))
lines(n_MSW[,"50%"],lty=1,lwd=2,col=mycol[2],type="o")
points(1:data$Y,n_MSW[,"50%"],col=mycol[2],pch=21,bg=paste0(mycol[2]))

legend("topright", legend=c("1SW","MSW"), col=mycol[1:2],lty=1,lwd=2,bty="n")


#dev.off()




## ---- echo=FALSE------------------------------------------------------------------------------------------------------------------

#### CAPTURE AT MP ####
par(mfrow=c(1,1)) 

mcmc <- as.matrix(tmp[,paste0("pi_MP[",1:data$Y,",1]")]) # 
piMP_1SW <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
mcmc <- as.matrix(tmp[,paste0("pi_MP[",1:data$Y,",2]")]) # 
piMP_MSW <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
### Total number of returns
#png("report/total_return.png",width = 780, height = 480)
plot(NULL,xlim=c(1,data$Y),ylim=c(0,100),bty="n",ylab="% captured at MP",xaxt="n",xlab="")#,main="% MSW to be captured by fishing")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)

# N total
segments(1:data$Y,piMP_MSW[,"2.5%"], 1:data$Y,piMP_MSW[,"97.5%"], col=paste0(mycol[4]))
lines(piMP_MSW[,"50%"],lty=1,lwd=2,col=mycol[4],type="o")
points(1:data$Y,piMP_MSW[,"50%"],col=mycol[4],pch=21,bg=paste0(mycol[4]))

# N total
segments(1:data$Y,piMP_1SW[,"2.5%"], 1:data$Y,piMP_1SW[,"97.5%"], col=paste0(mycol[3]))
lines(piMP_1SW[,"50%"],lty=1,lwd=2,col=mycol[3],type="o")
points(1:data$Y,piMP_1SW[,"50%"],col=mycol[3],pch=21,bg=paste0(mycol[3]))

legend("topright", legend=c("1SW", "MSW"), col=mycol[3:4],lty=1,lwd=3,bty="n")



## ---- echo=FALSE------------------------------------------------------------------------------------------------------------------
## a: sea age; 
##    1-1SW (Grisle), 
##    2-MSW (salmon)
## u: effect of being marked
##    1 - marked
##    2 - unmarked
################################################################################
## PROBABILITY DISTRIBUTIONS
## -------------------------
## pi_MP94[a]:probability to be captured at Moulin des Princes given sea age for 1994 
## pi_MP[t,a]:annual probability to be captured at Moulin des Princes given sea age
## pi_D_1SW[t,a]: annual probability for a marked 1SW to die from cause other than fishing given marking
## pi_D_MSW[t,a]: annual probability for a marked MSW to die from cause other than fishing given marking
## pi_Dum[t,a]: annual probability for a unmarked fish to die from cause other than fishing given sea age
## pi_oD: probability to recover a fish that die from other cause than fishing
## pi_F_1SW[t,a]: annual probability of a 1SW to be captured by fishing given marking
## pi_F_MSW[t,a]: annual probability of a MSW to be captured by fishing given marking 
## pi_oF[t,a]: annual probability to recover a caught fish (exploitation). From 1994 to 2002.
## pi_R[t,a]: annual probability to be captured during or after reproduction given sea age
####################################################################################  

par(mfrow=c(1,2)) 

#### 1SW ####
#piF_1SW[10,1] <- 0 # No exploitation allowed on 1SW in 2003
#piF_1SW[10,2] <- 0 # No exploitation allowed on 1SW in 2003 
mcmc <- as.matrix(tmp[,paste0("piF_1SW[",c(1:9,11:data$Y),",1]")]) # 
piF_1SWm <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
piF_1SWm <- rbind(piF_1SWm[1:9,], c(0,0,0),piF_1SWm[10:(data$Y-1),])

mcmc <- as.matrix(tmp[,paste0("piF_1SW[",c(1:9,11:data$Y),",2]")]) # 
piF_1SWum <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
piF_1SWum <- rbind(piF_1SWum[1:9,], c(0,0,0),piF_1SWum[10:(data$Y-1),])

### Total number of returns
#png("report/total_return.png",width = 780, height = 480)
plot(NULL,xlim=c(1,data$Y),ylim=c(0,50),bty="n",ylab="% 1SW captured by fishing",xaxt="n",xlab="")#, main="% 1SW to be captured by fishing")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)

# N total
segments(1:data$Y,piF_1SWm[,"2.5%"], 1:data$Y,piF_1SWm[,"97.5%"], col=paste0(mycol[4]))
lines(piF_1SWm[,"50%"],lty=1,lwd=2,col=mycol[4],type="o")
points(1:data$Y,piF_1SWm[,"50%"],col=mycol[4],pch=21,bg=paste0(mycol[4]))

# N total
segments(1:data$Y,piF_1SWum[,"2.5%"], 1:data$Y,piF_1SWum[,"97.5%"], col=paste0(mycol[3]))
lines(piF_1SWum[,"50%"],lty=1,lwd=2,col=mycol[3],type="o")
points(1:data$Y,piF_1SWum[,"50%"],col=mycol[3],pch=21,bg=paste0(mycol[3]))

legend("topright", legend=c("Unmarked", "Marked"), col=mycol[3:4],lty=1,lwd=3,bty="n")


#### MSW ####
mcmc <- as.matrix(tmp[,paste0("piF_MSW[",1:data$Y,",1]")]) # 
piF_MSWm <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
mcmc <- as.matrix(tmp[,paste0("piF_MSW[",1:data$Y,",2]")]) # 
piF_MSWum <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
### Total number of returns
#png("report/total_return.png",width = 780, height = 480)
plot(NULL,xlim=c(1,data$Y),ylim=c(0,50),bty="n",ylab="% MSW captured by fishing",xaxt="n",xlab="")#,main="% MSW to be captured by fishing")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)

# N total
segments(1:data$Y,piF_MSWm[,"2.5%"], 1:data$Y,piF_MSWm[,"97.5%"], col=paste0(mycol[4]))
lines(piF_MSWm[,"50%"],lty=1,lwd=2,col=mycol[4],type="o")
points(1:data$Y,piF_MSWm[,"50%"],col=mycol[4],pch=21,bg=paste0(mycol[4]))

# N total
segments(1:data$Y,piF_MSWum[,"2.5%"], 1:data$Y,piF_MSWum[,"97.5%"], col=paste0(mycol[3]))
lines(piF_MSWum[,"50%"],lty=1,lwd=2,col=mycol[3],type="o")
points(1:data$Y,piF_MSWum[,"50%"],col=mycol[3],pch=21,bg=paste0(mycol[3]))

legend("topright", legend=c("Unmarked", "Marked"), col=mycol[3:4],lty=1,lwd=3,bty="n")



## ---- echo=FALSE------------------------------------------------------------------------------------------------------------------

#### PROB. DEAD ####
par(mfrow=c(1,2)) 

#### 1SW ####
mcmc <- as.matrix(tmp[,paste0("piD_1SW[",1:data$Y,",1]")]) # 
piD_1SWm <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100

mcmc <- as.matrix(tmp[,paste0("piD_1SW[",1:data$Y,",2]")]) # 
piD_1SWum <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100

### Total number of returns
#png("report/total_return.png",width = 780, height = 480)
plot(NULL,xlim=c(1,data$Y),ylim=c(0,50),bty="n",ylab="% 1SW dead from cause other than fishing",xaxt="n",xlab="")#, main="% 1SW to be captured by fishing")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)

# N total
segments(1:data$Y,piD_1SWm[,"2.5%"], 1:data$Y,piD_1SWm[,"97.5%"], col=paste0(mycol[4]))
lines(piD_1SWm[,"50%"],lty=1,lwd=2,col=mycol[4],type="o")
points(1:data$Y,piD_1SWm[,"50%"],col=mycol[4],pch=21,bg=paste0(mycol[4]))

# N total
segments(1:data$Y,piD_1SWum[,"2.5%"], 1:data$Y,piD_1SWum[,"97.5%"], col=paste0(mycol[3]))
lines(piD_1SWum[,"50%"],lty=1,lwd=2,col=mycol[3],type="o")
points(1:data$Y,piD_1SWum[,"50%"],col=mycol[3],pch=21,bg=paste0(mycol[3]))

legend("topright", legend=c("Unmarked", "Marked"), col=mycol[3:4],lty=1,lwd=3,bty="n")


#### MSW ####
mcmc <- as.matrix(tmp[,paste0("piD_MSW[",1:data$Y,",1]")]) # 
piD_MSWm <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
mcmc <- as.matrix(tmp[,paste0("piD_MSW[",1:data$Y,",2]")]) # 
piD_MSWum <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
### Total number of returns
#png("report/total_return.png",width = 780, height = 480)
plot(NULL,xlim=c(1,data$Y),ylim=c(0,50),bty="n",ylab="% MSW dead from cause other than fishing",xaxt="n",xlab="")#,main="% MSW to be captured by fishing")
axis(side=1,line=1,labels = years[-1],at=1:data$Y, las=2, cex=.5)

# N total
segments(1:data$Y,piD_MSWm[,"2.5%"], 1:data$Y,piD_MSWm[,"97.5%"], col=paste0(mycol[4]))
lines(piD_MSWm[,"50%"],lty=1,lwd=2,col=mycol[4],type="o")
points(1:data$Y,piD_MSWm[,"50%"],col=mycol[4],pch=21,bg=paste0(mycol[4]))

# N total
segments(1:data$Y,piD_MSWum[,"2.5%"], 1:data$Y,piD_MSWum[,"97.5%"], col=paste0(mycol[3]))
lines(piD_MSWum[,"50%"],lty=1,lwd=2,col=mycol[3],type="o")
points(1:data$Y,piD_MSWum[,"50%"],col=mycol[3],pch=21,bg=paste0(mycol[3]))

legend("topright", legend=c("Unmarked", "Marked"), col=mycol[3:4],lty=1,lwd=3,bty="n")




## ----smolt, echo=FALSE------------------------------------------------------------------------------------------------------------

stade <- "smolt"
#dir <-  paste(wdir,site,"/",stade,sep="")
#if (file.exists(dir)){
# load dataset
load(paste(stade,"/data/data_",stade,"_",year,'.Rdata',sep="")) # chargement des données
load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
#}


tmp <- as.matrix(fit$sims.matrix)

#png(paste0(site,"/total_return.png"),width = 780, height = 480)
par(mfrow=c(1,1)) 

### Total number of returns
plot(NULL,xlim=c(1,data$Nyears),ylim=c(0,15000),bty="n",ylab="Total number of fish",xaxt="n",xlab="")
axis(side=1,line=1,labels = years[-c(1,2)],at=1:data$Nyears, las=2, cex=.5)

# N total
mcmc <- as.matrix(tmp[,paste0("Ntot[",1:data$Nyears,"]")])    
n <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Nyears,n[,"2.5%"], 1:data$Nyears,n[,"97.5%"], col=paste0(mycol[1]))
lines(n[,"50%"],lty=1,lwd=2,col=mycol[1],type="o")
points(1:data$Nyears,n[,"50%"],col=mycol[1],pch=21,bg=paste0(mycol[1]))

# Escapment
mcmc <- as.matrix(tmp[,paste0("Nesc[",1:data$Nyears,"]")])    
n <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Nyears,n[,"2.5%"], 1:data$Nyears,n[,"97.5%"], col=paste0(mycol[2]))
lines(n[,"50%"],lty=1,lwd=2,col=mycol[2],type="o")
points(1:data$Nyears,n[,"50%"],col=mycol[2],pch=21,bg=paste0(mycol[2]))

legend("topright", legend=c("Nombre total de smolts", "Echappement"), col=mycol[1:2],lty=1,lwd=2,bty="n")



## ----capt_smolt, echo=FALSE-------------------------------------------------------------------------------------------------------
par(mfrow=c(1,1)) 

### Total number of returns
plot(NULL,xlim=c(1,data$Nyears),ylim=c(0,100),bty="n",ylab="% smolts captured at traps",xaxt="n",xlab="")
axis(side=1,line=1,labels = years[-c(1,2)],at=1:data$Nyears, las=2, cex=.5)

# Moulin des Princes
mcmc <- as.matrix(tmp[,paste0("p_MP[",1:data$Nyears,"]")])    
n <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
segments(1:data$Nyears,n[,"2.5%"], 1:data$Nyears,n[,"97.5%"], col=paste0(mycol[1]))
lines(n[,"50%"],lty=1,lwd=2,col=mycol[1],type="o")
points(1:data$Nyears,n[,"50%"],col=mycol[1],pch=21,bg=paste0(mycol[1]))

# Moulin du Leslé
mcmc <- as.matrix(tmp[,paste0("p_ML[",3:data$Nyears,"]")])    
n <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))*100
n <- rbind(matrix(NA,2,3),n)
segments(1:data$Nyears,n[,"2.5%"], 1:data$Nyears,n[,"97.5%"], col=paste0(mycol[2]))
lines(n[,"50%"],lty=1,lwd=2,col=mycol[2],type="o")
points(1:data$Nyears,n[,"50%"],col=mycol[2],pch=21,bg=paste0(mycol[2]))

legend("topright", legend=c("Moulin des Princes", "Moulin du Leslé"), col=mycol[1:2],lty=1,lwd=3,bty="n")


## ----env, echo=FALSE--------------------------------------------------------------------------------------------------------------

stade <- "smolt"
#dir <-  paste(wdir,site,"/",stade,sep="")
#if (file.exists(dir)){
# load dataset
load(paste(stade,"/data/data_",stade,"_",year,'.Rdata',sep="")) # chargement des données
#load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
#}


#png(paste0(site,"/total_return.png"),width = 780, height = 480)
par(mfrow=c(1,1)) 

### Total number of returns
plot(NULL,xlim=c(1,data$Nyears),ylim=c(0,20),bty="n",ylab="Mean flow observed from 1st April to May 10",xaxt="n",xlab="")
axis(side=1,line=1,labels = years[-c(1,2)],at=1:data$Nyears, las=2, cex=.5)

lines(data$Q[,1],lty=1,lwd=2,col="steelblue1",type="o")

#legend("topright", legend=c("Moulin des Princes", "Moulin du Leslé"),col=mycol[1:2],lty=1,lwd=2,bty="n")



## ----parr, echo=FALSE-------------------------------------------------------------------------------------------------------------

# TACONS

stade <- "tacon"
#dir <-  paste(wdir,site,"/",stade,sep="")
#if (file.exists(dir)){
# load dataset
load(paste(stade,"/data/data_",stade,"_",year,'.Rdata',sep="")) # chargement des données
load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
#}


tmp <- as.matrix(fit$sims.matrix)

#png(paste0(site,"/total_return.png"),width = 780, height = 480)
par(mfrow=c(1,1)) 

### Total number of returns
plot(NULL,xlim=c(1,data$Nyear),ylim=c(0,50000),bty="n",ylab="Total number of fish",xaxt="n",xlab="")
axis(side=1,line=1,labels = years,at=1:data$Nyear, las=2, cex=.5)

# N total
mcmc <- as.matrix(tmp[,paste0("ntot_Sc[",1:data$Nyear,"]")])    
n <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))
segments(1:data$Nyear,n[,"2.5%"], 1:data$Nyear,n[,"97.5%"], col=paste0(mycol[1]))
lines(n[,"50%"],lty=1,lwd=2,col=mycol[1],type="o")
points(1:data$Nyear,n[,"50%"],col=mycol[1],pch=21,bg=paste0(mycol[1]))


## ----SR, echo=FALSE---------------------------------------------------------------------------------------------------------------


stade <- "adult"
load(paste(stade,"/data/data_",stade,"_",year,'.Rdata',sep="")) 
load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
adu <- as.matrix(fit$sims.matrix)
mcmc <- as.matrix(adu[,paste0("e_tot[",1:data$Y,"]")]) # 1984 to now)
s <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))

stade <- "tacon"
load(paste(stade,"/data/data_",stade,"_",year,'.Rdata',sep="")) 
load(paste0(stade,"/results/Results_",stade,"_",year,".RData"))
parr <- as.matrix(fit$sims.matrix)
mcmc <- as.matrix(parr[,paste0("ntot_Sc[",1:data$Nyear,"]")]) # 1984 to now)
r <- t(apply(mcmc,2,quantile,probs=c(0.025, .5, 0.975)))




#png(paste0(site,"/total_return.png"),width = 780, height = 480)
par(mfrow=c(1,1)) 

### Total number of returns
plot(NULL,xlim=c(0,1000),ylim=c(0,50000),bty="n",ylab="Recruitment (parr 0+)",xlab="Stock (escapted adults)")
#axis(side=1,line=1,labels = years,at=1:data$Nyear, las=2, cex=.5)

# Stock
segments(s[,"2.5%"], r[2:27,"50%"],e[,"97.5%"],r[2:27,"50%"], col=paste0(mycol[1]))
segments(s[,"50%"], r[2:27,"2.5%"],e[,"50%"],r[2:27,"97.5%"], col=paste0(mycol[1]))
points(s[1:26,"50%"],r[2:27,"50%"],col=mycol[1],pch=21,bg=paste0(mycol[1]))
text(s[1:26,"50%"],r[2:27,"50%"]+2000,labels = years, cex=.5)


