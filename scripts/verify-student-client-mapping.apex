// Verify Student-Client Mapping Status
System.debug('🔍 Checking Student-Client Mapping Status...');

try {
    // Check total counts
    Integer totalStudents = [SELECT COUNT() FROM Student__c];
    Integer totalClients = [SELECT COUNT() FROM Corporate_Client__c];
    Integer studentsWithClients = [SELECT COUNT() FROM Student__c WHERE Corporate_Client__c != null];
    Integer studentsWithoutClients = [SELECT COUNT() FROM Student__c WHERE Corporate_Client__c = null];
    
    System.debug('📊 Current Status:');
    System.debug('Total Students: ' + totalStudents);
    System.debug('Total Corporate Clients: ' + totalClients);
    System.debug('Students with Client Assignment: ' + studentsWithClients);
    System.debug('Students without Client Assignment: ' + studentsWithoutClients);
    
    if (totalStudents > 0 && totalClients > 0) {
        System.debug('✅ Data exists for both students and clients');
        
        if (studentsWithClients > 0) {
            System.debug('✅ Student-Client mapping is working!');
            
            // Show sample mappings
            List<Student__c> sampleMappings = [
                SELECT First_Name__c, Last_Name__c, Department__c,
                       Corporate_Client__c, Corporate_Client__r.Company_Name__c, Corporate_Client__r.Company_Industry__c
                FROM Student__c 
                WHERE Corporate_Client__c != null
                LIMIT 5
            ];
            
            System.debug('🔗 Sample Student-Client Mappings:');
            for (Student__c student : sampleMappings) {
                System.debug('   👤 ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                            ' (' + student.Department__c + ') → ' + 
                            student.Corporate_Client__r.Company_Name__c + 
                            ' (' + student.Corporate_Client__r.Company_Industry__c + ')');
            }
        } else {
            System.debug('⚠️  No students are currently mapped to clients');
            System.debug('💡 Run the setup script to create mappings');
        }
        
        // Check for students without departments
        List<Student__c> studentsWithoutDept = [
            SELECT Id, Name, First_Name__c, Last_Name__c, Department__c
            FROM Student__c 
            WHERE Department__c = null OR Department__c = ''
            LIMIT 5
        ];
        
        if (!studentsWithoutDept.isEmpty()) {
            System.debug('⚠️  Found students without department assignments:');
            for (Student__c student : studentsWithoutDept) {
                System.debug('   👤 ' + student.First_Name__c + ' ' + student.Last_Name__c + ' - Department: ' + student.Department__c);
            }
        } else {
            System.debug('✅ All students have department assignments');
        }
        
    } else {
        if (totalStudents == 0) {
            System.debug('❌ No students found - need to create student records first');
        }
        if (totalClients == 0) {
            System.debug('❌ No corporate clients found - need to create client records first');
        }
        System.debug('💡 Run the setup script to create sample data and mappings');
    }
    
    // Show field structure for debugging
    System.debug('🔍 Field Structure Check:');
    System.debug('Student__c.Department__c field type: ' + Student__c.Department__c.getDescribe().getType());
    System.debug('Student__c.Corporate_Client__c field type: ' + Student__c.Corporate_Client__c.getDescribe().getType());
    System.debug('Corporate_Client__c.Company_Name__c field type: ' + Corporate_Client__c.Company_Name__c.getDescribe().getType());
    
} catch (Exception e) {
    System.debug('❌ Error checking mapping status: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
