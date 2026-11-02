

#read file
data <- read.csv('SPHP_11012026.csv', skip = 1, header = TRUE)


#install.packages('tidyverse')
library('tidyverse')

#delete row 1
data <- data %>%  # Take the data, THEN...
  slice(-1)       # Remove row 1, THEN...


##clean up data using 'Tidyverse'
# NEW STEP: Changes 'X' to 'Timestamp'
data <- data %>%
  rename(Timestamp = X)

#CLEANUP STEP: Trim spaces from all character/text columns
data <- data %>% 
  mutate(
    across(where(is.character), str_trim),
    
    #CLEANUP STEP: Trim spaces from all integer columns
    across(where(is.integer), str_trim),
    
    #change all empty columns to NA
    across(everything(), ~ na_if(as.character(.), "")),
    
    #change all 'USA' in Column 'Country' to 'United States'
    Country = ifelse(Country == 'USA', 'United States', Country),
  )
    #Convert your text column into an actual R calendar date
data <- data %>% 
  mutate( 
    # Step E: Parse text strings into true calendar date formats
    Germination.Date = parse_date_time(Germination.Date, orders = c("ymd", "mdy", "md", "y")),
    First.Flower.Date = parse_date_time(First.Flower.Date, orders = c("ymd", "mdy", "md", "y")),
    First.Mature.Fruit.Date = parse_date_time(First.Mature.Fruit.Date, orders = c("ymd", "mdy", "md", "y")),
    
    # FIXED PARSER LINE: Uses correct uppercase format matching your data layout
    Timestamp = parse_date_time(Timestamp, orders = c("mdy HMS", "ymd HMS")),
   
    # FIX INDIVIDUAL ROW: If the plant name is Rosa, overwrite the broken dates with 2026-06-26
    #LAST CHECKED: Row 20
    Germination.Date = if_else(Source.ID == "RosaSep262026", as.Date("2026-06-26"), Germination.Date),
    First.Flower.Date = if_else(Source.ID == "RosaSep262026", as.Date("2026-06-26"), First.Flower.Date)
  )
    
  
  
#view data  
View(data)





