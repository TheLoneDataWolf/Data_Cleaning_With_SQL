# Data_Cleaning_With_SQL
Cleaning the Nashville Housing Dataset with SQL.  Please refer to the code to see the various functions implemented to get the job done!

First, I Standardized the Date Format to make it just Date and not the time included
Second, I needed to fill out the Property Address, by identifying data that had simlar entries but the Entries for the PropertyAddress was missing
Thrid, Seprating the Address columns to City, Address, and State to make it more readable
Fourth, In the SoldAsVacant Column there were 'Y' and 'N' entries that needed to be changed to 'YES' and 'NO'
Fifth, I removed duplicates by using ROW_NUMBER as an identifier and partioned it by the following filed(please refer to the code) and then perform a window function to query the results 
Sixth, I deleted all the useless columns to make the overall Dataset more readable


I hope you enjoyed this project and learn something as have I! :) 
