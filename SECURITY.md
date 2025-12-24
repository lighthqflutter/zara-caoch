# 🔐 Security Guide - Protecting API Keys and Secrets

## ⚠️ CRITICAL: This repository is PUBLIC

**Never commit secrets, API keys, tokens, or credentials to this repository!**

---

## 🛡️ Protection Layers in Place

### Layer 1: `.gitignore` Protection
The following files are automatically ignored by git:
- `.env` and all `.env.*` files (except `.env.example`)
- `secrets/` directories
- Files matching `*secret*`, `*credentials*.json`, `*key*.json`
- `GoogleService-Info.plist`
- Service account JSON files

### Layer 2: Pre-Commit Hook
A git pre-commit hook automatically scans for:
- OpenAI API keys (`sk-...`)
- Google API keys (`AIza...`)
- GitHub tokens (`ghp_...`, `github_pat_...`)
- Hardcoded passwords, secrets, tokens
- Forbidden files like `.env`

**The hook will BLOCK your commit if secrets are detected!**

### Layer 3: Environment Variables
All secrets are stored in `.env` file which is:
- ✅ In `.gitignore` (never committed)
- ✅ Loaded via `flutter_dotenv` package
- ✅ Has a safe template (`.env.example`)

---

## 📋 Files That Contain Secrets

### ❌ NEVER COMMIT THESE:

| File | Contains | Status |
|------|----------|--------|
| `.env` | OpenAI API key | ✅ Protected by .gitignore |
| `ios/Runner/GoogleService-Info.plist` | Firebase config | ✅ Protected by .gitignore |
| Any `*credentials*.json` | Service account keys | ✅ Protected by .gitignore |

### ✅ SAFE TO COMMIT:

| File | Contains | Why Safe |
|------|----------|----------|
| `lib/firebase_options.dart` | Firebase client API keys | Public client keys (not secrets) |
| `.env.example` | Template with placeholders | No real values |
| `pubspec.yaml` | Package dependencies | No secrets |

---

## 🚀 Setting Up Your Environment

### First Time Setup:

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Add your real API keys to `.env`:**
   ```bash
   # DO NOT COMMIT THIS FILE!
   OPENAI_API_KEY=sk-your-real-key-here
   ```

3. **Verify .env is not tracked:**
   ```bash
   git status
   # .env should NOT appear in the output
   ```

4. **Test the pre-commit hook:**
   ```bash
   # Try to commit .env (should be blocked)
   git add .env
   git commit -m "test"
   # Hook should BLOCK this commit
   ```

---

## ✅ How to Add New Secrets Safely

### Step 1: Add to `.env` file
```bash
# In .env (NOT committed)
NEW_API_KEY=your-secret-value
ANOTHER_SECRET=another-value
```

### Step 2: Update `.env.example` with placeholder
```bash
# In .env.example (committed)
NEW_API_KEY=your_api_key_here
ANOTHER_SECRET=your_secret_here
```

### Step 3: Update `EnvConfig` class
```dart
// In lib/core/config/env_config.dart
static String get newApiKey {
  return dotenv.env['NEW_API_KEY'] ?? '';
}
```

### Step 4: Verify it's protected
```bash
# Check .gitignore includes pattern
grep -E "\.env$" .gitignore

# Verify .env is not tracked
git ls-files .env
# Should return nothing
```

---

## 🔍 How to Check for Exposed Secrets

### Before Pushing:
```bash
# Check what files are staged
git status

# Review changes to be committed
git diff --cached

# Check for common secret patterns
git diff --cached | grep -iE "(api_key|secret|password|token)"
```

### Check Git History:
```bash
# Search entire history for a specific string
git log -S "OPENAI_API_KEY" --all

# List all files ever committed
git log --all --full-history --diff-filter=D --summary | grep delete

# Check if .env was ever committed
git log --all --full-history -- .env
```

---

## 🚨 What to Do If You Accidentally Commit a Secret

### If you HAVEN'T pushed yet:
```bash
# Remove the file from staging
git reset HEAD <file-with-secret>

# Amend the last commit (if already committed locally)
git commit --amend
```

### If you HAVE pushed to GitHub:
1. **Immediately rotate/revoke the exposed key:**
   - OpenAI: https://platform.openai.com/api-keys
   - Firebase: Firebase Console → Project Settings
   - GitHub: Settings → Developer settings → Personal access tokens

2. **Remove from git history:**
   ```bash
   # Nuclear option - rewrite history (use with caution!)
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch .env" \
     --prune-empty --tag-name-filter cat -- --all

   # Force push (⚠️ WARNING: This rewrites history!)
   git push origin --force --all
   ```

3. **Better option - use BFG Repo-Cleaner:**
   ```bash
   # Install BFG
   brew install bfg

   # Remove secrets
   bfg --delete-files .env
   bfg --replace-text passwords.txt  # file with secrets to replace

   git reflog expire --expire=now --all
   git gc --prune=now --aggressive

   git push origin --force --all
   ```

4. **Report to GitHub:**
   - If it's a critical secret, contact GitHub support to purge cached copies

---

## 🧪 Testing the Protection

### Test 1: Try to commit .env
```bash
echo "OPENAI_API_KEY=sk-test123" > test-secret.env
git add test-secret.env
git commit -m "test"
# Expected: ❌ Blocked by pre-commit hook
rm test-secret.env
```

### Test 2: Try to commit hardcoded secret
```bash
echo "const apiKey = 'sk-real123456';" > test.dart
git add test.dart
git commit -m "test"
# Expected: ❌ Blocked by pre-commit hook
rm test.dart
```

### Test 3: Verify .env is ignored
```bash
git add .env
git status
# Expected: .env should NOT appear in "Changes to be committed"
```

---

## 📚 Best Practices

### ✅ DO:
- Store all secrets in `.env` file
- Use `EnvConfig.openAiApiKey` to access secrets
- Commit `.env.example` with placeholders
- Rotate API keys regularly
- Use different keys for development/production
- Review git diffs before committing

### ❌ DON'T:
- Hardcode API keys in source code
- Commit `.env` file
- Share your `.env` file
- Use `--no-verify` to bypass the pre-commit hook (unless absolutely necessary)
- Store secrets in comments or documentation
- Push secrets to any git repository (even private ones)

---

## 🔗 Resources

- [OpenAI API Keys](https://platform.openai.com/api-keys)
- [Firebase Console](https://console.firebase.google.com)
- [GitHub Personal Access Tokens](https://github.com/settings/tokens)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [Git Secrets Tool](https://github.com/awslabs/git-secrets)

---

## 📞 Questions?

If you're unsure whether something is safe to commit:
1. Check if it's in `.gitignore`
2. Run the pre-commit hook manually: `.git/hooks/pre-commit`
3. When in doubt, DON'T commit it - ask first!

---

**Remember: Once a secret is pushed to GitHub, assume it's compromised forever. Always rotate/revoke exposed secrets immediately!**

Last Updated: 2025-12-24
