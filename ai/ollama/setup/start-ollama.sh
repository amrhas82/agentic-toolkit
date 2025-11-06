#!/bin/bash

# Ollama Docker Quick Start for Ubuntu
# Automated setup for Ubuntu users
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}====================================${NC}"
    echo -e "${BLUE}    Ollama Docker Quick Start      ${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "💡 $1"
}

# Check if Ubuntu/Debian-based
check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" || "$ID_LIKE" == "ubuntu" || "$ID" == "debian" ]]; then
            print_success "Ubuntu/Debian-based system detected: $NAME"
            return 0
        else
            print_warning "Non-Ubuntu system detected: $NAME"
            print_info "Some features may not work as expected"
            return 1
        fi
    else
        print_warning "Cannot detect OS distribution"
        return 1
    fi
}

# Install Docker on Ubuntu
install_docker_ubuntu() {
    print_info "Installing Docker on Ubuntu..."

    # Update package lists
    echo "🔄 Updating package lists..."
    timeout 30 sudo apt update --error-on=any || {
        print_warning "apt update failed or timed out. Trying alternative approach..."
        timeout 30 sudo apt-get update --quiet || {
            print_error "Failed to update package lists. You may need to update manually with: sudo apt update"
            read -p "Continue anyway? (y/N): " continue_anyway
            if [[ ! $continue_anyway =~ ^[Yy]$ ]]; then
                print_error "Exiting setup. Please run 'sudo apt update' manually and retry."
                exit 1
            fi
        }
    }

    # Install prerequisites
    sudo apt install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add user to docker group
    print_info "Adding user to docker group..."
    sudo usermod -aG docker $USER

    print_success "Docker installed successfully"
    print_warning "Please log out and log back in for group changes to take effect"
}

# Main installation function
main() {
    print_header

    # Check OS
    check_os

    # Check Docker installation
    if ! command -v docker >/dev/null 2>&1; then
        print_error "Docker not found"
        print_info "Installing Docker..."
        install_docker_ubuntu
        DOCKER_CMD="sudo docker"
    elif ! docker info >/dev/null 2>&1; then
        print_error "Docker daemon not accessible"

        # Check if service is running
        if sudo systemctl is-active docker >/dev/null 2>&1; then
            print_success "Docker service is running but user lacks permissions"
            print_info "Adding user to docker group..."
            sudo usermod -aG docker $USER
            print_warning "Log out and log back in for group changes to take effect"
            DOCKER_CMD="sudo docker"
        else
            print_info "Starting Docker service..."
            sudo systemctl start docker
            if sudo systemctl is-active docker >/dev/null 2>&1; then
                print_success "Docker service started"
                DOCKER_CMD="sudo docker"
            else
                print_error "Failed to start Docker service. Installing Docker..."
                install_docker_ubuntu
                DOCKER_CMD="sudo docker"
            fi
        fi
    else
        print_success "Docker is accessible"
        DOCKER_CMD="docker"
    fi

    # Get model name from user
    echo ""
    read -p "Enter model name to use (default: mistral:7b): " model_name
    model_name=${model_name:-mistral:7b}

    # Check if GPU is available
    GPU_SUPPORT=""
    if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1; then
        print_success "NVIDIA GPU detected"
        read -p "Use GPU acceleration? (y/N): " use_gpu
        if [[ $use_gpu =~ ^[Yy]$ ]]; then
            GPU_SUPPORT="gpu"
            print_info "Using GPU acceleration"
        else
            print_info "Using CPU-only mode"
        fi
    else
        print_info "No NVIDIA GPU detected, using CPU-only mode"
    fi

    echo "🚀 Starting Ollama container with model: $model_name"

    # Clean up any existing containers or port conflicts
    if ss -tuln 2>/dev/null | grep :11434 >/dev/null 2>&1 || lsof -i:11434 >/dev/null 2>&1; then
        print_warning "Port 11434 already in use. Cleaning up..."
        $DOCKER_CMD compose down 2>/dev/null || true
        $DOCKER_CMD stop ollama 2>/dev/null || true
        $DOCKER_CMD rm ollama 2>/dev/null || true

        PID=$(lsof -t -i:11434 2>/dev/null)
        if [ ! -z "$PID" ]; then
            echo "Killing process $PID using port 11434..."
            sudo kill -9 $PID 2>/dev/null || true
        fi
        sleep 3
    fi

    # Start container based on GPU support
    echo "🔧 Starting Ollama container..."

    if [ "$GPU_SUPPORT" = "gpu" ]; then
        $DOCKER_CMD compose up -d
    else
        # Create CPU-only compose file
        cat > docker-compose-cpu.yml << 'EOF'
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"

volumes:
  ollama_data:
EOF
        $DOCKER_CMD compose -f docker-compose-cpu.yml up -d
        rm -f docker-compose-cpu.yml
    fi

    # Wait for container to start
    echo "⏳ Waiting for container to start..."
    sleep 10

    # Check if container is running
    if $DOCKER_CMD ps --filter "name=ollama" --format "table {{.Names}}\t{{.Status}}" | grep -q "ollama.*Up"; then
        print_success "Ollama container is running on http://localhost:11434"

        # Pull the model
        echo ""
        echo "📥 Pulling model: $model_name"
        if $DOCKER_CMD exec ollama ollama pull "$model_name"; then
            print_success "Model '$model_name' pulled successfully"

            # Ask about context window configuration
            echo ""
            read -p "Configure model with 8192 token context window? (y/N): " configure_context
            if [[ $configure_context =~ ^[Yy]$ ]]; then
                echo "⚙️  Configuring model context window..."
                MODEL_WITH_CONTEXT="${model_name}-8k"

                $DOCKER_CMD exec ollama ollama create "$MODEL_WITH_CONTEXT" -f <(echo "FROM $model_name
PARAMETER num_ctx 8192")

                if [ $? -eq 0 ]; then
                    print_success "Model '$MODEL_WITH_CONTEXT' created with 8192 token context window"
                    model_name="$MODEL_WITH_CONTEXT"
                else
                    print_warning "Failed to create model with increased context"
                fi
            fi

            echo ""
            print_success "Setup complete!"
            echo ""
            echo "📋 Configuration for OpenCode:"
            echo "{"
            echo "  \"\$schema\": \"https://opencode.ai/config.json\","
            echo "  \"provider\": {"
            echo "    \"ollama\": {"
            echo "      \"npm\": \"@ai-sdk/openai-compatible\","
            echo "      \"options\": {"
            echo "        \"baseURL\": \"http://localhost:11434/v1\""
            echo "      },"
            echo "      \"models\": {"
            echo "        \"$model_name\": {"
            echo "          \"tools\": true"
            echo "        }"
            echo "      }"
            echo "    }"
            echo "  }"
            echo "}"
            echo ""
            echo "💡 Models available at https://ollama.com/library"

        else
            print_error "Failed to pull model '$model_name'"
            print_info "You can pull it later with: $DOCKER_CMD exec ollama ollama pull $model_name"
        fi
    else
        print_error "Failed to start Ollama container"
        $DOCKER_CMD logs ollama 2>/dev/null || print_error "No logs available"
        exit 1
    fi
}

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi