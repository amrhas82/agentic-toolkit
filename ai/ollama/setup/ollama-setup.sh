#!/bin/bash

# Ollama Docker Setup Manager
# Interactive menu-driven setup for Ollama with Docker
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
DOCKER_CMD=""
MODEL_NAME="mistral:7b"
CONTEXT_WINDOW=8192
CONTAINER_NAME="ollama"

# Helper functions
print_header() {
    echo -e "${BLUE}====================================${NC}"
    echo -e "${BLUE}    Ollama Docker Setup Manager    ${NC}"
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

# Check system requirements
check_system_requirements() {
    echo "🔍 Checking system requirements..."

    # Check if running on supported OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_success "Linux detected"
        # Check if Ubuntu/Debian-based
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            echo "📋 OS: $NAME $VERSION"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_success "macOS detected"
    else
        print_warning "Unsupported OS detected. Some features may not work."
    fi

    # Check available memory
    if command -v free >/dev/null 2>&1; then
        MEMORY_GB=$(($(free -g | awk '/^Mem:/{print $2}') + 0))
        echo "📋 Available RAM: ${MEMORY_GB}GB"
        if [ "$MEMORY_GB" -lt 4 ]; then
            print_warning "Less than 4GB RAM available. Some models may run slowly."
        fi
    fi
}

# Check Docker installation
check_docker() {
    echo ""
    echo "🐳 Checking Docker installation..."

    if ! command -v docker >/dev/null 2>&1; then
        print_error "Docker not found"
        return 1
    fi

    if ! docker info >/dev/null 2>&1; then
        print_error "Docker daemon not accessible"

        # Check if Docker service is running
        if command -v systemctl >/dev/null 2>&1 && sudo systemctl is-active docker >/dev/null 2>&1; then
            print_success "Docker service is running but user lacks permissions"
            print_info "Adding user to docker group for sudo-free access..."
            sudo usermod -aG docker $USER
            print_warning "Log out and log back in for group changes to take effect"
            print_info "For now, using sudo with password prompt..."
            DOCKER_CMD="sudo docker"
            return 0
        else
            print_error "Docker service is not running"
            return 1
        fi
    else
        print_success "Docker is accessible"
        DOCKER_CMD="docker"
        return 0
    fi
}

# Install Docker based on OS
install_docker() {
    echo ""
    echo "📥 Installing Docker..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux installation
        print_info "Installing Docker for Linux..."

        # Update package lists with shorter timeout and retry
        echo "🔄 Updating package lists..."
        timeout 30 sudo apt update --error-on=any || {
            print_warning "apt update failed or timed out. Trying alternative approach..."
            timeout 30 sudo apt-get update --quiet || {
                print_error "Failed to update package lists. You may need to update manually with: sudo apt update"
                read -p "Continue anyway? (y/N): " continue_anyway
                if [[ ! $continue_anyway =~ ^[Yy]$ ]]; then
                    return 1
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
        DOCKER_CMD="sudo docker"

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Please download and install Docker Desktop for macOS from: https://www.docker.com/products/docker-desktop"
        read -p "Press Enter after you have installed Docker Desktop..."

        if docker info >/dev/null 2>&1; then
            print_success "Docker is now accessible"
            DOCKER_CMD="docker"
        else
            print_error "Docker still not accessible. Please restart Docker Desktop."
            return 1
        fi
    fi
}

# Check Ollama container status
check_ollama_container() {
    echo ""
    echo "🔍 Checking Ollama container status..."

    if $DOCKER_CMD ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}" | grep -q "$CONTAINER_NAME"; then
        print_success "Ollama container is running"

        # Check if port 11434 is accessible
        if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
            print_success "Ollama API is accessible on port 11434"
            return 0
        else
            print_warning "Container is running but API is not accessible"
            return 1
        fi
    else
        print_warning "Ollama container is not running"
        return 1
    fi
}

# Check installed models
check_models() {
    echo ""
    echo "🤖 Checking installed models..."

    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        MODELS=$(curl -s http://localhost:11434/api/tags | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | sort)
        if [ -n "$MODELS" ]; then
            echo "📋 Installed models:"
            echo "$MODELS" | while read model; do
                echo "  • $model"
            done
            return 0
        else
            print_warning "No models installed"
            return 1
        fi
    else
        print_error "Cannot connect to Ollama API"
        return 1
    fi
}

# Start Ollama container
start_ollama() {
    echo ""
    echo "🚀 Starting Ollama container..."

    # Clean up any existing containers or port conflicts
    if ss -tuln 2>/dev/null | grep :11434 >/dev/null 2>&1 || lsof -i:11434 >/dev/null 2>&1; then
        print_warning "Port 11434 already in use. Cleaning up..."
        $DOCKER_CMD compose down 2>/dev/null || true
        $DOCKER_CMD stop $CONTAINER_NAME 2>/dev/null || true
        $DOCKER_CMD rm $CONTAINER_NAME 2>/dev/null || true

        # Kill any process using port 11434
        PID=$(lsof -t -i:11434 2>/dev/null)
        if [ ! -z "$PID" ]; then
            echo "Killing process $PID using port 11434..."
            sudo kill -9 $PID 2>/dev/null || true
        fi
        sleep 3
    fi

    # Check for GPU support
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

    # Create docker-compose file based on GPU support
    if [ "$GPU_SUPPORT" = "gpu" ]; then
        $DOCKER_CMD compose -f docker-compose.yml up -d
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

    if check_ollama_container; then
        print_success "Ollama container started successfully"
        return 0
    else
        print_error "Failed to start Ollama container"
        $DOCKER_CMD logs $CONTAINER_NAME 2>/dev/null || print_error "No logs available"
        return 1
    fi
}

# Stop Ollama container
stop_ollama() {
    echo ""
    echo "🛑 Stopping Ollama container..."

    if $DOCKER_CMD ps --filter "name=$CONTAINER_NAME" -q | grep -q .; then
        $DOCKER_CMD stop $CONTAINER_NAME
        $DOCKER_CMD compose down 2>/dev/null || true
        print_success "Ollama container stopped"
    else
        print_warning "Ollama container is not running"
    fi
}

# Install model
install_model() {
    echo ""
    echo "📥 Installing model: $MODEL_NAME"

    if ! check_ollama_container; then
        print_error "Ollama container must be running to install models"
        return 1
    fi

    # Pull the model
    if $DOCKER_CMD exec $CONTAINER_NAME ollama pull "$MODEL_NAME"; then
        print_success "Model '$MODEL_NAME' installed successfully"

        # Ask about context window configuration
        read -p "Configure model with increased context window? ($CONTEXT_WINDOW tokens) (y/N): " configure_context
        if [[ $configure_context =~ ^[Yy]$ ]]; then
            configure_model_context
        fi
    else
        print_error "Failed to install model '$MODEL_NAME'"
        return 1
    fi
}

# Configure model context window
configure_model_context() {
    echo ""
    echo "⚙️  Configuring model context window..."

    MODEL_WITH_CONTEXT="${MODEL_NAME}-${CONTEXT_WINDOW}k"

    # Create model with increased context
    $DOCKER_CMD exec $CONTAINER_NAME ollama create "$MODEL_WITH_CONTEXT" -f <(echo "FROM $MODEL_NAME
PARAMETER num_ctx $CONTEXT_WINDOW")

    if [ $? -eq 0 ]; then
        print_success "Model '$MODEL_WITH_CONTEXT' created with ${CONTEXT_WINDOW} token context window"
        MODEL_NAME="$MODEL_WITH_CONTEXT"
        print_info "Updated model name to: $MODEL_NAME"
    else
        print_error "Failed to create model with increased context"
    fi
}

# Remove model
remove_model() {
    echo ""
    if check_models; then
        echo "📋 Available models to remove:"
        MODELS=$(curl -s http://localhost:11434/api/tags | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | sort)
        echo "$MODELS" | while read model; do
            echo "  • $model"
        done

        read -p "Enter model name to remove: " model_to_remove
        if [ -n "$model_to_remove" ]; then
            echo "🗑️  Removing model: $model_to_remove"
            $DOCKER_CMD exec $CONTAINER_NAME ollama rm "$model_to_remove"
            print_success "Model '$model_to_remove' removed"
        fi
    fi
}

# Uninstall Ollama
uninstall_ollama() {
    echo ""
    echo "🗑️  Uninstalling Ollama..."

    # Stop and remove container
    stop_ollama
    $DOCKER_CMD rm $CONTAINER_NAME 2>/dev/null || true

    # Remove Docker volume
    VOLUME=$($DOCKER_CMD volume ls -q | grep ollama_data || true)
    if [ -n "$VOLUME" ]; then
        echo "🗑️  Removing Docker volume: $VOLUME"
        $DOCKER_CMD volume rm $VOLUME 2>/dev/null || true
    fi

    print_success "Ollama uninstalled successfully"
}

# Show configuration instructions
show_configuration() {
    echo ""
    echo "📋 Configuration for OpenCode/Droid CLI"
    echo "======================================"
    echo ""
    echo "For OpenCode, add this to your config.json:"
    echo ""
    echo "{"
    echo "  \"\$schema\": \"https://opencode.ai/config.json\","
    echo "  \"provider\": {"
    echo "    \"ollama\": {"
    echo "      \"npm\": \"@ai-sdk/openai-compatible\","
    echo "      \"options\": {"
    echo "        \"baseURL\": \"http://localhost:11434/v1\""
    echo "      },"
    echo "      \"models\": {"
    echo "        \"$MODEL_NAME\": {"
    echo "          \"tools\": true"
    echo "        }"
    echo "      }"
    echo "    }"
    echo "  }"
    echo "}"
    echo ""
    echo "For Droid CLI, use this configuration:"
    echo ""
    echo "{"
    echo "  \"custom_models\": ["
    echo "    {"
    echo "      \"model_display_name\": \"$MODEL_NAME [Local]\","
    echo "      \"model\": \"$MODEL_NAME\","
    echo "      \"base_url\": \"http://localhost:11434/v1\","
    echo "      \"api_key\": \"not-needed\","
    echo "      \"provider\": \"generic-chat-completion-api\","
    echo "      \"max_tokens\": 4000"
    echo "    }"
    echo "  ]"
    echo "}"
    echo ""
}

# Main menu
show_menu() {
    echo ""
    echo "📋 Main Menu:"
    echo "============"
    echo "1. Check system requirements"
    echo "2. Check Docker installation"
    echo "3. Install Docker"
    echo "3a. Skip Docker setup (assume installed)"
    echo "4. Start Ollama container"
    echo "5. Stop Ollama container"
    echo "6. Install model"
    echo "7. List installed models"
    echo "8. Remove model"
    echo "9. Configure model context window"
    echo "10. Show configuration instructions"
    echo "11. Uninstall Ollama"
    echo "12. Exit"
    echo ""
}

# Main execution loop
main() {
    print_header

    # Check basic requirements on startup
    check_system_requirements
    check_docker

    while true; do
        show_menu
        read -p "Select an option (1-12): " choice
        echo ""

        case $choice in
            1)
                check_system_requirements
                ;;
            2)
                if check_docker; then
                    print_success "Docker is properly installed and accessible"
                else
                    print_error "Docker installation issues detected"
                fi
                ;;
            3)
                install_docker
                ;;
            3a)
                echo "🔧 Skipping Docker installation - assuming Docker is already installed"
                DOCKER_CMD="docker"
                if ! docker info >/dev/null 2>&1; then
                    DOCKER_CMD="sudo docker"
                    print_info "Using sudo with Docker commands"
                fi
                print_success "Docker configuration complete"
                ;;
            4)
                start_ollama
                ;;
            5)
                stop_ollama
                ;;
            6)
                read -p "Enter model name (default: mistral:7b): " input_model
                MODEL_NAME=${input_model:-mistral:7b}
                install_model
                ;;
            7)
                check_models
                ;;
            8)
                remove_model
                ;;
            9)
                if check_ollama_container; then
                    read -p "Enter model name to configure: " input_model
                    MODEL_NAME=${input_model:-$MODEL_NAME}
                    read -p "Enter context window size (default: 8192): " input_context
                    CONTEXT_WINDOW=${input_context:-8192}
                    configure_model_context
                else
                    print_error "Ollama container must be running"
                fi
                ;;
            10)
                show_configuration
                ;;
            11)
                read -p "Are you sure you want to uninstall Ollama? (y/N): " confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    uninstall_ollama
                fi
                ;;
            12)
                echo "👋 Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please select 1-12."
                ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
        echo ""
    done
}

# Check if script is run directly or sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi