#!/bin/sh

getRandomNumbers() {
  codeCount=$1
  excludedNumbers=("${!2}")
  digits=(0 1 2 3 4 5 6 7 8 9)

  if (( $# != 1 ))
  then
    for i in "${excludedNumbers[@]}"; do
      digits=(${digits[@]//*$i*})
    done
  fi
  

  result=()
  for i in $( seq 1 $codeCount )
  do
    rand=$[$RANDOM % ${#digits[@]}]
    result+=(${digits[$rand]}) 
    unset 'digits[$rand]'
    digits=( "${digits[@]}" )
  done
  echo "${result[@]}"
}

randomIndexExcept() {
  maxExcludedIndex=$1
  exceptValues=("${!2}")

  randomIndex=$[$RANDOM % $maxExcludedIndex]
  for i in "${exceptValues[@]}"
  do
      if [ "$i" -eq "$randomIndex" ] ; then
          randomIndex=$(randomIndexExcept $maxExcludedIndex exceptValues[@])
          break
      fi
  done
  echo $randomIndex
}

shuffleArray() {
  inputArray=("${!1}")
  local result=()
  for i in "${inputArray[@]}"
  do
    randIndex=$[$RANDOM % ${#inputArray[@]}]
    result+=(${inputArray[$randIndex]}) 
    unset 'inputArray[$randIndex]'
    inputArray=( "${inputArray[@]}" )
  done
  echo "${result[@]}"
}

indexOf() {
  inputArray=("${!1}")
  value=$2
  for i in "${!inputArray[@]}"; do
   [[ "${inputArray[$i]}" = "${value}" ]] && break
  done
  echo $i
}

threeCorrectWrongPlaced() {
  codeCount=$1
  correctNumbers=("${!2}")
  countMinus1=$(($codeCount-1))
  
  result=()
  for i in $( seq 0 $countMinus1 )
  do
      result[$i]=-1
  done

  shuffledCorrectNumbers=($(shuffleArray correctNumbers[@]))
  correctNumber1=(${shuffledCorrectNumbers[0]})
  correctNumber2=(${shuffledCorrectNumbers[1]})
  correctNumber3=(${shuffledCorrectNumbers[2]})
  correctIndex1=$(indexOf correctNumbers[@] $correctNumber1)
  correctIndex2=$(indexOf correctNumbers[@] $correctNumber2)
  correctIndex3=$(indexOf correctNumbers[@] $correctNumber3)
  
  exceptIndex1=($correctIndex1)
  wrongIndex1=$(randomIndexExcept $codeCount exceptIndex1[@])
  result[$wrongIndex1]=$correctNumber1

  exceptIndex2=($correctIndex2 $wrongIndex1)
  wrongIndex2=$(randomIndexExcept $codeCount exceptIndex2[@])
  result[$wrongIndex2]=$correctNumber2

  exceptIndex3=($correctIndex3 $wrongIndex1 $wrongIndex2)
  wrongIndex3=$(randomIndexExcept $codeCount exceptIndex3[@])
  result[$wrongIndex3]=$correctNumber3
  
  countMinus3=$(($codeCount-3))
  incorrectNumbers=( $(getRandomNumbers $countMinus3 correctNumbers[@]) )
  
  for i in $( seq 0 $countMinus1 )
  do
    if (( result[$i] == -1 ))
    then
      result[$i]="${incorrectNumbers[0]}"
      unset 'incorrectNumbers[0]'
      incorrectNumbers=( "${incorrectNumbers[@]}" )
    fi
  done
  echo "${result[@]}"
}

twoCorrectWrongPlaced() {
  codeCount=$1
  correctNumbers=("${!2}")
  countMinus1=$(($codeCount-1))
  
  result=()
  for i in $( seq 0 $countMinus1 )
  do
      result[$i]=-1
  done

  shuffledCorrectNumbers=($(shuffleArray correctNumbers[@]))
  correctNumber1=(${shuffledCorrectNumbers[0]})
  correctNumber2=(${shuffledCorrectNumbers[1]})
  correctIndex1=$(indexOf correctNumbers[@] $correctNumber1)
  correctIndex2=$(indexOf correctNumbers[@] $correctNumber2)
  
  exceptIndex1=($correctIndex1)
  wrongIndex1=$(randomIndexExcept $codeCount exceptIndex1[@])
  result[$wrongIndex1]=$correctNumber1

  exceptIndex2=($correctIndex2 $wrongIndex1)
  wrongIndex2=$(randomIndexExcept $codeCount exceptIndex2[@])
  result[$wrongIndex2]=$correctNumber2
  
  countMinus2=$(($codeCount-2))
  incorrectNumbers=( $(getRandomNumbers $countMinus2 correctNumbers[@]) )
  
  for i in $( seq 0 $countMinus1 )
  do
    if (( result[$i] == -1 ))
    then
      result[$i]="${incorrectNumbers[0]}"
      unset 'incorrectNumbers[0]'
      incorrectNumbers=( "${incorrectNumbers[@]}" )
    fi
  done
  echo "${result[@]}"
}

oneCorrectWrongPlaced() {
  codeCount=$1
  correctNumbers=("${!2}")
  countMinus1=$(($codeCount-1))
  result=()
  for i in $( seq 0 $countMinus1 )
  do
      result[$i]=-1
  done

  correctIndex=$[$RANDOM % ${#correctNumbers[@]}]
  correctNumber=${correctNumbers[$correctIndex]}
  exceptedIndexes=($correctIndex)
  wrongIndex=$(randomIndexExcept $codeCount exceptedIndexes[@])
  result[$wrongIndex]=$correctNumber
  
  incorrectNumbers=( $(getRandomNumbers $countMinus1 correctNumbers[@]) )
  for i in $( seq 0 $countMinus1 )
  do
    if (( result[$i] == -1 ))
    then
      result[$i]="${incorrectNumbers[0]}"
      unset 'incorrectNumbers[0]'
      incorrectNumbers=( "${incorrectNumbers[@]}" )
    fi
  done
  echo "${result[@]}"
}

oneCorrectWellPlaced() {
  codeCount=$1
  correctNumbers=("${!2}")
  countMinus1=$(($codeCount-1))
  result=()
  for i in $( seq 0 $countMinus1 )
  do
      result[$i]=-1
  done

  correctIndex=$[$RANDOM % ${#correctNumbers[@]}]
  correctNumber=${correctNumbers[$correctIndex]}
  result[$correctIndex]=$correctNumber
  
  incorrectNumbers=( $(getRandomNumbers $countMinus1 correctNumbers[@]) )
  for i in $( seq 0 $countMinus1 )
  do
    if (( result[$i] == -1 ))
    then
      result[$i]="${incorrectNumbers[0]}"
      unset 'incorrectNumbers[0]'
      incorrectNumbers=( "${incorrectNumbers[@]}" )
    fi
  done
  echo "${result[@]}"
}

nothingCorrect() {
  codeCount=$1
  correctNumbers=("${!2}")

  incorrectNumbers=( $(getRandomNumbers $codeCount correctNumbers[@]) )
  echo "${incorrectNumbers[@]}"
}

generateHintsFor2() {
  correctNumbers=("${!1}")
  codeCount=2
  result="[]"

  question=$(echo "${correctNumbers[@]}" | jq -s '{"type": "QUESTION", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$question"']' )

  numbers=$(oneCorrectWellPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_WELL_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(nothingCorrect $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "NOTHING_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  echo $result
}

generateHintsFor3() {
  correctNumbers=("${!1}")
  codeCount=3
  result="[]"

  question=$(echo "${correctNumbers[@]}" | jq -s '{"type": "QUESTION", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$question"']' )

  numbers=$(oneCorrectWellPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_WELL_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(nothingCorrect $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "NOTHING_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(twoCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "TWO_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  echo $result
}

generateHintsFor4() {
  correctNumbers=("${!1}")
  codeCount=4
  result="[]"

  question=$(echo "${correctNumbers[@]}" | jq -s '{"type": "QUESTION", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$question"']' )

  numbers=$(oneCorrectWellPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_WELL_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(nothingCorrect $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "NOTHING_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(twoCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "TWO_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(twoCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "TWO_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  echo $result
}

generateHintsFor5() {
  correctNumbers=("${!1}")
  codeCount=5
  result="[]"

  question=$(echo "${correctNumbers[@]}" | jq -s '{"type": "QUESTION", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$question"']' )

  numbers=$(oneCorrectWellPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_WELL_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(nothingCorrect $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "NOTHING_CORRECT", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(oneCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "ONE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(twoCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "TWO_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(twoCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "TWO_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  numbers=$(threeCorrectWrongPlaced $codeCount correctNumbers[@])
  item=$(echo "${numbers[@]}" | jq -s '{"type": "THREE_CORRECT_WRONG_PLACED", "numbers": .}')
  result=$( echo "$result" | jq '. += ['"$item"']' )

  echo $result
}
