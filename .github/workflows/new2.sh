#!/bin/bash

. questions.sh

codeCount=2
correctNumbers=( $(getRandomNumbers $codeCount) )
generateHintsFor2 correctNumbers[@]
