#!/bin/bash
#按顺序传入两个参数，读写方式，blocksize 
for i in $1; do
  for j in $2; do
    for k in $(eval echo "{1..$TEST_TIMES}");do
    if [ "$i" = "rw" -o "$i" = "randrw" ];then
      fio -filename=$TEST_FILE -direct=1 -iodepth 1 -thread -rw=$i -rwmixread=$READ_RATE -ioengine=libaio -bs=$j -size=$FILE_SIZE -runtime=$RUN_TIME -numjobs=1 -group_reporting -name=$i$j$k >/var/log/fio/results/"method_"$i"_blocksize_"$j"_delay_"$k
      fio -filename=$TEST_FILE -direct=1 -iodepth 32 -thread -rw=$i -rwmixread=$READ_RATE -ioengine=libaio -bs=$j -size=$FILE_SIZE -runtime=$RUN_TIME -numjobs=1 -group_reporting -name=$i$j$k >/var/log/fio/results/"method_"$i"_blocksize_"$j"_iops_"$k
      echo "test_task $i$j$k finish"
    else
      fio -filename=$TEST_FILE -direct=1 -iodepth 1 -thread -rw=$i -ioengine=libaio -bs=$j -size=$FILE_SIZE -runtime=$RUN_TIME -numjobs=1 -group_reporting -name=$i$j$k >/var/log/fio/results/"method_"$i"_blocksize_"$j"_delay_"$k
      fio -filename=$TEST_FILE -direct=1 -iodepth 32 -thread -rw=$i -ioengine=libaio -bs=$j -size=$FILE_SIZE -runtime=$RUN_TIME -numjobs=1 -group_reporting -name=$i$j$k >/var/log/fio/results/"method_"$i"_blocksize_"$j"_iops_"$k
      echo "test_task $i$j$k finish"
    fi
    done
  done
done

grep 'IOPS' /var/log/fio/results/*iops* |awk '{print $1,$2,$3}' | awk -F, '{print $1}'|awk -F: '{print $1,$2,$3}' |awk -F_iops_ '{print $1,"test_group"$2,$3}' | awk -F/var/log/fio/results/ '{print $2}' >/var/log/fio/reports/IOPS_Report.txt

grep 'avg=' /var/log/fio_result/*delay* | grep ' lat ' | awk '{print $1,$2,$3,$6}' |awk -F_delay_ '{print $1,"test_group"$2}'|awk -F, '{print $1}' | awk -F/var/log/fio/results/ '{print $2}'|awk -F: '{print $1,$2,$3}' >/var/log/fio/reports/Delay_Report.txt

grep IOPS /var/log/fio_result/*_iops_* |awk -F: '{print $1,$2,$3}' |awk -F_iops_ '{print $1,"test_group"$2,$3}' | awk -F'(' '{print $1,$2}' | awk '{print $1,$2,$3,$6}' | awk -F')' '{print $1}'| awk -F/var/log/fio/results/ '{print $2}' >/var/log/fio/reports/BW_Report.txt

cd /var/log/fio/reports/

paste BW_Report.txt IOPS_Report.txt Delay_Report.txt |awk '{print $1,$2,$3,$4,$8,$11,$13,$12}' >Summary_Report.txt
