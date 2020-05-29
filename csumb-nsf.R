

#### Libraries ------

library(tidyverse)
library(here)
library(vroom)
library(readxl)


#### Load files -------


#  from https://www.cde.ca.gov/ds/sd/df/filesstaffdemo.asp

setwd("data")

demofiles <- fs::dir_ls( glob = "StaffD*.txt")

staffdemo <- vroom(demofiles)


credfiles <- fs::dir_ls( glob = "StaffC*.txt")

staffcred <- vroom(credfiles)


schoolfiles <- fs::dir_ls( glob = "StaffS*.txt")

staffschool <- vroom(schoolfiles)




setwd(here())

#### Manipulated data -----

staffschool <- staffschool %>% 
    filter(str_detect(CountyName,"Monterey")) %>%
    select(-FileCreated)

staffdemo <- staffdemo %>% 
    filter(str_detect(CountyName, "MONTEREY")) %>%
    select(-c(FileCreated,DistrictCode:DistrictName ))

joint <- staffschool %>%
    left_join(staffdemo, by = c("AcademicYear", "RecID")) %>%
    left_join(staffcred, by = c("AcademicYear", "RecID"))



