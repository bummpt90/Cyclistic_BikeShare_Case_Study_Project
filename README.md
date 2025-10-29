Cyclistic Bike Share: Casual Rider to Annual Member Conversion Strategy

Project Summary

This project is the capstone analysis for the Google Data Analytics Professional Certificate. The goal was to analyze 12 months of historical bike-share trip data from Cyclistic to identify key differences in usage patterns between annual members and casual riders.

The findings culminated in three data-driven marketing recommendations designed to convert casual, leisure-focused users into long-term, utility-focused annual members, thereby increasing Annual Recurring Revenue (ARR).

🎯 Business Problem

The Director of Marketing, Moreno, tasked the analytics team with answering the following question:

"How do annual members and casual riders use Cyclistic bikes differently, and how can Cyclistic use digital media to influence casual riders to become members?"

💻 Tools & Technologies

R & RStudio: Data cleaning, manipulation, and initial descriptive analysis (using tidyverse, lubridate, etc.).

Tableau: Data visualization and dashboard creation for stakeholder presentation.

Google Sheets / Excel: Initial data inspection and quality checks.

💾 Data Source

The analysis uses Cyclistic's historical trip data, which is publicly available.

Source: [Insert Link to Data Source Here, e.g., Divvy Public Data]

Time Period: 12 months of trip data (e.g., May 2024 - April 2025).

Note: Due to the large volume of data (over 5 million records), the process required robust data merging and cleaning in R.

📈 Methodology: The 6 Stages

The project followed the official data analysis process: Ask, Prepare, Process, Analyze, Share, Act.

1. Prepare & Process

Data Consolidation: Merged 12 separate monthly CSV files into a single R data frame.

Cleaning & Feature Engineering: Created the ride_length (duration in minutes) and day_of_week fields.

Outlier Removal: Filtered out invalid trips:

Trips: 1 minute (errors/tests)..

Trips: 1440 minutes (24 hours) (outliers/lost bikes).

2. Analyze

The analysis focused on two primary behavioral differences: Duration and Time/Day of Use.

🔑 Key Findings & Core Insight

The data clearly segmented the user base into two distinct personas:

1. The Core Conversion Opportunity: Ride Duration

Rider Type         Average Ride Duration             
Annual Member      11 minutes (Utility/Commuting)

Casual Rider       38 minutes (Leisure/Recreation)

Insight: Casual riders are heavily invested in long, recreational trips, for which they currently overpay using the single-ride pass structure.

2. Temporal Behavior

Rider Type            Peak Usage Day

Annual Member         Monday - Thursday (The Work Week)

Casual Rider          Saturday - Sunday (The Weekend)

Insight: Conversion efforts must be focused on weekend value rather than weekday commuting incentives.

📊 Final Deliverables & Visuals

The complete analysis is documented in the final Tableau Dashboard and a detailed RMarkdown Report.

Tableau Dashboard: (https://public.tableau.com/app/profile/matthew.beeun/viz/BikeShareDashboardforGoogleDataAnalyticProject/Dashboard1)

RMarkdown Report: 

✅ Recommendations (The "Act" Phase)

Based on the evidence that Casual Riders are primarily weekend leisure users, the strategy is to align membership value with their current habits:

Introduce a "Weekend Pass" or "Leisure Membership": A cost-effective, specialized membership covering Friday night through Sunday to directly target their most frequent and longest usage period.

Implement Real-Time Cost-Saving Communication: Use in-app or email notifications immediately after a long, expensive casual trip to show the real-time savings offered by an annual membership.

Geo-Target Promotions at Leisure Hubs: Focus advertising efforts at bike stations near parks, lakefronts, and tourist attractions where the highest volume of casual weekend trips originate.
