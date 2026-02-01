# CTF Writeup: Exploiting Logic Bugs in Legacy Code

## A deep dive into the "Legacy Node Manager" Challenge

**Category:** Pwn / Logic Exploitation
**Difficulty:** Beginner

---

### Introduction

In the world of cybersecurity, not every hack requires complex memory corruption or shellcode injection. Sometimes, the most critical vulnerabilities are simple **logic bugs**—flaws in how a program thinks, rather than how it handles memory.

In this article, I will walk you through **"Legacy Node Manager,"** a beginner-friendly CTF challenge I created to demonstrate how improper input validation can lead to privilege escalation.

### The Scenario

We are given a deprecated CLI tool called `legacy_node_manager`. The prompt tells us it is used to manage node allocations for a "sparse-tree algorithm." Our goal is to break the logic and force the system to give us the flag.

**Files Provided:**
* `legacy_node_manager`: The executable binary.
* `Dockerfile`: For local hosting.
* `run.sh`: Startup script.

---

### Step 1: Reconnaissance

The first step in any CTF challenge is to run the program and see how it behaves. When we connect to the server, we are greeted with a warning and two questions:

```bash
nc localhost 1337
```
**Output:**
--- LEGACY NODE MANAGER v1.0 (DEPRECATED) ---
WARNING: System uses a sparse-tree algorithm to save memory.
------------------------------------------
Enter max nodes to allocate: 
Enter target depth:

The program is asking us to manually configure its memory usage. It wants to know:

How much memory (nodes) we want to reserve.

How deep the tree structure should be.

### Step 2: Identifying the Vulnerability
The warning message gives us a massive hint: "System uses a sparse-tree algorithm."

In computer science, a binary tree grows exponentially. The number of nodes required is related to the depth by the formula:
Nodes ≈ 2^Depth

Let's do some quick math:

If we request a Depth of 2, we need about 2^2 = 4 nodes.

If we request a Depth of 6, we need about 2^6 = 64 nodes.

**The Flaw:** The program allows us to input any number for "Max nodes" and any number for "Target depth" independently. It does not seem to check if the Max nodes we allocated are actually enough to hold the Target depth we requested.

If we ask for a deep tree but only give it a tiny amount of memory, we might trigger a Resource Exhaustion or Boundary Violation error.


### Step 3: The Exploit Strategy
To exploit this, we will perform a "starvation attack." We will lie to the system:

We will allocate a very small amount of memory (e.g., 10 nodes).

We will demand a complex operation (e.g., Depth 6, which requires ~64 nodes).

The system will try to initialize the tree, realize it has run out of allocated memory, and hopefully crash in an insecure way (Fail Open).


### Step 4: Execution
Let's try these values against the live server.

**Command:**

nc localhost 1337

**Our Input:**
Enter max nodes to allocate: 10
Enter target depth: 6

**The Result:**

[+] Initializing Memory Manager...

[!] CRITICAL ALERT: MEMORY BOUNDARY VIOLATION
[+] PRIVILEGE ESCALATION SUCCESSFUL.
[+] FLAG: LNMHACKS{W3lc0me_t0_Lnm1it}


It worked! The system detected the boundary violation. Instead of safely shutting down, the legacy error handler defaulted to a debug mode or "fail open" state, granting us administrative privileges and printing the flag.


### Why This Matters
This challenge simulates a common class of real-world bugs known as Business Logic Errors.

In real applications, developers often assume users will provide logical inputs (e.g., "If they need 64 nodes, surely they will allocate 64 nodes"). Hackers exploit this trust by providing mathematically impossible or contradictory inputs to force the application into an undefined state.

**Key Takeaway:** Always validate that user inputs are consistent with each other before processing them!


**How to Host This Challenge**
If you want to try this challenge locally or host it for your friends, you can use Docker.

**1. Build the Image**
   docker build -t lnmhacks/logic_challenge .

**2. Run the Container**
   docker run -d -p 1337:5010 lnmhacks/logic_challenge

**3. Connect**
   nc localhost 1337
