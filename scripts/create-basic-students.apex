// Create basic students with only existing fields
System.debug('Creating basic students...');

try {
    // Create sample students with only the fields we know exist
    List<Student__c> students = new List<Student__c>();
    
    // Student 1
    students.add(new Student__c(
        First_Name__c = 'John',
        Last_Name__c = 'Smith',
        Email__c = 'john.smith@example.com'
    ));
    
    // Student 2
    students.add(new Student__c(
        First_Name__c = 'Sarah',
        Last_Name__c = 'Johnson',
        Email__c = 'sarah.johnson@example.com'
    ));
    
    // Student 3
    students.add(new Student__c(
        First_Name__c = 'Michael',
        Last_Name__c = 'Chen',
        Email__c = 'michael.chen@example.com'
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
