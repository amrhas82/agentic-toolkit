#!/bin/bash

# Ollama Ubuntu Setup Tool
# Automated installation and configuration of Ollama on Ubuntu systems
# Supports both CPU and GPU configurations with Docker

set -euo pipefail

# Script metadata
readonly SCRIPT_NAME="Ollama Ubuntu Setup Tool"
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_AUTHOR="OpenCode Development Team"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Global variables
VERBOSE=false
SILENT=false
FORCE_MODE=false
GPU_MODE="auto"  # auto, enabled, disabled
INSTALL_DIR="${HOME}/.ollama"
OLLAMA_PORT=11434
DRY_RUN=false

# Error codes
readonly ERROR_GENERIC=1
readonly ERROR_SYSTEM=2
readonly ERROR_DOCKER=3
readonly ERROR_OLLAMA=4
readonly ERROR_NETWORK=5
readonly ERROR_PERMISSION=6
readonly ERROR_DEPENDENCY=7
readonly ERROR_CONFIG=8
readonly ERROR_GPU=9
readonly ERROR_PORT=10
readonly ERROR_DISK_SPACE=11

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging function
log_info() {
    if [[ "$SILENT" != "true" ]]; then
        echo -e "${GREEN}[INFO]${NC} $1"
    fi
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1" >&2
    fi
}

# Function to display usage information
show_usage() {
    cat << EOF
${SCRIPT_NAME} v${SCRIPT_VERSION}

Usage: $(basename "$0") [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -s, --silent        Suppress non-error output
    -f, --force         Force installation even if components already exist
    -g, --gpu MODE      GPU mode: auto (default), enabled, disabled
    -d, --dir PATH      Installation directory (default: ${INSTALL_DIR})
    -p, --port PORT     Ollama port (default: ${OLLAMA_PORT})
    --version           Show version information
    --dry-run           Show what would be done without executing

EXAMPLES:
    $(basename "$0")                     # Default installation with auto GPU detection
    $(basename "$0") --verbose          # Verbose output with detailed logs
    $(basename "$0") --gpu enabled      # Force GPU mode
    $(basename "$0") --gpu disabled     # Force CPU mode
    $(basename "$0") --force            # Reinstall even if already installed
    $(basename "$0") --dry-run          # Preview installation steps

EOF
}

# Function to display version information
show_version() {
    echo "${SCRIPT_NAME} v${SCRIPT_VERSION}"
    echo "Author: ${SCRIPT_AUTHOR}"
    echo "Script Directory: ${SCRIPT_DIR}"
}

# Function to parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -s|--silent)
                SILENT=true
                shift
                ;;
            -f|--force)
                FORCE_MODE=true
                shift
                ;;
            -g|--gpu)
                if [[ -n "${2:-}" ]]; then
                    case "$2" in
                        auto|enabled|disabled)
                            GPU_MODE="$2"
                            ;;
                        *)
                            log_error "Invalid GPU mode: $2. Use: auto, enabled, disabled"
                            exit $ERROR_CONFIG
                            ;;
                    esac
                    shift 2
                else
                    log_error "GPU mode requires a value"
                    exit $ERROR_CONFIG
                fi
                ;;
            -d|--dir)
                if [[ -n "${2:-}" ]]; then
                    INSTALL_DIR="$2"
                    shift 2
                else
                    log_error "Installation directory requires a path"
                    exit $ERROR_CONFIG
                fi
                ;;
            -p|--port)
                if [[ -n "${2:-}" && "$2" =~ ^[0-9]+$ ]]; then
                    OLLAMA_PORT="$2"
                    shift 2
                else
                    log_error "Port must be a valid number"
                    exit $ERROR_CONFIG
                fi
                ;;
            --version)
                show_version
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit $ERROR_CONFIG
                ;;
        esac
    done
}

# Function to validate configuration
validate_configuration() {
    log_verbose "Validating configuration..."

    # Validate GPU mode
    if [[ ! "$GPU_MODE" =~ ^(auto|enabled|disabled)$ ]]; then
        log_error "Invalid GPU mode: $GPU_MODE"
        exit $ERROR_CONFIG
    fi

    # Validate port number
    if [[ ! "$OLLAMA_PORT" =~ ^[0-9]+$ ]] || [[ "$OLLAMA_PORT" -lt 1 ]] || [[ "$OLLAMA_PORT" -gt 65535 ]]; then
        log_error "Invalid port number: $OLLAMA_PORT"
        exit $ERROR_CONFIG
    fi

    # Validate installation directory
    if [[ -z "$INSTALL_DIR" ]]; then
        log_error "Installation directory cannot be empty"
        exit $ERROR_CONFIG
    fi

    log_verbose "Configuration validation completed"
}

# Function to check system requirements
check_system_requirements() {
    log_info "Checking system requirements..."

    # Check if running on Ubuntu
    if ! grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
        log_warn "This script is designed for Ubuntu systems. Other distributions may not be fully supported."
    fi

    # Check for Docker
    if ! command -v docker &> /dev/null; then
        log_info "Docker is not installed. It will be installed during the setup process."
    else
        log_info "Docker is already installed."
    fi

    # Check available disk space
    local available_space
    available_space=$(df / | awk 'NR==2 {print $4}')
    local required_space=10485760  # 10GB in KB

    if [[ $available_space -lt $required_space ]]; then
        log_error "Insufficient disk space. At least 10GB is required."
        exit $ERROR_DISK_SPACE
    fi

    log_info "System requirements check completed."
}

# Function to install Docker
install_docker() {
    if command -v docker &> /dev/null && [[ "$FORCE_MODE" != "true" ]]; then
        log_info "Docker is already installed. Skipping Docker installation."
        return 0
    fi

    log_info "Installing Docker..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would install Docker using official repository"
        return 0
    fi

    # Update package index
    log_verbose "Updating package index..."
    if ! sudo apt-get update; then
        log_error "Failed to update package index"
        exit $ERROR_NETWORK
    fi

    # Install prerequisites
    log_verbose "Installing prerequisites..."
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

    # Add Docker's official GPG key
    log_verbose "Adding Docker's GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up Docker repository
    log_verbose "Setting up Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    log_verbose "Installing Docker Engine..."
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Start and enable Docker
    log_verbose "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add current user to docker group
    log_verbose "Adding user to docker group..."
    sudo usermod -aG docker "$USER"

    log_info "Docker installation completed successfully."
    log_warn "You may need to log out and log back in for docker group changes to take effect."
}

# Function to install and configure Ollama
install_ollama() {
    log_info "Installing Ollama..."

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would pull Ollama Docker image and start container"
        return 0
    fi

    # Determine GPU support
    local gpu_flags=""
    if [[ "$GPU_MODE" == "auto" ]]; then
        if command -v nvidia-smi &> /dev/null; then
            log_info "NVIDIA GPU detected. Enabling GPU support."
            gpu_flags="--gpus all"
        else
            log_info "No NVIDIA GPU detected. Using CPU mode."
        fi
    elif [[ "$GPU_MODE" == "enabled" ]]; then
        log_info "GPU mode explicitly enabled. Using GPU support."
        gpu_flags="--gpus all"
    else
        log_info "GPU mode disabled. Using CPU mode."
    fi

    # Create installation directory
    mkdir -p "$INSTALL_DIR"

    # Pull Ollama image
    log_verbose "Pulling Ollama Docker image..."
    docker pull ollama/ollama

    # Stop existing Ollama container if it exists
    if docker ps -a --format 'table {{.Names}}' | grep -q "^ollama$"; then
        log_verbose "Stopping existing Ollama container..."
        docker stop ollama 2>/dev/null || true
        docker rm ollama 2>/dev/null || true
    fi

    # Start Ollama container
    log_verbose "Starting Ollama container..."
    docker run -d \
        --name ollama \
        -v "$INSTALL_DIR:/root/.ollama" \
        -p "$OLLAMA_PORT:11434" \
        $gpu_flags \
        ollama/ollama

    log_info "Ollama installation completed successfully."
    log_info "Ollama is running on port $OLLAMA_PORT"
}

# Function to show next steps
show_next_steps() {
    echo ""
    log_info "🎉 Installation completed successfully!"
    echo ""
    echo "Next Steps:"
    echo "1. Test your Ollama installation: curl http://localhost:$OLLAMA_PORT/api/tags"
    echo "2. Install your preferred model: ollama pull llama2"
    echo "3. Configure OpenCode/Droid CLI to use Ollama"
    echo ""
    echo "Configuration for OpenCode/Droid CLI:"
    echo "- API Endpoint: http://localhost:$OLLAMA_PORT"
    echo "- Models: Available after pulling models in step 2"
    echo ""
    echo "For more information, see the documentation."
}

# Main execution function
main() {
    log_info "${SCRIPT_NAME} v${SCRIPT_VERSION}"
    log_info "Starting Ollama installation on Ubuntu..."

    parse_arguments "$@"
    validate_configuration
    check_system_requirements
    install_docker
    install_ollama
    show_next_steps

    log_info "Setup completed successfully!"
}

# Run main function with all arguments
main "$@"