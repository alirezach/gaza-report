# Try to load renv, if not available, install it
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://packagemanager.posit.co/cran/latest")
}
library(renv)

# Initialize renv if not already initialized (e.g. .Rprofile is missing or renv dir is empty)
# Check if the .Rprofile specifically sources renv/activate.R
# and if the renv directory seems populated.
if (!file.exists(".Rprofile") || !any(grepl("source(\"renv/activate.R\")", readLines(".Rprofile", warn = FALSE)))) {
  # A basic .Rprofile might be needed
  if (!dir.exists("renv") || length(list.files("renv")) == 0) {
    renv::init(bare = TRUE, restart = FALSE) # bare = TRUE to not try to find packages initially
    cat("source(\"renv/activate.R\")\n", file = ".Rprofile")
    cat("Renviron.site updated to ensure renv is activated.\n")
  } else {
     # If renv dir exists but .Rprofile is not sourcing, add it
     cat("source(\"renv/activate.R\")\n", file = ".Rprofile", append = TRUE)
  }
} else {
  cat(".Rprofile already sources renv/activate.R\n")
}


# Activate the project
renv::activate()

# Packages to install
packages_to_install <- c("tidyverse", "rlistings", "jsonlite", "rmarkdown", "knitr", "bslib") # Added common Quarto/RMarkdown deps

# Install packages
renv::install(packages_to_install, prompt = FALSE, restart = FALSE)
# Alternatively, record them first then install
# for (pkg in packages_to_install) {
#   renv::record(pkg)
# }
# renv::install(prompt = FALSE, restart = FALSE)


# Snapshot the changes
renv::snapshot(prompt = FALSE) # Removed restart = FALSE

cat("renv setup and package installation complete.\n")
