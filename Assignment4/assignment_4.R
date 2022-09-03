# # ===================================================
# GBA464: Assignment 4
# Author: Yufeng Huang
# Description: write a function that plots crimes 
#              incidence in Baltimore city
# Data: Baltimore crime data
# Source: https://data.baltimorecity.gov/
# ===================================================
# DUE:  Sunday, August 21 at 11:59pm
# Send by email to r.programming.simon@gmail.com, one copy per team
#    please indicate the set of team members and your class section

 
# clear everything
rm(list = ls()) 

# libraries 
#   need to install.packages() these
#   let me know if installation does not work
library(maps)
library(maptools)

# download, unzip and read the shape file
url_zip <- 'https://dl.dropboxusercontent.com/s/chyvmlrkkk4jcgb/school_distr.zip'
if(!file.exists('school_distr.zip')) download.file(url_zip, 'school_distr.zip')     # download file as zip
unzip('school_distr.zip')   # unzip in the default folder
schdstr_shp <- readShapePoly('school.shp')  # read shape file
xlim <- schdstr_shp@bbox[1,]
ylim <- schdstr_shp@bbox[2,]

# example of how to use the shape file
#   if there are no error code reading the above, you can directly plot the map of Baltimore (lines within are school districts)
#   we'll be overlaying our plots of crime incidents on this map:
#plot(schdstr_shp, axes = T)     # axes = T gives x and y axes


# ======= now let's follow instructions in the pdf file ======

# download and load the crime csv data
#   link is https://dl.dropboxusercontent.com/s/4hg5ffdds9n2nx3/baltimore_crime.csv

url <- 'https://dl.dropboxusercontent.com/s/4hg5ffdds9n2nx3/baltimore_crime.csv'
if (!file.exists('baltimore_crime.csv')) {     # check whether data exists in local folder (prevents downloading every time)
    download.file(url, 'baltimore_crime.csv')
}
df<- read.csv('baltimore_crime.csv')  # load data

library(stringr)
# transform dates and time variables depending on what you need

ext_feature = function(df){
    temp = as.Date(df$CrimeDate, "%m/%d/%Y")
    year_df = format(temp, "%Y")
    month_df = format(temp, "%m")
    day_df = format(temp, "%d")
    modloc = gsub("\\(|\\)","",df[,"Location1"])
    modloc2 = modloc
    ti = df[,"CrimeTime"]
    time_df = sapply(ti, function(df) return(as.numeric(str_split(df,":")[[1]][2])/60 + as.numeric(str_split(df,":")[[1]][1]) + as.numeric(str_split(df,":")[[1]][3])/3600))
    latitude_df = sapply(str_split(modloc,","), function(df) return (as.numeric(df[[1]][1])))
    longitude_df = sapply(str_split(modloc2,","), function(df) return (as.numeric(df[2])))
    return(list(year = year_df, month = month_df, day = day_df, time = time_df, latitude = latitude_df, longitude = longitude_df))
}

res = ext_feature(df)
df$month = res$month
df$year = res$year
df$day = res$day
df$time = res$time

# split coordinates into longitude and latitude, both as numeric
# note: DO NOT USE for/while/repeat loop, and DO NOT USE the substr() function

df$latitude = res$latitude
df$longitude = res$longitude
df[1:6, c("Location", "District", "CrimeDate", "month", "day", "CrimeTime", "time", "latitude", "longitude")]

# generate geographic and time patterns for crimes with keyword "ASSAULT"
# note: DO NOT copy and paste of the same/similar command many times
library(ggplot2)
df_assault = df[grepl("ASSAULT",df$Description,ignore.case = T),]
xlim1 <- schdstr_shp@bbox[1,]
ylim1<- schdstr_shp@bbox[2,]

df_inside = df_assault[(df_assault$latitude > ylim["min"]) & (df_assault$latitude < ylim["max"]) & (df_assault$longitude > xlim["min"]) & (df_assault$longitude < xlim["max"]),]

pdf(file = "plotresult.pdf")
par(mfrow=c(2,2))
for(i in 1:4){
    starttime = 6*(i-1)
    endtime = 6*i
    tempdf = df_inside[(df_inside$time > starttime) & (df_inside$time < endtime),]
    
    plot(schdstr_shp, xlim = xlim1,ylim = ylim1, main=str_c("Hour ",starttime," ~ ", endtime), axes = T, cex.axis = 0.8)
    par(new = T)
    points(tempdf$longitude,tempdf$latitude, axes = T, col = alpha("red",0.3), pch = 20,cex = 0.01)

}
while (!is.null(dev.list()))
dev.off()