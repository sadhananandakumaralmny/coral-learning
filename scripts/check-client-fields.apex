// Check what fields are available on Corporate_Client__c
System.debug('🔍 Checking Corporate_Client__c fields...');

try {
    // Get the object describe
    Schema.DescribeSObjectResult describeResult = Corporate_Client__c.SObjectType.getDescribe();

    Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();

    System.debug('Total fields: ' + fieldMap.size());

    // List all field names and types
    for (String fieldName : fieldMap.keySet()) {
        Schema.SObjectField field = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('Field: ' + fieldName + ' - Type: ' + fieldDescribe.getType() + ' - Accessible: ' + fieldDescribe.isAccessible() + ' - Required: ' + fieldDescribe.isNillable());
    }

} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
