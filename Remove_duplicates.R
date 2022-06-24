###################################

# Pipeline for removing duplicates
# start date: 24/06/2022
# Vera Vinken 

###################################
 

# working directory -> set to where the files are 
setwd('\\\\webfolders.ncl.ac.uk@SSL/DavWWWRoot/rdw/ion02/02/smulderslab/VeraVinken/1-PHD_PROJECT/Literature review/Searches')

#read in all the files 
filenames<-list.files()               # create a vector with the names of dataframes 
list_dataframes<-lapply(filenames, read.csv)                            # read in the csv files and put in list  
