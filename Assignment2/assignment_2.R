# # ===================================================
# GBA464: Assignment 2 
# Author: Yufeng Huang
# Description: working with data frame
# Data: European car characteristics, prices and sales, 1970-1999
# Source: 
#   cars: https://sites.google.com/site/frankverbo/data-and-software/data-set-on-the-european-car-market
#   crude oil price: OPEC; IEA; extracted from 
#   http://www.statista.com/statistics/262858/change-in-opec-crude-oil-prices-since-1960/
# Optionally, you can also try plotting against UK gasoline price from www.theaa.com 
#   link: https://dl.dropboxusercontent.com/u/13844770/rdata/assignment_2/ukgas.csv
#   (https://www.theaa.com/public_affairs/reports/Petrol_Prices_1896_todate_gallons.pdf)
# Acknowledgement: Frank Verboven has contributed significant effort
#   making the car sales dataset publically available
# ===================================================

# ===== Step 0: load data and required packages =====

# download file to local folder if file does not exist
url <- 'https://dl.dropboxusercontent.com/s/nchoevokxmodlqu/cars.csv' 
if (!file.exists('cars.csv')) {     # check whether data exists in local folder (prevents downloading every time)
    download.file(url, 'cars.csv', mode = 'wb')
}
df <- read.csv('cars.csv')  # load data

url <- 'https://dl.dropboxusercontent.com/s/t9z1oe5e4d7uqya/oil.csv' 
if (!file.exists('oil.csv')) {
    download.file(url, 'oil.csv', mode = 'wb')
}
oil <- read.csv('oil.csv')  # load data

# ===== Question 0: what are the keys of the data frames? =====
# Before we start, let's think about what are the keys in the data frame
#   You don't have to do anything now; just think about it


# ===== Question 1: cleanup data =====
# 1) Take a subset of df, focusing on observations where class ($cla) is "standard" or 
#   "intermediate" or "luxury", use this sub-data-frame to replace the original df (now df is different)
# 2) Generate a column in df, $mpg, that measures fuel efficiency in mile per gallon
#   note that 1 mile per gallon = 235.215 / (1 liter per 100km). In other words, mpg is not 
#   proportional to liter per 100km, but is proportional to 1/(liter per 100). To check your answers, 
#   keep in mind that we usually see mpgs between 10 and 40. 
#   Also note: in the variable description, $li should be liter per 100km rather than liter per km.
# 3) Find a way to replace year in dataframe oil ($ye) into up to 2 digit (e.g. 1990 becomes 90, and 2001 becomes 1)

#############################

####1)
class_vec = df$cla
df = df[class_vec == "standard" |class_vec == "intermediate"|class_vec == "luxury",]

####2)

df["mpg"] = 235.215/df["li"]

####3)
oil$ye = oil$ye %% 100



# ===== Question 2: summarize fuel efficiency by year and manufacturer =====
# Take average of fuel efficiency $mpg for given the firm ($frm) and year ($ye)
#   You could use the function aggregate()
# Then, plot the average $mpg for firm ($frm) Volkswagen ("VW") across all years.
#   Set your axis label to "year" and "mile per gallon" and put up a title
#   "Volkswagen fuel efficiency"

### aggregate the mean first
average_mpg = aggregate(df[["mpg"]], list(frm = df[["frm"]], ye = df[["ye"]]), mean)
mpg_VW = average_mpg[average_mpg["frm"] == "VW",2:3]

## rename the new column as "mpg"
colnames(mpg_VW)[length(colnames(mpg_VW))] = "mpg"
plot(mpg_VW$ye, mpg_VW$mpg,xlab = "year", ylab = "mile per gallon", col = "#FF82AB",main = "Volkswagen fuel efficiency",type = 'l')








# ===== Question 3: merge with gasoline price data =====
# 1) Merge the average fuel efficiency data with crude oil price data, 
# 2) Create the same plot as above (also for VW) but add a plot of crude oil price over time
#   when doing so:  a) set xlab and ylab to "" in order to not generate any label,
#                   b) generate an axis on the right by using axis(side = 4, ...)
# 3) 1985 was the start of the new US regulation on fuel efficiency (which was announced in 1975).
#   Add a vertical line in the year 1985 to indicate this (search help lty or col for line type or 
#   color; adjust them so that the graph does not look that busy)


#############################

####1)
mer_oil_data = merge(average_mpg,oil, by = "ye")

####2)
data_plot = mer_oil_data[mer_oil_data["frm"] == "VW",]
par(new=TRUE)
plot(data_plot$ye, data_plot$oilpr,xlab = "", ylab = "",col = "#40E0D0",type = 'l',axes=FALSE)
axis(side = 4)
par(new = FALSE)

####3)
abline(v = 85, lty = 3)




# ===== Question 4: find new cars models =====
# Start with the subsetted data focusing on Volkswagen and on "standard" or "intermediate"
#   or "luxury" cars.
# 1) Find the first year where a specific car model (indicated by variable $type) 
#   has positive sales in a given market ($ma); i.e. that's the year when the model started to sell at all
#   Think of this as the year of introduction; consider using aggregate()
# Note: You might want to construct a data frame for this, and then merge it to the subset of df that  
#   focuses on Volkswagen, and assign the merge result to df_augment
# 2) Generate a sub-data frame where each car model just started selling for the first/second year;
#   that is, year <= year of introduction + 1; assign the data frame df_new
# 3) Generate average $mpg by year, for all the cars (in our subset) that started selling for the first/second year; 
#   use aggregate()
# 4) [Optional] Generate the same plot as in Question 3, but now focusing on the "new cars" that we defined above. 


#############################

####1)

df = df[df$frm == "VW",]
df_4 = df[df$qu > 0,]
first_year = aggregate(df_4$ye, list(df_4$type, df_4$ma), min)
name_f = c("type","ma","ye")
colnames(first_year) = name_f

df_augment = merge(df,first_year, by = name_f)


####2)

df_n_year = merge(df,first_year, by = name_f[1:2])
df_new = subset(df_n_year, ye.x <= ye.y+1 )
colnames(df_new)[colnames(df_new) == "ye.x" | colnames(df_new) =="ye.y"] = c("fir_y_sec_y","fir_y")


####3)
ave_2_mpg = aggregate(df_new$mpg, list(df_new$fir_y_sec_y), mean)


####4)

par(new = T)
plot(x = ave_2_mpg$Group.1, y = ave_2_mpg$x, type = 'l', xlab = "", ylab = "", col = "coral1",axes=FALSE)
par(new = F)
legend(70, 32, legend = c("Average mpg of cars", "Crude oil price","Average mpg of new cars"),
       col = c("#FF82AB", "#40E0D0","coral1"),
       pch = 22,title = "Line types", text.font = 6, bg = 'gray', cex = 0.44)



