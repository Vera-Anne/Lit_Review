###################################

# Pipeline for removing duplicates
# start date: 24/06/2022
# Vera Vinken 

###################################

##        to do       ## 
  # refine symbols taken out 
  


##        done in this version    ## 

  # Finished first version: current total of 1283 unique 


#####################################

library(readxl)
library(gtools)
require(openxlsx)
library(data.table)

# working directory -> set to where the files are 
setwd('\\\\webfolders.ncl.ac.uk@SSL/DavWWWRoot/rdw/ion02/02/smulderslab/VeraVinken/1-PHD_PROJECT/Literature review/Searches/2022_06_23')

filenames<-list.files(getwd())                            # get the file names 

# rewrite xls to csv 
  for (file in filenames){
    if(grepl("xls", file, fixed=TRUE)){                   # for every file, check if it is xls
      file.xl<-read_excel(file)
      write.csv(file.xl, file=sub("xls$", "csv", file))   # if it is, write it into a csv 
      unlink(file)                                        # delete the original xls files 
    }
  }      

# put everything in a list 
filenames<-list.files(getwd())                            # set up the new filenames 
list_dataframes<-lapply(filenames, read.csv)              # read in the csv files and put in list  

# Give every dataframe a column with the file name (so we can identify searches)
    for (i in 1:(length(list_dataframes))){  
      list_dataframes[[i]]$search_ID<-filenames[[i]]
    }

# Only keep relevant columns 
for (df in 1:length(list_dataframes)){
  
    # Check if this dataframe is proquest 
    if (grepl("proquest",list_dataframes[[df]][1,(ncol(list_dataframes[[df]]))], fixed=TRUE)){
      # if proquest, keep the following: 
      keep<-c("Title", "Authors", "year", "search_ID")
      list_dataframes[[df]]<-list_dataframes[[df]][,keep]
      } # end of proquest 

  
    # Check if this dataframe is webofscience 
    if (grepl("webofscience",list_dataframes[[df]][1,(ncol(list_dataframes[[df]]))], fixed=TRUE)){
      # if proquest, keep the following: 
      keep<-c("Article.Title", "Authors", "Publication.Year", "search_ID")
      list_dataframes[[df]]<-list_dataframes[[df]][,keep]
    } # end of webofscience 
  
  
    # Check if this dataframe is Scopus  
    if (grepl("scopus",list_dataframes[[df]][1,(ncol(list_dataframes[[df]]))], fixed=TRUE)){
      # if proquest, keep the following: 
      keep<-c("Title", "Authors", "year", "search_ID")
      list_dataframes[[df]]<-list_dataframes[[df]][,keep]
    } # end of Scopus  

  # rename columns 
  colnames<-c("title", "author", "year", "search_ID")
  colnames(list_dataframes[[df]])<-colnames

} # end of loop to shorten dataframes 

# combine the data 
combined_data<-do.call("smartbind", list_dataframes)

# Now take out anything that makes it harder to compare
for (col in 1:ncol(combined_data)){

      # make everything lower case: 
      combined_data[,col]<-tolower(combined_data[,col])
}


# create a vector with all the weird symbols 
symbols<-cbind("[_]", "[-]", "[,]", '[.]', "[.]", "[©.*]", "[']","[‘]", "[:]", "[;]", "[<>]", "[?]", "[[:space:]]", "[^[:graph:]]", "[()]", "[^[:alnum:]]", '[[:digit:]]+')
#symbols<-cbind("[_]", "[-]", "[,]", '[.]', "[.]", "[©.*]", "[']","[‘]", "[:]", "[;]", "[<>]", "[?]", "[<i>]", "[</i>]")

for (s in 1:(length(symbols))){
  combined_data$title<-gsub(symbols[s], " ", combined_data$title)
  print(symbols[s])
}

# Trim white space at the lead and tail of string
combined_data$title<-trimws(combined_data$title)
# create df with unique titles 
unique_titles<-combined_data[!duplicated(combined_data$title),]



