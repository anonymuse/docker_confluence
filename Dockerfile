FROM java:8

# Setup useful environment variables
ENV CONF_HOME=/var/atlassian/confluence \
    CONF_INSTALL=/opt/atlassian/confluence \
    CONFLUENCE_VERSION=5.9.6 \
    ATLN_URL=http://www.atlassian.com/software/confluence/downloads/binary \
    MYSQL_URL=http://dev.mysql.com/get/Downloads/Connector-J \
    MYSQL_VERSION=5.1.38 


# Install Atlassian Confluence and helper tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libtcnative-1 \
    && apt-get clean \
    && mkdir -p                "${CONF_HOME}" \
    && chmod -R 700            "${CONF_HOME}" \
    && chown daemon:daemon     "${CONF_HOME}" \
    && mkdir -p                "${CONF_INSTALL}/conf" \
    && curl -Ls \
        "${ATLN_URL}/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz" \
        | tar -xz --directory "${CONF_INSTALL}" \
        --strip-components=1 --no-same-owner \
    && curl -Ls \
        "${MYSQL_URL}/mysql-connector-java-${MYSQL_VERSION}.tar.gz" \
    | tar -xz --directory "${CONF_INSTALL}/confluence/WEB-INF/lib" \
    --strip-components=1 --no-same-owner \
        "mysql-connector-java-${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}-bin.jar" \
    && chmod -R 700            "${CONF_INSTALL}/conf" \
    && chmod -R 700            "${CONF_INSTALL}/temp" \
    && chmod -R 700            "${CONF_INSTALL}/logs" \
    && chmod -R 700            "${CONF_INSTALL}/work" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/conf" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/temp" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/logs" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/work" \
    && echo -e \
        "\nconfluence.home=$CONF_HOME" >> \
        "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
    && touch -d "@0"           "/opt/atlassian/confluence/conf/server.xml"

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
USER daemon:daemon

# Expose default HTTP connector port.
EXPOSE 8090

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/confluence"]

# Set the default working directory as the Confluence home directory.
WORKDIR /var/atlassian/confluence

# Run Atlassian Confluence as a foreground process by default.
CMD ["/opt/atlassian/confluence/bin/catalina.sh", "run"]
