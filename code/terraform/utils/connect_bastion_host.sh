#!/usr/bin/env bash
set -e

PROJECT_NAME=${1:-"cowing"}
ENV=${2:-"prod"}
KEY_NAME=${3:-"bastion_key"}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="bastion-connect-${TIMESTAMP}-result.txt"

# Disable AWS CLI pager
export AWS_PAGER=""

echo "Connecting to ${PROJECT_NAME}-${ENV} bastion host via SSM..." | tee "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"

# Check if Session Manager Plugin is installed
echo "Checking Session Manager Plugin..." | tee -a "$LOG_FILE"
if ! command -v session-manager-plugin &> /dev/null; then
    echo "ERROR: Session Manager Plugin is not installed!" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "Please install it using one of these methods:" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "Method 1 - Using Homebrew (recommended):" | tee -a "$LOG_FILE"
    echo "  brew install --cask session-manager-plugin" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "Method 2 - Manual installation:" | tee -a "$LOG_FILE"
    echo "  curl \"https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip\" -o \"sessionmanager-bundle.zip\"" | tee -a "$LOG_FILE"
    echo "  unzip sessionmanager-bundle.zip" | tee -a "$LOG_FILE"
    echo "  sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "After installation, run this script again." | tee -a "$LOG_FILE"
    echo "===========================================" | tee -a "$LOG_FILE"
    exit 1
else
    echo "Session Manager Plugin found: $(which session-manager-plugin)" | tee -a "$LOG_FILE"
fi

# Generate SSH key only if it doesn't exist (for future use if needed)
if [ ! -f "$KEY_NAME" ]; then
    echo "Generating new SSH key: $KEY_NAME (for future use)" | tee -a "$LOG_FILE"
    ssh-keygen -t rsa -f "$KEY_NAME" -N "" -q 2>&1 | tee -a "$LOG_FILE"
else
    echo "Using existing SSH key: $KEY_NAME" | tee -a "$LOG_FILE"
fi

# Get instance information
echo "Looking for bastion host..." | tee -a "$LOG_FILE"
echo "Executing: aws ec2 describe-instances..." | tee -a "$LOG_FILE"

INSTANCE_INFO=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${PROJECT_NAME}-${ENV}-bastion-host" "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,PrivateIpAddress,State.Name]' \
  --output text 2>&1)

echo "AWS describe-instances result:" | tee -a "$LOG_FILE"
echo "$INSTANCE_INFO" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"

if [ -z "$INSTANCE_INFO" ] || [ "$INSTANCE_INFO" = "None" ]; then
  echo "Error: Running bastion host not found" | tee -a "$LOG_FILE"
  echo "Please check if the bastion host exists and is in running state" | tee -a "$LOG_FILE"
  exit 1
fi

# Parse instance information
INSTANCE_ID=$(echo "$INSTANCE_INFO" | awk '{print $1}')
PUBLIC_IP=$(echo "$INSTANCE_INFO" | awk '{print $2}')
PRIVATE_IP=$(echo "$INSTANCE_INFO" | awk '{print $3}')
STATE=$(echo "$INSTANCE_INFO" | awk '{print $4}')

echo "Found bastion host:" | tee -a "$LOG_FILE"
echo "  Instance ID: $INSTANCE_ID" | tee -a "$LOG_FILE"
echo "  Public IP: $PUBLIC_IP" | tee -a "$LOG_FILE"
echo "  Private IP: $PRIVATE_IP" | tee -a "$LOG_FILE"
echo "  State: $STATE" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"

# Check if SSM agent is ready
echo "Checking SSM connectivity..." | tee -a "$LOG_FILE"
SSM_STATUS=$(aws ssm describe-instance-information \
  --filters "Key=InstanceIds,Values=$INSTANCE_ID" \
  --query 'InstanceInformationList[0].PingStatus' \
  --output text 2>&1)

echo "SSM Status: $SSM_STATUS" | tee -a "$LOG_FILE"

if [ "$SSM_STATUS" != "Online" ]; then
    echo "Warning: SSM Agent might not be ready. Status: $SSM_STATUS" | tee -a "$LOG_FILE"
    echo "Attempting connection anyway..." | tee -a "$LOG_FILE"
fi

echo "===========================================" | tee -a "$LOG_FILE"

echo "Connecting via SSM Session Manager..." | tee -a "$LOG_FILE"
echo "SSM command: aws ssm start-session --target $INSTANCE_ID" | tee -a "$LOG_FILE"
echo "===========================================" | tee -a "$LOG_FILE"

# Function to cleanup on exit
cleanup() {
    echo "Script execution completed at $(date)" | tee -a "$LOG_FILE"
    echo "SSH keys preserved: $KEY_NAME, ${KEY_NAME}.pub" | tee -a "$LOG_FILE"
    echo "Log saved to: $LOG_FILE"
}

# Set trap for cleanup
trap cleanup EXIT

# Connect via SSM Session Manager
echo "Starting SSM session..." | tee -a "$LOG_FILE"
echo "To exit the session, type 'exit' or press Ctrl+C" | tee -a "$LOG_FILE"

aws ssm start-session --target "$INSTANCE_ID"