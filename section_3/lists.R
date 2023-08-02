#Lists in R

#Deliverable - a list with the following components:
#Character:   Machine Name 
#Vector:      (min, mean, max) Utilization for the month(excluding missing hours)
#Logical:     Has utilization ever fallen below 90%? TRUE/FALSE
#Vector:      All hours where utilization is unknown (NAs)
#Dataframe:   For this machine 
#Plot:        For all machines 

getwd()
setwd("/Users/therandajashari/Documents/r_udemy_classes_main/07_23_r_data_class/section_3")

util <- read.csv("P3-Machine-Utilization.csv", stringsAsFactors = T)
head(util,12)
str(util)
summary(util)

#We need utilization which is 1 - Percent.Idle
#Derive Utilization Column 

util$utilization = 1 - util$Percent.Idle
head(util,12)

#-----------------------Handling Date-Time in R ------------------------------------

#Date is in European format or US format? 
#In R there is a universal format called POSIXct
#POSIXct is an integer - the number of seconds that passed sice 1970 but it is represented in a user friendly way  

#Convert the data into POSIXct from the arbitrary time format 
util$PosixTime <- as.POSIXct(util$Timestamp, format="%d/%m/%Y %H:%M") #capital Y for 4 digits, lower case d and m for two digits 
head(util,12)
summary(util)

#TIP: how to rearrange columns in a df: 
util$Timestamp <- NULL
head(util,12)
util <- util[,c(4,1,2,3)] #rearranging using indexes instead of names of columns

#-----------------------What is a List? ------------------------------------
summary(util)
#subset the data for only RL1 machines 
RL1 <- util[util$Machine == "RL1",]
summary(RL1) #the other machines still come up - we have to turn the column into factor 
RL1$Machine <- factor(RL1$Machine)

#Construct a List 
#1. Character:   Machine Name 
#2. Vector:      (min, mean, max) Utilization for the month(excluding missing hours)
#3. Logical:     Has utilization ever fallen below 90%? TRUE/FALSE

#1. Creating a vector 
util_stats_rl1 <- c(min(RL1$utilization, na.rm=T),
                    mean(RL1$utilization, na.rm=T),
                    max(RL1$utilization, na.rm=T)) 
  
#2. Logical operation 
util_under_90_flag <- 

which(RL1$utilization <0.90) #tells us which elements of the vector are true (it ignores NAs)

length(which(RL1$utilization <0.90)) #27 times utilization fell under 90%
length(which(RL1$utilization <0.90)) > 0 #place the result into our flag 

util_under_90_flag <- length(which(RL1$utilization <0.90)) > 0
util_under_90_flag

#To construct the list 
list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)
list_rl1

#-----------------------Naming components of lists ------------------------------------
list_rl1
names(list_rl1)
#Renaming the list components 
#in R you can assign things to a function (in this case names)
names(list_rl1) <- c("Machine", "Stats", "Low Threshold")

#Another way - like with dataframes:
rm(list_rl1)
list_rl1
#Give names as we create the list - saves some space 
list_rl1 <- list(Machine ="RL1", Stats = util_stats_rl1, LowThreshold = util_under_90_flag)
list_rl1

#-----------------------Extract components of lists ------------------------------------

#There are three ways:
#[] - this will always return a list 
#[[]] - will always return the actual component 
#$ - same as [[]] but prettier 

list_rl1
list_rl1[1] #list with one component machine 
list_rl1[[1]] #now it is a vector 
list_rl1$Machine

list_rl1[2]
typeof(list_rl1[2])

list_rl1[[2]]
typeof(list_rl1[[2]])

list_rl1$Stats

#How would you access the 3rd element of the vector (max utilization)?
list_rl1
list_rl1$Stats[3]

#or
list_rl1[[2]][3]



