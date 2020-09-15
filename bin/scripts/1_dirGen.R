#!/usr/bin/Rscript

#This assigns the arguments
args = commandArgs(trailingOnly=TRUE)

# here's the actual function to automatically generate the directories based on the schema file
dirGen <- function(idType="name"){
  #reads the schema file
  schema <- read.csv("../../schema.csv")
  # if the passed argument is "number", the notebookID is used, otherwise a descriptive name is generated from the optional data tags
  if (idType == "number" | ncol(schema)<6){
    xList <- unique(schema$notebook_id)
  } else {
    for (a in 6:ncol(schema)){
      if (exists("xList") & names(schema)[a] != "name_id"){
        xList <- paste(xList, schema[,a], sep = "_")
      } else if (names(schema)[a] != "name_id"){
        xList <- schema[,a]
      }
      schema$name_id <- xList
      write.csv(schema, "../../schema.csv", row.names = F)
    }
  }
  # Directories are touched, unless they already exist
  for(a in xList){
    dirName <- paste0("../../files/", a)
    if(!dir.exists(dirName))
    dir.create(dirName)
  }
}


# # test if there is at least one argument and uses the first one: if not, it defaults to the "name" argument
# if (length(args)==0) {
#   IDType <- "name"
#   dirGen(IDType)
# } else if (length(args)>0) {
#   dirGen(idType = args[1])
# }