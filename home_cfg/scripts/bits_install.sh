#!/bin/bash

# Install NodeJS via NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install v6.11.1

# Install Yarn
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$PATH"

# Install PIP and necessary Python packages
curl https://bootstrap.pypa.io/get-pip.py | python - --user
pip install --user crypto netifaces python-magic pyserial

# Setup bits
git clone https://github.com/LGSInnovations/bits.git
cd bits
npm install
npm run build

# Start bits
npm run dev