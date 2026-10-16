#!/bin/bash

# Latest release tag of a GitHub repo (follows the /releases/latest redirect,
# so it does not consume GitHub API rate limit)
github_latest_tag() {
  curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest" | sed 's#.*/tag/##'
}

# Install a binary from the latest GitHub release into /usr/local/bin
# Usage: install_github_binary <owner/repo> <asset> <binary>
# The asset name accepts {tag} (e.g. v1.2.3) and {version} (e.g. 1.2.3) placeholders.
# .tar.gz assets are extracted, any other asset is treated as the binary itself.
install_github_binary() {
  local repo="$1"
  local asset="$2"
  local binary="$3"
  local tag version tmpdir

  tag=$(github_latest_tag "$repo")
  if [ -z "$tag" ]; then
    echo "❌ Error: could not get the latest release of $repo."
    exit 1
  fi
  version="${tag#v}"
  asset="${asset//\{tag\}/$tag}"
  asset="${asset//\{version\}/$version}"

  tmpdir=$(mktemp -d)
  curl -fsSL -o "$tmpdir/$asset" "https://github.com/$repo/releases/download/$tag/$asset"

  case "$asset" in
    *.tar.gz) tar -xzf "$tmpdir/$asset" -C "$tmpdir" "$binary" ;;
    *) mv "$tmpdir/$asset" "$tmpdir/$binary" ;;
  esac

  sudo install -m 0755 "$tmpdir/$binary" "/usr/local/bin/$binary"
  rm -rf "$tmpdir"

  # Check installation
  if command -v "$binary" &>/dev/null; then
    echo "✔ $binary $tag installed correctly."
  else
    echo "❌ Error: $binary did not install correctly."
    exit 1
  fi
}
