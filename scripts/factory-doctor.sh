#!/usr/bin/env bash
set -euo pipefail

echo "========================================="
echo "       PINATA FACTORY DOCTOR CHECK       "
echo "========================================="

FAILURES=0

check_cmd() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "  [OK] $name: $(command -v "$cmd")"
  else
    echo "  [MISSING] $name ($cmd not found in PATH)"
    FAILURES=$((FAILURES + 1))
  fi
}

echo ""
echo "1. Git & GitHub Tooling"
check_cmd "Git" "git"
if command -v git >/dev/null 2>&1; then
  GIT_USER=$(git config user.name || echo "unconfigured")
  GIT_EMAIL=$(git config user.email || echo "unconfigured")
  echo "       user.name:  $GIT_USER"
  echo "       user.email: $GIT_EMAIL"
  if [ "$GIT_USER" != "cesarchavezcal" ]; then
    echo "  [WARN] git user.name ($GIT_USER) is not cesarchavezcal"
  fi
fi

check_cmd "GitHub CLI" "gh"
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    echo "       GitHub Auth: Authenticated"
  else
    echo "  [WARN] GitHub Auth: 'gh auth status' reported unauthenticated"
  fi
fi

echo ""
echo "2. Visual Regression & Headless Tools"
check_cmd "Node.js" "node"
check_cmd "npm" "npm"

if command -v before-and-after >/dev/null 2>&1; then
  echo "  [OK] before-and-after CLI: $(command -v before-and-after)"
else
  echo "  [INFO] before-and-after CLI not installed globally (available via 'npx @vercel/before-and-after')"
fi

echo ""
echo "3. Evidence Recorder Prerequisites"
check_cmd "Python 3" "python3"
check_cmd "FFmpeg" "ffmpeg"
check_cmd "FFprobe" "ffprobe"

if command -v ffmpeg >/dev/null 2>&1; then
  FFMPEG_OUT=$(ffmpeg -version 2>&1 || true)
  if echo "$FFMPEG_OUT" | grep -q -- "enable-libx264"; then
    echo "  [OK] FFmpeg has libx264 support"
  else
    echo "  [WARN] FFmpeg missing libx264 filter/encoder"
  fi
  if echo "$FFMPEG_OUT" | grep -q -- "enable-libass"; then
    echo "  [OK] FFmpeg has libass subtitle support"
  else
    echo "  [WARN] FFmpeg missing libass filter"
  fi
fi

echo ""
echo "4. Local Factory Skills (.agents/skills)"
SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.agents/skills"
EXPECTED_SKILLS=("new-feature" "code-structure" "unslop" "evidence-driven-testing" "before-and-after" "greploop" "greploop-apps")

for skill in "${EXPECTED_SKILLS[@]}"; do
  SKILL_PATH="$SKILLS_DIR/$skill/SKILL.md"
  if [ -f "$SKILL_PATH" ]; then
    echo "  [OK] Skill: $skill"
  else
    echo "  [MISSING] Skill file: $SKILL_PATH"
    FAILURES=$((FAILURES + 1))
  fi
done

echo ""
echo "========================================="
if [ "$FAILURES" -eq 0 ]; then
  echo "  Status: FACTORY READY (All required tools satisfied)"
else
  echo "  Status: $FAILURES issues detected"
fi
echo "========================================="
