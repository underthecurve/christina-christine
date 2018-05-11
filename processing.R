## to be run before plot.R

library('rvest')
library('stringr')
library('tidyverse')

## download national files from here: https://www.ssa.gov/oact/babynames/limits.html (National data)
## code partly inspired by: https://github.com/fivethirtyeight/data/blob/master/most-common-name/most-common-name.R

files  <- list.files('names/')
files <- files[-1]

allyears  <- data.frame()

for (i in 1:length(files)) {
    yeardata  <- read.table(paste0('names/', files[i]), sep=",")
    yeardata$year <- as.numeric(str_extract_all(files[i], "[0-9]+")[[1]])
    allyears <- rbind(allyears, yeardata)
}

names(allyears)  <- c("name", "sex", "n", "year")

# subset to Christine & Christina (assume female) and 1980
names.subset <- allyears %>% filter(year >= 1980 & 
                                (name == 'Christine' | name == 'Christina') & 
                                sex == 'F') %>% select(-sex)
head(names.subset)

## scrape data from SSA webpage about "births" (number of applicants for a Social Security card)
## code partly inspired by: http://bradleyboehmke.github.io/2015/12/scraping-html-tables.html
url <- "https://www.ssa.gov/oact/babynames/numberUSbirths.html"
page <- url %>%
  read_html() 

tbls <- html_nodes(page, "table")
tbls_ls <- page %>%
  html_nodes("table") %>%
  .[2] %>%
  html_table(fill = TRUE)

births <- tbls_ls[[1]]
colnames(births) <- c('year', 'male', 'female', 'total')

# subset to females who would be and 1980
births.subset <- births %>% filter(year >= 1980) %>% 
  select(year, female.births = female)

# make sure births are numeric
births.subset$female.births <- as.numeric(str_replace_all(
  births.subset$female.births, 
  pattern = ',', 
  replacement = ''
))

## merge names and births
df <- names.subset %>% full_join(births.subset, by = 'year')

## calculate per million and cumulative per million
df$per.million <- df$n/df$female.births * 1000000
df <- df %>% group_by(name) %>% 
  mutate(cumulative.per.million = cumsum(per.million), cumulative = cumsum(n)) 

write_csv(df, 'data.csv')

