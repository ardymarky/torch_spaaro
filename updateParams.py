import subprocess
import time
import numpy as np
from pymavlink import mavutil

# Start MAVProxy as a subprocess
mavproxy_process = subprocess.Popen(
    ['mavproxy.py', '--master', '/dev/serial/by-id/usb-FTDI_FT230X_Basic_UART_DO00W5W8-if00-port0', '--baudrate', '57600'], 
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE, 
    stderr=subprocess.PIPE
)

# Check if the process started correctly
# if mavproxy_process.stdin is None:
#     print("Failed to start MAVProxy or stdin is not accessible.")
# else:
#     print("MAVProxy started successfully.")

# Give MAVProxy some time to start
time.sleep(5)

# Get all parameter values from file
params = []

with open('parameters.txt', 'r') as file:
    for line in file:
        line = line.strip()
        if line:  # Check if the line is not empty
            parts = line.split()
            param_id = parts[0]
            param_val = parts[1]
            params.append((param_id, param_val))


# List of commands you want to send to MAVProxy
commands = []

for param_id, param_val in params:    
    # param_id = f"PARAM_{index:03d}"
    commands.append('param set ' + param_id + ' ' + param_val)

# Add required exit commands
commands.append('set requireexit True')
commands.append('exit')

# Function to send commands to MAVProxy
def send_command(command):
    # Send a command to MAVProxy's stdin
    mavproxy_process.stdin.write(f"{command}\n".encode())
    mavproxy_process.stdin.flush()

# Send each command with a delay
for command in commands:
    send_command(command)
    time.sleep(2)  

# Close the subprocess after all commands have been sent
mavproxy_process.stdin.write(b"exit\n")
mavproxy_process.stdin.flush()
mavproxy_process.wait() 

# print("MAVProxy commands executed.")

# Create the connection
master = mavutil.mavlink_connection('/dev/serial/by-id/usb-FTDI_FT230X_Basic_UART_DO00W5W8-if00-port0', 57600)
# Wait a heartbeat before sending commands
master.wait_heartbeat()

# Request all parameter values
master.mav.param_request_list_send(
    master.target_system, master.target_component
)

# Read out all parameter values
total_params = 24
recieved = 0
timeout_duration = 10
start_time = time.time()

while recieved < total_params:
    time.sleep(0.01)
    try:
        if time.time() - start_time > timeout_duration:
            print("Timeout waiting for parameters.")
            break
        
        message = master.recv_match(type='PARAM_VALUE', blocking=True).to_dict()
        print('name: %s\tvalue: %d' % (message['param_id'],
                                       message['param_value']))
        recieved += 1

    except Exception as error:
        print(error)
        sys.exit(0)
