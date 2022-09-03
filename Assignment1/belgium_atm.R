# # ===================================================
# GBA464: Assignment 1
# Author: Yufeng Huang
# Description: location choice of Belgium ATMs
# Data: Belgium ATM distribution in 1994
# Source: will reveal later 
# ===================================================
# INSTRUCTIONS
# 1. this assignment is individual and you cannot look at others' code
# 2. this assignment is graded mostly on correctness of the results but please do 
#       try to maintain readability; please also follow the variable naming instructions
# 3. variable definitions are downloadable at 
#   https://dl.dropboxusercontent.com/s/i5mb8saii14fa6h/variable_definition.txt
# 4. please make sure your code runs from the start to the end and produces the intended results

# clear everything
rm(list = ls())

# load data
url <- 'https://dl.dropboxusercontent.com/s/q6qzbfa1tdcqv6v/belgium_atm.csv'
df <- read.csv(url, stringsAsFactors = F)

# we can check the structure of the data by running

head(df)

# ==== question 1 ====

# Q1. First, recall that df is a data frame which is like a spreadsheet in Excel. 
#   Let's convert every column into a separate variable using '$'; for example:
population <- df$population
numATMs <- df$numATMs

# do the same for the other columns

ATMwithdr <- df$ATMwithdr
withdrvalue <- df$withdrvalue
unemprate <- df$unemprate
numbranches <- df$numbranches

#print(numbranches)

# ------ you should not work with 'df' anywhere beyond this line -----
#   i.e. please only work with the vectors (or create new vectors)
#   for the rest of this assignment


# ==== question 2 ====

# Q2a. Do the necessary conversion for all variables so that you can apply numeric operations on them
#   replace the original value of the vector in case of conversion

population <- as.numeric(population)
numATMs <- as.numeric(numATMs)
ATMwithdr <- as.numeric(ATMwithdr)
withdrvalue <- as.numeric(withdrvalue)
unemprate <- as.numeric(unemprate)
numbranches <- as.numeric(numbranches)

# verify whether the conversion of the type is successful
#print(is.numeric(population))
#print(is.numeric(numATMs))
#print(is.numeric(ATMwithdr))
#print(is.numeric(withdrvalue))
#print(is.numeric(unemprate))
#print(is.numeric(numbranches))

# Q2b. population is in a very different scale. Re-scale it into thousands, i.e., divide population by 1000
#   and replace the variable


population = population/1000


# ==== question 3 ====

# You want to take average for all variables but you realized that some variables have missing value
#   before taking averages, you need to make sure that all observations are taken from the same sets of 
#   observations (i.e. rows) where no variable is missing 

# Q3a. let's define a logical vector for non-missing rows, i.e. indicate TRUE for rows without any missing values, 
#   and FALSE for rows with missing values. Name the vector 'nm'. Note that the length of nm will be the same as 
#   the number of rows in the original data df


nm = c(!is.na(population) & !is.na(numATMs) & !is.na(ATMwithdr) & !is.na(withdrvalue) & !is.na(unemprate) & !is.na(numbranches))

# verify if the length of nm is the same as df
#print(length(nm) == length(df[,1]))



# Q3b. count the number of non-missing rows in the data df, name it 'count_nm'
#   count_nm should be one number. Note that there is no such a function 'count'. 
#   Think about how to count the number of non-missing rows. 

count_nm = length(nm[nm == TRUE])
print(count_nm)


# ==== question 4 ====

# Q4. Calculate the averages of number of ATM, number of branches, population, 
#   unemployment rate, number of withdraw per resident and amount per withdrawl.
#   In particular, notice that certain variables have missing values and you might want to  
#   only calculate means for the rows without missing values of any variable
#   (that is, the rows that you use to calculate the average of all variables should be the same)
#   Finally, collect results in a vector called 'mean_nm', name elements in the vector by the original variable name

# nm itself also works, such as mean(population[nm])
# just to test if the index of using which function also works
valid_idx = which(nm %in% TRUE)

# calculate the mean of all of the valid value of these variables
mean_population = mean(population[valid_idx])
mean_numATMs = mean(numATMs[valid_idx])
mean_ATMwithdr = mean(ATMwithdr[valid_idx])
mean_withdrvalue = mean(withdrvalue[valid_idx])
mean_unemprate = mean(unemprate[valid_idx])
mean_numbranches = mean(numbranches[valid_idx])


# add the info to the mean_nm
mean_nm = c(population = mean_population, numATMs = mean_numATMs,
            ATMwithdr = mean_ATMwithdr, withdrvalue = mean_withdrvalue,
            unemprate = mean_unemprate, numbranches = mean_numbranches)
print(mean_nm)

# ==== question 5 ====

# Q5. You realize that the reason for missing values in the original data is that there are no ATMs.
#   So in that regard you could have defined the missing values to zero
#   Re-define the missings to zero and assign it to the original variable,
#   find the total number of observations in the dataset (call it 'count_all'), 
#   and re-calculate means for the same set of variables and collect results in 'mean_all'



# REQUIRES: vec is a vector
# EFFECTS: assign each NA value in the vector to 0 and calculate the average value
findrealmean<-function (vec){
    vec[is.na(vec)] = 0
    return(mean(vec))
}

# implement the function to all of the variables to find the mean value
real_mean_population = findrealmean(population)
real_mean_numATMs = findrealmean(numATMs)
real_mean_ATMwithdr = findrealmean(ATMwithdr)
real_mean_withdrvalue = findrealmean(withdrvalue)
real_mean_unemprate = findrealmean(unemprate)
real_mean_numbranches = findrealmean(numbranches)


# add the info to the mean_all
mean_all = c(population = real_mean_population, numATMs = real_mean_numATMs,
            ATMwithdr = real_mean_ATMwithdr, withdrvalue = real_mean_withdrvalue,
            unemprate = real_mean_unemprate, numbranches = real_mean_numbranches)
print(mean_all)




# ==== question 6 ====

# You decide to investigate what's the average number of withdrawal and amount per withdrawal
#   by areas with different number of ATMs

# Q6a. Let's summarize the average ATMwithdr and average withdrvalue by the number of atms (for range 1-4). 
# 	That is, for all observations with number of ATMs equal to 1, compute the average ATMwithdr and withdrvalue. 
#	Do the same for observations with number of ATMs equal to 2, 3, and 4. Collect results in two separate 
# 	vectors and name them 'mean_a' and 'mean_w'

findreal<-function (vec){
    vec[is.na(vec)] = 0
    return(vec)
}

real_ATMwithdr = findreal(ATMwithdr)
real_withdrvalue = findreal(withdrvalue)

v = seq(from = 1, to = 4)
mean_a = c()
mean_w = c()
num_name <- c("One", "Two", "Three", "Four")

for (i in v){
    mean_a = append(mean_a,mean(real_ATMwithdr[numATMs == i]))
    mean_w = append(mean_w,mean(real_withdrvalue[numATMs == i]))
}
names(mean_a) = num_name
names(mean_w) = num_name
print(mean_a)
print(mean_w)






# Q6b. Separately, plot mean_a and mean_w by the number of ATMs; label the x axis "number of ATMs" 
#	and y axis "average withdrawal per resident" and "average amount per withdrawal", respectively
#   use line plot by setting type = 'l' as one of the plot function arguments


#plot the corresponding figures and save as a pdf
pdf(file = "plotresult.pdf")
plotv = seq(from = 1, to = 4)

plot(plotv, mean_a, xlab = "number of ATMs", ylab = "average withdrawal per resident",main = 'Fig1', type = 'l')
plot(plotv, mean_w, xlab = "number of ATMs", ylab = "average amount per withdrawal",main = 'Fig2', type = 'l')

while (!is.null(dev.list()))
dev.off()

