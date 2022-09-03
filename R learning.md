R learning



### Vector

Vector can only contain objects of the same type

No dimension

```R
vec = c(ele, ele2, ele3) #initialize a vector
vec2 = c(a = ele, b = ele2) #intialize a vector with name
vec = a:b / seq(from, to, length.out = num)/ seq(from, to, by = interval) #intialize a vector from a to b
vec = rep(a:b, times = num/c(c,d)/each = num) #repeat num's times
vec[-idx] #return the vector except the idx
sort(vec, decreasing = T) # return the right, default ascending
order(vec) # return the order of the vec
vec[order(vec)] = sort(vec)
unique(vec) # return the unique elements in the vec
duplicated(vec) # return the logical vector of whether the element needs duplicate
vec[-which(duplicated(vec))] = unique(vec)
xor(T,F) = T
xor(T,T) = F

match(element, vec_name) # find the element in the vec_name
which(vec_name %in% element) # find all the matching elsements in the vec   
which.max, which.min
names(vec_name) # name of the vector
append(vec_name1, vec_name2) # add the element to the vec
- append(vec_name, element, after = idx) # append the element into the vector and the position is idx
```



### Array

```R
arr = array(x, dim = c(a,b,c)) #return the a*b*c array, if x is larger, it will be the subset of x, else it will repeat.
arr = array(1:18, c(3,3,2)) #return the 3*3*2 array, where the first layer is 1,4,7,2,5,8,3,6,9, x is prioritized.
arr + c(a,b,c) #suppose arr is 3*3 the first row +a, second +b, third +c
arr = array(1:36, c(2,3,6))
att[2,2,5] = (5-1)*2*3 + (2-1)*2 + 2 = 28
```



### Matrix

Matrices must have every element be the same class

```R
matrix(num, nrow = num1, ncol = num2)# init the matrix
t(mat) #trans of mat
mat %*% mat #matrix multiply
cbind(x,y), rbind(x,y) #another way to init the matrix
#cbind is bind as the columns, rbind is bind as the rows
colnames(mat_name) # name of the mat
```

### List

List can contain elements of different classes.

```R
list(1,"a",TRUE) #init the list
unlist(listname) #transfer list to vec
log(listname) # Not work! No numeric argument to math func
vector("list", length = num) #init an empty list
list_name[[num]][b]/ list_name[['name']][b]/list_name$name[b]#fetch the element of the list
```

### Factor

```R
fac_name = factor(vec_name)  #init a factor
typeof(fac_name) #return integer since the factors are stored as int
levels(fac_name) #return the levels(character) and in order of alphabet
vec_name == "v" #return every num in vec with v, equal even if they are stored as int
table(fac_name) # table info for the factor
```



### Dataframe

Data frames can store different classes of objects in each column

```R
data.matrix() or as.matrix()# dataframe to matrix
read.csv() # read data to init df
data.frame(s = c(a,b,c), b = c(c,d,e))#initialize the dataframe
colnames(df_name) # name of the df
table(df_name) #output as the form of value
View(df_name) # Present as a view form
dim(df_name) # return value a,b of a*b matrix
nrow(df_name) #return the row number
names(df_name) # return the name of columns
dimnames(df_name) # return the row and column names of df
df[,num,drop = F] # return as a column of df
df[,num] # return as a list
subset(df, condition, select = c(col_names))
a[["n"]] = a[,"n"] != a["n"]# first two returns a vec, last one is original format

cbind(x,y), rbind(x,y) #cbind is bind as the columns, rbind is bind as the rows
df[c(a,b)] <=> df[,c(a,b)] #returh the a, b column
```



### Datatable

```R
## One of the most difference between dt and df is the df[c(a,b)] returns the col and 
## dt[, xxx] represents the col
dt[c(a,b)] returns the row
dt[, c(a,b)] # return the cols
dt[c(a,b)] # Do not return the cols but the rows
dt[a:b,] # return row a to b
dt[a:b, name] # return a vector
dt[a:b, "name"]# return as a df(keep colname)
dt[condition, fun] <=> fun(dt[cond]$name)
dt[, newcolname := fun]
dt[, `:=`(name1 = x1, name2 = x2,...namen)]
dt[a:b, .(col you want and fun)]
	e.g. dt_atm[condition,.(a = fun1, b = fun2), by = xx]
```



### Missing Value

```R
is.na()  ## test NA
## NA has a class. like integer, character
is.nan() ## test NAN
## is.na can detect NAN, else not true
```





### Reshape

```R
merge(a,b, by = c(c,d), all = T/F) #if all is T, then keep NA, default all = F
merge(a,b, by.x = c, by.y = d)
aggregate(x = data$a, by = list(data$b,data$c), fun)
# can also be written as x = list(name1 = data1), by = list(name2 = data2, name3 = data3)
aggregate(e~d, data, fun)
library("reshape")
melt(df, id = c("a","b"), na.rm = T) #recover the aggregate dataset to a long one
cast(df, a+b~c,fun.aggregate = fun, value = "d") #value= cannot be omitted, according to the d column and corresponding func to give value
# In cast, formula a~b, can be equal to value = "b"
# In this case, a,b are keys and c is the col name, if func aggregate is used, the col name is func(c). And if a+b~., then it means the others are aggregated into one scalar
# If the form is written as a~.|variable. It means do the cast for each ele in variable, shows in each $
# If the form is written as a~variable, each different ele in variable col will be a new col and run as fun(ele) for each a

```



### String

```R
paste(a,b,sep = "xxx")
paste(a,c:d,sep = "xxx")
nchar(c(char1, char2)) # return the length of char1 and char2
tolower/toupper/capitalize(c(char1, char2))
cat(str_name) #beautify the string

substr(c(str1,str2), start = a, stop = b) # return the substring from a to b(inc a and b)
substring(str, first = a:b, last = c:d)# return every related pairs from a to c to b to d
strsplit(str,cond)# split by condition
unlist(res) ## unlist the result of the strsplit will be a vector
tail(str, n = a) # return the last ath element
######## keyword here can be substituted by regex
grep(keyword, str) # return the position of keyword in str

grep(keyword, char) # 1
grep(keyword, vec) # num and we need the following trans
grep(keyword, vec, value = T) # return the words found
vec <- unlist(strsplit(char, " "))
grepl(keyword, vec) # return logical vec
regexpr(keyword, char) #return the info of first appeared
gregexpr(keyword, char) #return the info of every appeared
sub(keyword, newword, char) # replace the FIRST match
gsub(keyword, newword, char) # replace ALL match
```



### Date

```R
as.Date(date, format = "format you need") # according to your date, return a formalized one
class(Date)#"Date"
Datea - Dateb # return a difference
difftime(a,b, unit = "days"/"weeks")#return the day/week difference
format(date,"form you need")#output the form you need
as.POSIXct(time1, tz = "US/Pacific")#return the timezone info but the time need to formalize first.

```

```R
library(tidyverse)
library(htmlwidgets) #str_view

##
##In regex ^ means not，| means or，
##rep: ?:0/1(lazy,prefer least one), +:1/1+,*:0/0+
##rep: a{n}:aaaa(n times), {n,}:n/n+, {,m} m/m-, {n,m}:between n and m
str_length((c(a, b, c))) #return the length of each element in the vector
str_c(a,b) = paste(a,b,sep = "")# combine a and b 
#in str_c, the length-0 element will be automatically dropped
str_c("prefix-",c(a,b,c),"-suffix") # "prefix-a-suffix","prefix-b-suffix","prefix-c-suffix"
#if NA is used in vector, we need to use str_replace_na(X) to consider it as string
str_sub(vec,first,end) = substring(vec,first, end)
str_to_lower() # make the letter lower

str_view("a.v","\\.")# we need two \ to translate the .
str_view("a\v","\\\\")# we need four \ to translate \
str_view("apple","^a")# we can use ^ to represent the word start with a
str_view("eppla","a$")# we can use $ to represent the word end with a
# if we add ignore_case = T, we can match no matter lower or upper


str_detect(vec,value)#return the logical vector of the matching.
words[str_detect(vec,value)] = grep(keyword, vec, value = T) = str_subset(words, key) # return the words found
str_count(words,key) # return the times key occurs in the words
str_extract(words,key) # return the keys in the words
str_replace(words,key,replace) # replace the first key with replace
str_replace_all(words,key,replace) # replace all the keys with replace.
str_replace_all(words,c(a=repa,b=repb,c=repc)) # replace by the instruct of vector
str_split(words,key, num, simplify = T) # num means split for num times according to key

```



### IF

```R
ifelse(a == 1, a<-3, a<-5) #T
ifelse(a == 1 ,a=3, a=5) #F
a = ifelse(a == 1, 3, 5) # T
switch(x, a = "ad",b = "bd",c = "cd", stop("d")) #if x = "a" return ad
if(cond) next #jump to the next loop
if(cond) break #jump out of the loop
```



### APPLY & FUNC

```R
optimization_result <- optim(
  par = 100, # initial trial value, the value initially used
  fn = function(qty) {
  - profit(qty, df$demand_intercept[1], df$cost[1])
  } # function with ONE ARGUMENT to MINIMIZE
)
missing(arguement) # return whether an argument is there
lapply(data, func) # return a list of the result
sapply(data, func) # return the simplify form of result
apply(data, 1/2/c(1,2), fun) #if it's 1, it implements to the rows, if 2, it implements to each of the cols, when c(1,2), it implements to each of the xy plane
tapply(X = data, INDEX = list(a = df$a), FUN =func) # return the aggregate value of the function when it's implemented to the data for different types of a


sample(x = 1:5, size = 10, replace = T) # can be the same
sample(x = 1:15, size = 10, replace = F) # can not be the same, so the first must larger then the size
```

