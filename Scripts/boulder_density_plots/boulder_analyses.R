library(Ckmeans.1d.dp)
library(ggplot2)
library(gridExtra)

sites<-c("d2nf")

for(site in sites){
  datfn<-paste("/Users/josephlevy/Dropbox/Mars_Glacier_Boulders/Tebolt_Boulders/Matlab_Code/csvs/site_",site,".csv",sep="")
  dat<-read.table(file = datfn, header = T,sep = ",")
  
  # #####################################################
  # ##  k=k -- I did this 1-5 for the first run through
  # #####################################################
  # x<-dat$x
  # k<-2
  # result<-Ckmeans.1d.dp(x,k)
  # 
  # ggdat<-data.frame(x=dat$x,
  #                   y=dat$y,
  #                   cluster=factor(result$cluster))
  # g2<-ggplot(data=ggdat,aes(x=x,y=y,color=cluster))+
  #   geom_point()+
  #   theme_bw()+
  #   ggtitle("2 Clusters")

  #####################################################
  ##  Choose best k
  #####################################################
  x<-dat$x  ###take x values
  k<-1:25   ###cluster values to check
  result<-Ckmeans.1d.dp(x,k=k) ###fit all cluster models
  
  outputfn<-paste("/Users/josephlevy/Dropbox/Mars_Glacier_Boulders/BIC/plots/site_",site,"_BICPLOT.pdf",sep="")
  pdf(file = outputfn)
    pplot<-plotBIC(result)  #plot BIC values by number of clusters
    print(pplot) #print the plot to pdf
  dev.off()
  
  (k<-k[as.numeric(which.max(result$BIC))]) ## produce best number of clusters by BIC
  result<-Ckmeans.1d.dp(x,k) #Fit the optimal cluster model
  
  outputfn<-paste("/Users/josephlevy/Dropbox/Mars_Glacier_Boulders/BIC/plots/site_",site,"_OPTCLUSTERPLOT.pdf",sep="")
  pdf(file = outputfn)
  ggdat<-data.frame(x=dat$x,
                    y=dat$y,
                    cluster=factor(result$cluster))
  pplot<-ggplot(data=ggdat,aes(x=x,y=y,color=cluster))+ #plot colored by cluster
                geom_point()+
                theme_bw()+
                geom_vline(xintercept = result$centers,linetype="dashed") #plot centers with vertical line
  print(pplot)
  dev.off()
}