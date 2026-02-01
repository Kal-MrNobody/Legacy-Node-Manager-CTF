FROM ubuntu:22.04

# Use Indian Mirrors (Fixes College WiFi blocks)
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://in.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list

# Install socat
RUN apt-get update && apt-get install -y socat && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy files
COPY legacy_node_manager .
COPY flag.txt .
COPY run.sh .

# Permissions
RUN chmod +x legacy_node_manager run.sh

# User setup
RUN useradd -m ctf
USER ctf

CMD ["socat", "TCP-LISTEN:5010,reuseaddr,fork", "EXEC:./run.sh"]
