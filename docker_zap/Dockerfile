# Python run stage
FROM owasp/zap2docker-stable:2.12.0

# Install importer
COPY importer/ /usr/local/importer/
RUN pip install --no-cache-dir -r /usr/local/importer/requirements.txt

# Copy entrypoints and set PATH
WORKDIR /entrypoints
COPY ./docker_zap/entrypoints/ ./
ENV PATH="/usr/local/importer/bin:$PATH"

WORKDIR /
