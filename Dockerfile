FROM            dokken/centos-8
RUN             yum install epel-release -y
COPY            mongo.repo /etc/yum.repos.d/mongo.repo
RUN             yum install unzip jq git mysql mongodb-org-shell -y
COPY            run.sh /
ENTRYPOINT      [ "bash", "/run.sh" ]