#!/usr/bin/env python3

# attestation_agent.py
import base64
import hashlib
import json
import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/quote":
            try:
                # Read the attestation data
                with open("/etc/attestation_data", "rb") as f:
                    attestation_data = f.read()

                # Calculate the SHA256 hash
                digest = hashlib.sha256(attestation_data).hexdigest()

                # Call the tdx_quote command
                quote = subprocess.check_output(["tdx_quote"], input=digest.encode())

                ccel_tables = open('/sys/firmware/acpi/tables/CCEL', 'rb').read()
                ccel_data = open('/sys/firmware/acpi/tables/data/CCEL', 'rb').read()
                # Prepare the response
                response = {
                    "data": base64.b64encode(attestation_data).decode("utf-8"),
                    "quote": base64.b64encode(quote).decode("utf-8"),
                    "ccel_tables": base64.b64encode(ccel_tables).decode("utf-8"),
                    "ccel_data": base64.b64encode(ccel_data).decode("utf-8"),
                }

                # Send the response
                self.send_response(200)
                self.send_header("Content-type", "application/json")
                self.end_headers()
                self.wfile.write(bytes(json.dumps(response), "utf-8"))
            except Exception as e:
                self.send_error(500, str(e))
        else:
            self.send_error(404)

def run(server_class=HTTPServer, handler_class=RequestHandler, port=8000):
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    print(f"Starting attestation-agent on port {port}")
    httpd.serve_forever()

if __name__ == "__main__":
    run()

