# Makefile for MCP Kali Server Docker

# Variables
IMAGE_NAME = kali-server
CONTAINER_NAME = kali-server
API_PORT = 5000

# Default target
.PHONY: help
help:
	@echo "Kali Server Docker Management"
	@echo "============================="
	@echo "Available targets:"
	@echo "  build         - Build the Docker image"
	@echo "  run           - Run the container"
	@echo "  stop          - Stop the container"
	@echo "  restart       - Restart the container"
	@echo "  logs          - View container logs"
	@echo "  shell         - Access container shell"
	@echo "  health        - Check container health"
	@echo "  clean         - Remove container and image"
	@echo "  up            - Start with docker-compose"
	@echo "  down          - Stop docker-compose services"
	@echo "  test          - Test the API"
	@echo "  status        - Show container status"

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME):latest .

# Run the container
.PHONY: run
run: build
	docker run -d \
		--name $(CONTAINER_NAME) \
		-p 127.0.0.1:$(API_PORT):5000 \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		--restart unless-stopped \
		$(IMAGE_NAME):latest

# Stop the container
.PHONY: stop
stop:
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

# Restart the container
.PHONY: restart
restart: stop run

# View container logs
.PHONY: logs
logs:
	docker logs -f $(CONTAINER_NAME)

# Access container shell
.PHONY: shell
shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash

# Check container health
.PHONY: health
health:
	@echo "Checking container health..."
	@curl -s http://localhost:$(API_PORT)/health | python3 -m json.tool || echo "Health check failed"
	@echo ""
	@echo "Docker health status:"
	@docker inspect $(CONTAINER_NAME) --format='{{.State.Health.Status}}' 2>/dev/null || echo "No health status available"

# Clean up container and image
.PHONY: clean
clean: stop
	-docker rmi $(IMAGE_NAME):latest

# Docker Compose targets
.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

# Test the API
.PHONY: test
test:
	@echo "Testing API endpoints..."
	@curl -s http://localhost:$(API_PORT)/health | python3 -m json.tool || echo "API not responding"

# Show container status
.PHONY: status
status:
	@echo "Container Status:"
	@docker ps -f name=$(CONTAINER_NAME) --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "Image Info:"
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

# Update and rebuild
.PHONY: update
update: clean build run
	@echo "Container updated and restarted"

# Quick start (build and run)
.PHONY: quickstart
quickstart: build run
	@echo "Quick start complete!"
	@echo "API available at: http://localhost:$(API_PORT)"
	@echo "Health check: make health"
	@echo "View logs: make logs"