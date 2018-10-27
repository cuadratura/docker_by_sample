FROM centos

# FROM centos as test

RUN fallocate -t 10M /opt/file1
RUN fallocate -t 20M /opt/file2
RUN fallocate -t 30M /opt/file3

# FROM alpine
# COPY --from=test /opt/test2 /opt/myfile