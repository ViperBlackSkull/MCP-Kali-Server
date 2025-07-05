#!/bin/bash

# Entrypoint script for MCP Kali Server Docker container
set -e

# Default configuration
API_PORT=${API_PORT:-5000}
DEBUG_MODE=${DEBUG_MODE:-0}
KALI_SERVER_URL=${KALI_SERVER_URL:-"http://localhost:${API_PORT}"}

# Function to start Kali API server
start_kali_server() {
    echo "Starting Kali API Server on port ${API_PORT}..."
    if [ "$DEBUG_MODE" = "1" ]; then
        python3 kali_server.py --port "$API_PORT" --debug &
    else
        python3 kali_server.py --port "$API_PORT" &
    fi
    KALI_PID=$!
    echo "Kali API Server started with PID: $KALI_PID"
}

# Function to start MCP server
start_mcp_server() {
    echo "Waiting for Kali API Server to be ready..."
    # Wait for Kali server to be ready
    for i in {1..30}; do
        if curl -s "http://localhost:${API_PORT}/health" > /dev/null 2>&1; then
            echo "Kali API Server is ready!"
            break
        fi
        echo "Waiting for Kali API Server... (attempt $i/30)"
        sleep 2
    done
    
    echo "Starting MCP Server connecting to ${KALI_SERVER_URL}..."
    python3 mcp_server.py "$KALI_SERVER_URL" &
    MCP_PID=$!
    echo "MCP Server started with PID: $MCP_PID"
}

# Function to handle shutdown
cleanup() {
    echo "Shutting down services..."
    if [ ! -z "$KALI_PID" ]; then
        kill $KALI_PID 2>/dev/null || true
    fi
    if [ ! -z "$MCP_PID" ]; then
        kill $MCP_PID 2>/dev/null || true
    fi
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Print configuration
echo "=== MCP Kali Server Docker Container ==="
echo "API Port: $API_PORT"
echo "Debug Mode: $DEBUG_MODE"
echo "Kali Server URL: $KALI_SERVER_URL"
echo "========================================"

# Handle different startup modes
case "$1" in
    "kali-only")
        echo "Starting Kali API Server only..."
        start_kali_server
        wait $KALI_PID
        ;;
    "mcp-only")
        echo "Starting MCP Server only..."
        start_mcp_server
        wait $MCP_PID
        ;;
    "both"|*)
        echo "Starting both Kali API Server and MCP Server..."
        start_kali_server
        start_mcp_server
        
        # Wait for both processes
        while kill -0 $KALI_PID 2>/dev/null && kill -0 $MCP_PID 2>/dev/null; do
            sleep 1
        done
        
        echo "One of the services has stopped. Shutting down..."
        cleanup
        ;;
esac