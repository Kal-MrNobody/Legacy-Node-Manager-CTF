# Legacy Node Manager CTF Challenge

**Category:** Pwn / Logic Exploitation  
**Difficulty:** Beginner  
**Author:** Khushal Shadija  

## Challenge Description
The "Legacy Node Manager" is a deprecated CLI tool used to manage node allocations for a sparse-tree algorithm. The system is old and contains a critical logic flaw in how it validates memory resources against the requested tree depth.

**Objective:** Trigger a memory boundary violation to force the system into a "Fail Open" state and retrieve the flag.

## Files Included
* `legacy_node_manager`: The executable binary (Linux ELF).
* `Dockerfile`: Configuration to containerize and host the challenge.
* `run.sh`: Startup script for the service.
* `flag.txt`: The dummy flag for testing.

## Vulnerability Analysis

### 1. Reconnaissance
Running the binary presents us with two prompts:
```bash
./legacy_node_manager
--- LEGACY NODE MANAGER v1.0 (DEPRECATED) ---
WARNING: System uses a sparse-tree algorithm to save memory.
------------------------------------------
Enter max nodes to allocate: 
Enter target depth:

2. The Logic Bug
The warning mentions a sparse-tree algorithm. In binary trees, the number of nodes required grows exponentially relative to the depth ($Nodes = 2^{Depth}$).
