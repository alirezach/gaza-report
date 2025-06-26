if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://packagemanager.posit.co/cran/latest")
}
library(renv)
renv::activate()

packages_to_ensure <- c("DT", "bsicons")
installed_any_new_package = FALSE

for (pkg in packages_to_ensure) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste("Installing", pkg, "...\n"))
    renv::install(pkg, prompt = FALSE)
    installed_any_new_package = TRUE
  } else {
    cat(paste(pkg, "already installed.\n"))
  }
}

if (installed_any_new_package) {
  cat("New packages were installed, updating snapshot...\n")
  renv::snapshot(prompt = FALSE)
  cat("Snapshot updated.\n")
} else {
  cat("No new packages were installed. Snapshot not updated unless other changes occurred.\n")
  # Still, let's run snapshot to capture any other potential changes like R version or manual removals.
  # However, the warning about bsicons implies it's a missing new dependency.
  # If bsicons was truly missing, the above loop should have set installed_any_new_package to TRUE.
  # The fact that it wasn't means requireNamespace("bsicons") might be returning TRUE
  # even if renv considers it not "installed" for snapshot purposes.
  # To be safe, always run snapshot if we suspect discrepancies.
  # The prompt during the previous run said "The following required packages are not installed: - bsicons"
  # This implies renv::snapshot *detected* it as a dependency but it wasn't in the library.
  # So, we must ensure it's installed if not present, then snapshot.
  # The logic above should handle this. If it's still missing, snapshot will tell us.
  # Let's run snapshot anyway to be sure all dependencies are aligned.
  cat("Running snapshot to ensure lockfile is up-to-date with all dependencies...\n")
  renv::snapshot(prompt = FALSE)
  cat("Snapshot run complete.\n")
}
