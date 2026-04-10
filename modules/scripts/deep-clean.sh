# Deep clean script for Nix systems
# Removes old generations, garbage, and optimizes store
# WARNING: Do NOT run with sudo - run as normal user
echo "--- Starting Nix Deep Clean ---"

if [[ $EUID -eq 0 ]]; then
  echo "Error: Do not run this script with 'sudo ./clean-nix.sh'."
  echo "Run it as your normal user; it will ask for your password when needed."
  exit 1
fi

echo "Cleaning system generations..."
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

if command -v home-manager &> /dev/null; then
  echo "Cleaning Home Manager generations..."
  home-manager expire-generations "-0 days"
fi

echo "Cleaning user generations..."
nix-env --delete-generations old

echo "Removing 'result' symlinks in current directory..."
find . -name "result" -type l -delete

echo "Running Garbage Collector..."
sudo nix-collect-garbage -d
nix-collect-garbage -d

echo "Optimising the store (deduplicating files)..."
nix store optimise

echo "--- Clean Up Complete ---"
