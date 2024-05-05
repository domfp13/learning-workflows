FROM public.ecr.aws/amazonlinux/amazonlinux:latest

# Install dependencies
RUN yum update -y && \
 yum install -y httpd && \
 mkdir -p /var/run/httpd && \
 mkdir -p /var/lock/httpd

# Install apache and write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

# Configure apache
RUN echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf && \
 echo -e "#!/bin/sh\nmkdir -p /var/run/httpd\nmkdir -p /var/lock/httpd\n/usr/sbin/httpd -D FOREGROUND" > /root/run_apache.sh && \
 chmod 755 /root/run_apache.sh

EXPOSE 80

CMD ["/root/run_apache.sh"]

# TODO: enable ec2 pull from ec2
# TODO: Add a prefect worker
# TODO: Add a application load balancer
# TODO: Add cloudflair for security
# TODO: Create my own domain
