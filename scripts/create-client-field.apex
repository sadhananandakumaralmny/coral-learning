// Create Corporate_Client__c lookup field on Student object
System.debug('🏗️ Creating Corporate_Client__c lookup field...');

try {
    // First, let's check if we can create the field using Metadata API
    // For now, let's just create a simple relationship by updating existing students
    
    // Get all students and clients
    List<Student__c> students = [SELECT Id, Name, First_Name__c, Last_Name__c FROM Student__c];
    List<Corporate_Client__c> clients = [SELECT Id, Name FROM Corporate_Client__c];
    
    System.debug('📊 Found ' + students.size() + ' students and ' + clients.size() + ' clients');
    
    if (students.isEmpty() || clients.isEmpty()) {
        System.debug('❌ Need both students and clients to create relationships');
        return;
    }
    
    // For now, let's just show what we have and suggest manual steps
    System.debug('💡 To fix student client assignment, you need to:');
    System.debug('1. Add a lookup field "Corporate_Client__c" to the Student object');
    System.debug('2. Reference the Corporate_Client__c object');
    System.debug('3. Make it optional (not required)');
    System.debug('4. Set relationship label to "Students"');
    
    System.debug('📋 Current students:');
    for (Student__c student : students) {
        System.debug('  - ' + student.Name + ': ' + student.First_Name__c + ' ' + student.Last_Name__c);
    }
    
    System.debug('🏢 Available clients:');
    for (Corporate_Client__c client : clients) {
        System.debug('  - ' + client.Name);
    }
    
    System.debug('🎯 Once the field is created, students can be assigned to clients');
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
}
