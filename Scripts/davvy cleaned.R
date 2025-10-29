# install packages for cleaning, manipulation, transformation, visualization
install.packages(c("tidyverse", "lubridate", "rmarkdown", "readxl"))

# load the packages into r studio
library(tidyverse)
library(lubridate)
library(readxl)
library(rmarkdown)

# load the dataset into r studio for cleaning and analysis.
# load first dataset
divvy_2019_q1 <- read_excel("C:\\Users\\Mr Matthew\\Desktop\\portfolio\\Bike Share Case Study\\Datasets\\Divvy_Trips_2019_Q1.xlsx")
data(divvy_2019_q1)
View(divvy_2019_q1)


# load the dataset into r studio for cleaning and analysis.
# load first dataset
divvy_2020_q1 <- read_excel("C:\\Users\\Mr Matthew\\Desktop\\portfolio\\Bike Share Case Study\\Datasets\\Divvy_Trips_2020_Q1.xlsx")
divvy_2020_q1
View(divvy_2020_q1)

# Check the structure of the tables
str(divvy_2019_q1)
str(divvy_2020_q1)

# View the column names of the tables
colnames(divvy_2019_q1)
colnames(divvy_2020_q1)

# Summary of the tables
summary(divvy_2019_q1)
summary(divvy_2020_q1)

# Renaming and standardization
renamed_divvy_2019_q1 <- divvy_2019_q1 %>%
  rename(ride_id = trip_id,
         started_at = start_time,
         ended_at = end_time,
         start_station_id = from_station_id,
         start_station_name = from_station_name,
         end_station_id = to_station_id,
         end_station_name = to_station_name,
         member_casual = usertype) %>%
  select(ride_id,
         started_at,
         ended_at,
         start_station_id,
         start_station_name,
         end_station_id,
         end_station_name,
         rideable_type = bikeid,
         member_casual
)
renamed_divvy_2019_q1
View(renamed_divvy_2019_q1)


# Drop the unwanted columns from the 2020 
trimmed_divvy_2020_q1 <- divvy_2020_q1 %>%
  select(ride_id,
         started_at,
         ended_at,
         start_station_id,
         start_station_name,
         end_station_id,
         end_station_name,
         rideable_type,
         member_casual
    )
trimmed_divvy_2020_q1
View(trimmed_divvy_2020_q1)


# 2. CONVERT: Explicitly change the data type of ride_id in the 2019 data to <character>
# We assume the 2019 data is the one with the <double> type based on the error.

renamed_divvy_2019_q1 <- renamed_divvy_2019_q1 %>%
  mutate(ride_id = as.character(ride_id))

renamed_divvy_2019_q1 <- renamed_divvy_2019_q1 %>%
  mutate(rideable_type = as.character(rideable_type))

# combinning the two dataset after renaming and standardization
davvy_trips_merged <- bind_rows(renamed_divvy_2019_q1, trimmed_divvy_2020_q1)
davvy_trips_merged
View(davvy_trips_merged)


# Saves the single data frame object
saveRDS(davvy_trips_merged, file = "clean_cyclistic_data.rds")


# Reloads the object and assigns it to a variable (you can choose a new name here)
davvy_trips_merged <- readRDS("clean_cyclistic_data.rds")
View(davvy_trips_merged)


library(lubridate)
library(dplyr)
# data conversion 
davvy_trips_merged_converted <- davvy_trips_merged %>%
  mutate(
    started_at = ymd_hms(started_at),
    ended_at = ymd_hms(ended_at)
  )

# calculated field for ride length created and converted to numeric
davvy_trips_with_features <- davvy_trips_merged_converted %>%
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "mins"))
  )
View(davvy_trips_with_features)



library(dplyr)
library(lubridate)

davvy_trips_merged_calc <- davvy_trips_with_features %>%
  mutate(
    # Use wday() on the 'started_at' column
    # label = TRUE converts the number (1-7) to the actual day name ("Sunday", "Monday", etc.)
    # abbr = FALSE ensures the full name is used, making visualizations clearer.
    day_of_week = wday(started_at, label = TRUE, abbr = FALSE)
  )

# View the structure to confirm the new column
str(davvy_trips_merged_calc$day_of_week)
View(davvy_trips_merged_calc)



# Assuming your data frame is named 'davvy_trips_merged_calc'
davvy_clean_cyclistic_ready_data <- davvy_trips_merged_calc %>%
  # Filter out negative and extremely short rides (under 1 minute/60 seconds)
  filter(ride_length > 1)

View(davvy_clean_cyclistic_ready_data)


colnames(davvy_clean_cyclistic_ready_data)

# Saves the single data frame object
#saveRDS(clean_cyclistic_ready_data, file = "clean_cyclistic_ready_data.rds")

# Reloads the object and assigns it to a variable (you can choose a new name here)
#davvy_clean_cyclistic_ready_data <- readRDS("clean_cyclistic_ready_data.rds")
#View(davvy_clean_cyclistic_ready_data.rds)


# Analysis on the cleaned data to answer the business questions 
library(dplyr)


# Assuming your cleaned data frame is named 'clean_cyclistic_data'

davvy_summary_stats <- davvy_clean_cyclistic_ready_data %>%
  group_by(member_casual) %>%
  summarize(
    # 1. Total Number of Rides (Volume)
    number_of_rides = n(),
    
    # 2. Average Ride Length
    average_duration_mins = round(mean(ride_length), 4),
    
    # 3. Median Ride Length
    median_duration_mins = round(median(ride_length), 4),
    
    # 4. Maximum Ride Length
    max_duration_mins = round(max(ride_length), 4)
  )

# Output the results
print(davvy_summary_stats)



library(dplyr)
# Regrouping and streamlining the members using case when statement.

davvy_clean_cyclistic_ready_data <- davvy_clean_cyclistic_ready_data %>%
  # Create a new, standardized column named 'rider_type'
  mutate(rider_type = case_when(
    # Map the old 2019 'usertype' values to the new categories
    member_casual == "Customer" ~ "Casual Rider",
    member_casual == "Subscriber" ~ "Annual Member",
    
    # Map the new 2020 'member_casual' values to the new categories
    member_casual == "casual" ~ "Casual Rider",
    member_casual == "member" ~ "Annual Member"
  ))
View(davvy_clean_cyclistic_ready_data)


davvy_summary_stats_2 <- davvy_clean_cyclistic_ready_data %>%
  group_by(rider_type) %>%
  summarize(
    # 1. Total Number of Rides (Volume)
    number_of_rides = n(),
    
    # 2. Average Ride Length
    average_duration_mins = round(mean(ride_length), 4),
    
    # 3. Median Ride Length
    median_duration_mins = round(median(ride_length), 4),
    
    # 4. Maximum Ride Length
    max_duration_mins = round(max(ride_length), 4)
  )

# Output the results
print(davvy_summary_stats_2)


library(ggplot2)
# Plotting a supporting visual for the key findings
ggplot(davvy_summary_stats_2, aes(x = rider_type, y = number_of_rides, fill = rider_type)) +
  # Create the bar chart
  geom_bar(stat = "identity", position = "dodge") + 
  
  # Add the value labels on top of the bars
  geom_text(aes(label = format(number_of_rides, big.mark = ",")), 
            vjust = -0.5, size = 4) +
  
  # Apply professional labels and title
  labs(
    title = "Total Number of Trips (Q1 2019 & 2020 Combined)",
    subtitle = "Annual Members use the service more frequently for routine travel.",
    x = "Rider Type",
    y = "Total Number of Rides",
    fill = "Rider Type"
  ) +
  # Clean up the theme for better readability
  theme_minimal() +
  # Rotate axis text if names are long
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5)) +
  # Remove the y-axis line to focus on the bar height
  scale_y_continuous(labels = scales::comma)


library(ggplot2)

ggplot(davvy_summary_stats_2, aes(x = rider_type, y = average_duration_mins, fill = rider_type)) +
  # Create the bar chart
  geom_bar(stat = "identity", position = "dodge") + 
  
  # Add the value labels on top of the bars, rounding to 1 decimal place for presentation
  geom_text(aes(label = round(average_duration_mins, 1)), 
            vjust = -0.5, size = 4) +
  
  # Apply professional labels and title
  labs(
    title = "Average Trip Duration by Rider Type",
    subtitle = "Casual Riders take trips that are significantly longer than Annual Members.",
    x = "Rider Type",
    y = "Average Ride Duration (Minutes)",
    fill = "Rider Type"
  ) +
  # Clean up the theme
  theme_minimal() +
  # Customize colors (optional, but good for reporting)
  scale_fill_manual(values = c("Casual Rider" = "orange", "Annual Member" = "steelblue"))


# Temporal Usage analysis
library(dplyr)
# Assuming 'rider_type' and 'day_of_week' columns exist in 'clean_cyclistic_data'

davvy_daily_analysis <- davvy_clean_cyclistic_ready_data %>%
  group_by(rider_type, day_of_week) %>%
  summarize(
    total_rides = n(),
    average_duration_mins = round(mean(ride_length), 4)
  ) %>%
  ungroup() # Essential to remove grouping before the next step

print(davvy_daily_analysis)


# Supporting visuals

ggplot(davvy_daily_analysis, aes(x = day_of_week, y = total_rides, fill = rider_type)) +
  geom_col(position = "dodge") + # 'dodge' separates the bars for comparison
  labs(
    title = "Total Rides by Day of Week",
    subtitle = "Members use bikes for commuting (weekday focus); Casuals for leisure (weekend spike).",
    x = "Day of Week",
    y = "Total Rides",
    fill = "Rider Type"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma)


library(ggplot2)

ggplot(davvy_daily_analysis, aes(x = day_of_week, y = average_duration_mins, fill = rider_type)) +
  geom_col(position = "dodge") + # 'dodge' separates the bars for comparison
  labs(
    title = "Average Duration by Day of Week",
    subtitle = "Casual Riders have Longer trips daily.",
    x = "Day of Week",
    y = "average_duration_mins",
    fill = "Rider Type"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma)

# Recommended: Use write_csv from the readr package (part of tidyverse)
# It's generally faster and doesn't write row names by default.

write_csv(
  x = davvy_clean_cyclistic_ready_data, 
  file = "davvy_cleaned_data_for_analysis.csv"
)
