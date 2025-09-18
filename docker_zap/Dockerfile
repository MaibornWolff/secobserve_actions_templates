# Python run stage
FROM zaproxy/zap-stable:2.16.1

ARG CREATED
ARG REVISION
ARG VERSION

LABEL org.opencontainers.image.authors="stefan.fleckenstein@maibornwolff.de"
LABEL org.opencontainers.image.base.name="softwaresecurityproject/zap-stable"
LABEL org.opencontainers.image.created=${CREATED}
LABEL org.opencontainers.image.description="SecObserve is an open source vulnerability management system for software development teams."
LABEL org.opencontainers.image.documentation="https://maibornwolff.github.io/SecObserve/integrations/github_actions_and_templates/"
LABEL org.opencontainers.image.licenses="BSD3-Clause"
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.source="https://github.com/MaibornWolff/secobserve_actions_templates"
LABEL org.opencontainers.image.title="SecObserve vulnerability scanner ZAP"
LABEL org.opencontainers.image.url="https://github.com/MaibornWolff/secobserve_actions_templates"
LABEL org.opencontainers.image.vendor="MaibornWolff GmbH"
LABEL org.opencontainers.image.version=${VERSION}

# Install importer
COPY importer/ /usr/local/importer/
RUN pip install --no-cache-dir -r /usr/local/importer/requirements.txt

# Copy entrypoints and set PATH
WORKDIR /entrypoints
COPY ./docker_zap/entrypoints/ ./
RUN mkdir /zap/wrk
ENV PATH="/usr/local/importer/bin:$PATH"

WORKDIR /zap
