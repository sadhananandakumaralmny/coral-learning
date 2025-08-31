// Create sample students for the Learning Management System
System.debug('Creating sample students...');

try {
    // First, let's get some corporate clients to assign students to
    List<Corporate_Client__c> clients = [
        SELECT Id, Name 
        FROM Corporate_Client__c 
        LIMIT 3
    ];
    
    if (clients.isEmpty()) {
        System.debug('No corporate clients found. Creating a sample client first...');
        
        Corporate_Client__c sampleClient = new Corporate_Client__c(
            Name = 'TechCorp Solutions'
        );
        insert sampleClient;
        clients.add(sampleClient);
        System.debug('Created sample client: ' + sampleClient.Name);
    }
    
    // Create sample students
    List<Student__c> students = new List<Student__c>();
    
    // Student 1
    students.add(new Student__c(
        First_Name__c = 'John',
        Last_Name__c = 'Smith',
        Email__c = 'john.smith@techcorp.com',
        Phone__c = '+1-555-0101',
        Corporate_Client__c = clients[0].Id,
        Department__c = 'Engineering',
        Job_Title__c = 'Software Developer',
        Status__c = 'Active'
    ));
    
    // Student 2
    students.add(new Student__c(
        First_Name__c = 'Sarah',
        Last_Name__c = 'Johnson',
        Email__c = 'sarah.johnson@techcorp.com',
        Phone__c = '+1-555-0102',
        Corporate_Client__c = clients[0].Id,
        Department__c = 'Product Management',
        Job_Title__c = 'Product Manager',
        Status__c = 'Active'
    ));
    
    // Student 3
    students.add(new Student__c(
        First_Name__c = 'Michael',
        Last_Name__c = 'Chen',
        Email__c = 'michael.chen@techcorp.com',
        Phone__c = '+1-555-0103',
        Corporate_Client__c = clients[0].Id,
        Department__c = 'Design',
        Job_Title__c = 'UX Designer',
        Status__c = 'Active'
    ));
    
    // Student 4 (if we have more clients)
    if (clients.size() > 1) {
        students.add(new Student__c(
            First_Name__c = 'Emily',
            Last_Name__c = 'Davis',
            Email__c = 'emily.davis@company.com',
            Phone__c = '+1-555-0104',
            Corporate_Client__c = clients[1].Id,
            Department__c = 'Marketing',
            Job_Title__c = 'Marketing Specialist',
            Status__c = 'Active'
        ));
    }
    
    // Student 5 (if we have more clients)
    if (clients.size() > 2) {
        students.add(new Student__c(
            First_Name__c = 'David',
            Last_Name__c = 'Wilson',
            Email__c = 'david.wilson@enterprise.com',
            Phone__c = '+1-555-0105',
            Corporate_Client__c = clients[2].Id,
            Department__c = 'Sales',
            Job_Title__c = 'Sales Representative',
            Status__c = 'Active'
        ));
    }
    
    // Insert all students
    insert students;
    
    System.debug('✅ Successfully created ' + students.size() + ' students:');
    for (Student__c student : students) {
        System.debug('  - ' + student.First_Name__c + ' ' + student.Last_Name__c + ' (' + student.Email__c + ')');
        System.debug('    Client: ' + student.Corporate_Client__c);
        System.debug('    Department: ' + student.Department__c);
        System.debug('    Job Title: ' + student.Job_Title__c);
        System.debug('    Status: ' + student.Status__c);
        System.debug('    Student ID: ' + student.Name);
        System.debug('    ---');
    }
    
} catch (Exception e) {
    System.debug('❌ Error creating students: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
