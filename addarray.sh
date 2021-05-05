#!/bin/bash
declare -a ass1 # Declare an array named ass1, represents assignment one marks
declare -a ass2 # Declare an array named ass2, represents assignment two marks
ass1=(12 18 20 10 12 16 15 19 8 11) # Populates both arrays with results each student had for the assignments
ass2=(22 29 30 20 18 24 25 26 29 30)

count=0 # create a variable that will function as a counter and set it to 0

for (( i=1; i<=10; ++i )); # C style for loop that starts at 1 and ends at 10, repeats 10 times
do
    one=${ass1[$count]} # get the index of the students mark in the first assignment by using the count variable
    two=${ass2[$count]} # get the index of the students mark in the second assignment by using the count variable
    result=$(( one + two )) # add first assignment and second assignment results for this student
    echo -e "Student_$i Result:\t$result" # echo student number using current loop iteration and print their result
    (( count++ )) # iterate the counter to represent the next students index in the arrays
done
exit