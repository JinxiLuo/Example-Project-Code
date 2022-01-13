#Run the full script from here
rm(list=ls())
library(readxl)
library(naniar)
library(tidyverse) 
library(dplyr)
library(Hmisc)
library(plyr)
library(ggplot2)
library(anytime)
library(magrittr)
library(plyr)
memory.limit(size=1200000)




setwd("C:/Users/Alice/Desktop/Pan")
#Content:
#1. LOAD EVERYTHING IN
#2. Remove unneeded features and check for nulls to reduce amount of data
#3. COMBINE ALL USAGE DATA
#4. Create some subsets
#5. Merge session and usage
#6. Making old features 
#7. Making new features 
#8. Extra new features of interest
#9. Finalizing data and features to csv
#Now the data just need to have the grades linked by STUDENT_ID,COURSE_ID and TERM_CODE
# As well as to be rerun again once more session and usage data is obtained
# #########################. Test section
# With R studio to quickly un comment and comment out a block of code
# Highlight area and do ctrl+shift+C

#Final Data.....



#Running everything took about 1-2 hours with i7 10th gen and 16gb ram laptop
#This is because when I first coded things I vectorize most of the code which is not good and that I couldn't think of a way at the moment
#to eliminate the use of forloops completely 





#1. LOAD EVERYTHING IN 
#So I am just going to use the original code I had because it ran faster for me given the file formats I had already. 
#But if you are working with the data in a single excel file without first saving each file in separate csv file
#than using Mark's code may be easier
#And our results are pretty much the same as detailed below:

#Even with marks code the 2019 results still have missing data as a left join resulted in 9717 rows for 2019 data but 
#NO STUDENT/USAGE INFORMATION - EVERYTHING FROM USAGE COLUMNS ARE NAs
#Marks code results
#dplyr::left_join for UO 2019 session and usage -> 9717 obs of 31 var (1 proportion NAs on STUDENT_ID)
#dplyr::inner_join for UO 2019 session and usage -> 0 obs of 31 var 

#dplyr::left_join for UO 2020 session and usage -> 403283 obs of 31 var (0.004359222 proportion  NAs on STUDENT_ID)
#dplyr::left_join for NON UO 2020 session and usage -> 7140802 obs of 31 var (0.001503192 proportion  NAs on STUDENT_ID)
#dplyr::inner_join for UO 2020 session and usage -> 401525 obs of 31 var (0 proportion NAs on STUDENT_ID)
#dplyr::inner_join for NON UO 2020 session and usage -> 7130068 obs of 31 var (0 proportion NAs on STUDENT_ID)

#My code results - 2020 merge results are very close in both cases so i am just going not worry about it

#merge(left) for UO 2019 session and usage -> 9717 obs of 16 var (1 proportion NAs on STUDENT_ID)
#merge(inner) for NON UO 2020 data -> 7130351 obs of 12 var (0 proportion  NAs on STUDENT_ID)
#merge(inner) for UO 2020 data -> 401534 obs of 12 var (0 proportion  NAs on STUDENT_ID)

#In summary, both Mark and my code works the same but I thought his worked more correctly than mine cause they used a left join
#for the 2019 data which got results for the 2019 merge. But it doesn't make sense as no STUDENT_ID/usage data is included.
##Mark's code below:

# Panopto2019 <- readxl::read_xlsx("PanoptoSessions2019.xlsx") %>%
#   dplyr::select(COURSE_ID,
#                 SUBJECT_AREA,
#                 CATALOG_NBR,
#                 COURSE_NAME,
#                 SYSTEM_SESSION_ID,
#                 PANOPTO_SESSION_KEY,
#                 SESSION_NAME,
#                 PARENT_FOLDER_ID,
#                 PARENT_FOLDER_NAME,
#                 START_TIME,
#                 DURATION,
#                 DESCRIPTION,
#                 CLASS_NUMBER,
#                 TERM_CODE,
#                 OFFER_TYPE_CODE,
#                 STAFF,
#                 CAMPUS_CODE,
#                 ROOM,
#                 CLASS_TYPE,
#                 TYPE
#                 ) %>% unique()
# 
# tab_names <- readxl::excel_sheets("PanoptoUsage2019.xlsx")
# 
# PanoptoUsage2019 <- lapply(tab_names,
#                            function(x) readxl::read_xlsx("PanoptoUsage2019.xlsx", sheet=x)) %>%
#                            dplyr::bind_rows() %>%
#                            dplyr::select(PANOPTO_SESSION_KEY,
#                            STUDENT_ID,
#                            STUDENT_USERNAME,
#                            STUDENT_NAME,
#                            DAY_DATE,
#                            SYSTEM_USER_ID,
#                            VIEW_TIME,
#                            SECONDS_VIEWED,
#                            START_POSITION,
#                            CLASS_ENROLLED,
#                            OFFERING_ENROLLED,
#                            COURSE_ENROLLED
#                           ) %>% unique()
# 
# 
# UO_Data_2019 <- Panopto2019 %>%
#                   dplyr::filter(grepl("UO",COURSE_NAME)) %>%
#                   dplyr::inner_join(PanoptoUsage2019, by=c("PANOPTO_SESSION_KEY"))
# 
# Panopto2020 <- readxl::read_xlsx("PanoptoSessions2020.xlsx") %>%
#   dplyr::select(COURSE_ID,
#                 SUBJECT_AREA,
#                 CATALOG_NBR,
#                 COURSE_NAME,
#                 SYSTEM_SESSION_ID,
#                 PANOPTO_SESSION_KEY,
#                 SESSION_NAME,
#                 PARENT_FOLDER_ID,
#                 PARENT_FOLDER_NAME,
#                 START_TIME,
#                 DURATION,
#                 DESCRIPTION,
#                 CLASS_NUMBER,
#                 TERM_CODE,
#                 OFFER_TYPE_CODE,
#                 STAFF,
#                 CAMPUS_CODE,
#                 ROOM,
#                 CLASS_TYPE,
#                 TYPE
#   ) %>% unique()
# 
# tab_names <- readxl::excel_sheets("PanoptoUsage2020.xlsx")
# 
# PanoptoUsage2020 <- lapply(tab_names,
#                            function(x) readxl::read_xlsx("PanoptoUsage2020.xlsx", sheet=x)) %>%
#   dplyr::bind_rows() %>%
#   dplyr::select(PANOPTO_SESSION_KEY,
#                 STUDENT_ID,
#                 STUDENT_USERNAME,
#                 STUDENT_NAME,
#                 DAY_DATE,
#                 SYSTEM_USER_ID,
#                 VIEW_TIME,
#                 SECONDS_VIEWED,
#                 START_POSITION,
#                 CLASS_ENROLLED,
#                 OFFERING_ENROLLED,
#                 COURSE_ENROLLED
#   ) %>% unique()
# 
# UO_Data_2020 <- Panopto2020 %>%
#   dplyr::filter(grepl("UO",COURSE_NAME)) %>%
#   dplyr::inner_join(PanoptoUsage2020, by=c("PANOPTO_SESSION_KEY"))
# 
# Non_UO_Data_2020 <- Panopto2020 %>%
#   dplyr::filter(!grepl("UO",COURSE_NAME)) %>%
#   dplyr::inner_join(PanoptoUsage2020, by=c("PANOPTO_SESSION_KEY"))

##My code below, here the 2019 data code is commented out as merge returns no results.

# ses2019 = read.csv('PanoptoSessions2019.csv',na.string = c("NULL"))
# ses2019$DURATION=sapply(ses2019$DURATION, gsub, pattern=",", replacement="")
# ses2019$DURATION <- sapply(ses2019$DURATION, as.numeric)
ses2020 = read.csv('PanoptoSessions2020.csv',na.string = c("NULL"))
ses2020$DURATION=sapply(ses2020$DURATION, gsub, pattern=",", replacement="")
ses2020$DURATION <- sapply(ses2020$DURATION, as.numeric)

# names(ses2019)[1] <- "COURSE_ID"
names(ses2020)[1] <- "COURSE_ID"

#7.1 Recode term codes assuming year does not matter.
#This should still work as Pan key is unique for each repeated session 
#SP1 __05
#SP2 __10
#SP3 __12
#SP4 __14
#SP5 __20
#SP6 __25
#SP7 __30
ses2020$TERM_CODE = ses2020$TERM_CODE%%100
ses2020$TERM_CODE[ses2020$TERM_CODE==05] <- 'SP1'
ses2020$TERM_CODE[ses2020$TERM_CODE==10] <- 'SP2'
ses2020$TERM_CODE[ses2020$TERM_CODE==12] <- 'SP3'
ses2020$TERM_CODE[ses2020$TERM_CODE==14] <- 'SP4'
ses2020$TERM_CODE[ses2020$TERM_CODE==20] <- 'SP5'
ses2020$TERM_CODE[ses2020$TERM_CODE==25] <- 'SP6'
ses2020$TERM_CODE[ses2020$TERM_CODE==30] <- 'SP7'

ses2020$TERM_CODE[ses2020$TERM_CODE==23] <- 'SP3'
ses2020$TERM_CODE[ses2020$TERM_CODE==7] <- 'SP1'
ses2020$TERM_CODE[ses2020$TERM_CODE==13] <- 'SP2'
ses2020$TERM_CODE[ses2020$TERM_CODE==1] <- 'SPA'
ses2020$TERM_CODE[ses2020$TERM_CODE==48] <- 'SP6'
ses2020$TERM_CODE[ses2020$TERM_CODE==50] <- 'SP3'
ses2020$TERM_CODE[ses2020$TERM_CODE==40] <- 'SP1'
ses2020$TERM_CODE[ses2020$TERM_CODE==55] <- 'SP4'
ses2020$TERM_CODE[ses2020$TERM_CODE==45] <- 'SP2'
ses2020$TERM_CODE[ses2020$TERM_CODE==2] <- 'SPA'
ses2020$TERM_CODE[ses2020$TERM_CODE==3] <- 'SPA'
ses2020$TERM_CODE[ses2020$TERM_CODE==4] <- 'SPA'
ses2020=ses2020[ses2020$TERM_CODE %in% c('SP1','SP2','SP3','SP4','SP5','SP6','SP7'), ]

#7.3 Group sessions short, medium and long
#x< 103	OU 2020	Short
#103<= x < 815	OU 2020	Medium
#815 >= x	OU 2020	Long
#x < 777	Non-OU 2020	Short
#777 <= x < 3917	Non-OU 2020	Medium
#3917 >= x	Non-OU 2020	Long



ses2020<-ses2020%>%mutate(DURATION2 = case_when(
  
  grepl("UO",COURSE_NAME) & DURATION<103 ~ 'Short',
  grepl("UO",COURSE_NAME) & DURATION>=103 & DURATION<815 ~ 'Medium',
  grepl("UO",COURSE_NAME) & DURATION>=815  ~ 'Long',
  !grepl("UO",COURSE_NAME) & DURATION<777 ~ 'Short',
  !grepl("UO",COURSE_NAME) & DURATION>=777 & DURATION<3917 ~ 'Medium',
  !grepl("UO",COURSE_NAME) & DURATION>=3917  ~ 'Long',
  
  TRUE~'ERROR'
))


#7.4.2.1.Total short,mid,long sessions in course per term 

creationStorageShort = ses2020[ses2020$DURATION2=='Short',]
creationStorageMedium = ses2020[ses2020$DURATION2=='Medium',]
creationStorageLong = ses2020[ses2020$DURATION2=='Long',]

originalCreationShort =aggregate(x = creationStorageShort[c("DURATION2")], by = creationStorageShort[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMedium =aggregate(x = creationStorageMedium[c("DURATION2")], by = creationStorageMedium[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLong =aggregate(x = creationStorageLong[c("DURATION2")], by = creationStorageLong[c("COURSE_ID","TERM_CODE")], FUN = length)

names(originalCreationShort)[3] <- "TOTAL_SHORT_SESSIONS"
names(originalCreationMedium)[3] <- "TOTAL_MEDIUM_SESSIONS"
names(originalCreationLong)[3] <- "TOTAL_LONG_SESSIONS"

ses2020=merge(x = ses2020, y = originalCreationShort, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
ses2020=merge(x = ses2020, y = originalCreationMedium, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
ses2020=merge(x = ses2020, y = originalCreationLong, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
ses2020$TOTAL_SHORT_SESSIONS[is.na(ses2020$TOTAL_SHORT_SESSIONS)] <- 0
ses2020$TOTAL_MEDIUM_SESSIONS[is.na(ses2020$TOTAL_MEDIUM_SESSIONS)] <- 0
ses2020$TOTAL_LONG_SESSIONS[is.na(ses2020$TOTAL_LONG_SESSIONS)] <- 0

# U12019=read.csv(file = '1PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U22019=read.csv(file = '2PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U32019=read.csv(file = '3PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U42019=read.csv(file = '4PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U52019=read.csv(file = '5PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U62019=read.csv(file = '6PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U72019=read.csv(file = '7PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U82019=read.csv(file = '8PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U92019=read.csv(file = '9PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U102019=read.csv(file = '10PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U112019=read.csv(file = '11PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U122019=read.csv(file = '12PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
# U132019=read.csv(file = '13PanoptoUsage2019.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]

U12020=read.csv(file = '1PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U22020=read.csv(file = '2PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U32020=read.csv(file = '3PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U42020=read.csv(file = '4PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U52020=read.csv(file = '5PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U62020=read.csv(file = '6PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U72020=read.csv(file = '7PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U82020=read.csv(file = '8PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U92020=read.csv(file = '9PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U102020=read.csv(file = '10PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U112020=read.csv(file = '11PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U122020=read.csv(file = '12PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U132020=read.csv(file = '13PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U142020=read.csv(file = '14PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]
U152020=read.csv(file = '15PanoptoUsage2020.csv',na.string = c("NULL"))[ ,c("ï..PANOPTO_SESSION_KEY","STUDENT_ID","DAY_DATE","VIEW_TIME","SECONDS_VIEWED","START_POSITION")]

# names(U12019)[1] <- "PANOPTO_SESSION_KEY"
# names(U22019)[1] <- "PANOPTO_SESSION_KEY"
# names(U32019)[1] <- "PANOPTO_SESSION_KEY"
# names(U42019)[1] <- "PANOPTO_SESSION_KEY"
# names(U52019)[1] <- "PANOPTO_SESSION_KEY"
# names(U62019)[1] <- "PANOPTO_SESSION_KEY"
# names(U72019)[1] <- "PANOPTO_SESSION_KEY"
# names(U82019)[1] <- "PANOPTO_SESSION_KEY"
# names(U92019)[1] <- "PANOPTO_SESSION_KEY"
# names(U102019)[1] <- "PANOPTO_SESSION_KEY"
# names(U112019)[1] <- "PANOPTO_SESSION_KEY"
# names(U122019)[1] <- "PANOPTO_SESSION_KEY"
# names(U132019)[1] <- "PANOPTO_SESSION_KEY"

names(U12020)[1] <- "PANOPTO_SESSION_KEY"
names(U22020)[1] <- "PANOPTO_SESSION_KEY"
names(U32020)[1] <- "PANOPTO_SESSION_KEY"
names(U42020)[1] <- "PANOPTO_SESSION_KEY"
names(U52020)[1] <- "PANOPTO_SESSION_KEY"
names(U62020)[1] <- "PANOPTO_SESSION_KEY"
names(U72020)[1] <- "PANOPTO_SESSION_KEY"
names(U82020)[1] <- "PANOPTO_SESSION_KEY"
names(U92020)[1] <- "PANOPTO_SESSION_KEY"
names(U102020)[1] <- "PANOPTO_SESSION_KEY"
names(U112020)[1] <- "PANOPTO_SESSION_KEY"
names(U122020)[1] <- "PANOPTO_SESSION_KEY"
names(U132020)[1] <- "PANOPTO_SESSION_KEY"
names(U142020)[1] <- "PANOPTO_SESSION_KEY"
names(U152020)[1] <- "PANOPTO_SESSION_KEY"

#2. Remove unneeded features and check for nulls to reduce amount of data

#SES DATA
#Remove following cause mostly nulls > 80% (UO courses in 2019 and general 2020): STAFF, CAMPUS_CODE,ROOM,CLASS_TYPE, DESCRIPTION, CLASS_NUMBER
#Remove following cause no extra information: SYSTEM_SESSION_ID,PARENT_FOLDER_ID,PARENT_FOLDER_NAME

#ses2019[ ,c('STAFF', 'CAMPUS_CODE','ROOM','CLASS_TYPE', 'DESCRIPTION', 'CLASS_NUMBER','SYSTEM_SESSION_ID','PARENT_FOLDER_ID','PARENT_FOLDER_NAME')] <- list(NULL)
ses2020[ ,c('STAFF', 'CAMPUS_CODE','ROOM','CLASS_TYPE', 'DESCRIPTION', 'CLASS_NUMBER','SYSTEM_SESSION_ID','PARENT_FOLDER_ID','PARENT_FOLDER_NAME','CATALOG_NBR','OFFER_TYPE_CODE','TYPE','START_TIME')] <- list(NULL)
#USAGE DATA
#Removed at load in cause mostly constant value and Nas

#3. COMBINE ALL USAGE DATA
#totalUsage2019 <- rbind(U12019,U22019,U32019,U42019,U52019,U62019,U72019,U82019,U92019,U102019,U112019,U122019,U132019)
totalUsage2020 <- rbind(U12020,U22020,U32020,U42020,U52020,U62020,U72020,U82020,U92020,U102020,U112020,U122020,U132020,U142020,U152020)

#4. Create some subsets
#OU2019=ses2019[grepl("UO", ses2019$COURSE_NAME),]
OUses2020=ses2020[grepl("UO", ses2020$COURSE_NAME),]
camses2020=ses2020[!grepl("UO", ses2020$COURSE_NAME),]

#5. Merge session and usage

#All of OU 2019 only
#totalOU2019=merge(OU2019,totalUsage2019, by="PANOPTO_SESSION_KEY")
#All of OU 2020 only
#totalOU2020=merge(totalUsage2020, OUses2020, by="PANOPTO_SESSION_KEY")
totalOU2020 <- totalUsage2020 %>%
  dplyr::inner_join(OUses2020, by="PANOPTO_SESSION_KEY")

#All of cam 2020 only
#totalCam2020=merge(totalUsage2020, camses2020, by="PANOPTO_SESSION_KEY")
totalCam2020 <- totalUsage2020 %>%
  dplyr::inner_join(camses2020, by="PANOPTO_SESSION_KEY")


#6. Making old features - I did everything in chunks so I don't get confused when revisiting code in future.

###########TOTAL_SESSION_INTERACTIONS
#For each distinct STUDENT_ID, COURSE_ID and TERM_CODE row, we count the total number 
#of usage data that exists for a unique VIEW_TIME and SESSION_NAME.

#9999999999
totalOU2020$TOTAL_SESSION_INTERACTIONS = 1
originalCreation =aggregate(x = totalOU2020[c("TOTAL_SESSION_INTERACTIONS")], by = totalOU2020[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = sum)
#ttotalOU2020=merge(x = totalOU2020, y = originalCreation, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
ttotalOU2020 <- totalOU2020 %>%
  dplyr::left_join(originalCreation, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
ttotalOU2020$TOTAL_SESSION_INTERACTIONS = ttotalOU2020$TOTAL_SESSION_INTERACTIONS.y
ttotalOU2020$TOTAL_SESSION_INTERACTIONS.x = NULL
ttotalOU2020$TOTAL_SESSION_INTERACTIONS.y = NULL

totalCam2020$TOTAL_SESSION_INTERACTIONS = 1
originalCreation2 =aggregate(x = totalCam2020[c("TOTAL_SESSION_INTERACTIONS")], by = totalCam2020[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = sum)
#ttotalCam2020=merge(x = totalCam2020, y = originalCreation, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
ttotalCam2020 <- totalCam2020 %>%
  dplyr::left_join(originalCreation, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
ttotalCam2020$TOTAL_SESSION_INTERACTIONS = ttotalCam2020$TOTAL_SESSION_INTERACTIONS.y
ttotalCam2020$TOTAL_SESSION_INTERACTIONS.x = NULL
ttotalCam2020$TOTAL_SESSION_INTERACTIONS.y = NULL


###########TOTAL_SESSION_DURATION
#For each distinct COURSE_ID and TERM_CODE row, we count the total DURATION 
#that exists in the session data.

originalCreation <- data.frame(COURSE_ID=as.character(),TERM_CODE=as.character(),TOTAL_SESSION_DURATION=integer(),temps=as.character(),stringsAsFactors=FALSE)

for (row in 1:nrow(ses2020)) {
  courseID <- ses2020[row, "COURSE_ID"]
  termCode <- ses2020[row,'TERM_CODE']
  temps=paste(courseID,termCode)
  if(temps%in%originalCreation$temps){
    originalCreation[originalCreation$temps==temps,'TOTAL_SESSION_DURATION']=originalCreation[originalCreation$temps==temps,'TOTAL_SESSION_DURATION']+ses2020[row,'DURATION']
  }else{
    temp<-data.frame(courseID,termCode,ses2020[row,'DURATION'],temps)
    names(temp)<-c('COURSE_ID','TERM_CODE','TOTAL_SESSION_DURATION','temps')
    originalCreation <- rbind(originalCreation, temp)
  }
}
originalCreation$temps=NULL
# ttotalOU2020=merge(x = ttotalOU2020, y = originalCreation, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# ttotalCam2020=merge(x = ttotalCam2020, y = originalCreation, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)


ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(originalCreation, by=c('COURSE_ID','TERM_CODE'))


ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(originalCreation, by=c('COURSE_ID','TERM_CODE'))



###########TOTAL_TIME_VIEWED
#For each distinct STUDENT_ID, COURSE_ID and TERM_CODE row, 
#we count the total number of usage SECONDS_VIEWED that exists for a 
#unique VIEW_TIME and SESSION_NAME.
originalCreation=ttotalOU2020[!duplicated(ttotalOU2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME','VIEW_TIME')]),]
originalCreation =aggregate(x = ttotalOU2020[c("SECONDS_VIEWED")], by = ttotalOU2020[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = sum)
names(originalCreation)[4] <- "TOTAL_TIME_VIEWED"
#ttotalOU2020=merge(x = ttotalOU2020, y = originalCreation, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)

ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(originalCreation, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))



#--------------------------------------------------------------------------------------------------------------------------------------------------
originalCreation2=ttotalCam2020[!duplicated(ttotalCam2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME','VIEW_TIME')]),]
originalCreation2 =aggregate(x = ttotalCam2020[c("SECONDS_VIEWED")], by = ttotalCam2020[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = sum)
names(originalCreation2)[4] <- "TOTAL_TIME_VIEWED"
#ttotalCam2020=merge(x = ttotalCam2020, y = originalCreation2, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)

ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(originalCreation2, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))



###########TOTAL_SESSIONS_COURSE
#For each distinct COURSE_ID and TERM_CODE row, we count the total number 
#of sessions that exists in the session data.

originalCreation <- data.frame(COURSE_ID=as.character(),TERM_CODE=as.character(),TOTAL_SESSIONS_COURSE=integer(),temps=as.character(),stringsAsFactors=FALSE)

vidCounter =0
for (row in 1:nrow(ses2020)) {
  courseID <- ses2020[row, "COURSE_ID"]
  termCode <- ses2020[row,'TERM_CODE']
  
  temps=paste(courseID,termCode)
  if(temps%in%originalCreation$temps){
    originalCreation[originalCreation$temps==temps,'TOTAL_SESSIONS_COURSE']=originalCreation[originalCreation$temps==temps,'TOTAL_SESSIONS_COURSE']+1
  }else{
    temp<-data.frame(courseID,termCode,1,temps)
    names(temp)<-c('COURSE_ID','TERM_CODE','TOTAL_SESSIONS_COURSE','temps')
    originalCreation <- rbind(originalCreation, temp)
  }
}
originalCreation$temps=NULL
# ttotalOU2020=merge(x = ttotalOU2020, y = originalCreation, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# ttotalCam2020=merge(x = ttotalCam2020, y = originalCreation, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)

ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(originalCreation, by=c('COURSE_ID','TERM_CODE'))

ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(originalCreation, by=c('COURSE_ID','TERM_CODE'))



###########PORTION_OF_SESSIONS_WATCHED  
#TOTAL_TIME_VIEWED / TOTAL_SESSION_DURATION   #RERUN CODE FROM HERE when error checking new feature creation

ttotalOU2020 <- transform(ttotalOU2020, PROPORTION_OF_SESSIONS_WATCHED = TOTAL_TIME_VIEWED / TOTAL_SESSION_DURATION)
ttotalCam2020 <- transform(ttotalCam2020, PROPORTION_OF_SESSIONS_WATCHED = TOTAL_TIME_VIEWED / TOTAL_SESSION_DURATION)


#7. MAKING NEW FEATURES
#While each of these steps follows from each other, they are not dependent on each other in terms of how the code functions.
#Each section may be corrected to account for the assumptions at the time and would not affect code in other sections.

#7.1 See Above - figuring out term codes

#7.2 First assign order to each session based on first usage within each term. FINDING SESSION PERIOD 
#This assumes that students must view recordings based on some intended order.
#Accounts for if sessions vary by semester - new content or teacher changes watch schedule
#Accounts for if courses repeat through the year

#Order by:
#VIEW_TIME
#TERM_CODE
#COURSE_ID
ttotalOU2020$VIEW_TIME=as.POSIXlt(ttotalOU2020$VIEW_TIME,format="%m/%d/%Y %H:%M:%S",tz=Sys.timezone())
ttotalOU2020$DAY_DATE=as.POSIXlt(ttotalOU2020$DAY_DATE,format="%d/%m/%Y")
originalCreation=ttotalOU2020[with(ttotalOU2020, order((ttotalOU2020$VIEW_TIME),TERM_CODE, COURSE_ID)),]
originalCreation = originalCreation[,c('DAY_DATE','VIEW_TIME','COURSE_ID','COURSE_NAME','STUDENT_ID','TERM_CODE','SESSION_NAME','DURATION')]
#There are only 3 unique term codes for OU 2020
#Easier to divide into subsets and then apply date division
sesOrderSP3 =subset(originalCreation, TERM_CODE == 'SP3')
sesOrderSP4 = subset(originalCreation, TERM_CODE == 'SP4')
sesOrderSP6 = subset(originalCreation, TERM_CODE == 'SP6')
sesOrderSP3 = sesOrderSP3[match(unique(sesOrderSP3$SESSION_NAME), sesOrderSP3$SESSION_NAME),]
sesOrderSP4 = sesOrderSP4[match(unique(sesOrderSP4$SESSION_NAME), sesOrderSP4$SESSION_NAME),]
sesOrderSP6 = sesOrderSP6[match(unique(sesOrderSP6$SESSION_NAME), sesOrderSP6$SESSION_NAME),]
sesOrderSP3=sesOrderSP3[with(sesOrderSP3, order(COURSE_ID,(sesOrderSP3$VIEW_TIME))),]
sesOrderSP4=sesOrderSP4[with(sesOrderSP4, order(COURSE_ID,(sesOrderSP4$VIEW_TIME))),]
sesOrderSP6=sesOrderSP6[with(sesOrderSP6, order(COURSE_ID,(sesOrderSP6$VIEW_TIME))),]

#Divide dates:
#SP3: Core teaching and assessment period 6/04/2020 to 19/06/2020
#(Up to Census date) 6/04/2020 to 24/04/2020 [Early] (~week1-week3)
#(All the weeks between) 25/04/2020 to 31/05/2020 [Mid] (~week4-week9)
#(Two weeks before exams and exam period) 1/06/2020 to 19/06/2020 [Late] (~week10-Week13)

sesOrderSP3<-sesOrderSP3%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/04/24") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/04/25") & DAY_DATE<= as.POSIXct("2020/05/31") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/06/1")  ~ 'Late',
  TRUE~'Early'
))

#SP4: Core teaching and assessment period 15/06/2020 to 11/09/2020
#(Up to Census date) 15/06/2020 to 17/07/2020 [Early]
#(All the weeks between) 18/07/2020 to 23/08/2020 [Mid]
#(Two weeks before exams and exam period) 24/08/2020 to 11/09/2020 [Late]

sesOrderSP4<-sesOrderSP4%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/07/17") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/07/18") & DAY_DATE<= as.POSIXct("2020/08/23") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/08/24")  ~ 'Late',
  TRUE~'Early'
))

#SP6: Core teaching and assessment period 21/09/2020 to 04/12/2020
#(Up to Census date) 21/09/2020 to 9/10/2020 [Early]
#(All the weeks between) 10/10/2020 to 15/11/2020 [Mid]
#(Two weeks before exams and exam period) 16/11/2020 to 04/12/2020 [Late]

sesOrderSP6<-sesOrderSP6%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/10/9") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/10/10") & DAY_DATE<= as.POSIXct("2020/11/15") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/11/16")  ~ 'Late',
  TRUE~'Early'
))

#Lastly merge everything back into ttotalOU2020
sesOrder=rbind(sesOrderSP3,sesOrderSP4,sesOrderSP6)
sesOrder=sesOrder[,c('COURSE_ID','TERM_CODE','SESSION_NAME','SESSION_PERIOD')]
#ttotalOU2020 = merge(totalOU2020,sesOrder,by=c('TERM_CODE','COURSE_ID','SESSION_NAME'),all.x = TRUE)  #CODE RERUN STARTING POINT
ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(sesOrder, by=c('TERM_CODE','COURSE_ID','SESSION_NAME'))


#Afterwards for ttotalOU2020 there are 0.002348494 NAs, idk why this is so I am just going to replace with the most common level
ttotalOU2020$SESSION_PERIOD[is.na(ttotalOU2020$SESSION_PERIOD)] = 'Early'


#--------------------------------------------------------------------------------------------------------------------------------------------------

#Order by:
#VIEW_TIME
#TERM_CODE
#COURSE_ID
ttotalCam2020$VIEW_TIME=as.POSIXlt(ttotalCam2020$VIEW_TIME,format="%m/%d/%Y %H:%M:%S",tz=Sys.timezone())
ttotalCam2020$DAY_DATE=as.POSIXlt(ttotalCam2020$DAY_DATE,format="%d/%m/%Y")
originalCreation2=ttotalCam2020[with(ttotalCam2020, order((ttotalCam2020$VIEW_TIME),TERM_CODE, COURSE_ID)),]
originalCreation2 = originalCreation2[,c('DAY_DATE','VIEW_TIME','COURSE_ID','COURSE_NAME','STUDENT_ID','TERM_CODE','SESSION_NAME','DURATION')]
#There are only 7 unique term codes for NON OU 2020
#Easier to divide into subsets and then apply date division

sesOrderSP1 =subset(originalCreation2, TERM_CODE == 'SP1')
sesOrderSP2 =subset(originalCreation2, TERM_CODE == 'SP2')
sesOrderSP3 =subset(originalCreation2, TERM_CODE == 'SP3')
sesOrderSP4 = subset(originalCreation2, TERM_CODE == 'SP4')
sesOrderSP5 =subset(originalCreation2, TERM_CODE == 'SP5')
sesOrderSP6 = subset(originalCreation2, TERM_CODE == 'SP6')
sesOrderSP7 =subset(originalCreation2, TERM_CODE == 'SP7')

sesOrderSP1 = sesOrderSP1[match(unique(sesOrderSP1$SESSION_NAME), sesOrderSP1$SESSION_NAME),]
sesOrderSP2 = sesOrderSP2[match(unique(sesOrderSP2$SESSION_NAME), sesOrderSP2$SESSION_NAME),]
sesOrderSP3 = sesOrderSP3[match(unique(sesOrderSP3$SESSION_NAME), sesOrderSP3$SESSION_NAME),]
sesOrderSP4 = sesOrderSP4[match(unique(sesOrderSP4$SESSION_NAME), sesOrderSP4$SESSION_NAME),]
sesOrderSP5 = sesOrderSP5[match(unique(sesOrderSP5$SESSION_NAME), sesOrderSP5$SESSION_NAME),]
sesOrderSP6 = sesOrderSP6[match(unique(sesOrderSP6$SESSION_NAME), sesOrderSP6$SESSION_NAME),]
sesOrderSP7 = sesOrderSP7[match(unique(sesOrderSP7$SESSION_NAME), sesOrderSP7$SESSION_NAME),]


sesOrderSP1=sesOrderSP1[with(sesOrderSP1, order(COURSE_ID,(sesOrderSP1$VIEW_TIME))),]
sesOrderSP2=sesOrderSP2[with(sesOrderSP2, order(COURSE_ID,(sesOrderSP2$VIEW_TIME))),]
sesOrderSP3=sesOrderSP3[with(sesOrderSP3, order(COURSE_ID,(sesOrderSP3$VIEW_TIME))),]
sesOrderSP4=sesOrderSP4[with(sesOrderSP4, order(COURSE_ID,(sesOrderSP4$VIEW_TIME))),]
sesOrderSP5=sesOrderSP5[with(sesOrderSP5, order(COURSE_ID,(sesOrderSP5$VIEW_TIME))),]
sesOrderSP6=sesOrderSP6[with(sesOrderSP6, order(COURSE_ID,(sesOrderSP6$VIEW_TIME))),]
sesOrderSP7=sesOrderSP7[with(sesOrderSP7, order(COURSE_ID,(sesOrderSP7$VIEW_TIME))),]

#Divide dates:

#SP1: Core teaching and assessment period 
#(Up to Census date) 13/01/2020 to 31/01/2020 [Early]
#(All the weeks between) 1/02/2020 to 8/03/2020 [Mid]
#(Two weeks before exams and exam period) 9/03/2020 to 27/03/2020 [Late]

sesOrderSP1<-sesOrderSP1%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/01/31") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/02/1") & DAY_DATE<= as.POSIXct("2020/03/8") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/03/9")  ~ 'Late',
  TRUE~'Mid'
))

#SP2: Core teaching and assessment period 
#(Up to Census date) 2/03/2020 to 31/03/2020 [Early]
#(All the weeks between) 1/04/2020 to 5/06/2020 [Mid]
#(Two weeks before exams and exam period) 6/06/2020 to 4/07/2020 [Late]

sesOrderSP2<-sesOrderSP2%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/03/31") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/04/1") & DAY_DATE<= as.POSIXct("2020/06/5") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/06/6")  ~ 'Late',
  TRUE~'Mid'
))



#SP3: Core teaching and assessment period 6/04/2020 to 19/06/2020
#(Up to Census date) 6/04/2020 to 24/04/2020 [Early] (~week1-week3)
#(All the weeks between) 25/04/2020 to 31/05/2020 [Mid] (~week4-week9)
#(Two weeks before exams and exam period) 1/06/2020 to 19/06/2020 [Late] (~week10-Week13)

sesOrderSP3<-sesOrderSP3%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/04/24") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/04/25") & DAY_DATE<= as.POSIXct("2020/05/31") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/06/1")  ~ 'Late',
  TRUE~'Mid'
))

#SP4: Core teaching and assessment period 15/06/2020 to 11/09/2020
#(Up to Census date) 15/06/2020 to 17/07/2020 [Early]
#(All the weeks between) 18/07/2020 to 23/08/2020 [Mid]
#(Two weeks before exams and exam period) 24/08/2020 to 11/09/2020 [Late]

sesOrderSP4<-sesOrderSP4%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/07/17") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/07/18") & DAY_DATE<= as.POSIXct("2020/08/23") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/08/24")  ~ 'Late',
  TRUE~'Mid'
))

#SP5: Core teaching and assessment period 
#(Up to Census date) 27/07/2020 to 31/08/2020 [Early]
#(All the weeks between) 1/09/2020 to 30/10/2020 [Mid]
#(Two weeks before exams and exam period) 31/10/2020 to 28/11/2020 [Late]

sesOrderSP5<-sesOrderSP5%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/08/31") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/09/1") & DAY_DATE<= as.POSIXct("2020/10/30") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/10/31")  ~ 'Late',
  TRUE~'Mid'
))


#SP6: Core teaching and assessment period 21/09/2020 to 04/12/2020
#(Up to Census date) 21/09/2020 to 9/10/2020 [Early]
#(All the weeks between) 10/10/2020 to 15/11/2020 [Mid]
#(Two weeks before exams and exam period) 16/11/2020 to 04/12/2020 [Late]

sesOrderSP6<-sesOrderSP6%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/10/9") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/10/10") & DAY_DATE<= as.POSIXct("2020/11/15") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2020/11/16")  ~ 'Late',
  TRUE~'Mid'
))

#SP7: Core teaching and assessment period 
#(Up to Census date) 2/11/2020 to 18/12/2020 [Early]
#(All the weeks between) 19/12/2020 to 18/01/2021 [Mid]
#(Two weeks before exams and exam period) 19/01/2021 to 6/02/2021 [Late]

sesOrderSP7<-sesOrderSP7%>%mutate(SESSION_PERIOD = case_when(
  DAY_DATE<=as.POSIXct("2020/12/18") ~ 'Early',
  DAY_DATE>=as.POSIXct("2020/12/19") & DAY_DATE<= as.POSIXct("2021/01/18") ~ 'Mid',
  DAY_DATE>=as.POSIXct("2021/01/19")  ~ 'Late',
  TRUE~'Mid'
))


#Lastly merge everything back into ttotalOU2020
sesOrder=rbind(sesOrderSP1,sesOrderSP2,sesOrderSP3,sesOrderSP4,sesOrderSP5,sesOrderSP6,sesOrderSP7)
sesOrder=sesOrder[,c('COURSE_ID','TERM_CODE','SESSION_NAME','SESSION_PERIOD')]
#ttotalCam2020 = merge(totalCam2020,sesOrder,by=c('TERM_CODE','COURSE_ID','SESSION_NAME'),all.x = TRUE)  #CODE RERUN STARTING POINT
ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(sesOrder, by=c('TERM_CODE','COURSE_ID','SESSION_NAME'))

#Afterwards for ttotalOU2020 there are 0.01859473 NAs, idk why this is so I am just going to replace with the most common level
ttotalCam2020$SESSION_PERIOD[is.na(ttotalCam2020$SESSION_PERIOD)] = 'Mid'



#7.3 Grouping Duration - see above

###########7.4.2.Total proportion of (unique) short,mid, long sessions watched

#7.4.2.1.Total short,mid,long sessions in course per term - See Above

#7.4.2.2 Total short, mid,long sessions watched
#Here we take only unique videos 

creationStorage = ttotalOU2020[!duplicated(ttotalOU2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME')]),]
creationStorageShortWatch = creationStorage[creationStorage$DURATION2=='Short',]
creationStorageMediumWatch = creationStorage[creationStorage$DURATION2=='Medium',]
creationStorageLongWatch = creationStorage[creationStorage$DURATION2=='Long',]

originalCreationShortWatch =aggregate(x = creationStorageShortWatch[c("DURATION2")], by = creationStorageShortWatch[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatch =aggregate(x = creationStorageMediumWatch[c("DURATION2")], by = creationStorageMediumWatch[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatch =aggregate(x = creationStorageLongWatch[c("DURATION2")], by = creationStorageLongWatch[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = length)


names(originalCreationShortWatch)[4] <- "SHORT_SESSIONS_WATCHED"
names(originalCreationMediumWatch)[4] <- "MEDIUM_SESSIONS_WATCHED"
names(originalCreationLongWatch)[4] <- "LONG_SESSIONS_WATCHED"


ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(originalCreationShortWatch, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumWatch, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
ttotalOU2020 <- ttotalOU2020 %>%
  dplyr::left_join(originalCreationLongWatch, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))



ttotalOU2020[is.na(ttotalOU2020)] <- 0

ttotalOU2020$PROPORTION_SHORT_SESSION_WATCHED = (ttotalOU2020$SHORT_SESSIONS_WATCHED/ttotalOU2020$TOTAL_SHORT_SESSIONS)
ttotalOU2020$PROPORTION_MEDIUM_SESSION_WATCHED =(ttotalOU2020$MEDIUM_SESSIONS_WATCHED/ttotalOU2020$TOTAL_MEDIUM_SESSIONS)
ttotalOU2020$PROPORTION_LONG_SESSION_WATCHED = (ttotalOU2020$LONG_SESSIONS_WATCHED/ttotalOU2020$TOTAL_LONG_SESSIONS)
#Replacing Nas with 0
ttotalOU2020[is.na(ttotalOU2020)] <- 0


#--------------------------------------------------------------------------------------------------------------------------------------------------
creationStorage = ttotalCam2020[!duplicated(ttotalCam2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME')]),]
creationStorageShortWatch = creationStorage[creationStorage$DURATION2=='Short',]
creationStorageMediumWatch = creationStorage[creationStorage$DURATION2=='Medium',]
creationStorageLongWatch = creationStorage[creationStorage$DURATION2=='Long',]

originalCreationShortWatch =aggregate(x = creationStorageShortWatch[c("DURATION2")], by = creationStorageShortWatch[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatch =aggregate(x = creationStorageMediumWatch[c("DURATION2")], by = creationStorageMediumWatch[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatch =aggregate(x = creationStorageLongWatch[c("DURATION2")], by = creationStorageLongWatch[c("STUDENT_ID","COURSE_ID","TERM_CODE")], FUN = length)


names(originalCreationShortWatch)[4] <- "SHORT_SESSIONS_WATCHED"
names(originalCreationMediumWatch)[4] <- "MEDIUM_SESSIONS_WATCHED"
names(originalCreationLongWatch)[4] <- "LONG_SESSIONS_WATCHED"

ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(originalCreationShortWatch, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumWatch, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
ttotalCam2020 <- ttotalCam2020 %>%
  dplyr::left_join(originalCreationLongWatch, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
ttotalCam2020[is.na(ttotalCam2020)] <- 0

ttotalCam2020$PROPORTION_SHORT_SESSION_WATCHED = (ttotalCam2020$SHORT_SESSIONS_WATCHED/ttotalCam2020$TOTAL_SHORT_SESSIONS)
ttotalCam2020$PROPORTION_MEDIUM_SESSION_WATCHED =(ttotalCam2020$MEDIUM_SESSIONS_WATCHED/ttotalCam2020$TOTAL_MEDIUM_SESSIONS)
ttotalCam2020$PROPORTION_LONG_SESSION_WATCHED = (ttotalCam2020$LONG_SESSIONS_WATCHED/ttotalCam2020$TOTAL_LONG_SESSIONS)
#Replacing Nas with 0 for #/0 division 
ttotalCam2020[is.na(ttotalCam2020)] <- 0


#7.5 Session length and course periods


#7.5.1 Setting course periods
#This would be the same as session period initially but changes depending on first occurrence of "Mid" and "Late" respectively

tttotalOU2020<-ttotalOU2020%>%mutate(COURSE_PERIOD = case_when(
  TERM_CODE=='SP1'& (DAY_DATE <= as.POSIXct("2020/01/31")) ~ 'Early',
  TERM_CODE=='SP1'& (as.POSIXct("2020/02/1") >= DAY_DATE & DAY_DATE <= as.POSIXct("2020/03/8"))~ 'Mid',
  TERM_CODE=='SP1'& (DAY_DATE > as.POSIXct("2020/03/8"))  ~ 'Late',
  
  TERM_CODE=='SP2'& (DAY_DATE <= as.POSIXct("2020/03/31")) ~ 'Early',
  TERM_CODE=='SP2'& (as.POSIXct("2020/04/1") >= DAY_DATE & DAY_DATE <= as.POSIXct("2020/06/5"))~ 'Mid',
  TERM_CODE=='SP2'& (DAY_DATE > as.POSIXct("2020/06/5"))  ~ 'Late',
  
  TERM_CODE=='SP3'& (DAY_DATE <= as.POSIXct("2020/04/24")) ~ 'Early',
  TERM_CODE=='SP3'& (as.POSIXct("2020/04/25") >= DAY_DATE & DAY_DATE <= as.POSIXct("2020/05/31"))~ 'Mid',
  TERM_CODE=='SP3'& (DAY_DATE > as.POSIXct("2020/05/31"))  ~ 'Late',
  
  TERM_CODE=='SP4'& (DAY_DATE <= as.POSIXct("2020/07/17")) ~ 'Early',
  TERM_CODE=='SP4'& (as.POSIXct("2020/07/18") >= DAY_DATE & DAY_DATE <= as.POSIXct("2020/08/23"))~ 'Mid',
  TERM_CODE=='SP4'& (DAY_DATE > as.POSIXct("2020/08/23"))  ~ 'Late',
  
  TERM_CODE=='SP5'& (DAY_DATE <= as.POSIXct("2020/08/31")) ~ 'Early',
  TERM_CODE=='SP5'& (as.POSIXct("2020/09/1") >= DAY_DATE & DAY_DATE <= as.POSIXct("2020/10/30"))~ 'Mid',
  TERM_CODE=='SP5'& (DAY_DATE > as.POSIXct("2020/10/30"))  ~ 'Late',
  
  TERM_CODE=='SP6'& (DAY_DATE <= as.POSIXct("2020/10/9")) ~ 'Early',
  TERM_CODE=='SP6'& (as.POSIXct("2020/10/10") >= DAY_DATE & DAY_DATE <= as.POSIXct("2020/11/15"))~ 'Mid',
  TERM_CODE=='SP6'& (DAY_DATE > as.POSIXct("2020/11/15"))  ~ 'Late',
  
  TERM_CODE=='SP7'& (DAY_DATE <= as.POSIXct("2020/12/18")) ~ 'Early',
  TERM_CODE=='SP7'& (as.POSIXct("2020/12/19") >= DAY_DATE & DAY_DATE <= as.POSIXct("2021/01/18"))~ 'Mid',
  TERM_CODE=='SP7'& (DAY_DATE > as.POSIXct("2021/01/18"))  ~ 'Late',
  TRUE~SESSION_PERIOD
))


#--------------------------------------------------------------------------------------------------------------------------------------------------

tttotalCam2020<-ttotalCam2020%>%mutate(COURSE_PERIOD = case_when(
  TERM_CODE=='SP1'& (DAY_DATE <= as.POSIXlt("2020-01-31",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP1'& (as.POSIXlt("2020-02-1",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2020-03-8",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP1'& (DAY_DATE > as.POSIXlt("2020-03-8",format="%Y-%m-%d"))  ~ 'Late',
  
  TERM_CODE=='SP2'& (DAY_DATE <= as.POSIXlt("2020-03-31",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP2'& (as.POSIXlt("2020-04-1",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2020-06-5",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP2'& (DAY_DATE > as.POSIXlt("2020-06-5",format="%Y-%m-%d"))  ~ 'Late',
  
  TERM_CODE=='SP3'& (DAY_DATE <= as.POSIXlt("2020-04-24",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP3'& (as.POSIXlt("2020-04-25",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2020-05-31",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP3'& (DAY_DATE > as.POSIXlt("2020-05-31",format="%Y-%m-%d"))  ~ 'Late',
  
  TERM_CODE=='SP4'& (DAY_DATE <= as.POSIXlt("2020-07-17",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP4'& (as.POSIXlt("2020-07-18",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2020-08-23",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP4'& (DAY_DATE > as.POSIXlt("2020-08-23",format="%Y-%m-%d"))  ~ 'Late',
  
  TERM_CODE=='SP5'& (DAY_DATE <= as.POSIXlt("2020-08-31",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP5'& (as.POSIXlt("2020-09-1",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2020-10-30",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP5'& (DAY_DATE > as.POSIXlt("2020-10-30",format="%Y-%m-%d"))  ~ 'Late',
  
  TERM_CODE=='SP6'& (DAY_DATE <= as.POSIXlt("2020-10-9",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP6'& (as.POSIXlt("2020-10-10",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2020-11-15",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP6'& (DAY_DATE > as.POSIXlt("2020-11-15",format="%Y-%m-%d"))  ~ 'Late',
  
  TERM_CODE=='SP7'& (DAY_DATE <= as.POSIXlt("2020-12-18",format="%Y-%m-%d")) ~ 'Early',
  TERM_CODE=='SP7'& (as.POSIXlt("2020-12-19",format="%Y-%m-%d") >= DAY_DATE & DAY_DATE <= as.POSIXlt("2021-01-18",format="%Y-%m-%d"))~ 'Mid',
  TERM_CODE=='SP7'& (DAY_DATE > as.POSIXlt("2021-01-18",format="%Y-%m-%d"))  ~ 'Late',
  TRUE~SESSION_PERIOD
))

SAFETHIS_OU = tttotalOU2020
SAFETHIS_Cam = tttotalCam2020

#Reload this code for error checking
# tttotalOU2020 = SAFETHIS_OU
# tttotalCam2020 = SAFETHIS_Cam


#All is good from here - RUN FROM HERE DO NOt SCROLL UP AGAIN

#There are 0.3882941 proportion of Nas for some reason in the NON UO data so I am just going to replace with corresponding SESSION_PERIOD as the best approximation
#All the dates are entered correctly so it must be some format or idk what issue.


###########7.5.2.The number of total course short, medium and long sessions in each of the course periods for given term
#FOR A COURSE and sessions THAT WE HAVE USAGE DATA ON!!!!!!
#As it is not possible to find out what period of the course a session belongs too with only the session data and we must use the usage view time
#But the usage view time may not contain all usage data for all the sessions a course has.

creationStorage = tttotalOU2020[!duplicated(tttotalOU2020[,c('COURSE_ID','TERM_CODE','SESSION_NAME')]),]
creationStorageShortSessionsEarly = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageShortSessionsMid = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageShortSessionsLate = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageMediumSessionsEarly = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageMediumSessionsMid = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageMediumSessionsLate = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageLongSessionsEarly = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageLongSessionsMid = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageLongSessionsLate = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Late',]
#OU 2020 had no medium sessions during mid course period so we will later replace the column with all 0
#The errors should be normal and shows that there are no rows.
originalCreationShortSessionsEarly =aggregate(x = creationStorageShortSessionsEarly[c("DURATION2")], by = creationStorageShortSessionsEarly[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortSessionsMid =aggregate(x = creationStorageShortSessionsMid[c("DURATION2")], by = creationStorageShortSessionsMid[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortSessionsLate =aggregate(x = creationStorageShortSessionsLate[c("DURATION2")], by = creationStorageShortSessionsLate[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumSessionsEarly =aggregate(x = creationStorageMediumSessionsEarly[c("DURATION2")], by = creationStorageMediumSessionsEarly[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumSessionsMid =aggregate(x = creationStorageMediumSessionsMid[c("DURATION2")], by = creationStorageMediumSessionsMid[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumSessionsLate =aggregate(x = creationStorageMediumSessionsLate[c("DURATION2")], by = creationStorageMediumSessionsLate[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongSessionsEarly =aggregate(x = creationStorageLongSessionsEarly[c("DURATION2")], by = creationStorageLongSessionsEarly[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongSessionsMid =aggregate(x = creationStorageLongSessionsMid[c("DURATION2")], by = creationStorageLongSessionsMid[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongSessionsLate =aggregate(x = creationStorageLongSessionsLate[c("DURATION2")], by = creationStorageLongSessionsLate[c("COURSE_ID","TERM_CODE")], FUN = length)


names(originalCreationShortSessionsEarly)[3] <- "SHORT_SESSIONS_EARLY_PERIOD"
names(originalCreationShortSessionsMid)[3] <- "SHORT_SESSIONS_MID_PERIOD"
names(originalCreationShortSessionsLate)[3] <- "SHORT_SESSIONS_LATE_PERIOD"
names(originalCreationMediumSessionsEarly)[3] <- "MEDIUM_SESSIONS_EARLY_PERIOD"
names(originalCreationMediumSessionsMid)[3] <- "MEDIUM_SESSIONS_MID_PERIOD"
names(originalCreationMediumSessionsLate)[3] <- "MEDIUM_SESSIONS_LATE_PERIOD"
names(originalCreationLongSessionsEarly)[3] <- "LONG_SESSIONS_EARLY_PERIOD"
names(originalCreationLongSessionsMid)[3] <- "LONG_SESSIONS_MID_PERIOD"
names(originalCreationLongSessionsLate)[3] <- "LONG_SESSIONS_LATE_PERIOD"

tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationShortSessionsEarly, by=c("COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationShortSessionsMid, by=c("COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationShortSessionsLate, by=c("COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumSessionsEarly, by=c("COURSE_ID",'TERM_CODE'))
#tttotalOU2020$MEDIUM_SESSIONS_MID_PERIOD=0

tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumSessionsMid, by=c("COURSE_ID",'TERM_CODE'))


tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumSessionsLate, by=c("COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationLongSessionsEarly, by=c("COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationLongSessionsMid, by=c("COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationLongSessionsLate, by=c("COURSE_ID",'TERM_CODE'))


tttotalOU2020[is.na(tttotalOU2020)] <- 0

#--------------------------------------------------------------------------------------------------------------------------------------------------


creationStorage = tttotalCam2020[!duplicated(tttotalCam2020[,c('COURSE_ID','TERM_CODE','SESSION_NAME')]),]
creationStorageShortSessionsEarly = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageShortSessionsMid = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageShortSessionsLate = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageMediumSessionsEarly = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageMediumSessionsMid = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageMediumSessionsLate = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageLongSessionsEarly = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageLongSessionsMid = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageLongSessionsLate = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Late',]

originalCreationShortSessionsEarly =aggregate(x = creationStorageShortSessionsEarly[c("DURATION2")], by = creationStorageShortSessionsEarly[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortSessionsMid =aggregate(x = creationStorageShortSessionsMid[c("DURATION2")], by = creationStorageShortSessionsMid[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortSessionsLate =aggregate(x = creationStorageShortSessionsLate[c("DURATION2")], by = creationStorageShortSessionsLate[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumSessionsEarly =aggregate(x = creationStorageMediumSessionsEarly[c("DURATION2")], by = creationStorageMediumSessionsEarly[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumSessionsMid =aggregate(x = creationStorageMediumSessionsMid[c("DURATION2")], by = creationStorageMediumSessionsMid[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumSessionsLate =aggregate(x = creationStorageMediumSessionsLate[c("DURATION2")], by = creationStorageMediumSessionsLate[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongSessionsEarly =aggregate(x = creationStorageLongSessionsEarly[c("DURATION2")], by = creationStorageLongSessionsEarly[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongSessionsMid =aggregate(x = creationStorageLongSessionsMid[c("DURATION2")], by = creationStorageLongSessionsMid[c("COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongSessionsLate =aggregate(x = creationStorageLongSessionsLate[c("DURATION2")], by = creationStorageLongSessionsLate[c("COURSE_ID","TERM_CODE")], FUN = length)


names(originalCreationShortSessionsEarly)[3] <- "SHORT_SESSIONS_EARLY_PERIOD"
names(originalCreationShortSessionsMid)[3] <- "SHORT_SESSIONS_MID_PERIOD"
names(originalCreationShortSessionsLate)[3] <- "SHORT_SESSIONS_LATE_PERIOD"
names(originalCreationMediumSessionsEarly)[3] <- "MEDIUM_SESSIONS_EARLY_PERIOD"
names(originalCreationMediumSessionsMid)[3] <- "MEDIUM_SESSIONS_MID_PERIOD"
names(originalCreationMediumSessionsLate)[3] <- "MEDIUM_SESSIONS_LATE_PERIOD"
names(originalCreationLongSessionsEarly)[3] <- "LONG_SESSIONS_EARLY_PERIOD"
names(originalCreationLongSessionsMid)[3] <- "LONG_SESSIONS_MID_PERIOD"
names(originalCreationLongSessionsLate)[3] <- "LONG_SESSIONS_LATE_PERIOD"

# 
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationShortSessionsEarly, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationShortSessionsMid, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationShortSessionsLate, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationMediumSessionsEarly, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationMediumSessionsMid, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationMediumSessionsLate, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationLongSessionsEarly, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationLongSessionsMid, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationLongSessionsLate, by = c("COURSE_ID",'TERM_CODE'), all.x = TRUE)

tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationShortSessionsEarly, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationShortSessionsMid, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationShortSessionsLate, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumSessionsEarly, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumSessionsMid, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumSessionsLate, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationLongSessionsEarly, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationLongSessionsMid, by=c("COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationLongSessionsLate, by=c("COURSE_ID",'TERM_CODE'))

tttotalCam2020[is.na(tttotalCam2020)] <- 0


###########7.5.3.The number of total course short, medium and long sessions WATCHED BY STUDENT in each of the course periods for given term
#only counting unique sessions watched by student

creationStorage = tttotalOU2020[!duplicated(tttotalOU2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME')]),]
creationStorageShortWatchEarly = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageShortWatchMid = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageShortWatchLate = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageMediumWatchEarly = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageMediumWatchMid = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageMediumWatchLate = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageLongWatchEarly = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageLongWatchMid = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageLongWatchLate = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Late',]

originalCreationShortWatchEarly =aggregate(x = creationStorageShortWatchEarly[c("DURATION2")], by = creationStorageShortWatchEarly[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortWatchMid =aggregate(x = creationStorageShortWatchMid[c("DURATION2")], by = creationStorageShortWatchMid[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortWatchLate =aggregate(x = creationStorageShortWatchLate[c("DURATION2")], by = creationStorageShortWatchLate[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatchEarly =aggregate(x = creationStorageMediumWatchEarly[c("DURATION2")], by = creationStorageMediumWatchEarly[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatchMid =aggregate(x = creationStorageMediumWatchMid[c("DURATION2")], by = creationStorageMediumWatchMid[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatchLate =aggregate(x = creationStorageMediumWatchLate[c("DURATION2")], by = creationStorageMediumWatchLate[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatchEarly =aggregate(x = creationStorageLongWatchEarly[c("DURATION2")], by = creationStorageLongWatchEarly[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatchMid =aggregate(x = creationStorageLongWatchMid[c("DURATION2")], by = creationStorageLongWatchMid[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatchLate =aggregate(x = creationStorageLongWatchLate[c("DURATION2")], by = creationStorageLongWatchLate[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)


names(originalCreationShortWatchEarly)[4] <- "SHORT_WATCH_EARLY_PERIOD"
names(originalCreationShortWatchMid)[4] <- "SHORT_WATCH_MID_PERIOD"
names(originalCreationShortWatchLate)[4] <- "SHORT_WATCH_LATE_PERIOD"
names(originalCreationMediumWatchEarly)[4] <- "MEDIUM_WATCH_EARLY_PERIOD"
names(originalCreationMediumWatchMid)[4] <- "MEDIUM_WATCH_MID_PERIOD"
names(originalCreationMediumWatchLate)[4] <- "MEDIUM_WATCH_LATE_PERIOD"
names(originalCreationLongWatchEarly)[4] <- "LONG_WATCH_EARLY_PERIOD"
names(originalCreationLongWatchMid)[4] <- "LONG_WATCH_MID_PERIOD"
names(originalCreationLongWatchLate)[4] <- "LONG_WATCH_LATE_PERIOD"


# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationShortWatchEarly, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationShortWatchMid, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationShortWatchLate, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationMediumWatchEarly, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationMediumWatchMid, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationMediumWatchLate, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationLongWatchEarly, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationLongWatchMid, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalOU2020=merge(x = tttotalOU2020, y = originalCreationLongWatchLate, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)


tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationShortWatchEarly, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationShortWatchMid, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationShortWatchLate, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumWatchEarly, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumWatchMid, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationMediumWatchLate, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationLongWatchEarly, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationLongWatchMid, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(originalCreationLongWatchLate, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))


tttotalOU2020[is.na(tttotalOU2020)] <- 0

#--------------------------------------------------------------------------------------------------------------------------------------------------


creationStorage = tttotalCam2020[!duplicated(tttotalCam2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME')]),]
creationStorageShortWatchEarly = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageShortWatchMid = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageShortWatchLate = creationStorage[creationStorage$DURATION2=='Short'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageMediumWatchEarly = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageMediumWatchMid = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageMediumWatchLate = creationStorage[creationStorage$DURATION2=='Medium'& creationStorage$COURSE_PERIOD=='Late',]
creationStorageLongWatchEarly = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Early',]
creationStorageLongWatchMid = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Mid',]
creationStorageLongWatchLate = creationStorage[creationStorage$DURATION2=='Long'& creationStorage$COURSE_PERIOD=='Late',]

originalCreationShortWatchEarly =aggregate(x = creationStorageShortWatchEarly[c("DURATION2")], by = creationStorageShortWatchEarly[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortWatchMid =aggregate(x = creationStorageShortWatchMid[c("DURATION2")], by = creationStorageShortWatchMid[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationShortWatchLate =aggregate(x = creationStorageShortWatchLate[c("DURATION2")], by = creationStorageShortWatchLate[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatchEarly =aggregate(x = creationStorageMediumWatchEarly[c("DURATION2")], by = creationStorageMediumWatchEarly[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatchMid =aggregate(x = creationStorageMediumWatchMid[c("DURATION2")], by = creationStorageMediumWatchMid[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationMediumWatchLate =aggregate(x = creationStorageMediumWatchLate[c("DURATION2")], by = creationStorageMediumWatchLate[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatchEarly =aggregate(x = creationStorageLongWatchEarly[c("DURATION2")], by = creationStorageLongWatchEarly[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatchMid =aggregate(x = creationStorageLongWatchMid[c("DURATION2")], by = creationStorageLongWatchMid[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)
originalCreationLongWatchLate =aggregate(x = creationStorageLongWatchLate[c("DURATION2")], by = creationStorageLongWatchLate[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = length)


names(originalCreationShortWatchEarly)[4] <- "SHORT_WATCH_EARLY_PERIOD"
names(originalCreationShortWatchMid)[4] <- "SHORT_WATCH_MID_PERIOD"
names(originalCreationShortWatchLate)[4] <- "SHORT_WATCH_LATE_PERIOD"
names(originalCreationMediumWatchEarly)[4] <- "MEDIUM_WATCH_EARLY_PERIOD"
names(originalCreationMediumWatchMid)[4] <- "MEDIUM_WATCH_MID_PERIOD"
names(originalCreationMediumWatchLate)[4] <- "MEDIUM_WATCH_LATE_PERIOD"
names(originalCreationLongWatchEarly)[4] <- "LONG_WATCH_EARLY_PERIOD"
names(originalCreationLongWatchMid)[4] <- "LONG_WATCH_MID_PERIOD"
names(originalCreationLongWatchLate)[4] <- "LONG_WATCH_LATE_PERIOD"


# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationShortWatchEarly, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationShortWatchMid, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationShortWatchLate, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationMediumWatchEarly, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationMediumWatchMid, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationMediumWatchLate, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationLongWatchEarly, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationLongWatchMid, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)
# tttotalCam2020=merge(x = tttotalCam2020, y = originalCreationLongWatchLate, by = c('STUDENT_ID',"COURSE_ID",'TERM_CODE'), all.x = TRUE)



tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationShortWatchEarly, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationShortWatchMid, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationShortWatchLate, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumWatchEarly, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumWatchMid, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationMediumWatchLate, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationLongWatchEarly, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationLongWatchMid, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))
tttotalCam2020 <- tttotalCam2020 %>%
  dplyr::left_join(originalCreationLongWatchLate, by=c('STUDENT_ID',"COURSE_ID",'TERM_CODE'))

tttotalCam2020[is.na(tttotalCam2020)] <- 0



###########7.5.4.Number of sessions each course period

tttotalOU2020$SESSIONS_EARLY_PERIOD<-rowSums(tttotalOU2020[,c('SHORT_SESSIONS_EARLY_PERIOD','MEDIUM_SESSIONS_EARLY_PERIOD','LONG_SESSIONS_EARLY_PERIOD')])
# tttotalOU2020$LONG_SESSIONS_MID_PERIOD=0 #why did i have this uncommented before?
# tttotalOU2020$SHORT_SESSIONS_MID_PERIOD=0
# tttotalOU2020$MEDIUM_SESSIONS_MID_PERIOD=0
tttotalOU2020$SESSIONS_MID_PERIOD<-rowSums(tttotalOU2020[,c('SHORT_SESSIONS_MID_PERIOD','MEDIUM_SESSIONS_MID_PERIOD','LONG_SESSIONS_MID_PERIOD')])
tttotalOU2020$SESSIONS_LATE_PERIOD<-rowSums(tttotalOU2020[,c('SHORT_SESSIONS_LATE_PERIOD','MEDIUM_SESSIONS_LATE_PERIOD','LONG_SESSIONS_LATE_PERIOD')])
#--------------------------------------------------------------------------------------------------------------------------------------------------
tttotalCam2020$SESSIONS_EARLY_PERIOD<-rowSums(tttotalCam2020[,c('SHORT_SESSIONS_EARLY_PERIOD','MEDIUM_SESSIONS_EARLY_PERIOD','LONG_SESSIONS_EARLY_PERIOD')])
tttotalCam2020$SESSIONS_MID_PERIOD<-rowSums(tttotalCam2020[,c('SHORT_SESSIONS_MID_PERIOD','MEDIUM_SESSIONS_MID_PERIOD','LONG_SESSIONS_MID_PERIOD')])
tttotalCam2020$SESSIONS_LATE_PERIOD<-rowSums(tttotalCam2020[,c('SHORT_SESSIONS_LATE_PERIOD','MEDIUM_SESSIONS_LATE_PERIOD','LONG_SESSIONS_LATE_PERIOD')])

###########7.5.5.The total proportion of videos watched in each of the course periods

tttotalOU2020$SESSIONS_EARLY_PERIOD_WATCHED<-rowSums(tttotalOU2020[,c('SHORT_WATCH_EARLY_PERIOD','MEDIUM_WATCH_EARLY_PERIOD','LONG_WATCH_EARLY_PERIOD')])
tttotalOU2020$SESSIONS_MID_PERIOD_WATCHED<-rowSums(tttotalOU2020[,c('SHORT_WATCH_MID_PERIOD','MEDIUM_WATCH_MID_PERIOD','LONG_WATCH_MID_PERIOD')])
tttotalOU2020$SESSIONS_LATE_PERIOD_WATCHED<-rowSums(tttotalOU2020[,c('SHORT_WATCH_LATE_PERIOD','MEDIUM_WATCH_LATE_PERIOD','LONG_WATCH_LATE_PERIOD')])
tttotalOU2020$PROPORTION_SESSION_EARLY_PERIOD_WATCHED= (tttotalOU2020$SESSIONS_EARLY_PERIOD_WATCHED/tttotalOU2020$SESSIONS_EARLY_PERIOD)
tttotalOU2020$PROPORTION_SESSION_MID_PERIOD_WATCHED= (tttotalOU2020$SESSIONS_MID_PERIOD_WATCHED/tttotalOU2020$SESSIONS_MID_PERIOD)
tttotalOU2020$PROPORTION_SESSION_LATE_PERIOD_WATCHED= (tttotalOU2020$SESSIONS_LATE_PERIOD_WATCHED/tttotalOU2020$SESSIONS_LATE_PERIOD)
tttotalOU2020[is.na(tttotalOU2020)] <- 0
#--------------------------------------------------------------------------------------------------------------------------------------------------
tttotalCam2020$SESSIONS_EARLY_PERIOD_WATCHED<-rowSums(tttotalCam2020[,c('SHORT_WATCH_EARLY_PERIOD','MEDIUM_WATCH_EARLY_PERIOD','LONG_WATCH_EARLY_PERIOD')])
tttotalCam2020$SESSIONS_MID_PERIOD_WATCHED<-rowSums(tttotalCam2020[,c('SHORT_WATCH_MID_PERIOD','MEDIUM_WATCH_MID_PERIOD','LONG_WATCH_MID_PERIOD')])
tttotalCam2020$SESSIONS_LATE_PERIOD_WATCHED<-rowSums(tttotalCam2020[,c('SHORT_WATCH_LATE_PERIOD','MEDIUM_WATCH_LATE_PERIOD','LONG_WATCH_LATE_PERIOD')])
tttotalCam2020$PROPORTION_SESSION_EARLY_PERIOD_WATCHED= (tttotalCam2020$SESSIONS_EARLY_PERIOD_WATCHED/tttotalCam2020$SESSIONS_EARLY_PERIOD)
tttotalCam2020$PROPORTION_SESSION_MID_PERIOD_WATCHED= (tttotalCam2020$SESSIONS_MID_PERIOD_WATCHED/tttotalCam2020$SESSIONS_MID_PERIOD)
tttotalCam2020$PROPORTION_SESSION_LATE_PERIOD_WATCHED= (tttotalCam2020$SESSIONS_LATE_PERIOD_WATCHED/tttotalCam2020$SESSIONS_LATE_PERIOD)
tttotalCam2020[is.na(tttotalCam2020)] <- 0


#EVERYTHING IS GOOD above HERE AS WELL


###########7.5.6.Proportion of early period sessions re-watched early period
###########7.5.7.Proportion of early period sessions re-watched mid period
###########7.5.8.Proportion of early period sessions re-watched late period
###########7.5.9.Proportion of mid period sessions re-watched mid period
###########7.5.10.Proportion of mid period sessions re-watched late period
###########7.5.11.Proportion of late period sessions re-watched late period

#removing duplicate sessions that have same view time as we can't yet explain
originalCreation = tttotalOU2020[!duplicated(tttotalOU2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME','VIEW_TIME')]),]
#Then order:
#We order by 
#VIEW_TIME
#TERM_CODE
#COURSE_ID
#STUDENT_ID
originalCreation=originalCreation[with(originalCreation, order(VIEW_TIME,TERM_CODE,COURSE_ID,STUDENT_ID)),]
originalCreation = originalCreation[,c('VIEW_TIME','TERM_CODE','COURSE_ID','STUDENT_ID','SESSION_NAME','SESSION_PERIOD','COURSE_PERIOD')]
creationStorage = data.frame(COURSE_ID=as.character(),TERM_CODE=as.character(),STUDENT_ID=as.character(),
                             EARLY_SESSIONS_REWATCHED_EARLY_PERIOD=integer(),EARLY_SESSIONS_REWATCHED_MID_PERIOD=integer(),
                             EARLY_SESSIONS_REWATCHED_LATE_PERIOD=integer(),MID_SESSIONS_REWATCHED_MID_PERIOD=integer(),
                             MID_SESSIONS_REWATCHED_LATE_PERIOD=integer(),LATE_SESSIONS_REWATCHED_LATE_PERIOD=integer(),temp=as.character(),stringsAsFactors=FALSE)
#Possible scenarios:
#COURSE_PERIOD-SESSION_PERIOD
#EARLY-EARLY
#MID-EARLY
#MID-MID
#LATE-EARLY
#LATE-MID
#LATE-LATE

for (row in 1:nrow(originalCreation)) {
  
  courseID <- originalCreation[row, "COURSE_ID"]
  termCode <- originalCreation[row, "TERM_CODE"]
  sessionPeriod <- originalCreation[row, "SESSION_PERIOD"]
  coursePeriod <- originalCreation[row, 'COURSE_PERIOD']
  studentID <- originalCreation[row,'STUDENT_ID']
  
  toFind=paste(courseID, termCode,studentID)
  #if course and term code in the data
  if(toFind %in% creationStorage$temp){
    
    if(coursePeriod=='Early' & sessionPeriod=='Early'){
      tempVar=creationStorage[creationStorage$temp==toFind, "EARLY_SESSIONS_REWATCHED_EARLY_PERIOD"]
      creationStorage[creationStorage$temp==toFind, "EARLY_SESSIONS_REWATCHED_EARLY_PERIOD"]=tempVar+1
    }
    if(coursePeriod=='Mid' & sessionPeriod=='Early'){
      tempVar=creationStorage[creationStorage$temp==toFind, "EARLY_SESSIONS_REWATCHED_MID_PERIOD"]
      creationStorage[creationStorage$temp==toFind, "EARLY_SESSIONS_REWATCHED_MID_PERIOD"]=tempVar+1
    }
    if(coursePeriod=='Mid' & sessionPeriod=='Mid'){
      tempVar=creationStorage[creationStorage$temp==toFind, "MID_SESSIONS_REWATCHED_MID_PERIOD"]
      creationStorage[creationStorage$temp==toFind, "MID_SESSIONS_REWATCHED_MID_PERIOD"]=tempVar+1
    }
    if(coursePeriod=='Late' & sessionPeriod=='Early'){
      tempVar=creationStorage[creationStorage$temp==toFind, "EARLY_SESSIONS_REWATCHED_LATE_PERIOD"]
      creationStorage[creationStorage$temp==toFind, "EARLY_SESSIONS_REWATCHED_LATE_PERIOD"]=tempVar+1
    }
    if(coursePeriod=='Late' & sessionPeriod=='Mid'){
      tempVar=creationStorage[creationStorage$temp==toFind, "MID_SESSIONS_REWATCHED_LATE_PERIOD"]
      creationStorage[creationStorage$temp==toFind, "MID_SESSIONS_REWATCHED_LATE_PERIOD"]=tempVar+1
    }
    if(coursePeriod=='Late' & sessionPeriod=='Late'){
      tempVar=creationStorage[creationStorage$temp==toFind, "LATE_SESSIONS_REWATCHED_LATE_PERIOD"]
      creationStorage[creationStorage$temp==toFind, "LATE_SESSIONS_REWATCHED_LATE_PERIOD"]=tempVar+1
    }
    
  }
  else{
    #Accepting new course ID for a term code for a student
    #This initially starts at 0 but shouldn't matter that much as we are only 1 session off from true count
    temp<-data.frame(courseID,termCode,studentID,0,0,0,0,0,0, toFind)
    names(temp)<-c('COURSE_ID','TERM_CODE','STUDENT_ID','EARLY_SESSIONS_REWATCHED_EARLY_PERIOD','EARLY_SESSIONS_REWATCHED_MID_PERIOD',
                   'EARLY_SESSIONS_REWATCHED_LATE_PERIOD','MID_SESSIONS_REWATCHED_MID_PERIOD',
                   'MID_SESSIONS_REWATCHED_LATE_PERIOD','LATE_SESSIONS_REWATCHED_LATE_PERIOD','temp')
    creationStorage <- rbind(creationStorage, temp)
    
  }
  
}
creationStorage$temp=NULL
# tttotalOU2020=merge(tttotalOU2020,creationStorage,by=c('TERM_CODE','COURSE_ID','STUDENT_ID'),all.x = TRUE)
tttotalOU2020 <- tttotalOU2020 %>%
  dplyr::left_join(creationStorage, by=c('TERM_CODE','COURSE_ID','STUDENT_ID'))


tttotalOU2020$PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD=(tttotalOU2020$EARLY_SESSIONS_REWATCHED_EARLY_PERIOD/tttotalOU2020$SESSIONS_EARLY_PERIOD)
tttotalOU2020$PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD=(tttotalOU2020$EARLY_SESSIONS_REWATCHED_MID_PERIOD/tttotalOU2020$SESSIONS_EARLY_PERIOD)
tttotalOU2020$PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD=(tttotalOU2020$EARLY_SESSIONS_REWATCHED_LATE_PERIOD/tttotalOU2020$SESSIONS_EARLY_PERIOD)
tttotalOU2020$PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD=(tttotalOU2020$MID_SESSIONS_REWATCHED_MID_PERIOD/tttotalOU2020$SESSIONS_MID_PERIOD)
tttotalOU2020$PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD=(tttotalOU2020$MID_SESSIONS_REWATCHED_LATE_PERIOD/tttotalOU2020$SESSIONS_MID_PERIOD)
tttotalOU2020$PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD=(tttotalOU2020$LATE_SESSIONS_REWATCHED_LATE_PERIOD/tttotalOU2020$SESSIONS_LATE_PERIOD)
tttotalOU2020[is.na(tttotalOU2020)] <- 0

#--------------------------------------------------------------------------------------------------------------------------------------------------
SAVEPOINT = tttotalCam2020
# tttotalCam2020 = SAVEPOINT

#removing duplicate sessions that have same view time as we can't yet explain
originalCreation = tttotalCam2020[!duplicated(tttotalCam2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE','SESSION_NAME','VIEW_TIME')]),c('VIEW_TIME','TERM_CODE','COURSE_ID','STUDENT_ID','SESSION_NAME','SESSION_PERIOD','COURSE_PERIOD')]
#Then order:
#We order by
#VIEW_TIME
#TERM_CODE
#COURSE_ID
#STUDENT_ID
originalCreation2=originalCreation[with(originalCreation, order(VIEW_TIME,TERM_CODE,COURSE_ID,STUDENT_ID)),]
originalCreation2 = originalCreation2[,c('VIEW_TIME','TERM_CODE','COURSE_ID','STUDENT_ID','SESSION_NAME','SESSION_PERIOD','COURSE_PERIOD')]
originalCreation2$temp = 'woops'
originalCreation2$EARLY_SESSIONS_REWATCHED_EARLY_PERIOD=0
originalCreation2$EARLY_SESSIONS_REWATCHED_MID_PERIOD=0
originalCreation2$EARLY_SESSIONS_REWATCHED_LATE_PERIOD=0
originalCreation2$MID_SESSIONS_REWATCHED_MID_PERIOD=0
originalCreation2$MID_SESSIONS_REWATCHED_LATE_PERIOD=0
originalCreation2$LATE_SESSIONS_REWATCHED_LATE_PERIOD=0

#originalCreation$#Possible scenarios:
#COURSE_PERIOD-SESSION_PERIOD
#EARLY-EARLY
#MID-EARLY
#MID-MID
#LATE-EARLY
#LATE-MID
#LATE-LATE

originalCreation2 = originalCreation2%>%mutate(temp = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %nin% temp ~ paste(COURSE_ID,TERM_CODE,STUDENT_ID)
),

EARLY_SESSIONS_REWATCHED_EARLY_PERIOD = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %in% temp & (COURSE_PERIOD=='Early' & SESSION_PERIOD=='Early')~ 1,
),
EARLY_SESSIONS_REWATCHED_MID_PERIOD = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %in% temp & (COURSE_PERIOD=='Mid' & SESSION_PERIOD=='Early')~ 1,
),
MID_SESSIONS_REWATCHED_MID_PERIOD = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %in% temp & (COURSE_PERIOD=='Mid' & SESSION_PERIOD=='Mid')~ 1,
),
EARLY_SESSIONS_REWATCHED_LATE_PERIOD = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %in% temp & (COURSE_PERIOD=='Late' & SESSION_PERIOD=='Early')~ 1,
),
MID_SESSIONS_REWATCHED_LATE_PERIOD = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %in% temp & (COURSE_PERIOD=='Late' & SESSION_PERIOD=='Mid')~1 ,
),
LATE_SESSIONS_REWATCHED_LATE_PERIOD = case_when(
  paste(COURSE_ID,TERM_CODE,STUDENT_ID) %in% temp & (COURSE_PERIOD=='Late' & SESSION_PERIOD=='Late')~1,
)
)
#Ok so this code didn't exactly work but it can still work if we aggregate the respective columns for each student, course and term

temp1 = aggregate(x = originalCreation2[c("EARLY_SESSIONS_REWATCHED_EARLY_PERIOD")], by = originalCreation2[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
temp2  = aggregate(x = originalCreation2[c("EARLY_SESSIONS_REWATCHED_MID_PERIOD")], by = originalCreation2[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
temp3 = aggregate(x = originalCreation2[c("EARLY_SESSIONS_REWATCHED_LATE_PERIOD")], by = originalCreation2[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
temp4= aggregate(x = originalCreation2[c("MID_SESSIONS_REWATCHED_MID_PERIOD")], by = originalCreation2[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
temp5= aggregate(x = originalCreation2[c("MID_SESSIONS_REWATCHED_LATE_PERIOD")], by = originalCreation2[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
temp6= aggregate(x = originalCreation2[c("LATE_SESSIONS_REWATCHED_LATE_PERIOD")], by = originalCreation2[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)

temp1$EARLY_SESSIONS_REWATCHED_MID_PERIOD = temp2$EARLY_SESSIONS_REWATCHED_MID_PERIOD
temp1$EARLY_SESSIONS_REWATCHED_LATE_PERIOD = temp3$EARLY_SESSIONS_REWATCHED_LATE_PERIOD
temp1$MID_SESSIONS_REWATCHED_MID_PERIOD = temp4$MID_SESSIONS_REWATCHED_MID_PERIOD
temp1$MID_SESSIONS_REWATCHED_LATE_PERIOD=temp5$MID_SESSIONS_REWATCHED_LATE_PERIOD
temp1$LATE_SESSIONS_REWATCHED_LATE_PERIOD=temp6$LATE_SESSIONS_REWATCHED_LATE_PERIOD
temp1[is.na(temp1)] <- 0

originalCreation2 <- tttotalCam2020 %>%
  dplyr::inner_join(temp1, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))

tttotalCam2020=originalCreation2

tttotalCam2020$PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD=(tttotalCam2020$EARLY_SESSIONS_REWATCHED_EARLY_PERIOD/tttotalCam2020$SESSIONS_EARLY_PERIOD)
tttotalCam2020$PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD=(tttotalCam2020$EARLY_SESSIONS_REWATCHED_MID_PERIOD/tttotalCam2020$SESSIONS_EARLY_PERIOD)
tttotalCam2020$PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD=(tttotalCam2020$EARLY_SESSIONS_REWATCHED_LATE_PERIOD/tttotalCam2020$SESSIONS_EARLY_PERIOD)

tttotalCam2020$PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD=(tttotalCam2020$MID_SESSIONS_REWATCHED_MID_PERIOD/tttotalCam2020$SESSIONS_MID_PERIOD)
tttotalCam2020$PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD=(tttotalCam2020$MID_SESSIONS_REWATCHED_LATE_PERIOD/tttotalCam2020$SESSIONS_MID_PERIOD)

tttotalCam2020$PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD=(tttotalCam2020$LATE_SESSIONS_REWATCHED_LATE_PERIOD/tttotalCam2020$SESSIONS_LATE_PERIOD)
tttotalCam2020[is.na(tttotalCam2020)] <- 0


#Alls good above

###########8. Extra new features of interest

#8.1 COURSES_TAKEN which shows the number of courses the student is doing for that term.

tttotalOU2020$COURSES_TAKING = 1
temp1=tttotalOU2020[!duplicated(tttotalOU2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE')]),]
temp1 = aggregate(x = temp1[c("COURSES_TAKING")], by = temp1[c('STUDENT_ID',"TERM_CODE")], FUN = length)
ttttotalOU2020 = merge(temp1,tttotalOU2020,by=c('STUDENT_ID',"TERM_CODE"))

ttttotalOU2020$COURSES_TAKING = ttttotalOU2020$COURSES_TAKING.x
ttttotalOU2020$COURSES_TAKING.y = NULL
ttttotalOU2020$COURSES_TAKING.x = NULL
#--------------------------------------------------------------------------------------------------------------------------------------------------
tttotalCam2020$COURSES_TAKING = 1
temp2=tttotalCam2020[!duplicated(tttotalCam2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE')]),]
temp2 = aggregate(x = temp2[c("COURSES_TAKING")], by = temp2[c('STUDENT_ID',"TERM_CODE")], FUN = length)

ttttotalCam2020 <- temp2 %>%
  dplyr::inner_join(tttotalCam2020, by=c('STUDENT_ID','TERM_CODE'))
#ttttotalCam2020 = merge(temp2,tttotalCam2020,by=c('STUDENT_ID',"TERM_CODE"))

ttttotalCam2020$COURSES_TAKING = ttttotalCam2020$COURSES_TAKING.x
ttttotalCam2020$COURSES_TAKING.y = NULL
ttttotalCam2020$COURSES_TAKING.x = NULL

#8.2 keywords-

#Total_ASSESSMENTS_WATCHED:
#Group 1 (assessment): 'assessment', 'exam', 'exercise', 'portfolio', 'task', 'assignment', 'quiz', 
#'test', 'assess', 'essay', 'report', 'expectation', 'sample', 'rubric', 'criteria', 'marking'. 

#Total_INTRODUCTION_WATCHED:
#Group 2: (introduction): 'welcome', 'tutor', 'overview', 'introduction', 'intro' 
#+ any videos that are less than 5 minutes and have titles such as 'Course Code - Week 1', Week 2, Week 3, etc.). 
#Group 3 (announcement): 'announcement'.

#Total_ZOOM_WATCHED:
#Group 4 (zoom): 'zoom', 'drop_in', 'drop', 'tutorial', 'recording', 'discussion', 'practical', 'optional' (note all the videos in Group 4 these one should not have the word 'assignment' or 'assessment' in their Session_Name). 

#Total_LECTURE_WATCHED:
#Group 5 (lecture): anything that is left can fall in this group.


ttttotalOU2020$TOTAL_ASSESSMENTS_WATCHED=1
ttttotalOU2020$TOTAL_INTRODUCTION_WATCHED=1
ttttotalOU2020$TOTAL_ZOOM_WATCHED=1
ttttotalOU2020$TOTAL_ANNOUNCEMENT_WATCHED=1
ttttotalOU2020$TOTAL_LECTURE_WATCHED=1


ttttotalOU2020<-ttttotalOU2020%>%mutate(SESSION_GROUP = case_when(
  grepl('assessment|exam|exercise|portfolio|task|assignment|quiz|test|assess|essay|report|expectation|sample|rubric|criteria|marking', SESSION_NAME) ~ 'Assessment',
  grepl('welcome|tutor|overview|introduction|intro|Week 1|Week 2|Week 3', SESSION_NAME) ~ 'Introduction',
  grepl('announcement|Announcement', SESSION_NAME) ~ 'Announcement',
  grepl('zoom|drop_in|drop|tutorial|recording|discussion|practical|optional', SESSION_NAME) & !grepl('assignment|assessment', SESSION_NAME) ~ 'Zoom',
  TRUE~'Lecture'
))

assessmentsWatched = ttttotalOU2020[ttttotalOU2020$SESSION_GROUP=='Assessment',]
introductionWatched = ttttotalOU2020[ttttotalOU2020$SESSION_GROUP=='Introduction',]
zoomWatched = ttttotalOU2020[ttttotalOU2020$SESSION_GROUP=='Announcement',]
announcementWatched = ttttotalOU2020[ttttotalOU2020$SESSION_GROUP=='Zoom',]
lectureWatched = ttttotalOU2020[ttttotalOU2020$SESSION_GROUP=='Lecture',]


assessmentsWatched = aggregate(x = assessmentsWatched[c("TOTAL_ASSESSMENTS_WATCHED")], by = assessmentsWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
introductionWatched = aggregate(x = introductionWatched[c("TOTAL_INTRODUCTION_WATCHED")], by = introductionWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
zoomWatched = aggregate(x = zoomWatched[c("TOTAL_ZOOM_WATCHED")], by = zoomWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
announcementWatched = aggregate(x = announcementWatched[c("TOTAL_ANNOUNCEMENT_WATCHED")], by = announcementWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
lectureWatched = aggregate(x = lectureWatched[c("TOTAL_LECTURE_WATCHED")], by = lectureWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)


ttttotalOU2020 = merge(ttttotalOU2020,assessmentsWatched, by=c('STUDENT_ID',"COURSE_ID","TERM_CODE"),all.x=TRUE)
ttttotalOU2020 = merge(ttttotalOU2020,introductionWatched, by=c('STUDENT_ID',"COURSE_ID","TERM_CODE"),all.x=TRUE)
ttttotalOU2020 = merge(ttttotalOU2020,zoomWatched, by=c('STUDENT_ID',"COURSE_ID","TERM_CODE"),all.x=TRUE)
ttttotalOU2020 = merge(ttttotalOU2020,announcementWatched, by=c('STUDENT_ID',"COURSE_ID","TERM_CODE"),all.x=TRUE)
ttttotalOU2020 = merge(ttttotalOU2020,lectureWatched, by=c('STUDENT_ID',"COURSE_ID","TERM_CODE"),all.x=TRUE)


ttttotalOU2020[is.na(ttttotalOU2020)]=0

ttttotalOU2020$TOTAL_ASSESSMENTS_WATCHED = ttttotalOU2020$TOTAL_ASSESSMENTS_WATCHED.y
ttttotalOU2020$TOTAL_ASSESSMENTS_WATCHED.y=NULL
ttttotalOU2020$TOTAL_ASSESSMENTS_WATCHED.x=NULL
ttttotalOU2020$TOTAL_INTRODUCTION_WATCHED = ttttotalOU2020$TOTAL_INTRODUCTION_WATCHED.y
ttttotalOU2020$TOTAL_INTRODUCTION_WATCHED.y = NULL
ttttotalOU2020$TOTAL_INTRODUCTION_WATCHED.x = NULL
ttttotalOU2020$TOTAL_ZOOM_WATCHED = ttttotalOU2020$TOTAL_ZOOM_WATCHED.y
ttttotalOU2020$TOTAL_ZOOM_WATCHED.y = NULL
ttttotalOU2020$TOTAL_ZOOM_WATCHED.x= NULL

ttttotalOU2020$TOTAL_ANNOUNCEMENT_WATCHED = ttttotalOU2020$TOTAL_ANNOUNCEMENT_WATCHED.y
ttttotalOU2020$TOTAL_ANNOUNCEMENT_WATCHED.y = NULL
ttttotalOU2020$TOTAL_ANNOUNCEMENT_WATCHED.x= NULL

ttttotalOU2020$TOTAL_LECTURE_WATCHED = ttttotalOU2020$TOTAL_LECTURE_WATCHED.y
ttttotalOU2020$TOTAL_LECTURE_WATCHED.y = NULL
ttttotalOU2020$TOTAL_LECTURE_WATCHED.x = NULL

#--------------------------------------------------------------------------------------------------------------------------------------------------

ttttotalCam2020$TOTAL_ASSESSMENTS_WATCHED=1
ttttotalCam2020$TOTAL_INTRODUCTION_WATCHED=1
ttttotalCam2020$TOTAL_ZOOM_WATCHED=1
ttttotalCam2020$TOTAL_ANNOUNCEMENT_WATCHED=1
ttttotalCam2020$TOTAL_LECTURE_WATCHED=1


ttttotalCam2020<-ttttotalCam2020%>%mutate(SESSION_GROUP = case_when(
  grepl('assessment|exam|exercise|portfolio|task|assignment|quiz|test|assess|essay|report|expectation|sample|rubric|criteria|marking', SESSION_NAME) ~ 'Assessment',
  grepl('welcome|tutor|overview|introduction|intro|Week 1|Week 2|Week 3', SESSION_NAME) ~ 'Introduction',
  grepl('announcement|Announcement', SESSION_NAME) ~ 'Announcement',
  grepl('zoom|drop_in|drop|tutorial|recording|discussion|practical|optional', SESSION_NAME) & !grepl('assignment|assessment', SESSION_NAME) ~ 'Zoom',
  TRUE~'Lecture'
))

assessmentsWatched = ttttotalCam2020[ttttotalCam2020$SESSION_GROUP=='Assessment',]
introductionWatched = ttttotalCam2020[ttttotalCam2020$SESSION_GROUP=='Introduction',]
zoomWatched = ttttotalCam2020[ttttotalCam2020$SESSION_GROUP=='Announcement',]
announcementWatched = ttttotalCam2020[ttttotalCam2020$SESSION_GROUP=='Zoom',]
lectureWatched = ttttotalCam2020[ttttotalCam2020$SESSION_GROUP=='Lecture',]

assessmentsWatched = aggregate(x = assessmentsWatched[c("TOTAL_ASSESSMENTS_WATCHED")], by = assessmentsWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
introductionWatched = aggregate(x = introductionWatched[c("TOTAL_INTRODUCTION_WATCHED")], by = introductionWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
zoomWatched = aggregate(x = zoomWatched[c("TOTAL_ZOOM_WATCHED")], by = zoomWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
announcementWatched = aggregate(x = announcementWatched[c("TOTAL_ANNOUNCEMENT_WATCHED")], by = announcementWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)
lectureWatched = aggregate(x = lectureWatched[c("TOTAL_LECTURE_WATCHED")], by = lectureWatched[c('STUDENT_ID',"COURSE_ID","TERM_CODE")], FUN = sum)


ttttotalCam2020 <- ttttotalCam2020 %>%
  dplyr::left_join(assessmentsWatched, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
ttttotalCam2020 <- ttttotalCam2020 %>%
  dplyr::left_join(introductionWatched, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
ttttotalCam2020 <- ttttotalCam2020 %>%
  dplyr::left_join(zoomWatched, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
ttttotalCam2020 <- ttttotalCam2020 %>%
  dplyr::left_join(announcementWatched, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
ttttotalCam2020 <- ttttotalCam2020 %>%
  dplyr::left_join(lectureWatched, by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))

ttttotalCam2020[is.na(ttttotalCam2020)]=0



ttttotalCam2020$TOTAL_ASSESSMENTS_WATCHED = ttttotalCam2020$TOTAL_ASSESSMENTS_WATCHED.y
ttttotalCam2020$TOTAL_ASSESSMENTS_WATCHED.y=NULL
ttttotalCam2020$TOTAL_ASSESSMENTS_WATCHED.x=NULL
ttttotalCam2020$TOTAL_INTRODUCTION_WATCHED = ttttotalCam2020$TOTAL_INTRODUCTION_WATCHED.y
ttttotalCam2020$TOTAL_INTRODUCTION_WATCHED.y = NULL
ttttotalCam2020$TOTAL_INTRODUCTION_WATCHED.x = NULL
ttttotalCam2020$TOTAL_ZOOM_WATCHED = ttttotalCam2020$TOTAL_ZOOM_WATCHED.y
ttttotalCam2020$TOTAL_ZOOM_WATCHED.y = NULL
ttttotalCam2020$TOTAL_ZOOM_WATCHED.x= NULL

ttttotalCam2020$TOTAL_ANNOUNCEMENT_WATCHED = ttttotalCam2020$TOTAL_ANNOUNCEMENT_WATCHED.y
ttttotalCam2020$TOTAL_ANNOUNCEMENT_WATCHED.y = NULL
ttttotalCam2020$TOTAL_ANNOUNCEMENT_WATCHED.x= NULL

ttttotalCam2020$TOTAL_LECTURE_WATCHED = ttttotalCam2020$TOTAL_LECTURE_WATCHED.y
ttttotalCam2020$TOTAL_LECTURE_WATCHED.y = NULL
ttttotalCam2020$TOTAL_LECTURE_WATCHED.x = NULL



#9. Finalizing data and features to csv
ttttotalOU2020= ttttotalOU2020[!duplicated(ttttotalOU2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE')]),]
ttttotalCam2020= ttttotalCam2020[!duplicated(ttttotalCam2020[,c('STUDENT_ID','COURSE_ID','TERM_CODE')]),]

#7. I forgot to code these features:

# PROPORTION_SHORT_WATCH_EARLY_PERIOD
# PROPORTION_SHORT_WATCH_MID_PERIOD
# PROPORTION_SHORT_WATCH_LATE_PERIOD
# PROPORTION_SHORT_WATCH_EARLY_PERIOD
# PROPORTION_MEDIUM_WATCH_EARLY_PERIOD
# PROPORTION_MEDIUM_WATCH_MID_PERIOD
# PROPORTION_MEDIUM_WATCH_LATE_PERIOD
# PROPORTION_LONG_ WATCH_EARLY_PERIOD
# PROPORTION_LONG_ WATCH_MID_PERIOD
# PROPORTION_LONG_ WATCH_LATE_PERIOD


#UO 2020
ttttotalOU2020$PROPORTION_SHORT_WATCH_EARLY_PERIOD =(ttttotalOU2020$SHORT_WATCH_EARLY_PERIOD/ttttotalOU2020$SHORT_SESSIONS_EARLY_PERIOD)
ttttotalOU2020$PROPORTION_SHORT_WATCH_MID_PERIOD =(ttttotalOU2020$SHORT_WATCH_MID_PERIOD/ttttotalOU2020$SHORT_SESSIONS_MID_PERIOD)
ttttotalOU2020$PROPORTION_SHORT_WATCH_LATE_PERIOD = (ttttotalOU2020$SHORT_WATCH_LATE_PERIOD/ttttotalOU2020$SHORT_SESSIONS_LATE_PERIOD)
ttttotalOU2020$PROPORTION_MEDIUM_WATCH_EARLY_PERIOD =(ttttotalOU2020$MEDIUM_WATCH_EARLY_PERIOD/ttttotalOU2020$MEDIUM_SESSIONS_EARLY_PERIOD)
ttttotalOU2020$PROPORTION_MEDIUM_WATCH_MID_PERIOD =(ttttotalOU2020$MEDIUM_WATCH_MID_PERIOD/ttttotalOU2020$MEDIUM_SESSIONS_MID_PERIOD)
ttttotalOU2020$PROPORTION_MEDIUM_WATCH_LATE_PERIOD =(ttttotalOU2020$MEDIUM_WATCH_LATE_PERIOD/ttttotalOU2020$MEDIUM_SESSIONS_LATE_PERIOD)
ttttotalOU2020$PROPORTION_LONG_WATCH_EARLY_PERIOD =(ttttotalOU2020$LONG_WATCH_EARLY_PERIOD/ttttotalOU2020$LONG_SESSIONS_EARLY_PERIOD)
ttttotalOU2020$PROPORTION_LONG_WATCH_MID_PERIOD=(ttttotalOU2020$LONG_WATCH_MID_PERIOD/ttttotalOU2020$LONG_SESSIONS_MID_PERIOD)
ttttotalOU2020$PROPORTION_LONG_WATCH_LATE_PERIOD=(ttttotalOU2020$LONG_WATCH_LATE_PERIOD/ttttotalOU2020$LONG_SESSIONS_LATE_PERIOD)
ttttotalOU2020[is.na(ttttotalOU2020)] <- 0


#NON UO 2020
ttttotalCam2020$PROPORTION_SHORT_WATCH_EARLY_PERIOD =(ttttotalCam2020$SHORT_WATCH_EARLY_PERIOD/ttttotalCam2020$SHORT_SESSIONS_EARLY_PERIOD)
ttttotalCam2020$PROPORTION_SHORT_WATCH_MID_PERIOD =(ttttotalCam2020$SHORT_WATCH_MID_PERIOD/ttttotalCam2020$SHORT_SESSIONS_MID_PERIOD)
ttttotalCam2020$PROPORTION_SHORT_WATCH_LATE_PERIOD = (ttttotalCam2020$SHORT_WATCH_LATE_PERIOD/ttttotalCam2020$SHORT_SESSIONS_LATE_PERIOD)
ttttotalCam2020$PROPORTION_MEDIUM_WATCH_EARLY_PERIOD =(ttttotalCam2020$MEDIUM_WATCH_EARLY_PERIOD/ttttotalCam2020$MEDIUM_SESSIONS_EARLY_PERIOD)
ttttotalCam2020$PROPORTION_MEDIUM_WATCH_MID_PERIOD =(ttttotalCam2020$MEDIUM_WATCH_MID_PERIOD/ttttotalCam2020$MEDIUM_SESSIONS_MID_PERIOD)
ttttotalCam2020$PROPORTION_MEDIUM_WATCH_LATE_PERIOD =(ttttotalCam2020$MEDIUM_WATCH_LATE_PERIOD/ttttotalCam2020$MEDIUM_SESSIONS_LATE_PERIOD)
ttttotalCam2020$PROPORTION_LONG_WATCH_EARLY_PERIOD =(ttttotalCam2020$LONG_WATCH_EARLY_PERIOD/ttttotalCam2020$LONG_SESSIONS_EARLY_PERIOD)
ttttotalCam2020$PROPORTION_LONG_WATCH_MID_PERIOD=(ttttotalCam2020$LONG_WATCH_MID_PERIOD/ttttotalCam2020$LONG_SESSIONS_MID_PERIOD)
ttttotalCam2020$PROPORTION_LONG_WATCH_LATE_PERIOD=(ttttotalCam2020$LONG_WATCH_LATE_PERIOD/ttttotalCam2020$LONG_SESSIONS_LATE_PERIOD)
ttttotalCam2020[is.na(ttttotalCam2020)] <- 0




#ALLs good above

#Full files with all features


a=ttttotalOU2020
a <- a %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))

b=ttttotalCam2020
b <- b %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))


write.csv(a,'_UO_2020_All_Features.csv')
write.csv(b,'_NON-UO_2020_All_Features.csv')

#Files with "most important features", mainly proportion ones

features=c('STUDENT_ID','COURSE_ID','TERM_CODE','SUBJECT_AREA','COURSES_TAKING',
           'TOTAL_ASSESSMENTS_WATCHED','TOTAL_INTRODUCTION_WATCHED','TOTAL_ZOOM_WATCHED','TOTAL_LECTURE_WATCHED','TOTAL_ANNOUNCEMENT_WATCHED',
           'TOTAL_SESSION_INTERACTIONS','TOTAL_SESSION_DURATION','TOTAL_TIME_VIEWED','TOTAL_SESSIONS_COURSE','PROPORTION_OF_SESSIONS_WATCHED',
           'PROPORTION_SESSION_EARLY_PERIOD_WATCHED','PROPORTION_SESSION_MID_PERIOD_WATCHED',
           'PROPORTION_SESSION_LATE_PERIOD_WATCHED','PROPORTION_SHORT_SESSION_WATCHED',
           'PROPORTION_MEDIUM_SESSION_WATCHED','PROPORTION_LONG_SESSION_WATCHED',
           'SESSIONS_EARLY_PERIOD','SESSIONS_MID_PERIOD',
           'SESSIONS_LATE_PERIOD','PROPORTION_SHORT_WATCH_EARLY_PERIOD',
           'PROPORTION_SHORT_WATCH_MID_PERIOD','PROPORTION_SHORT_WATCH_LATE_PERIOD',
           'PROPORTION_MEDIUM_WATCH_EARLY_PERIOD',
           'PROPORTION_MEDIUM_WATCH_MID_PERIOD','PROPORTION_MEDIUM_WATCH_LATE_PERIOD',
           'PROPORTION_LONG_WATCH_EARLY_PERIOD','PROPORTION_LONG_WATCH_MID_PERIOD',
           'PROPORTION_LONG_WATCH_LATE_PERIOD',
           'PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD','PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD',
           'PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD','PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD',
           'PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD','PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD')

all=colnames(ttttotalOU2020)

unique(features[! features %in% all])

all2=colnames(ttttotalCam2020)

unique(features[! features %in% all2])


ok=ttttotalOU2020
ok <- ok %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))

ok2=ttttotalCam2020
ok2 <- ok2 %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))


temp1=ok[,features]
temp2=ok2[,features]
write.csv(temp1,'_UO_2020_Important_Features.csv')
write.csv(temp2,'_NON-UO_2020_Important_Features.csv')


#Test section

nonUO = read.csv('_NON-UO_2020_All_Features.csv')
UO = read.csv('_UO_2020_All_Features.csv')

nonUO=nonUO[!duplicated(nonUO[,c('COURSE_ID','TERM_CODE')]),]
UO=UO[!duplicated(UO[,c('COURSE_ID','TERM_CODE')]),]

nonUO = nonUO[,c('COURSE_ID','TERM_CODE')]
UO = UO[,c('COURSE_ID','TERM_CODE')]

write.csv(UO,'_UO_2020_Course_Term.csv')
write.csv(nonUO,'_NON-UO_2020_Course_Term.csv')



###################################################################################################################

####Final Data

setwd("C:/Users/Alice/Desktop/Pan")

UO_grades_data = read.csv('_UO_2020_All_Features.csv',na.string = c("NULL"))
NON_UO_grades_data = read.csv('_NON-UO_2020_All_Features.csv',na.string = c("NULL"))
# UO_grades_data = read.csv('_UO_2020_Important_Features.csv',na.string = c("NULL"))
# NON_UO_grades_data = read.csv('_NON-UO_2020_Important_Features.csv',na.string = c("NULL"))

unisaCourses = read.csv('unisaCourses.csv',na.string = c("NULL"))
edcCourses = read.csv('EDC.csv',na.string = c("NULL"))

UO_chen_grades = read.csv('chen_grades_UO.csv',na.string = c("NULL"))
NON_UO_chen_grades = read.csv('chen_grades_Non_UO.csv',na.string = c("NULL"))

names(UO_chen_grades)[1] <- "COURSE_ID"
names(NON_UO_chen_grades)[1] <- "COURSE_ID"
UO_chen_grades$SP = 'SP'
NON_UO_chen_grades$SP = 'SP'
UO_chen_grades$TERM_CODE = paste(UO_chen_grades$SP,UO_chen_grades$TERM_CATEGORY_CODE,sep='')
NON_UO_chen_grades$TERM_CODE = paste(NON_UO_chen_grades$SP,NON_UO_chen_grades$TERM_CATEGORY_CODE,sep='')


#HOME_LANGUAGE,CITIZENSHIP_STATUS, GENDER_CODE,BIRTH_DATE
testData1 = data.frame(UO_chen_grades[,c('STUDENT_ID','COURSE_ID','TERM_CODE','COURSE_GRADE_LETTER','HOME_LANGUAGE','CITIZENSHIP_STATUS','GENDER_CODE','BIRTH_DATE')])
testData2 = data.frame(UO_grades_data)
UO_data = merge(testData1,testData2,by=c('STUDENT_ID','COURSE_ID','TERM_CODE'))
testData1 = data.frame(NON_UO_chen_grades[,c('STUDENT_ID','COURSE_ID','TERM_CODE','COURSE_GRADE_LETTER','HOME_LANGUAGE','CITIZENSHIP_STATUS','GENDER_CODE','BIRTH_DATE')])
testData2 = data.frame(NON_UO_grades_data)
NON_UO_data = merge(testData1,testData2, by = c('STUDENT_ID','COURSE_ID','TERM_CODE'))


UO_data$X = NULL
NON_UO_data$X = NULL

#Good var
#CITZENSHIP
#GENDER
#BIRTHDATE

#BAD VAR
#NA home language replaced with english most of them are austarlian citizens
#UO data 153 Nas
#NON UO 75 NAs

NON_UO_data$HOME_LANGUAGE[NON_UO_data$HOME_LANGUAGE == 'NA'] <- 'English'
UO_data$HOME_LANGUAGE[UO_data$HOME_LANGUAGE == 'NA'] <- 'English'

UO_data$BIRTH_DATE<- substr(UO_data$BIRTH_DATE, 0, 4)
NON_UO_data$BIRTH_DATE<- substr(NON_UO_data$BIRTH_DATE, 0, 4)
UO_data$BIRTH_DATE = as.numeric(UO_data$BIRTH_DATE)
NON_UO_data$BIRTH_DATE = as.numeric(NON_UO_data$BIRTH_DATE)
UO_data$AGE = 2020 - UO_data$BIRTH_DATE
NON_UO_data$AGE = 2020 - NON_UO_data$BIRTH_DATE

UO_data$BIRTH_DATE = NULL
NON_UO_data$BIRTH_DATE = NULL


# write.csv(UO_data,'UO_data_2020.csv')
# write.csv(NON_UO_data,'NON_UO_data_2020.csv')

library(lmerTest)
library(caret)
library(MuMIn)


UO_data$RESPONSE = match(UO_data$COURSE_GRADE_LETTER, unique(UO_data$COURSE_GRADE_LETTER))
NON_UO_data$RESPONSE = match(NON_UO_data$COURSE_GRADE_LETTER, unique(NON_UO_data$COURSE_GRADE_LETTER))

# HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
# TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
# TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
# PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
# PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
# PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
# SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
# SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
# PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
# PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
# PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
# PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
# PROPORTION_LONG_WATCH_LATE_PERIOD+
# PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
# PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
# PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD
options(max.print=1000000)
# UO_data$RESPONSE = match(UO_data$COURSE_GRADE_LETTER, unique(UO_data$COURSE_GRADE_LETTER))
# NON_UO_data$RESPONSE = match(NON_UO_data$COURSE_GRADE_LETTER, unique(NON_UO_data$COURSE_GRADE_LETTER))





#Normal
tempSubset = subset(unisaCourses, Type == "Normal")
Normal <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('COURSE_NAME'))


fNormal <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                  TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                  TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                  PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                  PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                  PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                  SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                  SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                  PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                  PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                  PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                  PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                  PROPORTION_LONG_WATCH_LATE_PERIOD+
                  PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                  PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                  PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), Normal)
#summary(fNormal)
r.squaredGLMM(fNormal)

#AP
tempSubset = subset(unisaCourses, Type == "AP")
AP <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('COURSE_NAME'))


fAP <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
              TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
              TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
              PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
              PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
              PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
              SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
              SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
              PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
              PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
              PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
              PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
              PROPORTION_LONG_WATCH_LATE_PERIOD+
              PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
              PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
              PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), AP)
#summary(AP)
r.squaredGLMM(fAP)
#OUA
tempSubset = subset(unisaCourses, Type == "OUA")
OUA <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('COURSE_NAME'))


fOUA <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
               TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
               TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
               PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
               PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
               PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
               SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
               SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
               PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
               PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
               PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
               PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
               PROPORTION_LONG_WATCH_LATE_PERIOD+
               PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
               PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
               PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), OUA)
#summary(AP)
r.squaredGLMM(fOUA)
#Catherine
tempSubset = subset(unisaCourses, Type == "Catherine")
Catherine <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('COURSE_NAME'))


fCatherine <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                     TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                     TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                     PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                     PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                     PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                     SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                     SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                     PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                     PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                     PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                     PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                     PROPORTION_LONG_WATCH_LATE_PERIOD+
                     PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                     PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                     PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), Catherine)
#summary(AP)
r.squaredGLMM(fCatherine)
#UNISAONLINE
tempSubset = subset(unisaCourses, Type == "UNISAONLINE")
UNISAONLINE <- UO_data %>%
  dplyr::inner_join(tempSubset, by=c('COURSE_NAME'))


fUNISAONLINE <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                       TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                       TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                       PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                       PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                       PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                       SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                       SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                       PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                       PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                       PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                       PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                       PROPORTION_LONG_WATCH_LATE_PERIOD+
                       PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                       PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                       PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), UNISAONLINE)
#summary(AP)
r.squaredGLMM(fUNISAONLINE)
#Eyre
tempSubset = subset(unisaCourses, Type == "Eyre")
Eyre <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('COURSE_NAME'))


fEyre <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), Eyre)
#summary(AP)
r.squaredGLMM(fEyre)

#---------------
ses2020 = read.csv('PanoptoSessions2020.csv',na.string = c("NULL"))
names(ses2020)[1] <- "COURSE_ID"
temp2 = ses2020[,c('COURSE_ID','SUBJECT_AREA','CATALOG_NBR')]
temp2 = temp2 %>% distinct()

NON_UO_data <- NON_UO_data %>%
  dplyr::left_join(temp2, by=c('COURSE_ID'))
NON_UO_data$SUBJECT_CODE <- paste(NON_UO_data$SUBJECT_AREA.x,NON_UO_data$CATALOG_NBR)
NON_UO_data$SUBJECT_AREA = NON_UO_data$SUBJECT_AREA.x
look = NON_UO_data[,c('SUBJECT_CODE','SUBJECT_AREA.x')]


#EDUC
tempSubset = subset(edcCourses, Type == "EDUC")
EDUC <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fEDUC <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), EDUC)
#summary(AP)
r.squaredGLMM(fEDUC)

#ENVT
tempSubset = subset(edcCourses, Type == "ENVT")
ENVT <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fENVT <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), ENVT)
#summary(AP)
r.squaredGLMM(fENVT)

#HLTH
tempSubset = subset(edcCourses, Type == "HLTH")
HLTH <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fHLTH <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), HLTH)
#summary(AP)
r.squaredGLMM(fHLTH)
#HUMS
tempSubset = subset(edcCourses, Type == "HUMS")
HUMS <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fHUMS <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), HUMS)
#summary(AP)
r.squaredGLMM(fHUMS)
#ITL
tempSubset = subset(edcCourses, Type == "ITL")
ITL <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fITL <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), ITL)
#summary(AP)
r.squaredGLMM(fITL)
#LANG
tempSubset = subset(edcCourses, Type == "LANG")
LANG <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fLANG <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
               TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
               TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
               PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
               PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
               PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
               SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
               SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
               PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
               PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
               PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
               PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
               PROPORTION_LONG_WATCH_LATE_PERIOD+
               PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
               PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
               PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), LANG)
#summary(AP)
r.squaredGLMM(fLANG)
#SCEDC
tempSubset = subset(edcCourses, Type == "SCEDC")
SCEDC <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fSCEDC <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                PROPORTION_LONG_WATCH_LATE_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), SCEDC)
#summary(AP)
r.squaredGLMM(fSCEDC)
#SCEDS
tempSubset = subset(edcCourses, Type == "SCEDS")
SCEDS <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fSCEDS <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                 TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                 TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                 PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                 PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                 PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                 SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                 SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                 PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                 PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                 PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                 PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                 PROPORTION_LONG_WATCH_LATE_PERIOD+
                 PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                 PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                 PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), SCEDS)
#summary(AP)
r.squaredGLMM(fSCEDS)
#SCSEU
tempSubset = subset(edcCourses, Type == "SCSEU")
SCSEU <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fSCSEU <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                 TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                 TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                 PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                 PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                 PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                 SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                 SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                 PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                 PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                 PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                 PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                 PROPORTION_LONG_WATCH_LATE_PERIOD+
                 PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                 PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                 PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), SCSEU)
#summary(AP)
r.squaredGLMM(fSCSEU)
#SCUCO
tempSubset = subset(edcCourses, Type == "SCUCO")
SCUCO <- NON_UO_data %>%
  dplyr::inner_join(tempSubset, by=c('SUBJECT_CODE'))


fSCUCO <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
                 TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
                 TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
                 PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
                 PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
                 PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
                 SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
                 SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
                 PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
                 PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
                 PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
                 PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
                 PROPORTION_LONG_WATCH_LATE_PERIOD+
                 PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
                 PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
                 PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), SCUCO)
#summary(AP)
r.squaredGLMM(fSCUCO)



fm1 <- lmer(RESPONSE ~ HOME_LANGUAGE+CITIZENSHIP_STATUS+GENDER_CODE+AGE+TERM_CODE+SUBJECT_AREA+COURSES_TAKING+
              TOTAL_ASSESSMENTS_WATCHED+TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_LECTURE_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+
              TOTAL_SESSION_INTERACTIONS+TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+PROPORTION_OF_SESSIONS_WATCHED+
              PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+
              PROPORTION_SESSION_LATE_PERIOD_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+
              PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+
              SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+
              SESSIONS_LATE_PERIOD+PROPORTION_SHORT_WATCH_EARLY_PERIOD+
              PROPORTION_SHORT_WATCH_MID_PERIOD+PROPORTION_SHORT_WATCH_LATE_PERIOD+
              PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+
              PROPORTION_MEDIUM_WATCH_MID_PERIOD+PROPORTION_MEDIUM_WATCH_LATE_PERIOD+
              PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+
              PROPORTION_LONG_WATCH_LATE_PERIOD+
              PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+
              PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+
              PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD +(1 |STUDENT_ID), NON_UO_data)
summary(fm1)




# TERM_CODE+HOME_LANGUAGE+                                        
# SUBJECT_AREA+TOTAL_SHORT_SESSIONS+TOTAL_MEDIUM_SESSIONS+TOTAL_LONG_SESSIONS+TOTAL_SESSION_INTERACTIONS+                      
# TOTAL_SESSION_DURATION+TOTAL_TIME_VIEWED+TOTAL_SESSIONS_COURSE+                          
# PROPORTION_OF_SESSIONS_WATCHED+SESSION_PERIOD+SHORT_SESSIONS_WATCHED+                          
# MEDIUM_SESSIONS_WATCHED+LONG_SESSIONS_WATCHED+PROPORTION_SHORT_SESSION_WATCHED+                
# PROPORTION_MEDIUM_SESSION_WATCHED+PROPORTION_LONG_SESSION_WATCHED+COURSE_PERIOD+                                   
# SHORT_SESSIONS_EARLY_PERIOD+SHORT_SESSIONS_MID_PERIOD+SHORT_SESSIONS_LATE_PERIOD+                      
# MEDIUM_SESSIONS_EARLY_PERIOD+MEDIUM_SESSIONS_MID_PERIOD+MEDIUM_SESSIONS_LATE_PERIOD+                     
# LONG_SESSIONS_EARLY_PERIOD+LONG_SESSIONS_MID_PERIOD+LONG_SESSIONS_LATE_PERIOD+                       
# SHORT_WATCH_EARLY_PERIOD+SHORT_WATCH_MID_PERIOD+SHORT_WATCH_LATE_PERIOD+                         
# MEDIUM_WATCH_EARLY_PERIOD+MEDIUM_WATCH_MID_PERIOD+MEDIUM_WATCH_LATE_PERIOD+                        
# SESSIONS_EARLY_PERIOD+SESSIONS_MID_PERIOD+SESSIONS_LATE_PERIOD+                            
# SESSIONS_EARLY_PERIOD_WATCHED+SESSIONS_MID_PERIOD_WATCHED+SESSIONS_LATE_PERIOD_WATCHED+                    
# PROPORTION_SESSION_EARLY_PERIOD_WATCHED+PROPORTION_SESSION_MID_PERIOD_WATCHED+PROPORTION_SESSION_LATE_PERIOD_WATCHED+          
# EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+EARLY_SESSIONS_REWATCHED_MID_PERIOD+EARLY_SESSIONS_REWATCHED_LATE_PERIOD+            
# MID_SESSIONS_REWATCHED_MID_PERIOD+MID_SESSIONS_REWATCHED_LATE_PERIOD+LATE_SESSIONS_REWATCHED_LATE_PERIOD+             
# PROPORTION_EARLY_SESSIONS_REWATCHED_EARLY_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_MID_PERIOD+PROPORTION_EARLY_SESSIONS_REWATCHED_LATE_PERIOD+ 
# PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD+PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD+PROPORTION_LATE_SESSIONS_REWATCHED_LATE_PERIOD+  
# COURSES_TAKING+SESSION_GROUP+TOTAL_ASSESSMENTS_WATCHED+                       
# TOTAL_INTRODUCTION_WATCHED+TOTAL_ZOOM_WATCHED+TOTAL_ANNOUNCEMENT_WATCHED+                      
# TOTAL_LECTURE_WATCHED+PROPORTION_SHORT_WATCH_EARLY_PERIOD+PROPORTION_SHORT_WATCH_MID_PERIOD+               
# PROPORTION_SHORT_WATCH_LATE_PERIOD+PROPORTION_MEDIUM_WATCH_EARLY_PERIOD+PROPORTION_MEDIUM_WATCH_MID_PERIOD+              
# PROPORTION_MEDIUM_WATCH_LATE_PERIOD+PROPORTION_LONG_WATCH_EARLY_PERIOD+PROPORTION_LONG_WATCH_MID_PERIOD+              
# PROPORTION_LONG_WATCH_LATE_PERIOD+AGE





















remove = c('PROPORTION_SESSION_MID_PERIOD_WATCHED', 'SESSIONS_MID_PERIOD', 'PROPORTION_SHORT_WATCH_MID_PERIOD', 
           'PROPORTION_MEDIUM_WATCH_MID_PERIOD', 'PROPORTION_LONG_WATCH_MID_PERIOD', 'PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD', 
           'PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD')
UO_data=subset(UO_data,select=-c(PROPORTION_SESSION_MID_PERIOD_WATCHED, SESSIONS_MID_PERIOD, PROPORTION_SHORT_WATCH_MID_PERIOD, 
                                 PROPORTION_MEDIUM_WATCH_MID_PERIOD, PROPORTION_LONG_WATCH_MID_PERIOD, PROPORTION_MID_SESSIONS_REWATCHED_MID_PERIOD, 
                                 PROPORTION_MID_SESSIONS_REWATCHED_LATE_PERIOD))
intrain = createDataPartition(y=UO_data$COURSE_GRADE_LETTER,p=0.7,list=FALSE)
trainingData = UO_data[intrain,]
testingData = UO_data[-intrain,]

trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
svm_Linear <- train(COURSE_GRADE_LETTER ~., data = trainingData, method = "svmLinear",
                    trControl=trctrl,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)
testingData = testingData[testingData$SUBJECT_AREA!='GRAP',]
test_pred <- predict(svm_Linear, newdata = testingData)
confusionMatrix(table(test_pred, testingData$COURSE_GRADE_LETTER))


barplot(UO_data$COURSE_GRADE_LETTER)
ag = aggregate(UO_data$COURSE_GRADE_LETTER,UO_data,sum)
class(UO_data$COURSE_GRADE_LETTER)
table(UO_data$COURSE_GRADE_LETTER)






length(unique(UO_data[,"COURSE_ID"]))
length(unique(NON_UO_data[,"COURSE_ID"]))

length(unique(OUses2020[,"COURSE_ID"]))
length(unique(camses2020[,"COURSE_ID"]))


length(unique(UO_data[,"STUDENT_ID"]))
length(unique(NON_UO_data[,"STUDENT_ID"]))

count(UO_data$SUBJECT_AREA)
count(NON_UO_data$SUBJECT_AREA)

count(UO_data$GENDER_CODE)
count(NON_UO_data$GENDER_CODE)

count(UO_data$HOME_LANGUAGE)
count(NON_UO_data$HOME_LANGUAGE)

boxplot(UO_data$AGE, title="UO")
boxplot(NON_UO_data$AGE, title="UO")

summary(UO_data$AGE)
summary(NON_UO_data$AGE)

t1=UO_data[UO_data$AGE>29, ]
t2=NON_UO_data[NON_UO_data$AGE>21, ]

length(unique(t1[,"STUDENT_ID"]))
length(unique(t2[,"STUDENT_ID"]))


nrow(UO_data[UO_data$AGE>29, ])
nrow(NON_UO_data[NON_UO_data$AGE>21, ])

length(unique(UO_data[,"SESSION_NAME"]))
length(unique(NON_UO_data[,"SESSION_NAME"]))

t3 = UO_data[!duplicated(UO_data$SESSION_NAME), ]
t4 = NON_UO_data[!duplicated(NON_UO_data$SESSION_NAME), ]
count(t3$DURATION2)
count(t4$DURATION2)


sum(t3$SESSIONS_EARLY_PERIOD)
sum(t3$SESSIONS_MID_PERIOD)
sum(t3$SESSIONS_LATE_PERIOD)

sum(t4$SESSIONS_EARLY_PERIOD)
sum(t4$SESSIONS_MID_PERIOD)
sum(t4$SESSIONS_LATE_PERIOD)


