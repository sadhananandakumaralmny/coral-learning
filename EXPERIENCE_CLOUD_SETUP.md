# 🐠 Coral Learning Experience Cloud Student Portal

## Overview
This Experience Cloud site provides students with a customer-facing portal to view their course enrollments, track progress, and manage their learning journey.

## 🚀 Features

### Student Dashboard
- **Welcome Section**: Personalized greeting with student name
- **Statistics Cards**: 
  - Total Enrollments
  - In Progress Courses
  - Completed Courses
  - Average Progress
- **Course Enrollments List**: 
  - Course details and descriptions
  - Progress tracking with visual progress bars
  - Enrollment dates and status
  - Course completion information

### User Experience
- **Responsive Design**: Mobile-friendly interface
- **Modern UI**: Clean, professional appearance using Salesforce Lightning Design System
- **Intuitive Navigation**: Easy-to-use interface for students
- **Progress Visualization**: Visual progress bars and status indicators

## 🏗️ Architecture

### Components Created
1. **Experience Cloud Site**: `CoralLearningStudentPortal.site-meta.xml`
2. **Community Configuration**: `CoralLearningStudentPortal.community-meta.xml`
3. **Network Member Groups**: `Student.networkMemberGroup-meta.xml`
4. **Apex Controller**: `StudentPortalController.cls`
5. **Visualforce Pages**:
   - `student_dashboard.page` - Main dashboard
   - `login.page` - Login interface
   - `change_password.page` - Password management
   - `exception.page` - Error handling
   - `file_not_found.page` - 404 page
   - `in_maintenance.page` - Maintenance mode
   - `server_is_down.page` - Server issues
   - `bandwidth_exceeded.page` - Bandwidth limits

## 📋 Prerequisites

### Salesforce Org Requirements
- Experience Cloud enabled
- Custom objects: `Student__c`, `Course_Enrollment__c`, `Learning_Course__c`
- User profiles with appropriate permissions
- Contact records linked to User records for students

### Data Model
The portal expects the following data structure:
- **Students**: Users with Contact records linked to Student__c records
- **Course Enrollments**: Records linking students to courses with progress tracking
- **Learning Courses**: Course definitions and metadata

## 🛠️ Setup Instructions

### Step 1: Deploy Components
```bash
# Deploy all components to your org
sf project deploy start --source-dir force-app/main/default -o your-org-alias
```

### Step 2: Configure Experience Cloud
1. **Go to Setup** → **Digital Experiences** → **All Sites**
2. **Create New Site** using the deployed site configuration
3. **Activate the Site** and note the URL

### Step 3: Configure Community
1. **Go to Setup** → **Digital Experiences** → **All Communities**
2. **Create New Community** using the deployed community configuration
3. **Link the Community** to the created site

### Step 4: Set Up User Access
1. **Create Student Profile** with appropriate permissions
2. **Assign Users** to the Student profile
3. **Link User Records** to Contact records
4. **Create Student__c Records** for each student user

### Step 5: Configure Network Member Groups
1. **Go to Setup** → **Digital Experiences** → **Manage** → **Members**
2. **Create Member Groups** for different user types
3. **Assign Users** to appropriate member groups

## 🔐 Authentication & Security

### User Access
- **Self-Registration**: Disabled (users must be created by administrators)
- **Authentication**: Standard Salesforce authentication
- **Guest Access**: Disabled for security

### Data Security
- **Sharing Rules**: Enforced through Apex controller
- **Field-Level Security**: Controlled through profiles
- **Record Access**: Students can only see their own enrollments

## 📱 User Experience

### Student Journey
1. **Login**: Students access the portal with their Salesforce credentials
2. **Dashboard**: View personalized statistics and course overview
3. **Course Details**: Click on enrollments to see detailed progress
4. **Progress Tracking**: Monitor completion status and achievements

### Mobile Experience
- **Responsive Design**: Automatically adapts to different screen sizes
- **Touch-Friendly**: Optimized for mobile devices
- **Fast Loading**: Efficient data loading and caching

## 🎨 Customization

### Branding
- **Logo**: Update the 🐠 emoji and "Coral Learning" text
- **Colors**: Modify CSS variables for brand colors
- **Typography**: Adjust font families and sizes

### Layout
- **Grid System**: Modify the statistics grid layout
- **Card Design**: Customize enrollment card appearance
- **Navigation**: Add additional navigation elements

### Functionality
- **Additional Fields**: Extend the enrollment display
- **Actions**: Add course-specific actions (download materials, etc.)
- **Notifications**: Implement progress notifications

## 🚨 Troubleshooting

### Common Issues

#### Site Not Accessible
- Verify site is activated
- Check user permissions and profiles
- Ensure community is properly linked

#### Data Not Displaying
- Verify Student__c records exist and are linked to Users
- Check Course_Enrollment__c data and relationships
- Review Apex controller error logs

#### Authentication Issues
- Confirm user has correct profile
- Verify Contact record linkage
- Check network member group assignments

### Debug Mode
Enable debug logging for the `StudentPortalController` class to troubleshoot issues.

## 📈 Future Enhancements

### Planned Features
- **Course Search**: Find and enroll in new courses
- **Progress Certificates**: Download completion certificates
- **Discussion Forums**: Student collaboration spaces
- **Mobile App**: Native mobile application
- **Integration**: LMS and content management system integration

### Performance Optimizations
- **Data Caching**: Implement client-side caching
- **Lazy Loading**: Progressive data loading
- **CDN Integration**: Content delivery network optimization

## 📞 Support

For technical support or questions about the Experience Cloud portal:
- **Documentation**: Review this README and Salesforce documentation
- **Community**: Check Salesforce Trailblazer Community
- **Developer Support**: Contact the development team

## 📄 License

This project is proprietary to Coral Learning. All rights reserved.

---

**Last Updated**: December 2024
**Version**: 1.0.0
**Compatibility**: Salesforce API 58.0+
