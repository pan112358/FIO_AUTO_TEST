FROM centos:7.4.1708

MAINTAINER PeterPan

COPY ./files /opt/fio_autotest/

ENV TEST_FILE=/tmp/fiotest
ENV FILE_SIZE=5G
ENV RUN_TIME=300
ENV BLOCK_SIZE='4k 1024k'
ENV TEST_METHOD='read write rx'
ENV READ_RATE=70
ENV TEST_TIMES=3

RUN pip install --no-cache fio libaio-devel\
  &&chmod 777 /opt/fio_autotest/start.sh

ENTRYPOINT sh /opt/fio_autotest/start.sh

