step by step build new app 

git tag v1.0.1
git push origin v1.0.1

##
git add .github/workflows/flutter_build.yml
git commit -m "Update artifact actions to v4"
git push origin main

💡 Summary of workflow:

Increment build number in pubspec.yaml.

Commit changes (git add, git commit).

Push to main branch (git push).

Create a new tag (git tag vX.Y.Z → git push origin vX.Y.Z).

GitHub Actions triggers, builds APK/AAB, and creates release.