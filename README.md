# FIO_AUTO_TEST
This image will execute disk performance test tasks and generate report automatically 

该容器镜像实现了磁盘性能的测试。

使用时需要把存储挂载到容器 /var/log/fio/results和/var/log/fio/reports路径

可以设置的环境变量如下

ENV TEST_FILE=/tmp/fiotest       #需要测试的磁盘路径，对应fio测试命令里的-filename取值

ENV FILE_SIZE=5G                 #需要测试的文件大小，对应fio测试命令里的-size取值

ENV RUN_TIME=300                 #需要测试的单任务执行时间，对应fio测试命令里的-runtime取值

ENV BLOCK_SIZE='4k 1024k'        #需要测试的block size，对应fio测试命令里的-bs取值，不同取值中间以空格隔开

ENV TEST_METHOD='read write rw'  #需要测试的读写方式，对应fio测试命令里的-rw取值，不同取值中间以空格隔开

ENV READ_RATE=70                 #混合读写时的读比例，对应fio测试命令里的-rwmixread取值，不同取值中间以空格隔开

ENV TEST_TIMES=3                 #测试的组数

测试时长取决传入参数，可以采用如下方法预估

测试总时间=（BLOCK_SIZE类型数） * （ TEST_METHOD类型数 ）  *  （ 测试组数TEST_TIMES） * （单次测试执行时间RUN_TIME）


测试完成后，原始记录保存在 results目录




测试报告保存在reports目录
