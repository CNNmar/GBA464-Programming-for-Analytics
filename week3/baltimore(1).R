# # ===================================================
# GBA464: Baltimore public sector employee data
# Author: Yufeng Huang
# Description: exercise on data frame and functions
# Data: Baltimore city public sector employee data
# Source: provided by Open Data Baltimore
#   https://data.baltimorecity.gov/
# ===================================================

# ====== CLEAR EVERYTHING ======
rm(list = ls()) 

# ====== Step 0: read data ======
# [optional]: rewrite this section into a for-loop

# define url
url11 <- "https://dl.dropboxusercontent.com/s/15mnq99dhvzcen1/Baltimore_2011.csv"
url12 <- "https://dl.dropboxusercontent.com/s/wisapj2zfm1s333/Baltimore_2012.csv"
url13 <- "https://dl.dropboxusercontent.com/s/hs1764w79pkg389/Baltimore_2013.csv"
url14 <- "https://dl.dropboxusercontent.com/s/v9o7wp8tpvt5cb7/Baltimore_2014.csv"
url15 <- "https://dl.dropboxusercontent.com/s/c740f6beatfv0t9/Baltimore_2015.csv"
url16 <- "https://dl.dropboxusercontent.com/s/qew6cbpfybaeqgn/Baltimore_2016.csv"
url17 <- "https://dl.dropboxusercontent.com/s/wfrnri774dby6e9/Baltimore_2017.csv"
url18 <- "https://dl.dropboxusercontent.com/s/7uzi32hnal4aewj/Baltimore_2018.csv"
url19 <- "https://dl.dropboxusercontent.com/s/xx24l9ng0h4yf9o/Baltimore_2019.csv"
url20 <- "https://dl.dropboxusercontent.com/s/iba9gm3uz6y5us5/Baltimore_2020.csv"
url21 <- "https://dl.dropboxusercontent.com/s/otdqepo2naj515v/Baltimore_2021.csv"
# 	note: paste() is for you to see the end of the file...

# download data if not exist
if (!file.exists('Baltimore_2011.csv')) download.file(url11, 'Baltimore_2011.csv') 
if (!file.exists('Baltimore_2012.csv')) download.file(url12, 'Baltimore_2012.csv') 
if (!file.exists('Baltimore_2013.csv')) download.file(url13, 'Baltimore_2013.csv') 
if (!file.exists('Baltimore_2014.csv')) download.file(url14, 'Baltimore_2014.csv') 
if (!file.exists('Baltimore_2015.csv')) download.file(url15, 'Baltimore_2015.csv') 
if (!file.exists('Baltimore_2016.csv')) download.file(url16, 'Baltimore_2016.csv') 
if (!file.exists('Baltimore_2017.csv')) download.file(url17, 'Baltimore_2017.csv') 
if (!file.exists('Baltimore_2018.csv')) download.file(url18, 'Baltimore_2018.csv') 
if (!file.exists('Baltimore_2019.csv')) download.file(url19, 'Baltimore_2019.csv') 
if (!file.exists('Baltimore_2020.csv')) download.file(url20, 'Baltimore_2020.csv') 
if (!file.exists('Baltimore_2021.csv')) download.file(url21, 'Baltimore_2021.csv') 

# read data
df.1 <- read.csv('Baltimore_2011.csv', stringsAsFactors = F) 
df.2 <- read.csv('Baltimore_2012.csv', stringsAsFactors = F) 
df.3 <- read.csv('Baltimore_2013.csv', stringsAsFactors = F) 
df.4 <- read.csv('Baltimore_2014.csv', stringsAsFactors = F) 
df.5 <- read.csv('Baltimore_2015.csv', stringsAsFactors = F)
df.6 <- read.csv('Baltimore_2016.csv', stringsAsFactors = F)
df.7 <- read.csv('Baltimore_2017.csv', stringsAsFactors = F)
df.8 <- read.csv('Baltimore_2018.csv', stringsAsFactors = F)
df.9 <- read.csv('Baltimore_2019.csv', stringsAsFactors = F)
df.10 <- read.csv('Baltimore_2020.csv', stringsAsFactors = F)
df.11 <- read.csv('Baltimore_2021.csv', stringsAsFactors = F)

# change var names into lower case 
names(df.1) <- tolower(names(df.1)) 
names(df.2) <- tolower(names(df.2)) 
names(df.3) <- tolower(names(df.3))
names(df.4) <- tolower(names(df.4)) 
names(df.5) <- tolower(names(df.5))
names(df.6) <- tolower(names(df.6))
names(df.7) <- tolower(names(df.7))
names(df.8) <- tolower(names(df.8))
names(df.9) <- tolower(names(df.9))
names(df.10) <- tolower(names(df.10))
names(df.11) <- tolower(names(df.11))

# add year 
df.1$year <- 2011 
df.2$year <- 2012 
df.3$year <- 2013 
df.4$year <- 2014 
df.5$year <- 2015
df.6$year <- 2016
df.7$year <- 2017
df.8$year <- 2018
df.9$year <- 2019
df.10$year <- 2020
df.11$year <- 2021

# rbind data (why not merge?)
df <- rbind(df.1, df.2)
df <- rbind(df, df.3)
df <- rbind(df, df.4)
df <- rbind(df, df.5)
df <- rbind(df, df.6)
df <- rbind(df, df.7)
df <- rbind(df, df.8)
df <- rbind(df, df.9)
df <- rbind(df, df.10)
df <- rbind(df, df.11)

# ====== Step 1: Write the above into a loop =======
#	note that we're spending a lot of lines to read five dataframes (and what we're doing is subject to mistakes)
#	try writing the above into a loop to (1) look cleaner and easy to debug, and (2) be ready to accommodate more data down the line
# 	you can start a new script for this (and copy the rest of the questions there)

url11 <- "https://dl.dropboxusercontent.com/s/15mnq99dhvzcen1/Baltimore_2011.csv"
url12 <- "https://dl.dropboxusercontent.com/s/wisapj2zfm1s333/Baltimore_2012.csv"
url13 <- "https://dl.dropboxusercontent.com/s/hs1764w79pkg389/Baltimore_2013.csv"
url14 <- "https://dl.dropboxusercontent.com/s/v9o7wp8tpvt5cb7/Baltimore_2014.csv"
url15 <- "https://dl.dropboxusercontent.com/s/c740f6beatfv0t9/Baltimore_2015.csv"
url16 <- "https://dl.dropboxusercontent.com/s/qew6cbpfybaeqgn/Baltimore_2016.csv"
url17 <- "https://dl.dropboxusercontent.com/s/wfrnri774dby6e9/Baltimore_2017.csv"
url18 <- "https://dl.dropboxusercontent.com/s/7uzi32hnal4aewj/Baltimore_2018.csv"
url19 <- "https://dl.dropboxusercontent.com/s/xx24l9ng0h4yf9o/Baltimore_2019.csv"
url20 <- "https://dl.dropboxusercontent.com/s/iba9gm3uz6y5us5/Baltimore_2020.csv"
url21 <- "https://dl.dropboxusercontent.com/s/otdqepo2naj515v/Baltimore_2021.csv"

df_1 = data.frame()
for(i in 2011:2021){
    filename = paste('Baltimore', i,sep = "_")
    csvname = paste(filename, ".csv", sep = "")
    urlneed = get(paste("url",i%%2000, sep = ""))
    if (!file.exists(csvname)) download.file(urlneed, csvname)
    df <- read.csv(csvname, stringsAsFactors = F) 
    names(df) <- tolower(names(df)) 
    df$year <- i
    if (i == 2011){
        df_1 = df
    }
    else{
        df_1 = rbind(df_1, df)
    }
}
df_1


# ====== Step 2: Construct variables =======

# convert salary and gross pay to numeric
#   note: as.numeric does not direct work; need some character data manipulations

df_1$grosspay= as.numeric(df_1$grosspay)

# employment duration




# hire year

df$hire_year = format(as.Date(df$hiredate[1]),"%Y")


# average salary growth rate
#   NOTE: diff() function does it (but needs some modifications); 
#   You can also construct your own function to make it work 






# ====== Step 3: Further clean up names and extract gender and origin ======

# split names into first and last name, discard middle initial; 
#   note: you need to use an *apply function (i.e. lapply, sapply, or apply); the loop version is slow

# work on the first three rows first (the rest we'll do after Week 5)





# Loop version code here (do this after Week 5):





# Apply version code here (do this after Week 6):






# ====== Step 3 con'd: at salary by origin and gender =======
# install packages 'gender', categorize names into male and female
#   HINT: there are different methods; you can use ssa to work with US names and 
#           napp to work with other names; that will give you indication of who's more likely caucasian
#   note: 'gender' need to install some database for name processing; might not work on your computer if your folder contains spaces









# Conclusion: look at wage given likely gender and likely race (caucasian or not)







