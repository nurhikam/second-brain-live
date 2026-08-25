---
publish: true
---

# Install WSL2 by opening PowerShell as Administrator and running:
```
    # Install WSL using the default Linux distribution (Ubuntu).
    # See https://learn.microsoft.com/en-us/windows/wsl/install for more info
    wsl --install

    # Restart your computer, then start a shell inside of Windows Subsystem for Linux
    wsl

    # Install Node.js in WSL via nvm
    # Documentation: https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh"
    nvm install 22

    # Install and run Codex in WSL
    npm install --global @openai/codex
    codex

    # Additional details and instructions for how to install and run Codex in WSL:
    https://developers.openai.com/codex/windows
```

#dev #wsl