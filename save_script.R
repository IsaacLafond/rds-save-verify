# 1. Get all object names in the environment
all_objs <- ls()

# 2. Create a data frame of objects and their sizes
# This allows us to sort them and process smallest to largest
obj_sizes <- data.frame(
  name = all_objs,
  size = sapply(all_objs, function(x) object.size(get(x))),
  stringsAsFactors = FALSE
)

# Sort by size (ascending)
obj_sizes <- obj_sizes[order(obj_sizes$size), ]

# 3. Iterate through objects
for (obj_name in obj_sizes$name) {
  cat("Processing:", obj_name, "| Size:", format(object.size(get(obj_name)), units = "auto"), "\n")
  
  file_path <- paste0(obj_name, ".rds")
  
  # Save to RDS
  saveRDS(get(obj_name), file = file_path)
  cat("  - Saved to:", file_path, "\n")
  
  # Load it back for validation
  # We use a temporary name to avoid overwriting the original yet
  temp_load <- readRDS(file_path)
  
  # Check identity
  # identical() is strict; all.equal() is more flexible for large data
  is_match <- identical(get(obj_name), temp_load)
  
  if (is_match) {
    cat("  - Validation successful: Objects are identical.\n")
    
    # Remove the objects to free up memory
    rm(temp_load)
    rm(list = obj_name)
    
    # Force Garbage Collection
    # This is crucial for "massive" objects to free up the RAM for the next iteration
    gc()
    
    cat("  - Memory cleared for next object.\n")
  } else {
    stop(paste("Validation failed for object:", obj_name, ". Script halted to prevent data loss."))
  }
}

cat("\nAll objects have been saved, verified, and cleared from the environment.\n")
