# Legacy Node Manager CTF Challenge

**Category:** Pwn / Logic Exploitation  
**Difficulty:** Beginner  
**Author:** Khushal Shadija  

## Challenge Description
The "Legacy Node Manager" is a deprecated CLI tool used to manage node allocations for a sparse-tree algorithm. The system is old and contains a critical logic flaw in how it validates memory resources against the requested tree depth.

*Objective:* Trigger a memory boundary violation to force the system into a "Fail Open" state and retrieve the flag.

Files Included
* `legacy_node_manager`: The executable binary (Linux ELF).
* `Dockerfile`: Configuration to containerize and host the challenge.
* `run.sh`: Startup script for the service.
* `flag.txt`: The dummy flag for testing.

 Vulnerability Analysis

 1. Reconnaissance
Running the binary presents us with two prompts:
bash
./legacy_node_manager
--- LEGACY NODE MANAGER v1.0 (DEPRECATED) ---
WARNING: System uses a sparse-tree algorithm to save memory.
------------------------------------------
Enter max nodes to allocate: 
Enter target depth:

2. The Logic Bug
The warning mentions a sparse-tree algorithm. In binary trees, the number of nodes required grows exponentially relative to the depth (Nodes=2 
Depth
 ).

If we request a Depth of 2, we need approx 4 nodes.

If we request a Depth of 6, we need approx 64 nodes (2 
6
 ).

The program asks us to manually specify max nodes to allocate. The vulnerability is that the system accepts any allocation size without checking if it is mathematically sufficient for the requested depth before initialization.

3. Exploitation Strategy
To exploit this, we perform a Resource Exhaustion Attack (or simulated Heap Overflow):

Allocate a small amount of memory (e.g., 10 nodes).

Request a large tree depth (e.g., 6, which requires ~64 nodes).

This mismatch forces the system to write beyond its allocated boundary during initialization.

Solution
Command:

Bash
nc <target_ip> 1337
Input:

Max nodes: 10

Target depth: 6

Output:

Plaintext
[+] Initializing Memory Manager...

[!] CRITICAL ALERT: MEMORY BOUNDARY VIOLATION
[+] PRIVILEGE ESCALATION SUCCESSFUL.
[+] FLAG: LNMHACKS{W3lc0me_t0_Lnm1it}
How to Run Locally
You can host this challenge using Docker:

Build the image:

Bash
docker build -t lnmhacks/logic_challenge .
Run the container:

Bash
docker run -d -p 1337:5010 lnmhacks/logic_challenge
Connect:

Bash
nc localhost 1337


