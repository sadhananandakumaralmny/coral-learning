#!/bin/bash

echo "🚀 Deploying Coral Learning Application to Salesforce..."

# Set your Salesforce org alias (change this to match your org)
ORG_ALIAS="coral-learning"

# Deploy the application and all components
echo "📦 Deploying application components..."
sfdx force:source:deploy -p force-app/main/default/ -u $ORG_ALIAS

# Assign the permission set to your user (replace with your username)
echo "🔐 Assigning permission set..."
sfdx force:user:permset:assign -n CoralLearningUser -u $ORG_ALIAS

# Open the org to verify the deployment
echo "🌐 Opening org to verify deployment..."
sfdx force:org:open -u $ORG_ALIAS

echo "✅ Deployment complete! Check your org to see the Coral Learning app with tabs and logo."
echo "📱 Make sure to assign the 'Coral Learning User' permission set to users who need access."
