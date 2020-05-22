

#### Libraries ------
  
library(tidyverse)
library(here)
library(vroom)
library(readxl)


#### Load files -------


#  from https://www.cde.ca.gov/ds/sd/df/filesstaffdemo.asp


staffdemo <- vroom(here("data","StaffDemo18.txt"))
staffcred <- vroom(here("data","StaffCred18.txt"))
staffschool <- vroom(here("data","StaffSchoolFTE18.txt"))
oms <- read_excel(here("data","participant_export.xlsx"))
events_csv <- read_csv(here("data", "events.csv"))

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
    

oms_rev <- oms %>% 
    select(-c(`Part Count`,
           `End Date`:`Confirmation ID`,
           `Phone 01`:`Address 02...29`,
           `Address 01 (Home)`:`Address 02...34`,
           Credit_01:`Modification Date`)
           ) %>%
    mutate(cds = str_replace(`CDS Code`,str_extract(`CDS Code`,"[:punct:]"),'')) %>%
    mutate(cds = str_replace(cds,str_extract(cds,"[:punct:]"),'')) %>%
    select(-`CDS Code`) %>%
    arrange(`Start Date`)
   


people <- oms_rev %>%
    group_by(`First Name`,`Last Name`) %>%
    mutate(events = max(row_number())) %>%
    select(`First Name`:School,cds,events) %>%
    distinct()

School <- oms_rev %>%
         group_by(`School`) %>%
         select(`Event ID`,School)%>%
         count(`Event ID`)
    

STEAM <- events_csv %>%
       rename(Program = X3) %>%
       filter(Program == "STEAM") %>%
       left_join(oms_rev, by = "Event ID") %>%
       select( - `Event Title.y`) %>% 
       group_by(District,School, `First Name`, `Last Name`) %>%
       count(`Event Title.x`) %>%
       rename(`Event Title` = `Event Title.x`, Registration = n)
        


events <- oms_rev %>% 
    select(`Event Title`, `Event ID`) %>%
    distinct()

write_csv(events, "events.csv")


#### End -----
