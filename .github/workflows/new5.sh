#!/bin/bash

. questions.sh

codeCount=5
correctNumbers=( $(getRandomNumbers $codeCount) )
generateHintsFor5 correctNumbers[@]
