getwd()
setwd("/Users/therandajashari/Documents/r_udemy_classes_main/07_23_r_data_class/section_4")
setwd("./Weather Data") #the ./ inside the quotation marks instead of writing parent dir 

Chicago <- read.csv("Chicago-F.csv")
Chicago #We want the first column to be rownames instead
Chicago <- read.csv("Chicago-F.csv", row.names=1)
NewYork <- read.csv("NewYork-F.csv", row.names=1)
Houston <- read.csv("Houston-F.csv", row.names=1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names=1)
NewYork
Houston
SanFrancisco

is.data.frame(Chicago)

#convert everything into a MATRIX, all values are numeric - no need for a dataframe 
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)
#Check:
is.matrix(Chicago)

#Lets put all of this into a list: 
Weather <- list(Chicago=Chicago, NewYork=NewYork,Houston=Houston,SanFrancisco=SanFrancisco)
Weather

Weather[3] #as a list 
Weather[[3]] #just the matrix by itself 






