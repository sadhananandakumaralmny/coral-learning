public with sharing class LearningCourseController {
    
    @AuraEnabled(cacheable=true)
    public static List<Learning_Course__c> getLearningCourses() {
        try {
            return [
                SELECT Id, Name, Course_Description__c, Course_Duration__c, Course_Level__c, Course_Status__c, CreatedDate
                FROM Learning_Course__c 
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving learning courses: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Learning_Course__c createLearningCourse(String courseData) {
        try {
            Map<String, Object> courseMap = (Map<String, Object>) JSON.deserializeUntyped(courseData);
            
            Learning_Course__c newCourse = new Learning_Course__c();
            // Note: Name field is auto-number, so we don't set it
            newCourse.Course_Description__c = (String) courseMap.get('Course_Description__c');
            newCourse.Course_Duration__c = courseMap.get('Course_Duration__c') != null ? 
                Decimal.valueOf(String.valueOf(courseMap.get('Course_Duration__c'))) : null;
            newCourse.Course_Level__c = (String) courseMap.get('Course_Level__c');
            newCourse.Course_Status__c = (String) courseMap.get('Course_Status__c');
            
            insert newCourse;
            return newCourse;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating learning course: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Learning_Course__c updateLearningCourse(Id courseId, String courseData) {
        try {
            Map<String, Object> courseMap = (Map<String, Object>) JSON.deserializeUntyped(courseData);
            
            Learning_Course__c courseToUpdate = [
                SELECT Id, Name, Course_Description__c, Course_Duration__c, Course_Level__c, Course_Status__c
                FROM Learning_Course__c 
                WHERE Id = :courseId
                LIMIT 1
            ];
            
            // Note: Name field is auto-number, so we don't update it
            courseToUpdate.Course_Description__c = (String) courseMap.get('Course_Description__c');
            courseToUpdate.Course_Duration__c = courseMap.get('Course_Duration__c') != null ? 
                Decimal.valueOf(String.valueOf(courseMap.get('Course_Duration__c'))) : null;
            courseToUpdate.Course_Level__c = (String) courseMap.get('Course_Level__c');
            courseToUpdate.Course_Status__c = (String) courseMap.get('Course_Status__c');
            
            update courseToUpdate;
            return courseToUpdate;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error updating learning course: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteLearningCourse(Id courseId) {
        try {
            Learning_Course__c courseToDelete = [
                SELECT Id FROM Learning_Course__c WHERE Id = :courseId LIMIT 1
            ];
            delete courseToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting learning course: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Learning_Course__c> getCoursesByStatus(String status) {
        try {
            return [
                SELECT Id, Name, Course_Description__c, Course_Duration__c, Course_Level__c, Course_Status__c, CreatedDate
                FROM Learning_Course__c 
                WHERE Course_Status__c = :status
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving courses by status: ' + e.getMessage());
        }
    }
}
