#!/bin/sh
LAST_MONTH=`date +'%Y-%m-01' -d 'last month'`
CURRENT_MONTH=`date +'%Y-%m-01'`
comm -1 -3 "/snapshots/$LAST_MONTH.csv" "/snapshots/$CURRENT_MONTH.csv" > /snapshots/diff.csv
