// Fix Course Names Script for Coral Learning
// This script will update existing learning courses with proper names
// Run this in Developer Console or via SFDX

// First, let's see what courses exist
List<Learning_Course__c> existingCourses = [
    SELECT Id, Name, Course_Description__c, Course_Level__c, Course_Status__c
    FROM Learning_Course__c 
    LIMIT 100
];

System.debug('Found ' + existingCourses.size() + ' existing courses');

// Update course names based on their descriptions or create new ones
for(Learning_Course__c course : existingCourses) {
    // If the course has a description, use it as the name
    if(String.isNotBlank(course.Course_Description__c)) {
        course.Name = course.Course_Description__c;
    } else {
        // Generate a meaningful name based on level and status
        String level = String.isNotBlank(course.Course_Level__c) ? course.Course_Level__c : 'General';
        String status = String.isNotBlank(course.Course_Status__c) ? course.Course_Status__c : 'Active';
        course.Name = level + ' Learning Course (' + status + ')';
    }
}

// Update the courses
try {
    update existingCourses;
    System.debug('Successfully updated ' + existingCourses.size() + ' course names');
    
    // Display the updated courses
    for(Learning_Course__c course : existingCourses) {
        System.debug('Course ID: ' + course.Id + ', Name: ' + course.Name);
    }
} catch (Exception e) {
    System.debug('Error updating courses: ' + e.getMessage());
}

// If no courses exist, create some sample ones
if(existingCourses.isEmpty()) {
    System.debug('No existing courses found. Creating sample courses...');
    
    List<Learning_Course__c> newCourses = new List<Learning_Course__c>();
    
    Learning_Course__c course1 = new Learning_Course__c(
        Name = 'Introduction to Salesforce Development',
        Course_Description__c = 'Learn the fundamentals of Salesforce development including Apex, Lightning, and declarative development.',
        Course_Duration__c = 8.0,
        Course_Level__c = 'Beginner',
        Course_Status__c = 'Active'
    );
    newCourses.add(course1);
    
    Learning_Course__c course2 = new Learning_Course__c(
        Name = 'Advanced Apex Programming',
        Course_Description__c = 'Master advanced Apex concepts including triggers, batch processing, and complex business logic.',
        Course_Duration__c = 12.0,
        Course_Level__c = 'Advanced',
        Course_Status__c = 'Active'
    );
    newCourses.add(course2);
    
    Learning_Course__c course3 = new Learning_Course__c(
        Name = 'Lightning Web Components Fundamentals',
        Course_Description__c = 'Build modern, responsive user interfaces using Lightning Web Components and JavaScript.',
        Course_Duration__c = 6.0,
        Course_Level__c = 'Intermediate',
        Course_Status__c = 'Active'
    );
    newCourses.add(course3);
    
    Learning_Course__c course4 = new Learning_Course__c(
        Name = 'Salesforce Integration Patterns',
        Course_Description__c = 'Explore various integration patterns and best practices for connecting Salesforce with external systems.',
        Course_Duration__c = 10.0,
        Course_Level__c = 'Expert',
        Course_Status__c = 'Draft'
    );
    newCourses.add(course4);
    
    try {
        insert newCourses;
        System.debug('Successfully created ' + newCourses.size() + ' new learning courses');
    } catch (Exception e) {
        System.debug('Error creating new courses: ' + e.getMessage());
    }
}

System.debug('Course name fix script completed!');
