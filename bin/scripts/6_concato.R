#!/usr/bin/Rscript

concato <- function(dirz = "../files",
                    count = T){
  setwd(dirz)
  xList <- list.files()
  for (xL in xList){
    if (!grepl("ijm", xL)){
      setwd(xL)
      if (exists("cells")){
#        print("Found some cells, removing them")
        rm(cells)
        rm(rois)
      }
      yList <- list.files()
      for(yL in yList){
        if(!grepl(".csv",yL) & !grepl(".pdf", yL)){
          setwd(yL)
          zList <- list.files(pattern = "_WN_all.csv")[1]
          rList <- list.files(pattern = "_ROI_all.csv")[1]
          if(!exists("cells")){
            cells <- read.csv(zList)
          } else{
            interim <- read.csv(zList)
            if(ncol(interim) != ncol(cells)){
              for(i in names(cells)[!names(cells) %in% names(interim)]){
                interim[i] <- 0
              }
              for(i in names(interim)[!names(interim) %in% names(cells)]){
                cells[i] <- 0
              }
            }
            cells <- rbind(cells, interim)
          }
          if(!exists("rois")){
            rois <- read.csv(rList)
          } else{
            rinterim <- read.csv(rList)
            if(ncol(interim) != ncol(cells)){
              for(i in names(rois)[!names(rois) %in% names(rinterim)]){
                rinterim[i] <- 0
              }
              for(i in names(rinterim)[!names(rinterim) %in% names(rois)]){
                rois[i] <- 0
              }
            }
            rois <- rbind(rois, rinterim)
          }
          setwd("../")
        }
      }
      write.csv(cells, file = paste0(xL, "_all.csv"), row.names = F)
      write.csv(rois, file = paste0(xL, "_roi_all.csv"), row.names = F)
      if(!exists("minNum")){
        minNum <- nrow(cells)
      } else{
        if(nrow(cells) < minNum){
          minNum <- nrow(cells)
        }
      }
      setwd("../")
    }
  }
  if(count == T){
    cat(paste0("The minimum cell count recorded is: ",minNum))
  }
}

concato()
