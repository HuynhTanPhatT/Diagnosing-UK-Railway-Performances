# 🚂UK Rail Transport: Diagnosing Ticket Sales, Revenue & On-Time Performance (12/2023 - 05/2024)
- Author: Huỳnh Tấn Phát **(Transportation Data Analyst)**
- Date: 12/2025
- Tool Used: **Python**, **Power Bi**, **SQL**
  - `Python`: Pandas, Numpy, Datetime
  - `Power Bi`: Dax, calculated columns, data visualization, data modeling, ETL
  - `SQL`: CTEs, Joins, Case, aggregate functions



# ReadMe - Table Of Contents (TOCS)
1. [Executive Summary]()
2. [Background & Objectives]()
3. [Dataset Description]()
4. [Data Processing & Metric Definations (Dax)]()
5. [Defining Key Questions before Data Visualization]()
6. [Key Insights & Visualization]()
7. [Recommendations]()

# 🚀 Executive Summary 
- This project analyzes UK railway ticket and operation data to show how revenue, passenger demand, and on-time performance are connected.
- Using data from **+30.000** ticket transactions (`Online`, `Station`), the analysis helps **Railway Managers**:
  - See which routes and ticket types generate revenue
  - Understand when passengers travel the most
  - Identify routes with delays, cancellations, and revenue loss
- The objective is to support data-driven decisions in route planning, scheduling, and service reliability.


# 📌Background & Objectives
## Background: 
- The UK railway system operates under high passenger demand, where even small delays or cancellations can lead to revenue loss and reduced customer trust.
- Understanding how ticket sales, travel demand, and punctuality is important for improving operational efficiency and maintaining service reliability.

## Four Requirements from the Manager:
1. Analyze revenue from different ticket types & classes
2. Identify the most popular routes
3. Determine peak travel times
4. Diagnose on-time performance and contributing factors

## 🕵🏼‍♂️Who is this project for ?
- Manager of National Rail Service
- Operation Team

# 📂Dataset Description
## 📌Data Source:
- Source:
    - [Kaggle](https://www.kaggle.com/datasets/motsimaslam/national-rail-uk-train-ticket-data)
    - [Maven Anlytics](https://mavenanalytics.io/challenges/maven-rail-challenge)
- Size: The **Ticket** table contains **31.653** records with **18** fields
- Format: CSV

## 📊Data Relationships
<img width="1590" height="713" alt="image" src="https://github.com/user-attachments/assets/2f66dcbe-33d8-4257-88e0-de66108a9c2d" />



# Data Processing by Python & Power Bi

1. Using [Python](https://github.com/HuynhTanPhatT/UK-National-Railway-Ticket-Analysis/tree/main/Python%3A%20Data%20Cleaning) to:
> - **Data Cleaning**: check data quality, handle null values, convert data types, detect anomalies, recreate columns and update values.

2. Using [Power Bi](https://app.powerbi.com/view?r=eyJrIjoiZjZhMzMxNDAtZTcyYy00NGQ5LWE3ZjgtNDJiZmM1MzIzMjQ5IiwidCI6IjkxMTg1MWRjLTc5MTItNGY4OC1hMGU3LWI3YTRiYjNmYjlmYSIsImMiOjEwfQ%3D%3D&pageName=c66eabf02506d6147000) to:
> - ETL
> - DAX Calculations & Formulas

- `🔶Employ some several DAX formulas to calculate Key Performance Indicators (KPIs)`:
<details>
  <summary>Click to view examples of DAX formulas</summary>
  <br>

- **Ticket Sales**: The number of tickets sold
```dax
1_ticket_sales = COUNT(FactTable[transaction_id])

1_cancelled_ticket_sales = CALCULATE(
    COUNT(FactTable[transaction_id]),
    FILTER(FactTable,FactTable[journey_status] = "Cancelled"))

1_refunded_ticket_sales = CALCULATE(
    COUNTROWS(FactTable),
    FILTER(FactTable,FactTable[refund_requested] = "Yes"))

2_average_price_per_ticket (APT) = 
    DIVIDE([2_gross_revenue],[1_ticket_sales])
```

- **Revenue**:
```dax
2_gross_revenue = sum(FactTable[ticket_price])

2_net_revenue = //ticket_sold * price (actual earned)
CALCULATE(
    SUMX(FactTable,FactTable[ticket_price]),
    FactTable[refund_requested] = "No")

2_refund_revenue = CALCULATE(
    SUM(FactTable[ticket_price]),
    FILTER(FactTable,FactTable[refund_requested] = "Yes"))
```

- **On-Time Performance (OTP)**: The percentage of services that arrive or depart exactly without 0-minute delay
  - Formula: (Number of On-Time Trips / Total Number of Trips Arriving at Train Stops) × 100

```dax
4_%on-time performance = 
DIVIDE(
    [3_on-time train trips],
    [3_on-time train trips] + [3_delayed train trips])
```

</details>

- `🔶Employee some several DAX Formulas to calculate Customer Measures`:
<details>
    <summary>Click to view examples of DAX formulas</summary>
    <br>

- **Total Train Trips**: The total count of all train trips in the dataset, including on-time, delayed, and cancelled trips.
```dax
3_daily_train_trips = 
VAR total_train_trips = 
    SUMMARIZECOLUMNS(
        DimDate[Date],
        DimStation[route],
        "Trips", DISTINCTCOUNT(FactTable[departure_time]))
RETURN
SUMX(total_train_trips, [Trips])
```

- **On-Time Train Trips**: 
```dax
3_on-time train trips = 
VAR on_time_train_trips =
    SUMMARIZECOLUMNS(
        DimDate[Date],
        DimStation[route],
        FILTER(FactTable,FactTable[journey_status] = "On Time"),
        "Trips", DISTINCTCOUNT(FactTable[departure_time]))
RETURN
SUMX(on_time_train_trips, [Trips])
```

- **Delayed Train Trips**
```dax
3_delayed train trips = 
VAR delayed_train_trips =
    SUMMARIZECOLUMNS(
        DimDate[Date],
        DimStation[route],
        FILTER(FactTable,FactTable[journey_status] = "Delayed"),
        "Trips", DISTINCTCOUNT(FactTable[departure_time]))
RETURN
SUMX(delayed_train_trips, [Trips])
```

- **Cancelled Train Trips**
```dax
3_cancelled train trips = 
VAR total_cancelled_train_trips =
    SUMMARIZECOLUMNS(
        DimDate[Date],
        DimStation[route],
        FILTER(FactTable,FactTable[journey_status] = "Cancelled"),
        "Trips", DISTINCTCOUNT(FactTable[departure_time]))
RETURN
SUMX(total_cancelled_train_trips, [Trips])
```

</details>


# 🗯️Defining Key Questions before Data Visualization
## Step 1 & Step 2
<img width="1218" height="682" alt="image" src="https://github.com/user-attachments/assets/6e74e78a-0306-49d4-a463-cc5c24cd4f47" />



## Detailed Step 2
<img width="1226" height="684" alt="image" src="https://github.com/user-attachments/assets/b0e2a671-4246-4294-b813-46bc3738c778" />



# 📊Key Insights & Visualizations
## I. Overview
<img width="1300" height="730" alt="Page 1" src="https://github.com/user-attachments/assets/9e65e40f-dd45-4d20-bc91-45fbc34d69e1" />




## 📌Key Findings:
1. **Ticket Sales & Revenue Overview**:
    - From 12/2023 -> 05/2024, the company sold **⇈31.00K** tickets, bringing in ~**742K** USD in **gross revenue** with an average ticket price of **23.44** USD.
    - However, due to operational issues (weather, technical issues,etc..), **1.12K** tickets were refunded, leading to a revenue loss of **38.70K**.

    => **`Revenue loss is mainly affected by operational issues. Improving them could increase net revenue, while enhancing the customer experience.`**

2. **Ticket Purchases**:
    - Online purchases account for **59.32%** of total ticket sales (**18.11K**), mainly because of `a lower average ticket price` compared to Station purchases (**$20.67** vs. **$27.35**).
    - Even though Online sold **5.3K** more tickets than Station, the total net revenue gap remains small (**374.54K** vs. **328.68K**).


3. **Passengers prefer low-priced tickets**:
    - Standard-class tickets make up **90%** of total sales (**27.59K** tickets at **$20.72**) across both purchases, bringing **560K** (~**80%**) in total revenue -- Advance tickets being the most common type (**55.27**) within this class.

    => **`The UK ticket market prefers low-cost ticket options, particularly Standard (Advance)`**

5. **City**:
    - The top 5 highest-selling cities are concentrated around **London**, **Manchester**, **LiverPool**, **Birmingham**, **York**.
    - However, only **London** and **LiverPool** exceed the average in both ticket sales volume and revenue.
    - Notably, London records the highest transport demand:
      - Sold **15.48K** tickets (**56.10%**) of total ticket sales,
      - The number of passengers is nearly three times higher than **Manchester** (rank #2)
      - Contributed **349.09K** in net revenue, higher than other cities.
    
    => **`London is the central hub of railway services in the UK, not only contributing high passenger volume, but also generating large net revenue`**
## II. Behavior Analysis: Peak Travel Times
<img width="1299" height="731" alt="Page 2" src="https://github.com/user-attachments/assets/bc4218c4-f415-42c6-81f6-ed5b5166ba19" />



## 📌Key Findings:

1. **Passenger Demand across the Week**:
    - Passenger demand is mainly concentrated on business days, which are higher than on weekends, with a difference of **7K** passengers.
    - However, the difference between Peak Hours and Off-Peak Hours on both business days and weekends is not significant (**10.43K** vs. **11.43K**) and (**4.19K** vs. **4.48K**).
    - The highest passenger volume occurs in the morning (`5AM-12PM`), with **12.04K** passengers (**39.44%**), while the difference between AM and PM demand remains small.

2. **Peak Hours of Train Service Usage**:
    - Passenger volume increases sharply during `two main time windows`: `6-8AM` and `4-6PM`, 
aligning with daily activities: commuting to work or school.
    - In contrast, Off-Peak Hours consistently remain below **1.50K** passengers per hour.

    => **`Passenger demand is highly concentrated during peak hours.`**

3. **The distribution of passengers by Time Period**:
    - Passenger volume remains stable, ranging from **2.000**-**2.300** in both AM and PM periods.

4. **Time Slots within Peak Hours**:
    - Morning: `6:30 AM` && `8:00 AM` account for (**17.74%** - **1.409** passengers) && (**16.68%** - **1.369** passengers)
    - Evening:  `5:45 PM` && `6:45 PM` account for (**20.75%** - **1.165** passengers) & (**31.91%** - **2.545** passengers)

    => **`Train services show stable demand, but it fluctuates significantly at specific time slots within the peak hours.`**

## III. Operation Analysis: Diagnose on-time performance and contributing factors
<img width="1301" height="723" alt="Page 3" src="https://github.com/user-attachments/assets/dc1bee87-15f6-4c90-bdcc-9b39549bb457" />



## 📌Key Findings:

1. **Train Trips overview**:
  - A total of **19.87K** train trips were made by **⇈28.00K** rail passengers:
    - **18.02K** trips arrived on time at station stops (~**90%**)
    - **1.06K** trips were delayed
    - **790** trips were cancelled

2. **OTP remains Stable Over Time**:
  - **One-Time Performance** averaged **94.43%** ranging from **93.36%** to **94.77%**, with 03/2024 recording the lowest (**93.66%**)

  => **`This indicates strong operational reliability, because over 90% of train services arrived on schedule.`**

3. **Contributing factors affecting On-Time Performance**:
  - **~10%** of services were impacted mainly by:
    - Technical issues
    - Weather conditions
    - Resource issues (Staff shortage / Staffing)
    
  => **`These factors directly affect OTP and passenger experience, causing delays up to 180 minutes`**

## IV. Route Analysis: Identify the most popular routes
<img width="1302" height="726" alt="Page 4 - Ticket Sales" src="https://github.com/user-attachments/assets/47982889-3142-4186-925d-ae461b9e79f3" />


## 📌Key Findings — Ticket Sales & Revenue Contribution

<details>
  <summary>🔶Click here to Read Insights</summary>
  <br>

1. **Top 5 routes by Ticket Sales:**
  - `Four out of the top five routes with the highest ticket sales` are located in **London** (>**3.00** tickets each) -> This shows that `London is the central for rail travel demand in the UK.`
  - However, **Manchester Piccadily - LiverPool Lime Street** ranks **#1** in ticket sales with **4.537** tickets sold, but generates only ~**17K** in net revenue, which is lower than London routes.

      -> The revenue on this route is low due to `low average ticket price` (**$3.74**)

      -> This route `serves a high passenger volumes with low-priced tickets`, which is suitable with the UK market's demand

2. **Top 5 routes by Net Revenue:**
  - **London** accounts for `four out of the top five routes with the highest revenue` from (**52.03K**-**179K**)
  - Routes rank **#3** and **#4** in ticket sales volume, but generate high revenue due to `higher average ticket prices`:
    - **London King Cross - York**: **179K.498** & **$46.71**
    - **London Paddington - Reading** **63K.481** & **$16.88**
  - Additionally, **LiverPoolLime Street - London Euston** only sold **926** tickets, but with high-priced tickets (**$103.28**) generates **100K** ->  This route `ranks #2` in Net Revenue

    => **`Revenue is affected by ticket pricing - some routes with high-priced tickets generate high revenue depsite lower passenger volumes`**

3. **Top 5 routes with Highest number of Cancellations:**
  - Routes with the highest number of passenger cancellations are concentrated in London.
  - Especially, **LiverPoolLime Street - London Euston** although only have **99** cancelled passengers, this route lost **13.1K** in revenue (accounting for **~30%** of total revenue loss)

    => **`High-priced routes are high-risk: they generate significant revenue, but each cancellation leads to a signficant larger revenue loss compared to low-priced tickets.`**

4. **Routes & Cities with Poor Ticket Sales Performance:**
- **Edinburgh** has only one route, but **100%** delay affecting **51** passengers, leading to **2.09K** in refunds, with `no effective train trips.`
- **Bristol** also has one route, with very low passenger volume (**16 passengers**), and **98** in revenue.

</details>

<img width="1301" height="722" alt="Page 4 - Operational Efficiency" src="https://github.com/user-attachments/assets/318afe08-b3a2-47dd-9db5-4ac081ecd39a" />



## 📌Key Findings — Operational Efficiency
<details>
  <summary>🔶Click here to Read Insights</summary>
  <br>

1. **Top 5 Routes with the Highest On-Time Performance:**
  - The routes with the highest ticket sales are also the routes with the largest number of operated train trips.
  - These routes are also the highest number of on-time train trips.


2. **Top 5 Routes with the Highest Delays:**
  - Nearly **70%** of all delayed train trips are concentrated in **Liverpool** and **Manchester**, across 3 routes with (>**150** delayed trips) each:
    - **LiverPoolLime Street - London Euston** (#2 in Net Revenue)
    - **Manchester Picaddlly - London Euston**
    - **Manchester Piccadily - LiverPool Lime Street** (#1 in ticket sales)

3. **Top 5 Cancelled:**
  -`Four out of the five routes with the highest number of cancelled trips` are located in London, contributing **57.09%** of total cancellations.

4.  **Routes & Cties with Stable operations but Low Market Demand:**
  - Routes in **Bristol** and **Reading** show **100%** On-Time Performance, with no delays.
  - However, these routes generate low passenger volumes and revenue

</details>


## 📌 Key Conclusion

1️⃣ London is the central hub for rail travel in the UK, accounting for **56%** of passenger demand, nearly **54%** of total operated train trips, and generating **64%** of total revenue.

-> With **57.09** of all cancelledd trips, each cancellation impacts on `customer experience`, `trust in railway services`, and causes `significant revenue loss`.

2️⃣ **Liverpool**, **Manchester** are the two cities with the highest delays, combining and accounting for ~70% of all delayed train trips.

3️⃣ **Bristol** , **Reading** and **Edinburghm** show `stable on-time performance (OTP)`. Howver, passenger volume and revenue remain extremely low. The primary reason is `low market demand`, it's not about `operational performance`, and these routes currently haven't delivered any meaningful business value.

## V. Action Strategies
<img width="1299" height="727" alt="Page 5" src="https://github.com/user-attachments/assets/3bef2867-e097-46b0-ad05-ce317a7d4b47" />



# 💡Recommendations






| **Who**     | **Strategy**                                           | **Insight**                                                                                                                                                                                                                                                                                                                                                             | **Recommendation**                                                                                                                                                                                                                                                                                                                                                                      |
| ----------- | ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Manager**  | **1.🎯 Increase Revenue through Ticket Types & Classes** | 🔹 `Standard` tickets account for **90.36%** of total ticket sales (**27.59K**). <br><br> 🔹 `First-Class` ticket prices are consistently higher than `Standard` tickets, regardless of **Peak** or **Off-Peak** hours, weekdays or weekends. Additionally, from a passenger perspective, `First-Class` tickets are often unaffordable. | 💡**Apply** discounts or promotional offers for `First-Class` tickets to stimulate demand. <br><br> 💡**Focus** these strategies on low-demand time slots, especially on routes with strong demand. |
| **Manager** | **2.⌛ Optimize Staff Resources based on Peak Hours** |🔹 The highest passenger volume increases huge during `two main time windows`: `6-8 AM` and `4-6 PM`: <br>     ▪️`6:30 AM`: **17.74%** (**1.409** passengers) <br>     ▪️`8 AM`:  **16.68%** (**1.369** passengers) <br>     ▪️`5:45PM`: **20.75** (**1.165** passengers) <br>     ▪️`6:45 PM`: **31.91%** (**2.545** passengers) <br>🔹 `Four out of top five routes with the highest ticket sales` are located in **London** (>**3.000** ticket sales). | 💡**Optimize** staffing by increasing number of staff especially at peak hours where having the highest distribution of passenger vomes and routes. |
| **Rail Operation Team** | **3.⚙️ Improve Operational Efficency by reducing delay drivers** | 🔹 **~10%** of total train trips were delayed due to key factors: <br>     ▪️Technical issues <br>     ▪️Weather conditions <br>     ▪️ Resource issues (Staff shortages/staffing). | 💡Address `staff shortages` through improved schedule <br> 💡Enhance infrastructure resilience - especially the `Railway Signalling system` on routes with a high freqency of this technical failures <br> 💡Minimize the impact of Weather conditions. |
| **Rail Operation Team** | **4.🛤️ Close Underperforming Routes** | 🔹 **Bristol** and **Edinburghm** shows consistenly low passenger volume and revenue - particularly routes in Group #3 on Page 5 (Action), which no growth trend over 5 consecutive months | 💡 For routes under Criteria #3 (Page 5), the business should consider discontinuing these routes. |

