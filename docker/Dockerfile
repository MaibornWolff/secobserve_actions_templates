# Python build stage
FROM python:3.12.8-alpine AS python-build-stage

# Install gcc to be able to compile wheels for python packages
RUN apk add --no-cache gcc musl-dev python3-dev

# Generate wheels for Python packages
WORKDIR /usr/local
COPY docker/requirements.txt .
RUN pip wheel --wheel-dir /usr/src/app/wheels -r ./requirements.txt

# Go build stage for KICS
FROM golang:1.24.1-alpine AS go-build-stage

ARG KICS_VERSION=2.1.3

# Install kics from GitHub
WORKDIR /usr/local/kics
RUN apk add --no-cache build-base
RUN wget --no-verbose https://github.com/Checkmarx/kics/archive/refs/tags/v${KICS_VERSION}.tar.gz -O - | tar -zxf - \
    && cd kics-${KICS_VERSION} \
    && go build -o ./bin/kics cmd/console/main.go

# Python run stage
FROM python:3.12.8-alpine AS python-run-stage

ARG GITLEAKS_VERSION=8.22.1
ARG GRYPE_VERSION=0.86.1
ARG KICS_VERSION=2.1.3
ARG TRIVY_VERSION=0.58.1
ARG TFSEC_VERSION=1.28.12

ARG CREATED
ARG REVISION
ARG VERSION

LABEL org.opencontainers.image.authors="stefan.fleckenstein@maibornwolff.de"
LABEL org.opencontainers.image.created=${CREATED}
LABEL org.opencontainers.image.description="SecObserve is an open source vulnerability management system for software development teams."
LABEL org.opencontainers.image.documentation="https://maibornwolff.github.io/SecObserve/integrations/github_actions_and_templates/"
LABEL org.opencontainers.image.licenses="BSD3-Clause"
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.source="https://github.com/MaibornWolff/secobserve_actions_templates"
LABEL org.opencontainers.image.title="SecObserve vulnerability scanners"
LABEL org.opencontainers.image.url="https://github.com/MaibornWolff/secobserve_actions_templates"
LABEL org.opencontainers.image.vendor="MaibornWolff GmbH"
LABEL org.opencontainers.image.version=${VERSION}

# Install openssl-dev because libcrypto is needed for CryptoLyzer
RUN apk add --no-cache openssl-dev

# All absolute dir copies ignore workdir instruction. All relative dir copies are wrt to the workdir instruction
# copy python dependency wheels from python-build-stage
COPY --from=python-build-stage /usr/src/app/wheels  /wheels/
# use wheels to install python dependencies
RUN pip install --no-cache-dir --no-index --find-links=/wheels/ /wheels/* \
	&& rm -rf /wheels/ && rm -rf /tmp

# Hack because Python's find_library doesn't work on Alpine
RUN sed -i -e "s|get_library('crypto', 'libcrypto\.dylib', '42')|'/usr/lib/libcrypto\.so'|g" /usr/local/lib/python3.12/site-packages/oscrypto/_openssl/_libcrypto_cffi.py

# copy and install precompiled DrHeader library and rules
COPY docker/drheader/drheader-1.7.0-py2.py3-none-any.whl docker/drheader/rules.yml ./
RUN pip install --no-cache-dir ./drheader-1.7.0-py2.py3-none-any.whl

# install GitLeaks from Github
WORKDIR /usr/local/gitleaks
RUN wget --no-verbose https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz -O - | tar -zxf -

# install Grype from Github
WORKDIR /usr/local/grype
RUN wget --no-verbose https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_linux_amd64.tar.gz -O - | tar -zxf -

# Copy kics from go build stage
WORKDIR /usr/local/kics
COPY --from=go-build-stage /usr/local/kics/kics-${KICS_VERSION}/bin ./bin/
COPY --from=go-build-stage /usr/local/kics/kics-${KICS_VERSION}/assets/queries ./bin/assets/queries/
COPY --from=go-build-stage /usr/local/kics/kics-${KICS_VERSION}/assets/libraries ./bin/assets/libraries/

# Install trivy from GitHub
WORKDIR /usr/local/trivy
RUN wget --no-verbose https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -O - | tar -zxf -

# Install tfsec from GitHub
WORKDIR /usr/local/tfsec
RUN wget https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 && chmod ugo+x ./tfsec-linux-amd64 && mv ./tfsec-linux-amd64 ./tfsec

# eslint needs npm
# gitleaks needs git
# trivy needs docker
RUN apk add --no-cache npm git docker-cli

# Install importer
WORKDIR /usr/local/importer
COPY importer/ ./

# Install vulnerability_scanner
WORKDIR /usr/local/vulnerability_scanner
COPY vulnerability_scanner/ ./

# Copy entrypoints and set PATH
WORKDIR /entrypoints
COPY ./docker/entrypoints/ ./
ENV PATH="/usr/local/gitleaks:/usr/local/grype:/usr/local/kics/bin:/usr/local/trivy:/usr/local/tfsec:/usr/local/importer/bin:/usr/local/vulnerability_scanner/bin:$PATH"

WORKDIR /

RUN mkdir -p -m a=rwx /tmp
