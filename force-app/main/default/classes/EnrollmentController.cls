public with sharing class EnrollmentController {
    
    @AuraEnabled(cacheable=true)
    public static List<Course_Enrollment__c> getEnrollments() {
        try {
            return [
                SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
                       Student__r.Email__c, Course__c, Course__r.Name, 
                       Student_Name__c, Student_Email__c, CreatedDate,
                       Progress_Percentage__c, Status__c, Enrollment_Date__c, 
                       Completion_Date__c, Certificate_Issued__c
                FROM Course_Enrollment__c 
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving enrollments: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Course_Enrollment__c createEnrollment(String enrollmentData) {
        try {
            Map<String, Object> enrollmentMap = (Map<String, Object>) JSON.deserializeUntyped(enrollmentData);
            
            Course_Enrollment__c newEnrollment = new Course_Enrollment__c();
            newEnrollment.Student__c = (Id) enrollmentMap.get('Student__c');
            newEnrollment.Course__c = (Id) enrollmentMap.get('Course__c');
            
            insert newEnrollment;
            return newEnrollment;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating enrollment: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Course_Enrollment__c updateEnrollment(Id enrollmentId, String enrollmentData) {
        try {
            Map<String, Object> enrollmentMap = (Map<String, Object>) JSON.deserializeUntyped(enrollmentData);
            
            Course_Enrollment__c enrollmentToUpdate = [
                SELECT Id, Student__c, Course__c
                FROM Course_Enrollment__c 
                WHERE Id = :enrollmentId
                LIMIT 1
            ];
            
            enrollmentToUpdate.Student__c = (Id) enrollmentMap.get('Student__c');
            enrollmentToUpdate.Course__c = (Id) enrollmentMap.get('Course__c');
            
            update enrollmentToUpdate;
            return enrollmentToUpdate;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error updating enrollment: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteEnrollment(Id enrollmentId) {
        try {
            Course_Enrollment__c enrollmentToDelete = [
                SELECT Id FROM Course_Enrollment__c WHERE Id = :enrollmentId LIMIT 1
            ];
            delete enrollmentToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting enrollment: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Course_Enrollment__c> getEnrollmentsByStatus(String status) {
        try {
            return [
                SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
                       Student__r.Email__c, Course__c, Course__r.Name, CreatedDate,
                       Progress_Percentage__c, Status__c, Enrollment_Date__c, 
                       Completion_Date__c, Certificate_Issued__c
                FROM Course_Enrollment__c 
                WHERE Status__c = :status
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving enrollments by status: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Course_Enrollment__c> getEnrollmentsByClient(Id clientId) {
        try {
            return [
                SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
                       Student__r.Email__c, Course__c, Course__r.Name, CreatedDate,
                       Progress_Percentage__c, Status__c, Enrollment_Date__c, 
                       Completion_Date__c, Certificate_Issued__c
                FROM Course_Enrollment__c 
                WHERE Student__r.Corporate_Client__c = :clientId
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving enrollments by client: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Course_Enrollment__c> getEnrollmentsByStudent(Id studentId) {
        try {
            return [
                SELECT Id, Name, Student__c, Student__r.First_Name__c, Student__r.Last_Name__c, 
                       Student__r.Email__c, Course__c, Course__r.Name, CreatedDate,
                       Progress_Percentage__c, Status__c, Enrollment_Date__c, 
                       Completion_Date__c, Certificate_Issued__c
                FROM Course_Enrollment__c 
                WHERE Student__c = :studentId
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving enrollments by student: ' + e.getMessage());
        }
    }
}
