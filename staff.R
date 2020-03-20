

#### Libraries ------

library(tidyverse)
library(here)
library(vroom)


#### Load files -------


#  from https://www.cde.ca.gov/ds/sd/df/filesstaffdemo.asp


staffdemo <- vroom(here("data","StaffDemo18.txt"))
staffcred <- vroom(here("data","StaffCred18.txt"))
staffschool <- vroom(here("data","StaffSchoolFTE18.txt"))

