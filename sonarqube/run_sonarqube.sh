#!/bin/bash

set -euo pipefall

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
REPORTS_DIR="${SCRIPT_DIR}/reports"
SONAR_WORK_DIR="${SCRIPT_DIR}/.scannerwork"

DEFAULT_SONAR_HOST="http://localhost:9000"
DEFAULT_PROJECT_KEY="SecurityCompliance"

if [ -z "${SONARQUBE_TOKEN:-}" ]; then
    echo "Error: SONARQUBE_TOKEN environment variable is not set"
    exit 1
fi

run_sonar_scan() {
    local project_key="${1:-$DEFAULT_PROJECT_KEY}"
    local host_url="${2:-$DEFAULT_SONAR_HOST}"

    echo "Starting SonarQube scan for project: ${project_key}"
    

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

save_scan_report() {
    local report_file="${REPORTS_DIR}/sonarqube_report.txt"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    

    if [ -f "${SONAR_WORK_DIR}/report-task.txt" ]; then
        cp "${SONAR_WORK_DIR}/report-task.txt" "${report_file}.${timestamp}"
        ln -sf "${report_file}.${timestamp}" "${report_file}"
        echo "Scan report saved to: ${report_file}"
    else
        echo "Error: Scan report not found"
        exit 1
    fi
}

