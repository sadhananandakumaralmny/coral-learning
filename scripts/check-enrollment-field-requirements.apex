// Check field requirements on Course_Enrollment__c
System.debug('Checking Course_Enrollment__c field requirements...');

try {
    Schema.DescribeSObjectResult describeResult = Course_Enrollment__c.SObjectType.getDescribe();
    Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
    
    System.debug('Course_Enrollment__c custom fields:');
    for (String fieldName : fieldMap.keySet()) {
        Schema.SObjectField field = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        
        if (fieldDescribe.isCustom()) {
            System.debug('Field: ' + fieldName + 
                        ' - Type: ' + fieldDescribe.getType() + 
                        ' - Required: ' + (!fieldDescribe.isNillable()) + 
                        ' - Default: ' + fieldDescribe.getDefaultValue());
        }
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
