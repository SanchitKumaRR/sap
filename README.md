
# SAP (Simple AUR Packager) 🚀

**SAP** is a minimalist, lightning-fast AUR helper written in Python. It focuses on simplicity and transparent code, allowing users to install, search, and manage Arch User Repository packages without the bloat.

> "A project built for simplicity, by a developer who values clean logic."

## ✨ Features
- **Install (-S):** Automatic cloning, building, and installation.
- **Search (-Ss):** Real-time search using the official AUR RPC API.
- **Information (-Si):** Extract detailed metadata about any package.
- **Remove (-R):** Clean uninstallation via Pacman.
- **Cache Management (-Sc):** Keep your system clean by clearing build files.
- **Minimalist:** Zero bloat!!
- **Auto Updating!!(New!!)**-Auto updates the packages!

## 🛠️ Installation

To install **SAP** globally on your Arch Linux system:

```bash
# 1. Clone the repository
git clone [https://github.com/SanchitKumaRR/sap.git](https://github.com/SanchitKumaRR/sap.git)
cd sap

# 2. Make the script executable
chmod +x sap.sh

# 3. Move it to your local bin (to run 'sap' from anywhere)
sudo cp sap.sh /usr/local/bin/sap

