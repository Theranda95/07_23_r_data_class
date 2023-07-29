
getwd()
setwd("/Users/therandajashari/Documents/r_udemy_classes_main/07_23_r_data_class/section_1")

# We create an object - a data frame with 11 variables 
fin <- read.csv("P3-Future-500-The-Dataset.csv", stringsAsFactors = T, na.strings=c(""))
head(fin)
tail(fin)
str(fin)

#---------------------What are factors--------------------------
#Factors from the structure function are categorical variables 
#All characters will be recognized as factors using the 'stringsAsFactors = T'
#We need to change some of the from factors to non-factors like Revenue, Expenses, Growth etc 

#Changing a non-factor to factor 
fin$ID <- factor(fin$ID)
str(fin)

fin$Inception <- factor(fin$Inception)
summary(fin)

#Factor variable trap (FVT)

#Converting characters into numerics: 
a <- c("12", "13", "14", "12", "12")
typeof(a)

b <- as.numeric(a)
typeof(b)

#Converting factors into numerics: 
z <- factor(c("12", "13", "14", "12", "12")) #treating it as categorical 
z
y <- as.numeric(z) #we picked up the factorization of the list and not the actual numbers 
y 
#Correct way so you don't pick up the factorization 
#First convert z(factor) to character : factor -> character -> numeric 
as.character(z)
#then convert it to number 
x <- as.numeric(as.character(z))
x
head(fin)
str(fin)

#------------------------sub() and gsub() functions--------------------------------

sub() #replaces only the first instance
gsub() #replaces all instances 

#We want to remove "dollars" words from the Expenses column 
fin$Expenses <- gsub("Dollars", "", fin$Expenses)
fin$Expenses <- gsub(",", "", fin$Expenses)
head(fin)
#Expenses is no longer a factor, it is a character 
str(fin)

#removing a dollar sign 
fin$Revenue<- gsub("\\$", "", fin$Revenue) #because it is a special character it needs two backslashes 
fin$Revenue<- gsub(",", "", fin$Revenue)
head(fin)
str(fin)

#removing % in Growth 
fin$Growth<- gsub("%", "", fin$Growth)
head(fin)
str(fin)

fin$Expenses <- as.numeric(fin$Expenses)
fin$Revenue <- as.numeric(fin$Revenue)
fin$Growth <- as.numeric(fin$Growth)
str(fin)

summary(fin)

#------------------Missing data ----------------------

#missing valua is expressed as NA

?NA #a third logical concept (besides true and false)

#Locate missing data 
#Updated import to this:fin <- read.csv("P3-Future-500-The-Dataset.csv", stringsAsFactors = T, na.strings=c(""))

head(fin,24)
complete.cases(fin) #vector with true and false values - checking NA in any of the places 
#picking up rows with at least one NA in it 
#we can subset 
fin[!complete.cases(fin),] #but it is not picking up the rows with empty values
#we need to import the data that replaces empty characters with NA's 

#------------------Filtering using which() for non-missing data -------------------------

head(fin)
fin[fin$Revenue == 9746272,] #two other rows coming up - R picks up the empty values as well 

#How to correct it 
which(fin$Revenue == 9746272) #Which() looks through the vector and only picks up the true values 
#which() ignores false and NA values - we get the number of the row with the true value 

fin[which(fin$Revenue == 9746272),] #we get the whole row 

head(fin)
fin[fin$Employees == 45,]
fin[which(fin$Employees == 45),]

#------------------Filtering using is.na() for non-missing data -------------------------

head(fin,24)

fin$Expenses == NA #we can't compare thing to NA
fin[fin$Expenses == NA,]

is.na(fin$Expenses)
fin[is.na(fin$Expenses),]

fin[is.na(fin$State),]

#------------------Removing records with missing data -------------------------

#We will remove the empty values in the industry column 

#First make a back-up of the data before changing it so we can restore it 
fin_backup <- fin
#All rows with empty values in some of the columns 
fin[!complete.cases(fin),]
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),] #opposite 
fin <- fin[!is.na(fin$Industry),] #override it with the new dataframe 

head(fin,20)

#------------------Resetting data frame index  -------------------------

#when rows are removed and we need to reset the row numbers 
rownames(fin) <- 1:nrow(fin)
tail(fin)

#a quick tip 
rownames(fin) <- NULL #a faster way to reset the row names faster 
tail(fin)

#------------------Replacing missing data: Factual Analysis Method-------------------------

#we can restore the state when we know the city and we can calculate expenses with 100% certaintly 

fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City == "New York",]
fin[is.na(fin$State) & fin$City == "New York", "State"] <- "NY"
#check 
fin[c(11,377),]

fin[!complete.cases(fin),]

fin[is.na(fin$State) & fin$City == "San Francisco", "State"] <- "CA"
fin[c(82,265),]

fin[!complete.cases(fin),]

#------------------Replacing missing data: Median Imputation Method (Part 1)--------------------

fin[!complete.cases(fin),]

median(fin[,"Employees"], na.rm = T) #getting the median of all employees regardless of industry 
mean(fin[,"Employees"], na.rm = T)

median(fin[fin$Industry=="Retail","Employees"], na.rm = T) #getting the median if employees in retail industry
med_empl_retail <- median(fin[fin$Industry=="Retail","Employees"], na.rm = T) 
med_empl_retail 

fin[is.na(fin$Employees) & fin$Industry == "Retail",] 
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_empl_retail
#check
fin[3,] 

#fill the Employees for Financial Service 
med_empl_finserv <- median(fin[fin$Industry=="Financial Services","Employees"], na.rm = T) #removing na when calculating median

fin[is.na(fin$Employees) & fin$Industry == "Financial Services",] 
fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- med_empl_finserv

fin[330,] 

fin[!complete.cases(fin),]

#------------------Replacing missing data: Median Imputation Method (Part 2) --------------------

fin[!complete.cases(fin),]
med_growth_constr <- median(fin[fin$Industry=="Construction","Growth"], na.rm = T) 
fin[is.na(fin$Growth) & fin$Industry == "Construction", "Growth"] <- med_growth_constr
#check
fin[8,]

#------------------Replacing missing data: Median Imputation Method (Part 3) --------------------
fin[!complete.cases(fin),]

#Revenue 
med_revenue_constr <- median(fin[fin$Industry=="Construction", "Revenue"], na.rm =T)
med_revenue_constr

fin[is.na(fin$Revenue) & fin$Industry=="Construction","Revenue"] <- med_revenue_constr
fin[c(8,42),]

fin[!complete.cases(fin),]

#expenses
#we don't want to replace expenses for row 15 (thats by itself) because the row wont add up 
med_exp_constr <- median(fin[fin$Industry==c("Construction"), "Expenses"], na.rm =T)
med_exp_constr

fin[is.na(fin$Expenses) &fin$Industry == "Construction", "Expenses"] <- med_exp_constr
fin[c(8,15,42),]

#what if IT services was in the construction industry but we wouldn't want to pick that? 
#add another filter layer (that profit also has to be missing)
fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit)]
fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit), "Expenses"] <- med_exp_constr
fin[!complete.cases(fin),]
#what if we want to change both of them at the same time (in different categories)? 


#------------------Replacing missing data: Deriving values method --------------------

#Revenue - Expenses = Profit 
#Expenses = Revenue - Profit 

fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue"] - fin[is.na(fin$Profit), "Expenses"]
fin[c(8,42),]

fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]
fin[15,]

fin[!complete.cases(fin),]
#--------------------------Visualizing results ------------------------------
library(ggplot2)

#A scatterplot classified by industry, showing revenue, expenses, profit 

p <- ggplot(data=fin)
p + geom_point(aes(x=Revenue , y=Expenses, 
                   color=Industry, size = Profit))

#A scatterplot that includes industry trends for the expenses-revenue relationship 
 #preset aesthetics 
d <- ggplot(data=fin,aes(x=Revenue , y=Expenses, 
                          color=Industry)) 

d + geom_point() + 
  geom_smooth(fill=NA, size=1.2)

#Boxplot showing growth by Industry 

f <- ggplot(data=fin, aes(x=Industry, y=Growth, color=Industry))
f + geom_boxplot(size=1)

f + geom_jitter() +
    geom_boxplot(size=1, alpha=0.5, outlier.color =NA)












