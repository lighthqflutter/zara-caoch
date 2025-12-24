# TestFlight Submission Checklist

## ✅ Already Completed

### 1. Privacy Permissions (Info.plist)
- ✅ **NSCameraUsageDescription**: "Zara Coach needs camera access to take photos of your math work for review and feedback."
- ✅ **NSMicrophoneUsageDescription**: "Zara Coach needs microphone access for voice input during math practice sessions."
- ✅ **NSPhotoLibraryUsageDescription**: "Zara Coach needs photo library access to save and retrieve photos of your math work."
- ✅ **NSSpeechRecognitionUsageDescription**: "Zara Coach uses speech recognition to help you practice math problems with voice input."

### 2. App Configuration
- ✅ Bundle ID: `com.zaracoach.zaraCoach`
- ✅ Display Name: "Zara Coach"
- ✅ Version: 1.0.0+1

---

## 📋 Required Before TestFlight Upload

### 1. App Store Connect Setup
**Prerequisites:**
- [ ] Apple Developer Program membership ($99/year)
- [ ] Certificates, Identifiers & Profiles configured

**Steps:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps" → "+" → "New App"
3. Fill in:
   - **Platform**: iOS
   - **Name**: Zara Coach
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: com.zaracoach.zaraCoach (should be in dropdown)
   - **SKU**: zaracoach-001 (any unique identifier)
   - **User Access**: Full Access

### 2. App Information (Required)

#### Privacy Policy
**Status**: ⚠️ **REQUIRED**

Since the app collects data (photos, user progress), you NEED a privacy policy URL.

**Quick Options:**
1. **Use a privacy policy generator** (free):
   - [PrivacyPolicies.com](https://www.privacypolicies.com/privacy-policy-generator/)
   - [Termly](https://termly.io/products/privacy-policy-generator/)

2. **Host it on**:
   - GitHub Pages (free, fast)
   - Your website
   - Google Docs (set to public)

**What to include:**
- Data collected: Photos of student work, progress data, session history
- How it's used: Educational feedback, progress tracking
- Storage: Firebase (Google Cloud)
- Third parties: OpenAI (for AI feedback), Google ML Kit (for OCR)
- Data retention: As long as account exists
- User rights: Can request deletion
- Children's privacy: COPPA compliance (if under 13)

#### App Category
- **Primary Category**: Education
- **Secondary Category**: Productivity (optional)

#### Age Rating
- Go through questionnaire in App Store Connect
- Likely rating: **4+** (educational content)
- Note: Might be **9+** if collecting data from children

### 3. Export Compliance
**Required for App Store submission:**

The app uses HTTPS for network requests (Firebase, OpenAI). You'll need to declare:

- [ ] **Does your app use encryption?** → **YES**
- [ ] **Does your app qualify for exemption?** → **YES**
   - Standard encryption (HTTPS) → Qualifies for exemption
   - No proprietary encryption protocols
- [ ] **Upload**: No upload required for standard HTTPS

### 4. App Store Assets

#### App Icon
**Status**: ⚠️ **VERIFY REQUIRED**
- Required sizes: 1024x1024 (App Store), 180x180, 120x120, 87x87, etc.
- Check: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

#### Screenshots (for TestFlight metadata)
**Optional for TestFlight**, but recommended:
- iPad Pro (12.9"): 2048 x 2732 pixels (portrait) or 2732 x 2048 (landscape)
- Take 3-5 screenshots showing:
  1. Home screen
  2. Math practice
  3. English practice
  4. Parent dashboard
  5. Feedback screen

### 5. App Description (for App Store Connect)
```
Zara Coach - Personalized Learning Assistant

Help your child excel in math and English with AI-powered practice and feedback!

FEATURES:
• Math Practice (8 difficulty levels from Primary 4 to Secondary 2)
• English Practice (Reading Comprehension & Vocabulary)
• Photo Upload & OCR - Take pictures of handwritten work
• AI-Powered Feedback - Encouraging, personalized guidance
• Voice Guidance - Natural voice instructions
• Parent Dashboard - Track progress and performance
• Adaptive Learning - Adjusts difficulty based on performance

DESIGNED FOR:
Primary 4-6 and Secondary 1-2 students who want to improve their math and English skills with personalized, encouraging feedback.

PRIVACY:
Your child's data is secure. Photos and progress are stored privately and never shared. See our privacy policy for details.
```

---

## 🏗️ Build & Upload Process

### Method 1: Using Xcode (Recommended)

1. **Open Xcode Workspace**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Target**
   - Select "Runner" in the project navigator
   - Select "Any iOS Device (arm64)" as the destination

3. **Version & Build Number**
   - Verify in Xcode: Target → General → Identity
   - Version: 1.0.0
   - Build: 1

4. **Archive**
   - Menu: Product → Archive
   - Wait for archive to complete (2-5 minutes)

5. **Validate**
   - Organizer opens automatically after archive
   - Click "Distribute App"
   - Select "App Store Connect"
   - Select "Upload"
   - Click "Next" through options
   - **IMPORTANT**: Click "Validate" first before uploading
   - Fix any issues that appear

6. **Upload**
   - After validation passes, click "Upload"
   - Wait for upload to complete

### Method 2: Using Flutter Command

```bash
# Build the IPA file
flutter build ipa --release

# This creates: build/ios/ipa/zara_coach.ipa

# Then upload via Xcode Organizer or Transporter app
```

---

## 📱 After Upload to App Store Connect

### 1. Processing Time
- Apple processes the build: **5-30 minutes**
- Check status: App Store Connect → TestFlight → iOS Builds

### 2. Enable TestFlight
Once processing completes:
1. Go to App Store Connect → Your App → TestFlight
2. Select the build
3. Add "Test Information":
   - **What to Test**: "Initial MVP release. Test math practice, English exercises, OCR review, and parent dashboard."
   - **Test Notes**: (Optional) "Known issues: None"
4. Add yourself as internal tester
5. Click "Start Testing"

### 3. Beta Review (Optional)
- **Internal Testing**: No review needed, instant access
- **External Testing**: Requires Apple review (1-2 days)

---

## ⚠️ Common Validation Issues & Fixes

### 1. Missing Export Compliance
**Fix**: Add to `Info.plist`:
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```
(Only if you DON'T use custom encryption beyond standard HTTPS)

### 2. Missing Privacy Policy
**Fix**: Must provide URL before public release (not required for TestFlight)

### 3. Invalid Icon
**Fix**: Ensure app icon is:
- Exactly 1024x1024 pixels
- RGB color space (not CMYK)
- No alpha channel/transparency

### 4. Invalid Provisioning Profile
**Fix**: In Xcode:
- Select Runner target
- Signing & Capabilities
- Ensure "Automatically manage signing" is checked
- Team: Select your team

---

## 🎯 Quick Start Steps

**For your first TestFlight upload:**

1. ✅ **Verify Apple Developer membership is active**
2. ✅ **Create app in App Store Connect** (one-time setup)
3. ✅ **Create Privacy Policy** (can be simple, host on GitHub)
4. ✅ **Open Xcode** → `ios/Runner.xcworkspace`
5. ✅ **Product → Archive**
6. ✅ **Validate** → Fix any issues
7. ✅ **Upload** → Wait for processing
8. ✅ **Add yourself as tester** in App Store Connect
9. ✅ **Install TestFlight app** on iPad
10. ✅ **Accept invite** and test!

---

## 📞 Support

If you encounter issues:
- Apple Developer Forums: https://developer.apple.com/forums/
- App Store Connect Help: https://developer.apple.com/support/app-store-connect/

---

**Last Updated**: 2025-12-23
