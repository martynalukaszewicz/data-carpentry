################
## Instructor Training: (https://carpentries.github.io/instructor-training/),
##                      Preparing for Training and Certification (https://carpentries.github.io/instructor-training/setup.html),
##                      Starting with Data in R (https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html)
##
## @authors 
## @contact 
##
##
################
## @description 
##
## @param 
##
## @lastChange 2022-04-04
##
## @changes
##   
################
getwd()  ## working directory


## Loading the survey data
## We are investigating the animal species diversity and weights found within plots at our study site.


## Downloading the data, download it to 'data_raw' folder. Modifications to file will be made in 'data' folder.
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")



## Reading the data into R
## The file has now been downloaded to the destination you specified, but R has not yet loaded the data from the file into memory. 
## To do this, we can use the read_csv() function from the tidyverse package.
## load the tidyverse packages, incl. dplyr
## install.packages("tidyverse") ## if library(tidyverse) package not there 
library(tidyverse)

## Read CSV file from 'data_raw' folder
surveys <- read_csv("data_raw/portal_data_joined.csv")
head(surveys)  ## first 6 rows of data


## To open the dataset in RStudio’s Data Viewer, use the view() function:
view(surveys)


## What are data frames?
## We can see this also when inspecting the structure of a data frame with the function str():
str(surveys)

######## Challenge    ######################
##Based on the output of str(surveys), can you answer the following questions?
  
##  What is the class of the object surveys?
### ANSWER:
class(surveys)  ## * class: data frame

##  How many rows and how many columns are in this object?
### ANSWER:
dim(surveys)  ## * how many rows: 34786,  how many columns: 13
nrow(surveys)  ## * how many rows: 34786
ncol(surveys)  ## * how many columns: 13


## Indexing and subsetting data frames
# We can extract specific values by specifying row and column indices
# in the format: 
# data_frame[row_index, column_index]
# For instance, to extract the first row and column from surveys:
surveys[1, 1]

# First row, sixth column:
surveys[1, 6]   

# We can also use shortcuts to select a number of rows or columns at once
# To select all columns, leave the column index blank
# For instance, to select all columns for the first row:
surveys[1, ]

# The same shortcut works for rows --
# To select the first column across all rows:
surveys[, 1]

# An even shorter way to select first column across all rows:
surveys[1] # No comma! 

# To select multiple rows or columns, use vectors!
# To select the first three rows of the 5th and 6th column
surveys[c(1, 2, 3), c(5, 6)] 

# We can use the : operator to create those vectors for us:
surveys[1:3, 5:6] 

# This is equivalent to head_surveys <- head(surveys)
head_surveys <- surveys[1:6, ]
head_surveys
# As we've seen, when working with tibbles 
# subsetting with single square brackets ("[]") always returns a data frame.
# If you want a vector, use double square brackets ("[[]]")

# For instance, to get the first column as a vector:
surveys[[1]]

# To get the first value in our data frame:
surveys[[1, 1]]

surveys[, -1]                 # The whole data frame, except the first column
surveys[-(7:nrow(surveys)), ] # Equivalent to head(surveys)


# As before, using single brackets returns a data frame:
surveys["species_id"]
surveys[, "species_id"]

# Double brackets returns a vector:
surveys[["species_id"]]

# We can also use the $ operator with column names instead of double brackets
# This returns a vector:
surveys$species_id

##   Challenge ####################
## 1 . Create a data.frame (surveys_200) containing only the data in row 200 of the surveys dataset.
surveys_200 <- surveys[200, ]
## 2. Notice how nrow() gave you the number of rows in a data.frame?
## Create a new data frame (surveys_last) from that last row.
## 2.
# Saving `n_rows` to improve readability and reduce duplication
surveys_last <- surveys[nrow(surveys), ]
surveys_last
tail(surveys,n=1)  ## compare with tail()
## 3. Use nrow() to extract the row that is in the middle of the data frame. 
## Store the content of this row in an object named surveys_middle.
surveys_middle <- surveys[round(nrow(surveys)/ 2), ]  ## round() if nrow() was an odd number, even here
## 4. Combine nrow() with the - notation above to reproduce the behavior of head(surveys), 
## keeping just the first through 6th rows of the surveys dataset.
surveys_head <- surveys[-(7:nrow(surveys)), ]
surveys_head

## Factors
?factor
### The function factor is used to encode a vector as a factor
## (the terms ‘category’ and ‘enumerated type’ are also used for factors).
surveys$sex <- factor(surveys$sex)
surveys$sex  ## default levels: F M
summary(surveys$sex)
## By default, R always sorts levels in alphabetical order. For instance, if you have a factor with 2 levels:
  
sex <- factor(c("male", "female", "female", "male"))
levels(sex)
nlevels(sex)  ## number of levels
sex # current order

sex <- factor(sex, levels = c("male", "female"))
sex # after re-ordering

###### Challenge ########################
## 1. Change the columns taxa and genus in the surveys data frame into a factor.
surveys$taxa <- factor(surveys$taxa)
surveys$genus <- factor(surveys$genus)
## 2. Using the functions you learned before, can you find out…
## How many rabbits were observed?
summary(surveys)
summary(surveys$taxa) ## 75 rabbits in the 'taxa' column
nlevels(surveys$genus)  ## 26 unique genera in the 'genus' column

####### Converting factors
## If you need to convert a factor to a character vector, 
## you use as.character()
as.character(sex)

## Another method is to use the levels() function. Compare:
year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)               # Wrong! And there is no warning...
as.numeric(as.character(year_fct)) # Works...
as.numeric(levels(year_fct))[year_fct]    # The recommended way.

## Renaming factors
## bar plot of the number of females and males captured during the experiment:
plot(surveys$sex)
## However, as we saw when we used summary(surveys$sex), 
## there are about 1700 individuals for which the sex information hasn’t been recorded. 
## To show them in the plot, we can turn the missing values into a factor level with the addNA() function.
sex <- surveys$sex
levels(sex)
sex <- addNA(sex)
levels(sex)
head(sex)
levels(sex)[3] <- "undetermined"
levels(sex)
head(sex)
## Now we can plot the data again, using 
plot(sex)
## Challenge
## Rename “F” and “M” to “female” and “male” respectively.
levels(sex)
levels(sex)[1:2] <- c("female", "male")
levels(sex)
## Now that we have renamed the factor level to “undetermined”, 
## can you recreate the barplot such that “undetermined” is first (before “female”)?
sex <- factor(sex, levels = c("undetermined", "female", "male"))
sex
plot(sex)

#### Challenge ###########
### 1. We have seen how data frames are created when using read_csv(), 
## but they can also be created by hand with the data.frame() function. 
## There are a few mistakes in this hand-crafted data.frame.
## Can you spot and fix them? Don’t hesitate to experiment!
animal_data <- data.frame(
  animal = c(dog, cat, sea cucumber, sea urchin),
  feel = c("furry", "squishy", "spiny"),
  weight = c(45, 8 1.1, 0.8))

################## missing quotations around animal names
###############  missing one entry in 'feel'
############ missing comma in 'weight'
animal_data <- data.frame(
  animal = c("dog", "cat", "sea cucumber", "sea urchin"),
  feel = c("furry", "fluffy", "squishy", "spiny"),
  weight = c(45, 8, 1.1, 0.8))

animal_data  ## now correct 

###### 2. Can you predict the class for each of the columns in the following example? 
## Check your guesses using str(country_climate):
## Are they what you expected? Why? Why not?
## What would you need to change to ensure that each column had the accurate data type?
country_climate <- data.frame(
  country = c("Canada", "Panama", "South Africa", "Australia"),
  climate = c("cold", "hot", "temperate", "hot/temperate"),
  temperature = c(10, 30, 18, "15"),
  northern_hemisphere = c(TRUE, TRUE, FALSE, "FALSE"),
  has_kangaroo = c(FALSE, FALSE, FALSE, 1)
)

## mix of numeric and character in 'temperature'
## mix of TRUE/FALSE and character in 'northern_hemisphere'
## mix of TRUE/FALSE and numeric in 'has_kangaroo'
temp <- factor(country_climate$temperature)  ## convert to factor
country_climate$temperature <-  as.numeric(levels(temp))[temp]    # The recommended way.
country_climate$temperature

hemi <- factor(country_climate$northern_hemisphere)  ## convert to factor
country_climate$northern_hemisphere <- as.logical(levels(hemi))[hemi] ## then to type with same order
country_climate$northern_hemisphere 


kang <- factor(country_climate$has_kangaroo)
country_climate$has_kangaroo <-  as.logical(as.numeric(levels(kang)))[kang]  
country_climate$has_kangaroo


country_climate


########## Formatting dates ################
str(surveys)
## The lubridate package has many useful functions for working with dates. 
library(lubridate)
## Here we will use the function ymd(), 
## which takes a vector representing year, month, and day, 
## and converts it to a Date vector.
my_date <- ymd("2015-01-01")
str(my_date)
# sep indicates the character to use to separate each component
my_date <- ymd(paste("2015", "1", "1", sep = "-")) 
str(my_date)
## Now we apply this function to the surveys dataset. 
## Create a character vector from the year, month, and day columns of surveys using paste():
paste(surveys$year, surveys$month, surveys$day, sep = "-")
## This character vector can be used as the argument for ymd():
ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))
surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))  
str(surveys) # notice the new column, with 'date' as the class
summary(surveys$date)

missing_dates <- surveys[is.na(surveys$date), c("year", "month", "day")]

head(missing_dates)  ## April (4) 30 days max, September (9) 30 days max
missing_dates$month

