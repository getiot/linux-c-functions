#!/bin/bash

DEPLOY_BRANCH="deploy"

echo "Copying new build files..."
cp -R build/html/* ./

echo "Committing changes..."
git add .
git commit -m "Deploy Sphinx documentation $(date)"

echo "Pushing to remote repository..."
git push origin "$DEPLOY_BRANCH"
git push gitee "$DEPLOY_BRANCH"

echo "Deployment complete!"
