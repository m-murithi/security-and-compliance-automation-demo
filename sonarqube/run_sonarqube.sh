#!/bin/bash

# Set strict error handling
set -euo pipefail

# Script configuration
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
REPORTS_DIR="${SCRIPT_DIR}/reports"
SONAR_WORK_DIR="${SCRIPT_DIR}/.scannerwork"

# Default values
DEFAULT_SONAR_HOST="http://localhost:9000"
DEFAULT_PROJECT_KEY="SecurityCompliance"

# Configuration validation
if [ -z "${SONARQUBE_TOKEN:-}" ]; then
    echo "Error: SONARQUBE_TOKEN environment variable is not set"
    exit 1
fi

# Create reports directory if it doesn't exist
mkdir -p "${REPORTS_DIR}"

# Function to perform SonarQube scan
run_sonar_scan() {
    local project_key="${1:-$DEFAULT_PROJECT_KEY}"
    local host_url="${2:-$DEFAULT_SONAR_HOST}"

    echo "Starting SonarQube scan for project: ${project_key}"
    
    # Run SonarQube scanner with error handling
    if ! sonar-scanner \
        -Dsonar.projectKey="${project_key}" \
        -Dsonar.sources=. \
        -Dsonar.host.url="${host_url}" \
        -Dsonar.login="${SONARQUBE_TOKEN}" \
        -Dsonar.working.directory="${SONAR_WORK_DIR}"; then
        echo "Error: SonarQube scan failed"
        exit 1
    fi
}

# Function to save scan report
save_scan_report() {
    local report_file="${REPORTS_DIR}/sonarqube_report.txt"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    
    # Save report with timestamp
    if [ -f "${SONAR_WORK_DIR}/report-task.txt" ]; then
        cp "${SONAR_WORK_DIR}/report-task.txt" "${report_file}.${timestamp}"
        ln -sf "${report_file}.${timestamp}" "${report_file}"
        echo "Scan report saved to: ${report_file}"
    else
        echo "Error: Scan report not found"
        exit 1
    fi
}

# Main execution
main() {
    # Run scan
    run_sonar_scan "$@"
    
    # Save report
    save_scan_report
    
    echo "SonarQube scan completed successfully"
}

# Execute main function with all passed arguments
main "$@"