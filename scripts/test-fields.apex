// Test script to check available fields and create a basic course
// Run this in Developer Console or via SFDX

// First, let's see what fields are available
Schema.SObjectType courseType = Schema.getGlobalDescribe().get('Learning_Course__c');
if (courseType != null) {
    Schema.DescribeSObjectResult courseDescribe = courseType.getDescribe();
    Map<String, Schema.SObjectField> fieldMap = courseDescribe.fields.getMap();
    
    System.debug('Available fields on Learning_Course__c:');
    for (String fieldName : fieldMap.keySet()) {
        Schema.SObjectField field = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('Field: ' + fieldName + ' - Type: ' + fieldDescribe.getType() + ' - Label: ' + fieldDescribe.getLabel());
    }
    
    // Try to create a simple course with just the basic fields
    try {
        Learning_Course__c testCourse = new Learning_Course__c(
            Course_Status__c = 'Active'
        );
        
        insert testCourse;
        System.debug('Successfully created test course with ID: ' + testCourse.Id);
        System.debug('Auto-generated Name: ' + testCourse.Name);
        
        // Now let's try to update it with more fields
        testCourse.Course_Status__c = 'Draft';
        update testCourse;
        System.debug('Successfully updated course status to: ' + testCourse.Course_Status__c);
        
    } catch (Exception e) {
        System.debug('Error creating/updating course: ' + e.getMessage());
        System.debug('Stack trace: ' + e.getStackTraceString());
    }
} else {
    System.debug('Learning_Course__c object not found!');
}
