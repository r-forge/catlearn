nosof92plot <- function(results,title = 'Nosofsky et al. (1992)') {
  #results <- as.data.frame(cbind(c(1,1,1,1,2,2,2,2),c(c(0.61,0.73,0.86,0.97),
  #                         c(0.70,0.88,0.98,0.98))))
  #colnames(results) <- c('pattern','corr')
  plot(
    results$corr[results$pattern == 1]
    , axes = FALSE
    , ylim = c(0.5,1)
    , xlab = 'Training Block'
    , ylab ='P(corr)'
    , bty = 'l'
    , mgp = c(2,1,0)
    , type = 'b'
    , pch = 15
    , lty = 'solid'
    , cex = 1
    , mgp = c(2.5,1,0)
  )
  title(main = title)
  box(bty='l')
  axis(1,at=0:5,labels=c('0','1','2','3','4','5'))
  axis(2,at=c(0.5,0.6,0.7,0.8,0.9,1),las = 1)
  
  lines(results$corr[results$pattern == 2],type = 'b', pch=3, cex = 1)
  legend("bottomright",c('Pattern 1','Pattern 2'), pch = c(15,3),inset=0.05)
}
