FROM haproxy:latest

# Switch to root user to install rsyslog
USER root

# Install rsyslog
RUN apt-get update && apt-get install -y rsyslog

# Copy configuration files
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY rsyslog.conf /etc/rsyslog.conf

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/haproxy/dev && \
    mkdir -p /var/log/haproxy && \
    chown -R haproxy:haproxy /var/lib/haproxy /var/log/haproxy

# Expose necessary ports
EXPOSE 80 443 8404

# Start rsyslogd as root and then start HAProxy as haproxy user
CMD rsyslogd && \
    su haproxy -c "haproxy -f /usr/local/etc/haproxy/haproxy.cfg"
