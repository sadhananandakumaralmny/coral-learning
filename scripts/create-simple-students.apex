// Create simple students without requiring existing corporate clients
System.debug('Creating simple students...');

try {
    // Create sample students without corporate client assignment for now
    List<Student__c> students = new List<Student__c>();
    
    // Student 1
    students.add(new Student__c(
        First_Name__c = 'John',
        Last_Name__c = 'Smith',
        Email__c = 'john.smith@example.com',
        Phone__c = '+1-555-0101',
        Department__c = 'Engineering',
        Job_Title__c = 'Software Developer',
        Status__c = 'Active'
    ));
    
    // Student 2
    students.add(new Student__c(
        First_Name__c = 'Sarah',
        Last_Name__c = 'Johnson',
        Email__c = 'sarah.johnson@example.com',
        Phone__c = '+1-555-0102',
        Department__c = 'Product Management',
        Job_Title__c = 'Product Manager',
        Status__c = 'Active'
    ));
    
    // Student 3
    students.add(new Student__c(
        First_Name__c = 'Michael',
        Last_Name__c = 'Chen',
        Email__c = 'michael.chen@example.com',
        Phone__c = '+1-555-0103',
        Department__c = 'Design',
        Job_Title__c = 'UX Designer',
        Status__c = 'Active'
    ));
    
    // Insert all students
    insert students;
    
    System.debug('✅ Successfully created ' + students.size() + ' students:');
    for (Student__c student : students) {
        System.debug('  - ' + student.First_Name__c + ' ' + student.Last_Name__c + ' (' + student.Email__c + ')');
        System.debug('    Student ID: ' + student.Name);
        System.debug('    ---');
    }
    
} catch (Exception e) {
    System.debug('❌ Error creating students: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
