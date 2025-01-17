dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2021, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

DECLARE(`GMMLIB_VER',intel-gmmlib-22.2.1)
DECLARE(`GMMLIB_SRC_REPO',https://github.com/intel/gmmlib/archive/GMMLIB_VER.tar.gz)

ifelse(OS_NAME,centos,ifelse(OS_VERSION,7,`dnl
include(centos-scl.m4)
'))
include(cmake.m4)

ifelse(OS_NAME,ubuntu,`
define(`GMMLIB_BUILD_DEPS',`ca-certificates g++ make wget')
')

ifelse(OS_NAME,centos,`
define(`GMMLIB_BUILD_DEPS',`ifelse(OS_VERSION,7,devtoolset-9-gcc-c++,gcc-c++) dnl
   make wget')
')

define(`BUILD_GMMLIB',`
# build gmmlib
ARG GMMLIB_REPO=GMMLIB_SRC_REPO
RUN cd BUILD_HOME && \
  wget -O - ${GMMLIB_REPO} | tar xz
RUN cd BUILD_HOME/gmmlib-GMMLIB_VER && mkdir build && cd build && \
  ifelse(OS_NAME,centos,ifelse(OS_VERSION,7,scl enable devtoolset-9 -- ))cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR \
    .. && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
')

REG(GMMLIB)

include(end.m4)dnl
