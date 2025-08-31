// Script to populate existing learning courses with meaningful data
// Run this in Developer Console or via SFDX

// First, let's see what courses exist and update them
List<Learning_Course__c> existingCourses = [
    SELECT Id, Name, Course_Status__c
    FROM Learning_Course__c 
    ORDER BY Name
    LIMIT 100
];

System.debug('Found ' + existingCourses.size() + ' existing courses to update');

// Update each course with meaningful data
for(Learning_Course__c course : existingCourses) {
    // Set course description based on the course number
    if(course.Name == 'COURSE-0000') {
        course.Course_Description__c = 'Introduction to Salesforce Development - Learn the fundamentals of Salesforce development including Apex, Lightning, and declarative development.';
        course.Course_Duration__c = 8.0;
        course.Course_Level__c = 'Beginner';
    } else if(course.Name == 'COURSE-0001') {
        course.Course_Description__c = 'Advanced Apex Programming - Master advanced Apex concepts including triggers, batch processing, and complex business logic.';
        course.Course_Duration__c = 12.0;
        course.Course_Level__c = 'Advanced';
    } else if(course.Name == 'COURSE-0002') {
        course.Course_Description__c = 'Lightning Web Components Fundamentals - Build modern, responsive user interfaces using Lightning Web Components and JavaScript.';
        course.Course_Duration__c = 6.0;
        course.Course_Level__c = 'Intermediate';
    } else if(course.Name == 'COURSE-0003') {
        course.Course_Description__c = 'Salesforce Integration Patterns - Explore various integration patterns and best practices for connecting Salesforce with external systems.';
        course.Course_Duration__c = 10.0;
        course.Course_Level__c = 'Expert';
    } else if(course.Name == 'COURSE-0004') {
        course.Course_Description__c = 'Data Management and Analytics - Learn how to effectively manage data, create reports, and build dashboards in Salesforce.';
        course.Course_Duration__c = 7.0;
        course.Course_Level__c = 'Intermediate';
    } else if(course.Name == 'COURSE-0005') {
        course.Course_Description__c = 'Sales Cloud Implementation - Master the implementation and configuration of Salesforce Sales Cloud for your organization.';
        course.Course_Duration__c = 9.0;
        course.Course_Level__c = 'Advanced';
    } else if(course.Name == 'COURSE-0009') {
        course.Course_Description__c = 'Service Cloud Best Practices - Implement and optimize Service Cloud to deliver exceptional customer service experiences.';
        course.Course_Duration__c = 8.5;
        course.Course_Level__c = 'Advanced';
    } else {
        // For any other courses, provide generic but meaningful data
        course.Course_Description__c = 'Comprehensive Salesforce Training Course - Covering essential concepts and practical applications for Salesforce professionals.';
        course.Course_Duration__c = 6.0;
        course.Course_Level__c = 'Intermediate';
    }
}

// Update the courses
try {
    update existingCourses;
    System.debug('Successfully updated ' + existingCourses.size() + ' courses with meaningful data');
    
    // Display the updated courses
    for(Learning_Course__c course : existingCourses) {
        System.debug('Course: ' + course.Name + ' - Description: ' + course.Course_Description__c + ' - Duration: ' + course.Course_Duration__c + ' - Level: ' + course.Course_Level__c);
    }
} catch (Exception e) {
    System.debug('Error updating courses: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Course data population script completed!');
