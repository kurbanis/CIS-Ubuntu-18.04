#!/bin/bash
# Run from top level directory of CIS audit script repo: https://github.com/kurbanis/CIS-Ubuntu-20.04
if [[ $# -gt 0 ]] ; then
  cd $1
fi

cwd=$(pwd)

start_time=`date +%Y%m%d-%H%M`
report_file_name="${start_time}_CIS_Report_${HOSTNAME}.txt"
echo $report_file_name
echo "CIS Ubunutu 20.04 LTS Benchmark Audit" > $report_file_name
echo "---------" >> $report_file_name
echo "started at ${start_time}" >> $report_file_name
echo >> $report_file_name

echo "[*] - Running bats tests in $cwd"
bats -r * |  tee -a $report_file_name