# Use official Kali Linux as base image
FROM kalilinux/kali-rolling:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV API_PORT=5000
ENV PYTHONUNBUFFERED=1

# Update package lists and install essential packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    wget \
    nmap \
    netcat-traditional \
    dnsutils \
    whois \
    gobuster \
    sqlmap \
    hydra \
    john \
    hashcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Copy only the Kali server
COPY kali_server.py .

# Expose port
EXPOSE 5000

# Add simple health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Run the Kali server directly
CMD ["python3", "kali_server.py", "--port", "5000"]
