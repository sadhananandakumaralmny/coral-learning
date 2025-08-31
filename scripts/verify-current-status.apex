// Verify current status after data recreation
System.debug('🔍 Verifying current data status...');

try {
    // Check all objects
    Integer totalStudents = [SELECT COUNT() FROM Student__c];
    Integer totalClients = [SELECT COUNT() FROM Corporate_Client__c];
    Integer totalCourses = [SELECT COUNT() FROM Learning_Course__c];
    Integer totalEnrollments = [SELECT COUNT() FROM Course_Enrollment__c];
    
    System.debug('📊 Current Data Status:');
    System.debug('=====================================');
    System.debug('Total Students: ' + totalStudents);
    System.debug('Total Corporate Clients: ' + totalClients);
    System.debug('Total Learning Courses: ' + totalCourses);
    System.debug('Total Course Enrollments: ' + totalEnrollments);
    System.debug('=====================================');
    
    if (totalStudents > 0) {
        System.debug('👥 Student Details:');
        List<Student__c> students = [
            SELECT Id, Name, First_Name__c, Last_Name__c, Email__c
            FROM Student__c 
            ORDER BY First_Name__c
        ];
        
        for (Student__c student : students) {
            System.debug('   - ' + student.First_Name__c + ' ' + student.Last_Name__c);
            System.debug('     Student ID: ' + student.Name);
            System.debug('     Email: ' + student.Email__c);
            System.debug('     ---');
        }
    }
    
    if (totalClients > 0) {
        System.debug('🏢 Corporate Client Details:');
        List<Corporate_Client__c> clients = [
            SELECT Id, Name
            FROM Corporate_Client__c 
            ORDER BY Name
        ];
        
        for (Corporate_Client__c client : clients) {
            System.debug('   - ' + client.Name + ' (ID: ' + client.Id + ')');
        }
    }
    
    if (totalCourses > 0) {
        System.debug('📚 Learning Course Details:');
        List<Learning_Course__c> courses = [
            SELECT Id, Name
            FROM Learning_Course__c 
            ORDER BY Name
        ];
        
        for (Learning_Course__c course : courses) {
            System.debug('   - ' + course.Name + ' (ID: ' + course.Id + ')');
        }
    }
    
    // Check if the Corporate_Client__c field exists on Student__c
    System.debug('🔍 Checking for Corporate_Client__c field on Student__c...');
    
    try {
        // Try to query the field to see if it exists
        List<Student__c> testQuery = [
            SELECT Id, Corporate_Client__c
            FROM Student__c 
            LIMIT 1
        ];
        System.debug('✅ Corporate_Client__c field EXISTS on Student__c object');
        
        // Check if any students have client assignments
        Integer studentsWithClients = [SELECT COUNT() FROM Student__c WHERE Corporate_Client__c != null];
        System.debug('Students with client assignments: ' + studentsWithClients);
        
        if (studentsWithClients > 0) {
            System.debug('🔗 Student-Client relationships found!');
        } else {
            System.debug('⚠️  No students are currently assigned to clients');
        }
        
    } catch (Exception fieldError) {
        System.debug('❌ Corporate_Client__c field does NOT exist on Student__c object');
        System.debug('Error: ' + fieldError.getMessage());
    }
    
    System.debug('=====================================');
    System.debug('✅ Data verification completed');
    
} catch (Exception e) {
    System.debug('❌ Error during verification: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
