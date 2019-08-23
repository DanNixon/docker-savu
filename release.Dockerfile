FROM nvidia/cuda:9.0-devel-centos7

# Install packaged dependencies
RUN yum install -y \
      bc \
      boost-devel \
      bzip2 \
      make \
      mesa-libGL-deve \
      mesa-libGLU-devel \
      openssh-clients \
      perl \
      wget && \
    yum clean all && \
    rm -rf /var/cache/yum

# Download and build FTTW
ARG FFTW_VERSION=3.3.7
RUN curl -L -o /tmp/fftw-${FFTW_VERSION}.tar.gz http://fftw.org/fftw-${FFTW_VERSION}.tar.gz && \
    cd /tmp && \
    tar -xf fftw-${FFTW_VERSION}.tar.gz && \
    cd /tmp/fftw-${FFTW_VERSION} && \
    ./configure --disable-static --enable-threads --enable-shared && \
    make -j`nproc` && \
    make install && \
    ./configure --disable-static --enable-threads --enable-shared --enable-float && \
    make -j`nproc` && \
    make install && \
    ./configure --disable-static --enable-threads --enable-shared --enable-long-double && \
    make -j`nproc` && \
    make install && \
    rm -rf /tmp/*

# Download and build OpenMPI
ARG OPENMPI_VERSION=3.0.0
RUN curl -L -o /tmp/openmpi-${OPENMPI_VERSION}.tar.gz https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-${OPENMPI_VERSION}.tar.gz && \
    cd /tmp && \
    tar -xf openmpi-${OPENMPI_VERSION}.tar.gz && \
    cd /tmp/openmpi-${OPENMPI_VERSION} && \
    ./configure --with-sge --enable-orterun-prefix-by-default --disable-static && \
    make -j`nproc` && \
    make install && \
    rm -rf /tmp/*

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
RUN ldconfig

# Download and install Savu
ARG SAVU_VERSION=2.3.1
COPY install_savu.sh /install_savu.sh
RUN /install_savu.sh "$SAVU_VERSION" && \
    /miniconda/bin/conda clean --all --yes && \
    rm -rf /tmp/*

# Allow for custom versions of Savu (e.g. for development)
RUN mkdir /savu_custom
VOLUME /savu_custom
ENV PYTHONPATH=/savu_custom:${PYTHONPATH}

# Add a user
RUN useradd --create-home --shell /bin/bash savu

# Source Savu setup script on Bash startup
RUN echo '. /savu_setup.sh' >> /etc/bashrc
RUN echo '. /savu_setup.sh' >> /etc/profile

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ['/entrypoint.sh']
