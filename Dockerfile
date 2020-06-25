# Start with empty ubuntu machine
FROM ubuntu:18.04

# Setup correct environment variable
ENV HOME /root

# Move all code into Tango directory
ADD . /opt/TangoService/Tango/

RUN cd /opt/TangoService/Tango && \
        mkdir -p volumes && \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        nginx \
        supervisor \
        python-pip \
        python-dev \
        openssh-client \
        redis-server && \
        ln -s /usr/bin/redis-server /usr/local/bin/redis-server && \
        cd /opt && \
        cd /opt/TangoService/Tango/ && \
        cp ./wrapdocker /usr/local/bin/wrapdocker && \
        cp ./deployment/config/nginx.conf /etc/nginx/nginx.conf && \
        cp ./deployment/config/supervisord.conf /etc/supervisor/supervisord.conf && \
        cp ./deployment/config/redis.conf /etc/redis.conf && \
        chmod +x /usr/local/bin/wrapdocker && \
        pip install -r requirements.txt && \
        mkdir -p /var/log/docker /var/log/supervisor && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf "/var/lib/apt/lists/*"

# Define additional metadata for our image.
VOLUME /var/lib/docker

WORKDIR /opt/TangoService/Tango/

# Reload new config scripts
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]


# TODO:
# volumes dir in root dir, supervisor only starts after calling start once , nginx also needs to be started
# Different log numbers for two different tangos
# what from nginx forwards requests to tango
# why does it still start on 3000
