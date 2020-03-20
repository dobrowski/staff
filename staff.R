

#### Libraries ------

library(tidyverse)
library(here)
library(vroom)


#### Load files -------


#  from https://www.cde.ca.gov/ds/sd/df/filesstaffdemo.asp


staffdemo <- vroom(here("data","StaffDemo18.txt"))
staffcred <- vroom(here("data","StaffCred18.txt"))
staffschool <- vroom(here("data","StaffSchoolFTE18.txt"))



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
    





#### End -----
