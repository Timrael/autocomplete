#!/bin/sh
DATE=`(date +%Y-%m-01)` && wget "http://download.companieshouse.gov.uk/BasicCompanyDataAsOneFile-$DATE.zip" && unzip -p "BasicCompanyDataAsOneFile-$DATE.zip" | csvquote | cut -d, -f1,2,35,37,39,41,43,45,47,49,51,53 | csvquote -u | sed 's/""//g' > "/snapshots/$DATE.csv" && rm "BasicCompanyDataAsOneFile-$DATE.zip"
