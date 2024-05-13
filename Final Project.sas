/********************************************
PURPOSE: Final Project: COVID-19 Data Analysis
DATA SETS: 
    COVID-19 data comes from the Center for Systems Science and Engineering at Johns Hopkins University; 
    Region data comes from the U.S. Census; 
PROGRAMMER: Helen Liang, Ivy Zhao
DATE UPDATED: 5/7/2020
 ********************************************/


libname mylib "/home/u63668564/GPH-GU-2022 SAS Bootcamp/Final Project";

/* 1. Provide basic information about the data source and the purpose of this data analysis. */

/* This analysis focuses on COVID-19 data in the state of Minnesota during the study period from June 1 to June 7, 2020. 
Our goal is to understand the COVID-19 trends, compare outcomes with regional averages, and make recommendations to policymakers. */

/* 2a. What was the total number of COVID-19 outcomes of 
(a) tests,
(b) confirmed cases,
(c) hospitalizations, and 
(d) deaths 
recorded in Minnesota at the beginning of the study period (on June 1)? */

data mylib.cd0601;
    set mylib.cd0601;
run;

proc means data=mylib.cd0601 sum;
    where Province_State = "Minnesota"; 
run;

/* tests = 255,592
   confirmed cases = 25,208
   hospitalizations = 3,086
   deaths = 1,060 */

/* 2b. Now, merge COVID-19 dataset with Census region data. */

data mylib.region;
    set mylib.region;
run;

data mylib.cd0601_merged;
    merge mylib.cd0601 
          mylib.region;
run;

/* 2c. What was the average number of COVID-19 outcomes of
(a) tests, 
(b) confirmed cases, 
(c) hospitalizations, and 
(d) deaths 
recorded in your state’s region at the beginning of the study period (on June 1)? */

proc means data=mylib.cd0601_merged mean;
    where Region = "Midwest";
run;

/* tests = 279,553.75
   confirmed cases = 29,889.83
   hospitalizations = 2,729.57
   deaths = 1,564.50  */

/* 3. Next, merge all COVID-19 datasets provided into one combined dataset. */

data mylib.all_covid;
    set mylib.cd0531
    	mylib.cd0601
        mylib.cd0602
        mylib.cd0603
        mylib.cd0604
        mylib.cd0605
        mylib.cd0606
        mylib.cd0607;
run;

/* 4. Describe daily trends for a specific outcome of your choice. 
Briefly explain why you chose that one specific outcome to assess daily changes during the study period. 
This can be in a graph format but be sure to write a brief description. */

/* 4a. Compute the number of new COVID-19 outcomes for each day of the study period (June 1-7, 2020) 
by subtracting the total number of the same outcome recorded the day before from the total number reported that day.
Outcome selected = Confirmed */

/* Sort data by date and filtering for Minnesota */
proc sort data=mylib.all_covid out=mylib.mn_covid;
    by Last_Update;
    where Province_State = "Minnesota";
run;

/* Calculate new daily confirmed cases */
data mylib.mn_new_cases;
    set mylib.mn_covid;
    by Last_Update;
    retain prev_confirmed 0;
    new_confirmed = Confirmed - prev_confirmed;
    prev_confirmed = Confirmed;
    if _n_ = 1 then new_confirmed = .; 
    drop prev_confirmed;
run;

/* Print data */
proc print data=mylib.mn_new_cases;
    var Last_Update Confirmed new_confirmed;

/* Plot daily trends in new confirmed cases */
proc sgplot data=mylib.mn_new_cases;
    series x=Last_Update y=new_confirmed / lineattrs=(color=blue);
    xaxis label="Date";
    yaxis label="New Confirmed Cases";
run;

/* For this “new outcome,” you will choose only one outcome from
(a) tests, 
(b) confirmed cases, 
(c) hospitalizations, or 
(d) deaths. 

Be sure to explain why you chose that one specific outcome. 

How did the total daily number of “new outcome” change over time in your state during the study period (June 1-7, 2020)? 
Did these numbers increase, decrease, or pretty much stay the same? */

/* We chose to analyze daily trends of new confirmed COVID-19 cases because they directly reflected infection trends over time. 
Monitoring new confirmed cases is crucial for understanding the virus's transmission dynamics and assists public health administrators in executing timely interventions. 

Table 2 displayed the number of total and new confirmed COVID-19 cases in Minnesota from June 1 to June 7, 2020, with Figure 1 illustrating daily trends of new confirmed cases. 
The data highlights daily changes in newly confirmed cases, with a gradual and steady increase from June 2nd to June 5th, then a steep increase with the peak on June 7th (707 new confirmed cases) before the rapid decline on June 8th with 385 new confirmed cases (not shown in Table 2). 
Despite the decline, the trend on new confirmed COVID-19 cases remains relatively high. */