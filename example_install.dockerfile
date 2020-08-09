FROM ubuntu:20.04
RUN apt update

# ------ Getting Latest R ------
# https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/

# base packages
RUN apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common -y

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

RUN apt install r-base -y
RUN R --version

# XML-parsing back-end for R-XML
RUN apt install libxml2-dev -y

# XML-package in R got discontinued, but here's a workaround
RUN R -e 'install.packages("XML", repos = "http://www.omegahat.net/R")'

# We will also need curl
RUN apt install libcurl4-gnutls-dev -y

# with all the above, this should work
RUN R -e 'install.packages("gmapsdistance")'

# test
RUN R -e 'library(gmapsdistance)'
