# Coral Learning - Salesforce Application

A comprehensive corporate learning management system built on Salesforce with AI-powered insights and modern UI components.

## 🚀 Features

- **Custom Learning Courses Management** - Create, track, and manage corporate training courses
- **Corporate Client Management** - Manage client relationships and training programs
- **AI Insights Dashboard** - Get intelligent insights into learning patterns and performance
- **Modern Lightning Web Components** - Beautiful, responsive UI built with LWC
- **Custom App with Logo** - Professional branding with custom application header

## 🏗️ Architecture

- **Custom Objects**: Learning_Course__c, Corporate_Client__c, AI_Insights__c
- **Lightning Web Components**: coralAppHeader, coralLearningCourses, coralCorporateClients, coralAIInsights
- **Custom Application**: CoralLearning with custom tabs and navigation
- **Flexipages**: Custom home page layout with header and main content

## 📋 Prerequisites

- Salesforce CLI (sfdx) installed
- Access to a Salesforce org (Developer, Sandbox, or Production)
- Node.js and npm (for development)

## 🚀 Quick Deployment

### Option 1: Automated Deployment Script

1. **Update the org alias** in `scripts/deploy-coral-learning.sh`:
   ```bash
   ORG_ALIAS="your-org-alias"
   ```

2. **Run the deployment script**:
   ```bash
   ./scripts/deploy-coral-learning.sh
   ```

### Option 2: Manual Deployment

1. **Authenticate with your org**:
   ```bash
   sfdx force:auth:web:login -a your-org-alias
   ```

2. **Deploy all components**:
   ```bash
   sfdx force:source:deploy -p force-app/main/default/ -u your-org-alias
   ```

3. **Assign permission set**:
   ```bash
   sfdx force:user:permset:assign -n CoralLearningUser -u your-org-alias
   ```

4. **Open your org**:
   ```bash
   sfdx force:org:open -u your-org-alias
   ```

## 🔧 Configuration

### Custom App Setup
- The app is configured with three custom tabs: Learning Courses, Corporate Clients, and AI Insights
- Custom logo is integrated into the app header
- Modern gradient design with professional styling

### Permission Set
- `CoralLearningUser` permission set provides access to all custom objects and tabs
- Make sure to assign this permission set to users who need access

### Logo Integration
- Logo file: `coralLearningLogo.resource`
- Automatically displayed in the app header
- Responsive design for mobile and desktop

## 📱 Using the Application

1. **Launch the App**: Look for "Coral Learning" in your Salesforce App Launcher
2. **Navigate Tabs**: Use the custom tabs to access different features
3. **Create Content**: Start by creating learning courses and corporate clients
4. **View Insights**: Check the AI Insights tab for intelligent analytics

## 🛠️ Development

### Project Structure
```
force-app/main/default/
├── applications/          # Custom app configuration
├── lwc/                  # Lightning Web Components
├── objects/              # Custom objects and fields
├── tabs/                 # Custom tabs
├── flexipages/           # Custom page layouts
├── permissionsets/       # Permission sets
└── staticresources/      # Logo and other assets
```

### Making Changes
1. Edit the component files in the `lwc/` directory
2. Update metadata files as needed
3. Deploy changes using the deployment script
4. Test in your org

## 🐛 Troubleshooting

### Tabs Not Visible
- Ensure the `CoralLearningUser` permission set is assigned to your user
- Check that the custom app is visible in your profile
- Verify tab permissions in the permission set

### Logo Not Displaying
- Confirm the static resource is deployed
- Check the component's logo URL reference
- Verify the resource metadata file

### Deployment Issues
- Check Salesforce CLI authentication
- Verify org access and permissions
- Review deployment error messages

## 📞 Support

For issues or questions:
1. Check the deployment logs
2. Verify Salesforce org permissions
3. Review component metadata files

## 📄 License

This project is part of the Coral Learning platform and follows Salesforce development best practices.
