// Complete Student-Client Mapping Setup
// This script will create the full workflow for mapping students to corporate clients

System.debug('🚀 Starting Complete Student-Client Mapping Setup...');

try {
    // Step 1: Check and create corporate clients if needed
    System.debug('📋 Step 1: Setting up Corporate Clients...');
    
    List<Corporate_Client__c> existingClients = [
        SELECT Id, Name, Company_Name__c, Company_Industry__c, Company_Size__c, Contact_Person__c
        FROM Corporate_Client__c 
        LIMIT 10
    ];
    
    if (existingClients.isEmpty()) {
        System.debug('🏢 No corporate clients found. Creating sample clients...');
        
        List<Corporate_Client__c> newClients = new List<Corporate_Client__c>();
        
        // Create diverse sample clients
        newClients.add(new Corporate_Client__c(
            Company_Name__c = 'TechCorp Solutions',
            Company_Industry__c = 'Technology',
            Company_Size__c = '500-1000',
            Contact_Person__c = 'Sarah Johnson',
            Contact_Email__c = 'sarah.johnson@techcorp.com',
            Contact_Phone__c = '(555) 123-4567',
            Status__c = 'Active',
            Annual_Revenue__c = 50000000
        ));
        
        newClients.add(new Corporate_Client__c(
            Company_Name__c = 'Global Manufacturing Inc',
            Company_Industry__c = 'Manufacturing',
            Company_Size__c = '1000+',
            Contact_Person__c = 'Mike Chen',
            Contact_Email__c = 'mike.chen@globalmfg.com',
            Contact_Phone__c = '(555) 234-5678',
            Status__c = 'Active',
            Annual_Revenue__c = 75000000
        ));
        
        newClients.add(new Corporate_Client__c(
            Company_Name__c = 'Healthcare Partners',
            Company_Industry__c = 'Healthcare',
            Company_Size__c = '500-1000',
            Contact_Person__c = 'Dr. Emily Rodriguez',
            Contact_Email__c = 'emily.rodriguez@healthcare.com',
            Contact_Phone__c = '(555) 345-6789',
            Status__c = 'Active',
            Annual_Revenue__c = 30000000
        ));
        
        insert newClients;
        existingClients = newClients;
        System.debug('✅ Created ' + newClients.size() + ' new corporate clients');
        
        // Verify the clients were created with proper names
        for (Corporate_Client__c client : existingClients) {
            System.debug('   Created client: ' + client.Id + ' - Company_Name__c: ' + client.Company_Name__c);
        }
    } else {
        System.debug('✅ Found ' + existingClients.size() + ' existing corporate clients');
        for (Corporate_Client__c client : existingClients) {
            System.debug('   Existing client: ' + client.Id + ' - Company_Name__c: ' + client.Company_Name__c);
        }
    }
    
    // Step 2: Check and create students if needed
    System.debug('📋 Step 2: Setting up Students...');
    
    List<Student__c> existingStudents = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Department__c, Corporate_Client__c
        FROM Student__c 
        LIMIT 20
    ];
    
    if (existingStudents.isEmpty()) {
        System.debug('👥 No students found. Creating sample students...');
        
        List<Student__c> newStudents = new List<Student__c>();
        
        // Create sample students across different departments
        String[] departments = new String[]{'Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations'};
        String[] firstNames = new String[]{'Alex', 'Jordan', 'Casey', 'Taylor', 'Morgan', 'Riley', 'Quinn', 'Avery'};
        String[] lastNames = new String[]{'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis'};
        
        for (Integer i = 0; i < 15; i++) {
            String dept = departments[Math.mod(i, departments.size())];
            String firstName = firstNames[Math.mod(i, firstNames.size())];
            String lastName = lastNames[Math.mod(i, lastNames.size())];
            
            newStudents.add(new Student__c(
                First_Name__c = firstName,
                Last_Name__c = lastName,
                Department__c = dept,
                Email__c = firstName.toLowerCase() + '.' + lastName.toLowerCase() + '@company.com',
                Phone__c = '(555) ' + String.valueOf(100 + i) + '-' + String.valueOf(1000 + i),
                Status__c = 'Active'
            ));
        }
        
        insert newStudents;
        existingStudents = newStudents;
        System.debug('✅ Created ' + newStudents.size() + ' new students');
        
        // Verify the students were created with proper departments
        for (Student__c student : existingStudents) {
            System.debug('   Created student: ' + student.Id + ' - Department: ' + student.Department__c);
        }
    } else {
        System.debug('✅ Found ' + existingStudents.size() + ' existing students');
        for (Student__c student : existingStudents) {
            System.debug('   Existing student: ' + student.Id + ' - Department: ' + student.Department__c);
        }
    }
    
    // Step 3: Map students to corporate clients
    System.debug('📋 Step 3: Mapping Students to Corporate Clients...');
    
    List<Student__c> studentsToUpdate = new List<Student__c>();
    Integer clientIndex = 0;
    
    for (Student__c student : existingStudents) {
        if (student.Corporate_Client__c == null) {
            // Assign to next available client
            Corporate_Client__c assignedClient = existingClients[Math.mod(clientIndex, existingClients.size())];
            student.Corporate_Client__c = assignedClient.Id;
            studentsToUpdate.add(student);
            
            System.debug('🔗 Mapping: ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                        ' (Dept: ' + student.Department__c + ') → ' + assignedClient.Company_Name__c + 
                        ' (Industry: ' + assignedClient.Company_Industry__c + ')');
            
            clientIndex++;
        }
    }
    
    if (!studentsToUpdate.isEmpty()) {
        System.debug('🔄 Updating ' + studentsToUpdate.size() + ' students with client assignments...');
        update studentsToUpdate;
        System.debug('🎉 Successfully mapped ' + studentsToUpdate.size() + ' students to clients');
    } else {
        System.debug('✅ All students already have client assignments');
    }
    
    // Step 4: Verify the relationships
    System.debug('📋 Step 4: Verifying Student-Client Relationships...');
    
    List<Student__c> finalStudents = [
        SELECT Id, Name, First_Name__c, Last_Name__c, Department__c,
               Corporate_Client__c, Corporate_Client__r.Company_Name__c, Corporate_Client__r.Company_Industry__c,
               Corporate_Client__r.Company_Size__c
        FROM Student__c 
        ORDER BY Corporate_Client__r.Company_Name__c, First_Name__c
    ];
    
    System.debug('📊 Final Student-Client Mapping Summary:');
    System.debug('=====================================');
    
    Map<String, List<Student__c>> clientStudentMap = new Map<String, List<Student__c>>();
    
    for (Student__c student : finalStudents) {
        String clientName = student.Corporate_Client__r?.Company_Name__c != null ? 
                           student.Corporate_Client__r.Company_Name__c : 'No Client';
        
        if (!clientStudentMap.containsKey(clientName)) {
            clientStudentMap.put(clientName, new List<Student__c>());
        }
        clientStudentMap.get(clientName).add(student);
    }
    
    for (String clientName : clientStudentMap.keySet()) {
        List<Student__c> students = clientStudentMap.get(clientName);
        System.debug('🏢 ' + clientName + ' (' + students.size() + ' students):');
        
        for (Student__c student : students) {
            String clientIndustry = student.Corporate_Client__r?.Company_Industry__c != null ? 
                                   student.Corporate_Client__r.Company_Industry__c : 'N/A';
            System.debug('   👤 ' + student.First_Name__c + ' ' + student.Last_Name__c + 
                        ' - ' + student.Department__c + ' (Industry: ' + clientIndustry + ')');
        }
        System.debug('');
    }
    
    System.debug('🎯 Student-Client Mapping Setup Complete!');
    System.debug('Total Students: ' + finalStudents.size());
    System.debug('Total Clients: ' + existingClients.size());
    
    Integer studentsWithClients = 0;
    if (clientStudentMap.containsKey('No Client')) {
        studentsWithClients = finalStudents.size() - clientStudentMap.get('No Client').size();
    } else {
        studentsWithClients = finalStudents.size();
    }
    
    System.debug('Students with Clients: ' + studentsWithClients);
    
    // Final verification that fields are populated
    System.debug('🔍 Final Field Verification:');
    for (Student__c student : finalStudents.take(3)) { // Show first 3 students
        System.debug('   Student: ' + student.First_Name__c + ' ' + student.Last_Name__c);
        System.debug('     Department: ' + student.Department__c);
        System.debug('     Client ID: ' + student.Corporate_Client__c);
        System.debug('     Client Name: ' + student.Corporate_Client__r?.Company_Name__c);
    }
    
} catch (Exception e) {
    System.debug('❌ Error in Student-Client Mapping Setup: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
