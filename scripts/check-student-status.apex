// Check current student and client status
System.debug('🔍 Checking current student and client status...');

try {
    // Check what fields exist on Student object
    System.debug('📋 Student object fields:');
    Map<String, Schema.SObjectField> studentFields = Schema.SObjectType.Student__c.fields.getMap();
    for (String fieldName : studentFields.keySet()) {
        Schema.SObjectField field = studentFields.get(fieldName);
        System.debug('  - ' + fieldName + ' (' + field.getDescribe().getType() + ')');
    }
    
    // Check current students
    List<Student__c> students = [SELECT Id, Name, First_Name__c, Last_Name__c FROM Student__c LIMIT 5];
    System.debug('👥 Current students: ' + students.size());
    for (Student__c student : students) {
        System.debug('  - ' + student.Name + ': ' + student.First_Name__c + ' ' + student.Last_Name__c);
    }
    
    // Check corporate clients
    List<Corporate_Client__c> clients = [SELECT Id, Name FROM Corporate_Client__c LIMIT 5];
    System.debug('🏢 Current corporate clients: ' + clients.size());
    for (Corporate_Client__c client : clients) {
        System.debug('  - ' + client.Name);
    }
    
} catch (Exception e) {
    System.debug('❌ Error checking status: ' + e.getMessage());
}
