public with sharing class StudentController {
    
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents() {
        try {
            return [
                SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c,
                       Corporate_Client__c, Corporate_Client__r.Name, Department__c,
                       Job_Title__c, Status__c, CreatedDate
                FROM Student__c 
                ORDER BY Last_Name__c ASC, First_Name__c ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving students: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudentsByClient(Id clientId) {
        try {
            return [
                SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c,
                       Corporate_Client__c, Corporate_Client__r.Name, Department__c,
                       Job_Title__c, Status__c, CreatedDate
                FROM Student__c 
                WHERE Corporate_Client__c = :clientId
                ORDER BY Last_Name__c ASC, First_Name__c ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving students by client: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudentsByStatus(String status) {
        try {
            return [
                SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c,
                       Corporate_Client__c, Corporate_Client__r.Name, Department__c,
                       Job_Title__c, Status__c, CreatedDate
                FROM Student__c 
                WHERE Status__c = :status
                ORDER BY Last_Name__c ASC, First_Name__c ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving students by status: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Student__c createStudent(Student__c student) {
        try {
            // Validate required fields
            if (String.isBlank(student.First_Name__c) || String.isBlank(student.Last_Name__c) || String.isBlank(student.Email__c)) {
                throw new AuraHandledException('First Name, Last Name, and Email are required fields.');
            }
            
            // Check for duplicate email
            List<Student__c> existingStudents = [
                SELECT Id FROM Student__c 
                WHERE Email__c = :student.Email__c
            ];
            
            if (!existingStudents.isEmpty()) {
                throw new AuraHandledException('A student with this email already exists.');
            }
            
            insert student;
            return student;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating student: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Student__c updateStudent(Student__c student) {
        try {
            // Validate required fields
            if (String.isBlank(student.First_Name__c) || String.isBlank(student.Last_Name__c) || String.isBlank(student.Email__c)) {
                throw new AuraHandledException('First Name, Last Name, and Email are required fields.');
            }
            
            // Check for duplicate email (excluding current student)
            List<Student__c> existingStudents = [
                SELECT Id FROM Student__c 
                WHERE Email__c = :student.Email__c AND Id != :student.Id
            ];
            
            if (!existingStudents.isEmpty()) {
                throw new AuraHandledException('A student with this email already exists.');
            }
            
            update student;
            return student;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating student: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteStudent(Id studentId) {
        try {
            Student__c studentToDelete = [SELECT Id FROM Student__c WHERE Id = :studentId];
            delete studentToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting student: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Student__c getStudentById(Id studentId) {
        try {
            return [
                SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c,
                       Corporate_Client__c, Corporate_Client__r.Name, Department__c,
                       Job_Title__c, Status__c, CreatedDate
                FROM Student__c 
                WHERE Id = :studentId
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving student: ' + e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Student__c> searchStudents(String searchTerm) {
        try {
            if (String.isBlank(searchTerm)) {
                return getStudents();
            }
            
            String searchPattern = '%' + searchTerm + '%';
            
            return [
                SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c,
                       Corporate_Client__c, Corporate_Client__r.Name, Department__c,
                       Job_Title__c, Status__c, CreatedDate
                FROM Student__c 
                WHERE First_Name__c LIKE :searchPattern 
                   OR Last_Name__c LIKE :searchPattern 
                   OR Email__c LIKE :searchPattern
                   OR Department__c LIKE :searchPattern
                   OR Job_Title__c LIKE :searchPattern
                ORDER BY Last_Name__c ASC, First_Name__c ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error searching students: ' + e.getMessage());
        }
    }
}
