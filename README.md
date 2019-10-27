# docker-h4cf

## Ubuntu based Docker container for HDF4 CF Conversion Toolkit

The Docker file `Dockerfile` sources an Apt package file named `apt.txt`, which lists the Apt packages required to build the image.

Build the image with

    docker build -f Dockerfile \
    [--build-arg HDF4_VER=<HDF4 lib. version string, default 4.2.13>] \
    [--build-arg HDFEOS_VER=<HDFEOS lib. version string, default 2.19v1.00>] \
    [--build-arg HDF5_VER=<HDF5 lib. version string, default 5-1.8.19>] \
    [--build-arg NETCDF_C_VER=<NetCDF C lib. version string, default 4.4.1.1>] \
    [--build-arg H4CF_VER=<H4CF conversion toolkit version string, default 1.2>]
    -t <image name> .

The build arguments `HDF4_VER`, `HDFEOS_VER`, `HDF5_VER`, `NETCDF_C_VER`, `H4CF_VER` are optional - default versions are used within the Docker file, as indicated above.

Run the image in a detached container with

    docker run --name <container name> -itd <image name>

Enter the container in a Bash shell with

    docker exec -it <container name> bash
