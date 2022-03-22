#!/bin/bash

. questions.sh

codeCount=3
correctNumbers=( $(getRandomNumbers $codeCount) )
generateHintsFor3 correctNumbers[@]
