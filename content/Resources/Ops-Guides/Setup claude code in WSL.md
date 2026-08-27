---
publish: true
---

# First install wsl and node.js
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
```
## Step 5: Install and Test Claude Code

### 5.1 Install Claude Code

bash

```bash
# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

### 5.2 Set Up Authentication

You'll need one of these options:

**Option A: Anthropic Console (API)**

- Create account at [console.anthropic.com](https://console.anthropic.com)
- Set up billing
- Generate API key

**Option B: Claude Pro/Max Subscription**

- Subscribe to Claude Pro or Max at [claude.ai](https://claude.ai)
- Use your Claude.ai account

### 5.3 Initialize Claude Code

bash

```bash
# Navigate to a test directory
mkdir ~/test-project
cd ~/test-project

# Start Claude Code
claude
```

Follow the authentication prompts to connect your account.

---

## Step 6: Test Claude Code Configuration

### 6.1 Basic Functionality Test

bash

```bash
# Test basic commands
/help

# Test AI interaction
/ask "What is the current directory and what files are in it?"

# Test file generation
/generate "Create a simple hello.py file that prints 'Hello, Claude Code!'"

# Check system health
/doctor
```

### 6.2 Verify File Operations

bash

```bash
# List files created by Claude
ls -la

# Test file reading
/ask "Read the hello.py file and explain what it does"

# Test code execution (if Python installed)
python3 hello.py
```

---

## Step 7: Example - Running Claude on Existing Project

### 7.1 Navigate to Existing Project

bash

```bash
# Option 1: WSL project (best performance)
cd ~/my-existing-project

# Option 2: Windows project (accessible but slower)
cd /mnt/c/Users/YourUsername/Documents/my-project

# Option 3: Project on moved drive
cd /mnt/e/my-projects/existing-project
```

### 7.2 Initialize Claude in Project

bash

```bash
# Start Claude Code in project directory
claude

# Generate project documentation
/generate "Create a comprehensive CLAUDE.md file that explains this project structure and how to work with it"

# Ask Claude to analyze the project
/ask "Analyze this codebase and give me a summary of what this project does"
```

### 7.3 Common Claude Code Workflows

bash

```bash
# Code analysis and review
/ask "Review the main.js file for potential improvements"

# Bug fixing
/ask "There's a bug in the login function, can you help me find and fix it?"

# Feature development
/generate "Add a new API endpoint for user profile management"

# Testing
/test "Create unit tests for the authentication module"

# Refactoring
/refactor "Convert this callback-based code to use async/await"

# Documentation
/ask "Generate JSDoc comments for all functions in utils.js"
```

### 7.4 Project-Specific Commands

bash

```bash
# Commit changes (if git is set up)
/ask "Review my changes and create an appropriate git commit message"

# Environment setup
/ask "Help me set up the development environment for this project"

# Dependencies
/ask "Analyze package.json and suggest any outdated or security-vulnerable dependencies"
```

Ref: [Complete Claude Code Installation Guide for Windows | Claude | Claude](https://claude.ai/public/artifacts/d5297b60-4c2c-4378-879b-31cc75abdc98?fullscreen=false)

tags: #dev, #ai, #wsl 

[[Setup Codex in WSL]]
