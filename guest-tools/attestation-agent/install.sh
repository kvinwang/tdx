#!/bin/bash

# Copy the attestation-agent script
cp attestation_agent.py /usr/local/bin/attestation_agent.py

# Create a systemd service file
cat > /etc/systemd/system/attestation-agent.service << EOF
[Unit]
Description=Attestation Agent
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/attestation_agent.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl daemon-reload
systemctl enable attestation-agent
systemctl start attestation-agent

