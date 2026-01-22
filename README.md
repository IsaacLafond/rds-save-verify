# RDS Object Serializer & Verifier

A lightweight, memory-efficient R utility designed to save large environment objects into individual `.rds` files. This script is specifically optimized for **massive datasets** that approach the limits of system RAM.

## Description

When working with datasets that consume a significant portion of available memory, saving a workspace or multiple objects simultaneously can cause R to crash. This script solves that by:

1. **Prioritizing Memory:** Sorting objects by size and processing them from smallest to largest.
2. **Validation:** Automatically reading each saved file back into R and comparing it to the original to ensure data integrity.
3. **Aggressive Cleanup:** Using explicit `rm()` and `gc()` (Garbage Collection) calls to ensure that the memory used by a massive object is fully released before the next comparison begins.

## Installation

No formal installation is required. You only need a working installation of R.

1. Clone this repository:
```bash
git clone https://github.com/your-username/rds-serializer.git

```


2. Alternatively, just download the `save_script.R` file directly into your project directory.

## Usage

### 1. Prepare your Environment

Open your R terminal and load the data you wish to process:

```r
load("your_massive_data.RData")

```

### 2. Execute the Script

Run the script using the `source()` function. The script will automatically detect all objects in your current environment, save them, verify them, and then clear them to free up RAM.

```r
source("save_script.R")

```

### 3. Monitoring Output

The script provides real-time console feedback for each object:

* **Processing:** Name and memory size of the object.
* **Saved:** Confirmation of the `.rds` file creation.
* **Validation:** Result of the `identical()` check.
* **Memory Cleared:** Confirmation that RAM has been reclaimed.

> [!CAUTION]
> This script is designed to **remove objects from the environment** after successful verification to save memory. Ensure you have a backup of your data before running if you intend to keep the objects in the active R session.

---

## How it Works

The script utilizes a "Serial Comparison" workflow to minimize the memory footprint:

1. **Sort:** `object.size()` is used to create a processing queue.
2. **Serialize:** `saveRDS()` writes the object to disk.
3. **Verify:** The file is read back into a temporary variable for comparison.
4. **Purge:** Both the original and temporary objects are removed, followed by a `gc()` call to reset the memory pointer.

---
