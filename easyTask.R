library("gfpop")
n <- 400
mydata <- dataGenerator(n, c(0.2, 0.5, 0.8, 1), c(5, 10, 15, 20), sigma = 1, gamma = 0.966)
beta <- 2*log(n)
penVector <-c(beta,beta/5,beta/100)
par(mfrow=c(length(penVector),1))
for (pen in penVector)
{
  myGraphDecay <- graph(
    Edge(0, 0, "up", penalty = pen),
    Edge(0, 0, "null", 0, decay = 0.966)
  )
  g <- gfpop(data =  mydata, mygraph = myGraphDecay, type = "mean")
  #g
  gamma <- 0.966
  len <- diff(c(0, g$changepoints))
  signal <- NULL
  for(i in length(len):1){
    signal <- c(signal, g$parameters[i]*c(1, cumprod(rep(1/gamma,len[i]-1))))
  }
  signal <- rev(signal)
  ylimits <- c(min(mydata), max(mydata))
  title<-paste("Penalty = ",format(round(pen, 2), nsmall = 2))
  plot(mydata, type ='p', pch ='+', ylim = ylimits,main=title)
  par(new = TRUE)
  plot(signal, type ='l', col = 4, ylim = ylimits, lwd = 3,ylab="")
  legend('topright', legend=c("DATA", "GFPOP"),
         col=c("black", "blue"), lty=1:1, cex=0.4,ncol=2)
}
