

#### Libraries ------

library(tidyverse)
library(here)
library(vroom)
library(readxl)
library(janitor)

#### Load files -------


#  from https://www.cde.ca.gov/ds/sd/df/filesstaffdemo.asp

setwd("data")

demofiles <- fs::dir_ls( glob = "StaffD*.txt")

staffdemo <- vroom(demofiles)


credfiles <- fs::dir_ls( glob = "StaffC*.txt")

staffcred <- vroom(credfiles)


schoolfiles <- fs::dir_ls( glob = "StaffS*.txt")

staffschool <- vroom(schoolfiles)

subject_code <- read_csv(here("data", "staffcred_authorization_type.csv"))

cred_type <- read_csv(here("data", "staffcred_credential_type.csv"))


setwd(here())

#### Manipulated data -----

staffschool <- staffschool %>% 
    filter(str_detect(CountyName,"Monterey")) %>%
    select(-FileCreated)

staffdemo <- staffdemo %>% 
    filter(str_detect(CountyName, "MONTEREY")) %>%
    select(-c(FileCreated,DistrictCode:DistrictName ))

staffcred <- staffcred %>%
       left_join(cred_type, by = "CredentialType") %>%
       left_join(subject_code, by = "AuthorizationType")

joint <- staffschool %>%
    left_join(staffdemo, by = c("AcademicYear", "RecID")) %>%
    left_join(staffcred, by = c("AcademicYear", "RecID")) %>%
    filter(AcademicYear == "1819", 
           StaffType %in% c("T", "P"), 
           #CredentialType %in% c("50","60")
           )

Science_Math <- joint %>%
       filter(AuthorizationType %in% c("100","110","130","140","160","170","190",
                                       "200","210","220","230","250","270","280",
                                       "310","320","330")) %>%
       filter(`RecID` != "1000470556") #removed because 200 FTETeaching looks like data error
    
tabyl(Science_Math$CredentialType)

write_csv(Science_Math,here("output","science_math_teachersMontereyCounty.csv"))


