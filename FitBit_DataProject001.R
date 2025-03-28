## DATA PROJECT 001
## LAST UPDATED: Thursday, March 27th, 2025
## AUTHOR: Sayantani Basu Roy

## DATA SOURCE: https://www.kaggle.com/datasets/arashnic/fitbit
## BUSINESS PROBLEM: RECOMMENDATIONS FOR THE MARKETING TEAM using INSIGHTS FROM Fitness Smart Device USER DATA

# As we know this is the most important package to be used in R:
install.packages("tidyverse")
library("tidyverse")
# Upload the zipped file downloaded from Kaggle to the RStudio folder:

# DATASET #1::: Daily Activity
DailyActivity <- read_csv("Fitabase Data 3.12.16-4.11.16/dailyActivity_merged.csv",col_names = T)

# Change the names of a few columns: re-assign to a new data_frame
# Filter for the condition: TotalDistance = TrackerDistance
mod_DailyActivity <- DailyActivity %>%
  rename(ModeratelyActiveMinutes = FairlyActiveMinutes,
         LightlyActiveDistance = LightActiveDistance,
         SedentaryDistance = SedentaryActiveDistance) %>%
  filter(TrackerDistance == TotalDistance)

# CHECK datatypes of columns:
str(mod2_DailyActivity)
# Id is numeric, it should be a character.
# ActivityDate is character, it should be Date.
# The rest are numeric as they should be.

# 1> Make NEW columns
# 2> Remove UNWATED columns to get the CLEAN data,
# 3> Change datatypes of ActivityDate, Id
# 4> Divide ActivityDate into Year, Month, Day
# 5> Convert Month (3 or 4) to Name-of_Month (Mar / Apr)
mod2_DailyActivity <- mod_DailyActivity %>% 
  # 1>
  mutate(Hi_Distance = VeryActiveDistance + ModeratelyActiveDistance,
         Lo_Distance = LightlyActiveDistance + SedentaryDistance,
         Hi_Minutes = VeryActiveMinutes + ModeratelyActiveMinutes,
         Lo_Minutes = LightlyActiveMinutes + SedentaryMinutes,
         TotalMinutes = Hi_Minutes + Lo_Minutes) %>%
  # 2>
  select(Id, ActivityDate, TotalSteps, TotalDistance, TotalMinutes, Calories,
         Hi_Distance, Lo_Distance, Hi_Minutes, Lo_Minutes) %>%
  # 3>
  mutate(ActivityDate=mdy(ActivityDate), Id=as.character(Id)) %>%
  # 4>
  separate(ActivityDate, into=c("Year","Month","Day"), sep="-") %>%
  # 5>
  mutate(Month = ifelse(Month=="03","March","April"))

# Histogram of TOTAL DISTANCE:
ggplot(data=mod2_DailyActivity, aes(x=TotalDistance,color=Month)) + 
  geom_histogram(bins=15) +
  labs(title="Total DISTANCE values",x="")

# Histogram of TOTAL STEPS:
ggplot(data=mod2_DailyActivity, aes(x=TotalDistance,color=Month)) + 
  geom_histogram(bins=15) + 
  labs(title="Total STEPS values",x="")

#####################
# MESSAGE ONE: SIMILAR Distributions: MORE Smaller Values:
# USER INSIGHT: FitBit Users are walking less.
#####################

# TOTAL STEPS v/s TOTAL DISTANCE:
# Making a plot, showing the 2 Months:
ggplot(data=mod2_DailyActivity) + 
  geom_point(mapping = aes(x=TotalSteps,y=TotalDistance,color=Month)) + 
  facet_wrap(~Month) + 
  labs(title="Steps & Distance", x="number of Steps",y="Distance covered")
#####################
# MESSAGE TWO: More Steps, Higher Distance
# USER INSIGHT: No such insight. Validates our dataset.
#####################
# BIGGER SAMPLE FOR APRIL THAN MARCH (368 v/s 73)
# For Comment on Seasonal Difference between April v/s March, Dataset 
# needs to be Balanced.

# Histogram of CALORIES:
ggplot(data=mod2_DailyActivity, aes(x=Calories,color=Month)) + 
  geom_histogram(bins=15) + 
  labs(title="Burnt CALORIES values",x="") 
#####################
# MESSAGE THREE: Distribution DIFF from TotalSteps & TotalDistance: MORE 
# Values in the MIDDLE
# USER INSIGHT: Most FitBit Users are spending Calories between 1000 and 3000 
# per day but majority of them are burning 2000 or more each day. 
# This means we need age information: most likely Calorie usage decreases 
# with age and that means the next marketing campaign should be
# directed towards middle aged and older women. Having sleep information
# would also empower the analytics in order to power the campaign.
#####################

# TOTAL STEPS v/s CALORIES: 
ggplot(data=mod2_DailyActivity) + 
  geom_point(mapping = aes(x=TotalSteps,y=Calories,color=Month)) + 
  facet_wrap(~Month) + 
  labs(title="Steps & Calories", x="number of Steps",y="Calories spent")
# MESSAGE FOUR: More Steps, More Calories but the Trend is not CRYSTAL
# CLEAR because of the difference in distribution and the imbalance in 
# the number of daily observations in April v/s March.

# Histogram of TOTAL MINUTES:
ggplot(data=mod2_DailyActivity, aes(y=TotalMinutes,color=Month)) + 
  geom_histogram(bins=15)

################################################
# TOTAL MINUTES v/s TOTAL DISTANCE: not USEFUL 
ggplot(data=mod2_DailyActivity) + 
  geom_point(mapping = aes(x=TotalMinutes,y=TotalDistance,color=Id)) + 
  facet_wrap(~Month)

# SEDENTARY MINUTES v/s TOTAL CALORIES: not USEFUL 
ggplot(data=mod_DailyActivity) + 
  geom_smooth(mapping = aes(x=SedentaryMinutes,y=Calories)) +
  geom_point(mapping = aes(x=SedentaryMinutes,y=Calories))

# FILTER for Calories Value: FILTERED BUT NOT USEFUL
mod3_DailyActivity <- mod2_DailyActivity %>%
  filter((Calories > 1000) & (Calories < 3000))

# RE-DO HISTOGRAMS: DID NOT WORK
ggplot(data=mod3_DailyActivity, aes(y=Calories,color=Month)) + 
  geom_histogram(bins=15)
ggplot(data=mod3_DailyActivity, aes(y=TotalDistance,color=Month)) + 
  geom_histogram(bins=15)
################################################

# CALORIES V/S DISTANCE: NOT a STONG RELATION
ggplot(data=mod3_DailyActivity) + 
  geom_smooth(mapping = aes(x=TotalDistance,y=Calories)) +
  geom_point(mapping = aes(x=TotalDistance,y=Calories))
#################################################


# Put summary statistics into a dataframe
Summary_data <- 
  as.data.frame( mod2_DailyActivity %>%
                  group_by(Month) %>%
                  drop_na() %>%
                  summarise(mean_TotalDistance = mean(TotalDistance),
                    mean_TotalSteps = mean(TotalSteps),
                    mean_Calories = mean(Calories),
                    mean_TotalMinutes = mean(TotalMinutes)) )


# FIRST PLOT: NO NEED!!!!
# Total Steps v/s Total Distance
#trunc_TotalDistance_Steps <- mod2_DailyActivity %>% filter(TotalDistance < 20 & 
#                                                       TotalSteps < 25000)

## WE WILL USE ONLY DATASET Number 1 #################
# DATASET #2::: Heart Rate
HeartRate <- read_csv("Fitabase Data 3.12.16-4.11.16/heartrate_seconds_merged.csv",col_names = T)

# DATASET #3::: Hourly Calories
HourlyCalorie <- read_csv("Fitabase Data 3.12.16-4.11.16/hourlyCalories_merged.csv",col_names = T)

# DATASET #4::: Hourly Intensity
HourlyIntensity <- read_csv("Fitabase Data 3.12.16-4.11.16/hourlyIntensities_merged.csv",col_names = T)

# DATASET #5::: Hourly Steps
HourlySteps <- read_csv("Fitabase Data 3.12.16-4.11.16/hourlySteps_merged.csv",col_names = T)

# DATASET #6::: Calories by Minute: NARROW
MinuteCalories <- read_csv("Fitabase Data 3.12.16-4.11.16/minuteCaloriesNarrow_merged.csv",col_names = T)

# DATASET #7::: Intensity by Minute: NARROW
MinuteIntensity <- read_csv("Fitabase Data 3.12.16-4.11.16/minuteIntensitiesNarrow_merged.csv",col_names = T)

# DATASET #8::: Minute METs: NARROW
MinuteMETs <- read_csv("Fitabase Data 3.12.16-4.11.16/minuteMETsNarrow_merged.csv",col_names = T)

# DATASET #9::: Sleep Duration in Minutes
MinuteSleep <- read_csv("Fitabase Data 3.12.16-4.11.16/minuteSleep_merged.csv",col_names = T)

# DATASET #10::: Steps Duration in Minutes
MinuteSteps <- read_csv("Fitabase Data 3.12.16-4.11.16/minuteStepsNarrow_merged.csv",col_names = T)

# DATASET #11::: Weight Log Information
WeightLog <- read_csv("Fitabase Data 3.12.16-4.11.16/weightLogInfo_merged.csv",col_names = T)
