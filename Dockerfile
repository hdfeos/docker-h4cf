FROM ubuntu:latest

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

RUN apt-get update
RUN apt-get -yq install gcc \
                        build-essential \
                        wget \
                        bzip2 \
                        tar \
                        libghc-zlib-dev \
                        libjpeg-dev \
                        gfortran \
                        bison \
                        flex \
                        file

#Build HDF4
RUN wget https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/latest_release/hdf-4.2.13.tar.gz; \
    tar zxvf hdf-4.2.13.tar.gz; \
    cd hdf-4.2.13; \
    ./configure --prefix=/usr/local/ --disable-netcdf; \
    make && make install; \
    cd ..; \
    rm -rf /hdf-4.2.13 /hdf-4.2.13.tar.gz 

#Build HDF-EOS2
RUN wget https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/previous_releases/HDF-EOS2.19v1.00.tar.Z; \
    tar zxvf HDF-EOS2.19v1.00.tar.Z; \
    cd hdfeos; \
    ./configure --prefix=/usr/local/ --enable-install-include --with-hdf4=/usr/local; \
    make && make install; \
    cd ..; \
    rm -rf /hdfeos /HDF-EOS2.19v1.00.tar.Z 

# Build HDF5
RUN wget https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/hdf5-1.8.19.tar.gz; \
    tar zxvf hdf5-1.8.19.tar.gz; \
    cd hdf5-1.8.19; \
    ./configure --prefix=/usr/local/; \
    make && make install; \
    cd ..; \
    rm -rf /hd5f-1.8.19 /hdf5-1.8.19.tar.gz

# Build netCDF.
RUN NETCDF_C_VERSION="4.4.1.1" \
    && wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_C_VERSION}.tar.gz -P /tmp \
    && tar -xf /tmp/netcdf-${NETCDF_C_VERSION}.tar.gz -C /tmp \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib ./configure --prefix=/usr/local \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && make \
    && cd /tmp/netcdf-${NETCDF_C_VERSION} \
    && make install \
    && rm -rf /tmp/netcdf-${NETCDF_C_VERSION}

# Build H4CF Conversion Toolkit

RUN wget http://hdfeos.org/software/h4cflib/h4cflib_1.2.tar.gz; \
    tar zxvf h4cflib_1.2.tar.gz; \
    cd h4cflib_1.2; \
    ./configure --prefix=/usr/local/ --with-hdf4=/usr/local/ --with-hdfeos2=/usr/local/ --with-netcdf=/usr/local/; \
    make && make install; \
    cd ..; \
    rm -rf /h4cflib_1.2 /hf4cflib_1.2.tar.gz

