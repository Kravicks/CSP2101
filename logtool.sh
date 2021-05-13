#!/bin/bash
declare -a logs # declare array logs
declare -a AcceptedInput # declare array  AcceptedInput
declare -a OperatorList # declare array  OperatorList
declare -a SearchArray # declare array  SearchArray
OperatorList=(">","<","==","!=") # populate the operator list of accepted operators
patt="serv_acc_log.+csv$" # store the pattern of the names of csv files




mennum=0 # SETUP Arrays and constants
exit=0
AcceptedInput=('PROTOCOL',"SRC_IP",'SRC_PORT','DEST_IP','DEST_PORT','PACKETS','BYTES','CLASS') # Populate array with search fields

ReadFile(){ # Function to read the final file in the users directory and file and echo if the the linecount exceeds the warning value
    InputDir=$(pwd) # store current working directory in the variable inputdir
    cd ~
    cd $dir
    cat $fname
    LineCount=$(cat $fname| wc -l)
    cd /
    cd $InputDir
    if [[ $LineCount -ge $WarningValue ]]; then
        echo  "The logs have exceeded your warning limit!"
   fi
}
Validate(){ # Declare validate function
again=1 
while [[ "$again" -eq 1 ]]; do # While loop that compares the given user input to all elements in the Accepted input array
    read -p "Enter field: " a
    Wcount=$(printf "%s\n" "${AcceptedInput[@]}"|grep -i -w $a | wc -w ) # prints all accepted inputs, pipes to grep and perform a case insensitive search on whole words that match user input
                                                                    # pipes to get word count and store it in the variable Wcount
    if [[ $Wcount -ge 1 ]]; then #if wcount is greater than or equal one , set again to zero and break the       while loop
    
        again=0
    elif [[ $Wcount -eq 0 ]]; then
        echo " Entered search field does not match a given field, please try again" # if wordcount = 0 tell the user the input was incorrect and repeat the loop
          
    fi

done
}

CheckField(){ # Check field function to check that the given field details are acceptable

if [ "$1" == "PROTOCOL" ]; then # if the function argument is equal to protocol, execute the following code
    declare -a protocols
    protocols=('TCP','UDP','ICMP','GRE') # populate array full of accepted protocols
    echo $protocols
    again=1
    while [[ $again -eq 1 ]]; do
        read -p "Enter a protocol from the list: " prot
        prot=${prot^^} # turns given protocol into all caps
        if [[ "${protocols[@]}" =~ "${prot}" ]]; then # if the input from the user is found in the array of accepted protocols, add the user input to search array and end the loop
            SearchArray+=($prot)
            again=0
        elif [[ ! "${protocols[@]}" =~ "${prot}" ]]; then # if the input from the user is not found in the array of accepted protocols, print error message and continue the loop
            echo "Not a valid protocol, please try again"
        fi
    done


elif [ "$1" == "SRC_IP" ]; then  # if the function argument is equal to SRC_IP, execute the following code  
    again=1
    while [[ $again -eq 1 ]]; do
        read -p "Enter the IP field details e.g EXT, OPENSTACK, 1xxxx: " SRCipfield # get user input for ipfield
        SRCipfield=${SRCipfield^^} # make ipfield all caps
        
        if  (($SRCipfield >= 10000 && $SRCipfield <= 19999)) || [ $SRCipfield == "EXT" ] || [ $SRCipfield == "OPENSTACK" ]; then
            SearchArray+=($SRCipfield) 
            again=0
            #if the input from the user is found in the array of accepted ipfields, add the user input to search array and end the loop
        elif  (($SRCipfield < 10000 || $SRCipfield > 19999)) || [ ! $SRCipfield == "EXT" ] || [ ! $SRCipfield == "OPENSTACK" ]; then
            echo "Not a valid entry, please try again"
            #if the input from the user is not found in the array of accepted ipfields, print error message and continue the loop
        fi
    done

elif [ "$1" == "DEST_IP" ]; then  # if the function argument is equal to DEST_IP, execute the following code
    again=1
    while [[ $again -eq 1 ]]; do
        read -p "Enter the IP field details e.g EXT, OPENSTACK, 1xxxx: " DESTipfield
            DESTipfield=${DESTipfield^^}

        if (($DESTipfield >= 10000 && $DESTipfield <= 19999)) || [ $DESTipfield == "EXT" ] || [ $DESTipfield == "OPENSTACK" ]; then
            SearchArray+=($DESTipfield)
            again=0
             #if the one of the comparisons evaluates to true, add the user input to search array and end the loop

        elif (($DESTipfield < 10000 || $DESTipfield > 19999)) || [ ! $DESTipfield == "EXT" ] || [ ! $DESTipfield == "OPENSTACK" ]; then
            echo "Not a valid entry, please try again"
             #if neither one of the comparisons evaluates to true, print error message and continue loop


        fi
    done
elif [ "$1" == "SRC_PORT" ]; then  # if the function argument is equal to SRC_PORT, execute the following code
    again=1
    while [[ $again -eq 1 ]]; do
            read -p "Enter the port number 0-65535" SRCPortNum
        if (($SRCPortNum >= 0 && $SRCPortNum <= 65535)); then
            SearchArray+=($SRCPortNum)
            again=0
        #if the source port num is equal or greater than 0 and less than or equal to 65535 , add the user input to search array and end the loop
        elif (($SRCPortNum < 0 || $SRCPortNum > 65535)); then
            echo "Not a valid port number, please try again"
        #if the source port num is less than 0 or greater than 65535 , print error message and continue loop

        fi
    done

elif [ "$1" == "DEST_PORT" ]; then  # if the function argument is equal to DEST_PORT, execute the following code
    again=1
    while [[ $again -eq 1 ]]; do
            read -p "Enter the port number 0-65535" DESTPortNum
        if (($DESTPortNum >= 0 && $DESTPortNum <= 65535)); then
            SearchArray+=($DESTPortNum)
            again=0
        #if the source port num is equal or greater than 0 and less than or equal to 65535 , add the user input to search array and end the loop

        elif (($DESTPortNum < 0 || $DESTPortNum > 65535)); then
            echo "Not a valid port number, please try again"
        #if the source port num is less than 0 or greater than 65535 , print error message and continue loop

        fi
    done
elif [ "$1" == "PACKETS" ]; then # if the function argument is equal to packets, execute the following code
    again=1
    again2=1
    while [[ $again -eq 1 ]]; do
        read -p "enter amount of packets" packets
    if [[ $packets =~ ^[0-9]+$ ]]; then # if the user input matches the pattern, add the user input to the searcharray and end the while loop
        SearchArray+=($packets)
        again=0
    elif [[ ! $packets =~ ^[0-9]+$ ]]; then # if the user input does not match the pattern, print an error message and continue the while loop
        echo "Not a digit, please try again"
    fi
    done
    
    while [[ $again2 -eq 1 ]]; do
        read -p "Greater than (>), Less than (<), Equal to (==) Or not equal to !=: " PacketOP
        if [[ "${OperatorList[@]}" =~ "${PacketOP}" ]]; then # if the user input is found in the operatorlist array end the while loop
            again2=0
        elif [[ ! "${OperatorList[@]}" =~ "${PacketOP}" ]]; then # if the user input is not found in the operatorlist array print an error message and continue the while loop
            echo "Not a valid Operator, please try again"
    fi
    done
elif [ "$1" == "BYTES" ]; then # if the function argument is equal to packets, execute the following code
    again=1
    again2=1
    while [[ $again -eq 1 ]]; do 
        read -p "enter amount of bytes" Bytes
        if [[ $Bytes =~ ^[0-9]+$ ]]; then # if the user input matches the pattern, add the user input to the searcharray and end the while loop
            SearchArray+=($Bytes)
            again=0
        elif [[ ! $Bytes =~ ^[0-9]+$ ]]; then # if the user input does not match the pattern, print error message and continue the while loop
            echo "Not a digit, please try again"
        fi
    done
    while [[ $again2 -eq 1 ]]; do
        read -p "Greater than (>), Less than (<), Equal to (==) Or not equal to !=: " ByteOP
        if [[ "${OperatorList[@]}" =~ "${ByteOP}" ]]; then # if the user input is found in the operatorlist array end the while loop
            again2=0
        elif [[ ! "${OperatorList[@]}" =~ "${ByteOP}" ]]; then # if the user input is not found in the operatorlist array print an error message and continue the while loop
            echo "Not a valid Operator, please try again"
        fi
    done


fi

}
# Iterate through files in current directroy
for file in ./*; do # for every file in the directory, 
    if [[ $file =~ $patt ]]; then # for every file that has the pattern of the a server log
        logs+=($(basename $file)) # Populate array with file names in directory that match the pattern
    fi
done
# Function to create directory and file name if they dont exist
DirectFile(){
    InputDir=$(pwd) # Set variable to current working directory
    cd ~ # change directroy to home directory
    if [[ ! -d $dir ]]; then # if directory given by user isnt a directory make the directory then travel to that directroy
        mkdir $dir
        cd $dir
        if [[ ! -f $fname ]]; then # if the file given by the user doesnt exist, create the file
            touch $fname
        fi
        cd / # travel to root directory
        cd $InputDir # travel back to the original working directory
    elif [[ -d $dir ]]; then # if directory exists travel to the directroy and create the file
        cd $dir
        touch $fname
        cd /
        cd $InputDir
    fi

}

while [ $exit -eq 0 ]; do # start a while loop that creates a menu and doesnt exit until user chooses exit option
    read -p "    MENU- Select 1,2,3 or 4
    1) Field Options
    2) Log search Options
    3) Begin search
    4) Warning limit
    5) Exit program" menuanswer # Create menu and store menu choice in variable menuanswer

    if [[ $menuanswer -eq 1 ]]; then # if menuanswer == 1 execute the following code
        SearchArray=() # Set search array to empty when the user attempts to change their field options
        answer1="" 
        answer2=""
        answer3=""
        read -p "How many fields to include:
        1
        2
        3 " NumFields # Get user input on how many fields to have in their search
        if [[ "$NumFields" -eq 3 ]]; then # if numfields == 3 execute the following code
            echo $AcceptedInput

            
            Validate 
            answer1=$a # Set answer1 to the variable from the function validate
            answer1=${answer1^^} # converts all characters to uppercase to search through csv
            CheckField $answer1 # call the function checkfield with answer1 as the arguement

                

            Validate
            answer2=$a # Set answer2 to the variable from the function validate
            answer2=${answer2^^} # converts all characters to uppercase to search through csv
            CheckField $answer2  # call the function checkfield with answer2 as the arguement  

            Validate
            answer3=$a # Set answer2 to the variable from the function validate
            answer3=${answer3^^} # converts all characters to uppercase to search through csv
            CheckField $answer3 # call the function checkfield with answer2 as the arguement  

        elif [[ "$NumFields" -eq 2 ]]; then # if numfields == 2 execute the following code
            
            echo $AcceptedInput
            Validate # call the validate function
            answer1=$a # set variable to $a variable from the validate function
            answer1=${answer1^^} # set variable to all capitals
            CheckField $answer1 # call the checkfield functions with the answer1 variable as an arguement
                
            Validate
            answer2=$a
            answer2=${answer2^^}
            CheckField $answer2

        elif [[ "$NumFields" -eq 1 ]]; then
            
            echo $AcceptedInput
            Validate
            answer1=$a
            answer1=${answer1^^}
            
            CheckField $answer1
            
        fi
answer3=$(echo $answer3 | sed 's/_/ /g')    # replace the underscore with a space for all answers so that it can be used to search the csv files
answer2=$(echo $answer2 | sed 's/_/ /g')
answer1=$(echo $answer1 | sed 's/_/ /g')




count=${#logs[*]} # store the number of csv files that will be used
    elif [[ "$menuanswer" -eq 2 ]]; then
        echo -e "the logs array contains $count files.\n" #print the number of files to search
        read -p "all [1] or choose 1 [0]" choice # get user input for 1 file or all of them
        if [[ $choice =~ 0 ]]; then # if they choose to pick one file iterate through the files and echo them to the user
            mennum=0
            for file in "${logs[@]}"; do 
                echo -e "$mennum $file"
                ((mennum++))
            done
            echo -e "\t"
            read -p "Enter the number of the file in the menu you wish to search, i.e. [0,1,2,3 or 4]" sel # get the log that the user wants to use in their search
            echo "you have entered $sel"
            echo -e "${logs[$sel]}"
            sel=${logs[$sel]} # use the number the user entered as the index of the logs array and place that into the sel variable
        elif [[ $choice =~ 1 ]]; then
            echo -e "${logs[@]}"
            sel=${logs[@]} # place all the file names into the sel variable
            
        fi
    
    elif [[ "$menuanswer" -eq 3 ]]; then # if menuanswer = 3 execute the following code
        read -p "what is the path of your directory eg. Desktop/x : " dir # Get the directory path 
        read -p "what is your file name: " fname # Get the file name
        DirectFile # call the function to create the directory and the file
      
        
    
        
        
    
        for i in $sel; do # for every file in sel

            if [[ $NumFields -eq 3 ]]; then
                awk -v a1="$answer1"  -v a2="$answer2" -v a3="$answer3" 'BEGIN {FS=","}
                NR==1{for(i=1;i<=NF;i++){if($i==a1)c1=i; if ($i==a2)c2=i; if ($i==a3)c3=i;}} NR=1{printf "%-10s %-10s %-10s %s\n", $c1, $c2, $c3, $13}
                ' $i > tempfile.csv # if the user chooses 3 fields create an awk statement that uses a c style loop to iterate through the first row of fields, if $i matches an answer it wil print that column
                # once matches are found for all three answers, it will output the columns to tempfile.csv
                # the -v option is used to bringe shell variables into the awk statement
                
            elif [[ $NumFields -eq 2 ]]; then
                awk -v a1="$answer1"  -v a2="$answer2" 'BEGIN {FS=","}
                NR==1{for(i=1;i<=NF;i++){if($i==a1)c1=i; if ($i==a2)c2=i;}} NR=1{printf "%-10s %-10s %s\n", $c1, $c2, $13}
                ' $i > tempfile.csv
            elif [[ $NumFields -eq 1 ]]; then
                awk -v a1="$answer1" 'BEGIN {FS=","}
                NR==1{for(i=1;i<=NF;i++){if($i==a1)c1=i;}} NR=1{printf "%-10s %s\n", $c1, $13}
                ' $i > tempfile.csv
 
            fi

        done
        grep "suspicious" tempfile.csv > tempfile2.csv # Grep only the lines  where the class field is suspicious
        FirstEl=${SearchArray[0]} # set the variable to the first element in the search array array
        SecondEl=${SearchArray[1]} # set the variable to the first element in the search array array
        ThirdEl=${SearchArray[2]} # set the variable to the first element in the search array array
        

        if [[ "$answer1" == "PACKETS" ]] && [[ "$answer2" == "BYTES" ]]; then # if ans1 = packets and ans2 = bytes, execute below code
            if [[ "$NumFields" -eq 3 ]]; then
                #use -v option to get shell variables into awk, set ttlbytes =0, if the if statement is true, add up the ttl bytes and packets and print $1 $2 and $3 that were true in the if statement 
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlbytes=0} { if ($1 '"$PacketOP"' p && $2 '"$ByteOP"' b && $3 ~ t){ttlbytes=ttlbytes+$2; ttlpacket=ttlpacket+$1; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ",ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                #read from tempfile2 and output to the directory path/file of the users choosing
                
                ReadFile # call the function readfile to cat the user's file and get a linecount for the warning limit value
            elif [[ "$NumFields" -eq 2 ]]; then #if num fields = 2  get the first and second index of the search array compare $1 to userinput for packets and bytes with the byte operator and packet operator
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlbytes=0;ttlpacket=0}{ if ($1 '"$PacketOP"' p && $2 '"$ByteOP"' b) {{ttlbytes=ttlbytes+$2;ttlpacket=ttlpacket+$1; print  $1 "    " $2, "Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
                # print the $1 and $2 values that were evaluted as true in the if statement and add up the totals for ttlbytes and ttlpacket and print them
            fi
        elif [[ "$answer1" == "BYTES" ]] && [[ "$answer2" == "PACKETS" ]]; then # if ans1 = bytes and ans2 = packets execute the code below
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlbytes=0;ttlpacket=0} { if ($1 '"$ByteOP"' b && $2 '"$PacketOP"' p && $3 ~ t){ttlbytes=ttlbytes+$1; ttlpacket=ttlpacket+$2; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ",ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 2 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlbytes=0}{ if ($1 '"$ByteOP"' b && $2 '"$PacketOP"' p) {{ttlbytes=ttlbytes+$1;print  $1 "    " $2, "Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
            fi
        
        
        
        elif [[ "$answer1" == "BYTES" ]] && [[ "$answer3" == "PACKETS" ]]; then

            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlpacket=0;ttlbytes=0} { if ($1 '"$ByteOP"' b && $2 ~ s && $3 '"$PacketOP"' p){ttlbytes=ttlbytes+$1; ttlpacket=ttlpacket+$3; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ",ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            fi
        
        elif [[ "$answer2" == "BYTES" ]] && [[ "$answer3" == "PACKETS" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlpacket=0;ttlbytes=0} { if ($1 ~ f && $2 '"$ByteOP"' b && $3 '"$PacketOP"' p){ttlbytes=ttlbytes+$2; ttlpacket=ttlpacket+$3; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ",ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            fi
        elif [[ "$answer1" == "PACKETS" ]] && [[ "$answer3" == "BYTES" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" -v p="$packets" 'BEGIN {ttlpacket=0;ttlbytes=0} { if ($1 '"$PacketOP"' b && $2 ~ s && $3 '"$ByteOP"' p){ttlbytes=ttlbytes+$1; ttlpacket=ttlpacket+$3; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ",ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            fi
        elif [[ "$answer1" == "PACKETS" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v p="$packets" 'BEGIN {ttlpacket=0}{ if ($1 '"$PacketOP"' p && $2 ~ s && $3 ~ t) {ttlpacket=ttlpacket+$1; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Packets: ", ttlpacket > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 2 ]]; then
                awk -v f="$FirstEl" -v s="$SecondEl" -v p="$packets" -v fn="$fname" -v path="$dir" 'BEGIN {ttlpacket=0}{ if ($1 '"$PacketOP"' p && $2 ~ s) {ttlpacket=ttlpacket+$1; print  $1 "    " $2, " Total Packets: ", ttlpacket > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 1 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v p="$packets" 'BEGIN {ttlpacket=0} { if ($1 '"$PacketOP"' p){ttlpacket=ttlpacket+$1; print  $1, "Total Packets: ", ttlpacket > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            fi
        elif [[ "$answer2" == "PACKETS" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v p="$packets" 'BEGIN {ttlpacket=0}{ if ($1 ~ f && $2 '"$PacketOP"' p && $3 ~ t) {ttlpacket=ttlpacket+$2; printf "%-8s %-8s %-8s %-8s %-8s \n", $1, $2, $3, "Total Packets: ", ttlpacket > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 2 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v p="$packets" 'BEGIN {ttlpacket=0}{ if ($1 ~ f && $2 '"$PacketOP"' p) {{ttlpacket=ttlpacket+$2; print  $1 "    " $2, " Total Packets: ", ttlpacket > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
            fi
        elif [[ "$answer3" == "PACKETS" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v p="$packets" 'BEGIN {ttlpacket=0}{ if ($1 ~ f && $2 ~ s && $3 '"$PacketOP"' p) {{ttlpacket=ttlpacket+$3; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Packets: ",ttlpacket  > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
            fi

       


        elif [[ "$answer1" == "BYTES" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" 'BEGIN {ttlbytes=0}{ if ($1 '"$ByteOP"' b && $2 ~ s && $3 ~ t) {{ttlbytes=ttlbytes+$1; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 2 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v b="$Bytes" 'BEGIN {ttlbytes=0}{ if ($1 '"$ByteOP"' b && $2 ~ s) {ttlbytes=ttlbytes+$1; print $1 "    " $2, "Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 1 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v b="$Bytes" 'BEGIN {ttlbytes=0} { if ($1 '"$ByteOP"' b){ttlbytes=ttlbytes+$1; print  $1, "Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}}  ' tempfile2.csv
                ReadFile
            fi
        elif [[ "$answer2" == "BYTES" ]]; then
            if [[ "$NumFields" -eq 3 ]]; then          
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" 'BEGIN {ttlbytes=0} { if ($1 ~ f && $2 '"$ByteOP"' b && $3 ~ t){ttlbytes=ttlbytes+$2; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ",ttlbytes > ("/home/kali/"path"/" fn)}} ' tempfile2.csv
                ReadFile
                elif [[ "$NumFields" -eq 2 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v b="$Bytes" 'BEGIN {ttlbytes=0}{ if ($1 ~ f && $2 '"$ByteOP"' b) {{ttlbytes=ttlbytes+$2;print  $1 "    " $2   " Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
            fi
        elif [[ "$answer3" == "BYTES" ]]; then 
            if [[ "$NumFields" -eq 3 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" -v b="$Bytes" 'BEGIN {ttlbytes=0}{ if ($1 ~ f && $2 ~ s && $3 '"$ByteOP"' b) {{ttlbytes=ttlbytes+$3; printf "%-8s %-8s %-8s %-8s %-8s \n",  $1, $2, $3, "Total Bytes: ", ttlbytes > ("/home/kali/"path"/" fn)}}} ' tempfile2.csv
                ReadFile
                
            fi





       
       
        else if [[ "$NumFields" -eq 3 ]]; then  # if none of the answers are either packets or bytes execute the code  below
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" -v t="$ThirdEl" '{ if ($1 ~ f && $2 ~ s && $3 ~ t) {printf "%-10s %-10s %-10s \n" $1, $2, $3 > ("/home/kali/"path"/" fn)}}' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 2 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" -v s="$SecondEl" '{ if ($1~f && $2 ~ s) {printf "%-10s %-10s \n"  $1, $2 > ("/home/kali/"path"/" fn)}}' tempfile2.csv
                ReadFile
            elif [[ "$NumFields" -eq 1 ]]; then
                awk -v fn="$fname" -v path="$dir" -v f="$FirstEl" ' { if ( $1 ~ f) {print  $1  > ("/home/kali/"path"/" fn)}}' tempfile2.csv
                ReadFile
            fi
        fi
        

     
    elif [[ "$menuanswer" -eq 4 ]]; then   # Prompt user for a value that they would like a warning even # of matching logs exceed it
        read -p "Enter the limit amount of logs that where you would like to recieve a warning: " WarningValue 

    elif [[ "$menuanswer" -eq 5 ]]; then # if user inputs 5 in the menu, the program will exit
        exit=1
    fi
done     
exit 