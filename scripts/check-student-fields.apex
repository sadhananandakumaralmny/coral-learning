// Check what fields exist on Student__c
System.debug('Checking Student__c fields...');

try {
    Schema.DescribeSObjectResult describeResult = Student__c.SObjectType.getDescribe();
    Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
    
    System.debug('Student__c fields:');
    for (String fieldName : fieldMap.keySet()) {
        Schema.SObjectField field = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('Field: ' + fieldName + ' - Type: ' + fieldDescribe.getType() + ' - Accessible: ' + fieldDescribe.isAccessible());
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
