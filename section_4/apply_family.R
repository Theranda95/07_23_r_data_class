#Load libraries 
library(data.table) #needed to run function
library(dplyr) #needed to combine matrices 
library(ggplot2) #needed for graphing 
library(ggpubr) #needed for stats tests 

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

##---------------------------- Using Apply ------------------------------------------

?apply()

#applying functions to the rows or columns of a matrix 
#apply(matrix,1,mean) 1 - is taking the rows and finding the mean 
#apply(matrix,2,mean) 2 - taking columns and applying means 

#Average for every row 
Chicago
Means <- apply(Chicago,1,mean) #it spits out a vector 
is.vector(Means)
#check:
mean(Chicago["DaysWithPrecip",])
apply(Chicago,1,max)
apply(Chicago,1,min)
#for practice 
apply(Chicago,2,max) #doesn't make much sense but good exercise 
apply(Chicago,2,min)
#compare 
apply(Chicago,1,max)
apply(NewYork,1,max)
apply(Houston,1,max)
apply(SanFrancisco,1,max)
                      #<<<this is (nearly) deliverable 1 but there is a faster way 
#we can cbind() to bind this into a matrix 

##------------------------ Using Apply with loops --------------------------------

Chicago
#Find the mean of every row:
#1. via loops 
output <- NULL #preparing an empty vector 
for(i in 1:5){  #run the cycle of the loop 
  output[i] <- mean(Chicago[i,]) #instead of 1 - replace it by i (to iterate all the rows)
}
# we then place the result into the output 
#so that the first element of the output will be the average for the first row 
output
#change the output to names vectors 
names(output) <-rownames(Chicago) 
output

#2. via apply function 
apply(Chicago, 1, mean) #one line of code only

##--------------------------- Using lapply() -------------------------------------
#Apply a function and return a LIST as the output 
Chicago
t(Chicago) #transposing the matrix 
Weather #how do we transpose the list 

#1.Through the loop 
t(Weather$Chicago)
t(Weather$NewYork)
t(Weather$Houston)
#... and so on but with larger matrices the more time consuming 

#2. lapply 
lapply(Weather, t) #list(t(Weather$Chicago), t(Weather$NewYork), t(Weather$Houston), t(Weather$SanFrancisco))
mynewlist <- lapply(Weather, t)

#example 2 
Chicago 
rbind(Chicago, NewRow=1:12) #how do we do this on the single one of the cities 
lapply(Weather, rbind, NewRow=1:12) #list, function, option parameters 

#example 3
?rowMeans() #calculates the means of all the row or all the columns of the matrix 
rowMeans(Chicago) #identical to: apply(Chicago, 1, mean)
lapply(Weather, rowMeans)
                 ## (nearly) deliv 1: better but will improve further 

#rowMeans 
#colMeans
#rowSums
#colSums

?fread()

##---------------------- Combining lapply with the [] operator --------------------------------

Weather #this is our weather list 
#I can add all image tables of one genotype in a list #9 tables

Weather$Chicago[1,1]
#Same as:
Weather[[1]][1,1]
#We want to extract AvgHigh_F for Jan not just for Chicago but for all matrices in the list 
#This is similar to extracting column area and column roundness for all the images of one genotype 

#We could do:
#Weather$Chicago[1,1] then Weather$NewYork[1,1].... or iteration=apply function:
lapply(Weather, "[", 1, 1) # "lapply(Weather" - means that we are iterating in each element of weather list 
                           # the inside "[" refers to the component within the element of the list 

lapply(Weather, "[",1, ) #the whole row for each element 
lapply(Weather, "[", ,1) #the whole column for each element 
#R thinks we missed something in the previous line but it still works 

##---------------------- Adding your own function --------------------------------

#nesting lapply functions within our function is incredibly powerful 
#I can create and use a function to read and pre-process the data

  #we take every component of the Weather list (matrices in this case)
  #and we apply the rowMeans function to that matrix and the output 
  #is a list with those results 
    lapply(Weather, rowMeans) #we can replace the rowMeans with our function
lapply(Weather, function(x)   ) #x is the argument and anything outside of function and in between the bracket is the body of the function 

                          










