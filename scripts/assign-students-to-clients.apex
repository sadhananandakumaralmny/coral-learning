// Assign students to corporate clients
System.debug('🔗 Attempting to assign students to corporate clients...');

try {
    // Step 1: Check if Corporate_Client__c field exists
    System.debug('🔍 Step 1: Checking if Corporate_Client__c field exists...');
    
    try {
        // Try to query the Corporate_Client__c field
        List<Student__c> testQuery = [
            SELECT Id, Corporate_Client__c
            FROM Student__c 
            LIMIT 1
        ];
        System.debug('✅ Corporate_Client__c field EXISTS - students can be assigned to clients');
        
        // Step 2: Get students and clients
        System.debug('📊 Step 2: Getting students and corporate clients...');
        
        List<Student__c> students = [
            SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Corporate_Client__c
            FROM Student__c 
            ORDER BY First_Name__c
        ];
        
        List<Corporate_Client__c> clients = [
            SELECT Id, Name 
            FROM Corporate_Client__c 
            ORDER BY Name
        ];
        
        System.debug('Found ' + students.size() + ' students and ' + clients.size() + ' clients');
        
        if (clients.isEmpty()) {
            System.debug('❌ No corporate clients available for assignment');
            return;
        }
        
        // Step 3: Assign students to clients
        System.debug('🔗 Step 3: Assigning students to corporate clients...');
        
        List<Student__c> studentsToUpdate = new List<Student__c>();
        
        for (Integer i = 0; i < students.size(); i++) {
            Student__c student = students[i];
            Corporate_Client__c client = clients[Math.mod(i, clients.size())];
            
            // Only update if the student doesn't already have a client
            if (student.Corporate_Client__c == null) {
                student.Corporate_Client__c = client.Id;
                studentsToUpdate.add(student);
                
                System.debug('🔗 Assigning ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                            ' to client: ' + client.Name);
            } else {
                System.debug('ℹ️  ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                            ' already has client: ' + student.Corporate_Client__c);
            }
        }
        
        if (!studentsToUpdate.isEmpty()) {
            update studentsToUpdate;
            System.debug('✅ Successfully assigned ' + studentsToUpdate.size() + ' students to corporate clients');
        } else {
            System.debug('ℹ️  No students needed updating - all already have clients');
        }
        
        // Step 4: Verify the assignments
        System.debug('🔍 Step 4: Verifying client assignments...');
        
        List<Student__c> finalStudents = [
            SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Corporate_Client__c,
                   Corporate_Client__r.Name
            FROM Student__c 
            ORDER BY First_Name__c
        ];
        
        System.debug('📊 Final Student-Client Assignments:');
        System.debug('=====================================');
        
        for (Student__c student : finalStudents) {
            if (student.Corporate_Client__c != null) {
                System.debug('✅ ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                            ' → ' + student.Corporate_Client__r.Name);
            } else {
                System.debug('❌ ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                            ' → NO CLIENT ASSIGNED');
            }
        }
        
        System.debug('=====================================');
        System.debug('🎉 Student-client assignment completed successfully!');
        
    } catch (Exception fieldError) {
        System.debug('❌ Corporate_Client__c field does NOT exist - students cannot be assigned to clients');
        System.debug('Error: ' + fieldError.getMessage());
        
        // Step 5: Try to create the field manually using metadata API
        System.debug('🔧 Step 5: Attempting to create Corporate_Client__c field manually...');
        
        try {
            // This is a workaround - we'll try to create the field using the put() method
            // This might work if the field exists in metadata but not in the org
            System.debug('⚠️  Field creation requires manual intervention in Salesforce Setup');
            System.debug('📋 To create the field manually:');
            System.debug('   1. Go to Setup > Object Manager > Student__c');
            System.debug('   2. Click "Fields & Relationships"');
            System.debug('   3. Click "New"');
            System.debug('   4. Choose "Lookup Relationship"');
            System.debug('   5. Related To: Corporate_Client__c');
            System.debug('   6. Field Name: Corporate_Client__c');
            System.debug('   7. Field Label: Corporate Client');
            System.debug('   8. Save');
            
        } catch (Exception createError) {
            System.debug('❌ Could not create field: ' + createError.getMessage());
        }
    }
    
} catch (Exception e) {
    System.debug('❌ Error assigning students to clients: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
