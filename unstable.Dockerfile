FROM dannixon/savu:latest

ARG SAVU_REVISION=master

# Clone the Savu repostory in the custom directory
RUN yum install -y git && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    git clone https://github.com/DiamondLightSource/Savu.git /savu_unstable && \
    cd /savu_unstable && \
    git checkout ${SAVU_REVISION}

ENV PYTHONPATH=/savu_unstable:${PYTHONPATH}
