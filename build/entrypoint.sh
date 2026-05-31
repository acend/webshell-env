#!/bin/bash
# On OpenShift, HOME is overridden to /home/project (the PVC mount).
# Copy profile files from the image so the terminal gets the correct
# prompt, aliases, and PATH on first run. Existing files are not overwritten,
# so user customisations on the PVC are preserved.
[ -f "$HOME/.bashrc" ] || cp /home/theia/.bashrc "$HOME/.bashrc"
[ -f "$HOME/.profile" ] || cp /home/theia/.profile "$HOME/.profile"

exec node /home/theia/applications/browser/lib/backend/main.js "$@"
