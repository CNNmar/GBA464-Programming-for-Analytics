    # # ===================================================
    # GBA464: RFM analysis on CDNOW data
    # Author: Yufeng Huang
    # Description: Lab on functions and loops
    # Data: CDNOW customer data (this time full data)
    # Source: provided by Professor Bruce Hardie on
    #   http://www.brucehardie.com/datasets/CDNOW_sample.zip
    # ===================================================
    
    # ====== CLEAR EVERYTHING ======
    rm(list = ls())
    
    # ====== READ TRIAL DATA =======
    
    url <- 'https://dl.dropboxusercontent.com/s/xxfloksp0968mgu/CDNOW_sample.txt'
    if (!file.exists('CDNOW_sample.txt')) {     # check whether data exists in local folder (prevents downloading every time)
        download.file(url, 'CDNOW_sample.txt')
    }
    df.raw <- read.fwf('CDNOW_sample.txt', width = c(6, 5, 9, 3, 8), stringsAsFactors = F)  # load data
    
    # ====== Section 2: loading the data ======
    
    Sys.setlocale("LC_TIME", "English")
    df.raw[[1]] <- NULL # drop old id
    names(df.raw) <- c("id", "date", "qty", "expd")
    
    # a) generate year and month
     
    #first, I generate a formalized date to extract the year and month from them
    df.raw$f_date = as.Date(as.character(df.raw$date), "%Y%m%d")
    df.raw$year = format(df.raw$f_date, "%Y")
    df.raw$month = format(df.raw$f_date, "%m")
    
    
    # b) aggregate into monthly data with number of trips and total expenditure
    
    
    df_new_1 = aggregate(qty ~ id + year + month, df.raw, sum)
    df_new_2 = aggregate(expd ~ id + year + month, df.raw, sum)
    df_new_3 = aggregate(qty ~ id + year + month, df.raw, length)
    colnames(df_new_3)[4] = "trips"
    
    #merge the aggregate data and sort by id
    df_new = merge(df_new_1, df_new_2, by = c("id", "year", "month"), all = T)
    df_new = merge(df_new, df_new_3,by = c("id", "year", "month"), all = T)
    df_new = df_new[order(df_new$id),]
    
    
    # c) generate a table of year-months, merge, replace no trip to zero.
    # Hint: how do you deal with year-months with no trip? These periods are not in the original data,
    #   but you might need to have these periods when you calcualte RFM, right?
    # Consider expanding the time frame using expand.grid() but you do not have to.
    
    id_max = df_new[dim(df_new)[1],"id"]
    year_1 = c("1997")
    month_1 = c(1:12)
    year_2 = c("1998")
    month_2 = c(1:6)
    id_list = c(1:id_max)
    df_mon = merge(expand.grid(id = id_list, year = year_1, month = month_1),
                   expand.grid(id = id_list, year = year_2, month = month_2),
                   by = c("id", "year", "month"), all = T)
    
    df_new$month = as.numeric(df_new$month)
    df_mon$month = as.numeric(df_mon$month)
    df_mon = merge(df_mon, df_new, by = c("id", "year", "month"), all = T)
    df_mon[is.na(df_mon)] = 0
    df_mon = df_mon[order(df_mon$id,df_mon$year,df_mon$month),]
    
    
    
    # now we should have the dataset we need;
    #   double check to make sure that every consumer is in every period (18 months in total)
    
    
    # ====== Section 3.1: recency ======
    # use repetition statement, such as a "for-loop", to generate a recency measure for each consumer 
    #   in each period. Hint: if you get stuck here, take a look at Example 3 when we talked about "for-loops"
    #   call it df$recency
    
    
    findnum<- function(col){
        newvec= c(1:length(col))
        newvec[1] = NA
    
        for (i in 2:length(col)){
            if (i %% 18 == 1 | (is.na(newvec[i-1]) & col[i-1] == 0)){
                newvec[i] = NA
            }
            else if(col[i-1] != 0 & col[i] != 0){
                newvec[i] = 1
            }
            else{
                cnt = 1
                j = 1
                while(i-j-1){
                    if (col[i-j] != 0 & col[i-j+1] == 0){
                        break
                    }
                    cnt = cnt + 1
                    j = j+1
                }
                newvec[i] = cnt
            }
        }
        
        
        return(newvec)
    }
    
    
    df_mon$recency = findnum(df_mon$trips)
        
    
    
    
    
    
    
    
    # ====== Section 3.2: frequency ======
    # first define quarters and collapse/merge data sets
    #   quarters should be e.g. 1 for January-March, 1997, 2 for April-June, 1997, ...
    #   and there should be six quarters in the 1.5-year period
    #   Next, let's define frequency purchase occasions in PAST QUARTER
    #   Call this df$frequency
    
    df_mon$quarter = NA
    clist = c()
    for(i in 1:18){
        clist[i] = (i-1)%/%3 + 1
    }
    df_mon$quarter = rep(clist, length.out = dim(df_mon)[1])
    
    
    findfreq<- function(df){
        newvec= c(1:dim(df)[1])
        
        for (i in 1:length(newvec)){
            if (i %% 18 <= 3 & i %% 18 >= 1){
                newvec[i] = NA
            }
            else{
                temp_id = df[i, "id"]
                temp_quarter = df[i, "quarter"]
                newvec[i] = sum(df[df$id == temp_id & df$quarter == temp_quarter-1,]$trips)
            }
            
        }
        
        
        return(newvec)
    }
    
    df_mon$frequency = findfreq(df_mon)
    
    
    
    
    # ====== Section 3.3: monetary value ======
    # average monthly expenditure in the months with trips (i.e. when expenditure is nonzero)
    #   for each individual in each month, find the average expenditure from the start of the sample to 
    #   the PAST MONTH. Call this df$monvalue
    
    
    findtimes<- function(col){
        vec_time = c()
        for(i in 2:length(col)){
            start = 18*((i-1)%/%18)+1
            cnt = 0
            while(start < i){
                if (col[start]> 0){
                    cnt = cnt+1
                }
                start = start+1
            }
            vec_time[i] = cnt
        }
        return(vec_time)
    }
    
    df_mon$times = findtimes(df_mon$expd)
    
    
    findmonexpd<- function(df){
        newvec= c(1:dim(df)[1])
        for (i in 1:length(newvec)){
            start = 18*((i-1)%/%18)+1
            if (i %% 18 ==1){
                newvec[i] = NA
            }
            else{
                if(df$times[i] == 0){
                    newvec[i] = NA
                }
                else{
                    newvec[i] = sum(df[start:(i-1),]$expd)/df$times[i]
                }
            }
            
        }
        
        return(newvec)
    }
    
    df_mon$monvalue = findmonexpd(df_mon)
    
    df = df_mon
    df$times = NULL
    
    # ====== Section 4: Targeting using RFM ======
    # now combine these and construct an RFM index
    #   You only need to run this section.
    
    b1 <- -0.05
    b2 <- 3.5
    b3 <- 0.05
    
    df$index <- b1*df$recency + b2*df$frequency + b3*df$monvalue
    
    
    
    # ====== using the RFM index (Optional, not graded) =======
    # validation: check whether the RFM index predict customer purchase patterns
    # Order your sample (still defined by keys of consumer-year-month) based on the RFM index. 
    #   Split your sample into 10 groups. The first group is top 10% in terms of
    #   the RFM index; second group is 10%-20%, etc.
    # Make a bar plot on the expected per-month expenditure that these consumers generate and comment on 
    #   whether the RFM index help you segment which set of customers are "more valuable"
    
    # First, I sort my df
    sorted_df = df[order(df$index),]
    # Then, divide them into 10 parts equally and classify them
    groups = quantile(sorted_df$index, probs = seq(0, 1, 0.1), na.rm = T)
    
    for(i in 1:10){
        sorted_df$group[sorted_df$index > groups[i] & sorted_df$index < groups[i+1]] = i
    }
    
    # Derive the average value
    avg_df = aggregate(sorted_df$expd, list(sorted_df$group), mean)
    par(mar=c(8, 4.1, 4.1, 2.1))
    barplot(avg_df$x~ avg_df$Group.1,
            xlab="Delines in the RFM index", ylab = "Average expenditure")
    
