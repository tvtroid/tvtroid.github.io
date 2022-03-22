#!/bin/bash

. questions.sh

codeCount=4
correctNumbers=( $(getRandomNumbers $codeCount) )
generateHintsFor4 correctNumbers[@]
