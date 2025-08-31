// Try to create Corporate_Client__c field via Apex
System.debug('🏗️ Attempting to create Corporate_Client__c field via Apex...');

try {
    // Check if the field already exists
    Map<String, Schema.SObjectField> studentFields = Schema.SObjectType.Student__c.fields.getMap();
    
    if (studentFields.containsKey('Corporate_Client__c')) {
        System.debug('✅ Corporate_Client__c field already exists!');
        return;
    }
    
    System.debug('❌ Corporate_Client__c field does not exist');
    System.debug('💡 The field needs to be created via metadata deployment');
    
    // Since we can't create custom fields via Apex, let's work with what we have
    System.debug('🔄 Alternative approach: Let\'s check if we can use a different field');
    
    // List all available fields on Student
    System.debug('📋 Available Student fields:');
    for (String fieldName : studentFields.keySet()) {
        Schema.SObjectField field = studentFields.get(fieldName);
        Schema.DescribeFieldResult describe = field.getDescribe();
        System.debug('  - ' + fieldName + ' (' + describe.getType() + ') - ' + describe.getLabel());
    }
    
    // Check if there are any other relationship fields
    System.debug('🔍 Looking for relationship fields...');
    for (String fieldName : studentFields.keySet()) {
        Schema.SObjectField field = studentFields.get(fieldName);
        Schema.DescribeFieldResult describe = field.getDescribe();
        if (describe.getType() == Schema.DisplayType.REFERENCE && fieldName != 'OwnerId') {
            System.debug('  🔗 Found relationship field: ' + fieldName + ' → ' + describe.getReferenceTo()[0]);
        }
    }
    
} catch (Exception e) {
    System.debug('❌ Error: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
