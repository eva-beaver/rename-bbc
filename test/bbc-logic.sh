#!/bin/bash

CURRFULLFILENAME=""
CURRFileExtension=""
CURRFILENAME=""

declare -a newFileName

#////////////////////////////////
function __getFileExt()
{
    CURRFileExtension=${CURRFULLFILENAME:$((len-3)):3}
    
}

#////////////////////////////////
function __getFileName()
{
    CURRFILENAME=${CURRFULLFILENAME:0:$((len-4))}
    
}


#////////////////////////////////
function __renameFile()
{
    
    # Escape_to_the_Country_Series_19_-_14._Welsh_Borders_b0c11gh2_editorial.mp4
    # Top_of_the_Pops_-_08_04_1993_m0019dvp_original.mp4
    
    CURRFULLFILENAME="$2"
    __getFileExt "$2"
    __getFileName "$2"
    
    local dashFound=0
    local dotFound=0
    
    if [[ "$CURRFILENAME" == *"-"* ]]; then
        dashFound=1
        printf "Dash\n"
    fi
    
    if [[ "$CURRFILENAME" == *"."* ]]; then
        dotFound=1
        printf "Dot\n"
    fi
    
    # Check if it has an "_"
    if [[ "$2" == *"_"* ]]; then
        
        parts=($(echo $2 | tr "_" "\n"))
        
        local length=${#parts[@]}
        
        echo "Len="$length
        
        # only process files that have 3 or more parts
        if [[ $length -gt 2 ]]; then
            
            for (( j=0; j<length; j++ ));
            do
                printf "Current index %d with value %s\n" $j "${parts[$j]}"
            done
            
        fi
        
        if [[ "${parts[0]}" == "Top" ]] && [[ "${parts[1]}" == "of" ]] && [[ "${parts[2]}" == "the" ]] && [[ "${parts[3]}" == "Pops" ]]; then
            
            printf "top of the [$dashFound]\n"
            
            if [[ $dashFound -eq 1 ]]; then
                
                printf "top of the\n"
                
                newFileName+="${parts[0]}."
                newFileName+="${parts[1]}."
                newFileName+="${parts[2]}."
                newFileName+="${parts[3]}."
                newFileName+="${parts[7]}-"
                newFileName+="${parts[6]}-"
                newFileName+="${parts[5]}"
                
                
                #for (( j=0; j<length; j++ ));
                #do
                #    printf "${parts[$j]}"
                #    #newFileName[${#newFileName[@]}]="${parts[$j]}"
                #    newFileName+="${parts[$j]}"
                #done
                
            fi
            
        fi
        
        if [[ $dashFound -eq 1 ]] && [[ $dotFound -eq 1 ]]; then
            
            printf "dash dot\n"
            
            local dashPos=0
            
            for (( j=0; j<length; j++ ));
            do
                if [[ "${parts[$j]}" == "-" ]]; then
                    dashPos=j
                    break
                else
                    newFileName+="${parts[j]}."
                fi
            done
            
        fi
        
        ((fileRenamedCnt=fileRenamedCnt+1))
        
    fi
    
    printf ">>>>>>$newFileName\n"
    
}


# Escape_to_the_Country_Series_19_-_14._Welsh_Borders_b0c11gh2_editorial.mp4
# Top_of_the_Pops_-_08_04_1993_m0019dvp_original.mp4


__renameFile "dir" "Escape_to_the_Country_Series_19_-_14._Welsh_Borders_b0c11gh2_editorial"

#__renameFile "dir" "Top_of_the_Pops_-_08_04_1993_m0019dvp_original"