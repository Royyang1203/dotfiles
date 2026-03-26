# ~/.config/zsh/.zprofile
# Login-only setup.

# Homebrew shellenv (macOS).
for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew
do
  if [ -x "$candidate" ]; then
    eval "$("$candidate" shellenv)"
    break
  fi
done

export PATH="$HOME/.local/bin:$PATH"
