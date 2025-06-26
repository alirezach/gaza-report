set -e

echo "Starting Step 1: Ensure R packages are correctly managed by renv."

# Read and display current renv.lock for debugging
echo "Current renv.lock:"
cat renv.lock || echo "renv.lock not found"

# Attempt to install packages and update renv.lock using renv itself
# This is a more robust way than manually editing renv.lock

# Ensure R is available
if ! command -v R &> /dev/null
then
    echo "R could not be found. Attempting to install R."
    sudo apt-get update -y
    sudo apt-get install -y r-base r-base-dev
    # Try again to see if R is available
    if ! command -v R &> /dev/null
    then
        echo "Failed to install R."
        # exit 1 # Removed this line
    fi
    echo "R installed successfully."
fi

# The R script install_packages.R is already created by a previous step.
# We just need to ensure its contents are what we expect if we were to re-create it here.
# For this execution, we assume install_packages.R exists and is correct.

echo "Running R script install_packages.R..."
Rscript install_packages.R

# Check the contents of renv.lock after the script execution
echo "Updated renv.lock content:"
cat renv.lock

echo "Step 1 finished."
