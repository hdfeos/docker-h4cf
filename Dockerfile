FROM ubuntu:latest

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

COPY ["./apt.txt", "./"]

RUN apt update && apt install -yq $(grep -vE "^\s*#" ./apt.txt)

#Build HDF4 lib.
ARG HDF4_VER=4.2.13
RUN wget https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/latest_release/hdf-${HDF4_VER}.tar.gz; \
    tar zxvf hdf-${HDF4_VER}.tar.gz; \
    cd hdf-${HDF4_VER}; \
    ./configure --prefix=/usr/local/ --disable-netcdf; \
    make && make check && make install; \
    cd ..; \
    rm -rf /hdf-${HDF4_VER} /hdf-${HDF4_VER}.tar.gz 

#Build HDF-EOS2 lib.
ARG HDFEOS_VER=2.19v1.00
RUN wget https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/previous_releases/HDF-EOS${HDFEOS_VER}.tar.Z; \
    tar zxvf HDF-EOS${HDFEOS_VER}.tar.Z; \
    cd hdfeos; \
    ./configure --prefix=/usr/local/ --enable-install-include --with-hdf4=/usr/local; \
    make && make check && make install; \
    cd ..; \
    rm -rf /hdfeos /HDF-EOS${HDFEOS_VER}.tar.Z 

# Build HDF5 lib.
ARG HDF5_VER=5-1.8.19
RUN wget https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/hdf${HDF5_VER}.tar.gz; \
    tar zxvf hdf${HDF5_VER}.tar.gz; \
    cd hdf${HDF5_VER}; \
    ./configure --prefix=/usr/local/; \
    make && make check && make install; \
    cd ..; \
    rm -rf /hdf${HDF5_VER}/hdf${HDF5_VER}.tar.gz

# Build netCDF C lib.
ARG NETCDF_C_VER=4.4.1.1
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-${NETCDF_C_VER}.tar.gz -P /tmp \
    && tar -xf /tmp/netcdf-${NETCDF_C_VER}.tar.gz -C /tmp \
    && cd /tmp/netcdf-${NETCDF_C_VER} \
    && CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib ./configure --prefix=/usr/local \
    && cd /tmp/netcdf-${NETCDF_C_VER} \
    && make \
    && cd /tmp/netcdf-${NETCDF_C_VER} \
    && make install \
    && rm -rf /tmp/netcdf-${NETCDF_C_VER}

# Build H4CF Conversion Toolkit
ARG H4CF_VER=1.2
RUN wget http://hdfeos.org/software/h4cflib/h4cflib_${H4CF_VER}.tar.gz; \
    tar zxvf h4cflib_${H4CF_VER}.tar.gz; \
    cd h4cflib_${H4CF_VER}; \
    ./configure --prefix=/usr/local/ --with-hdf4=/usr/local/ --with-hdfeos2=/usr/local/ --with-netcdf=/usr/local/; \
    make && make install; \
    cd ..; \
    rm -rf /h4cflib_${H4CF_VER} /hf4cflib_${H4CF_VER}.tar.gz
