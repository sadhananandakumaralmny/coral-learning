// Test script to check Corporate_Client__c fields
// Run this in Developer Console or via SFDX

try {
    // Get the describe result for Corporate_Client__c
    Schema.DescribeSObjectResult describeResult = Corporate_Client__c.SObjectType.getDescribe();
    
    System.debug('Object Label: ' + describeResult.getLabel());
    System.debug('Object Name: ' + describeResult.getName());
    
    // Get all fields
    Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
    
    System.debug('Available fields:');
    for(String fieldName : fieldMap.keySet()) {
        Schema.SObjectField field = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        System.debug('Field: ' + fieldName + ' - Type: ' + fieldDescribe.getType() + ' - Label: ' + fieldDescribe.getLabel());
    }
    
    // Try to create a simple record
    Corporate_Client__c testClient = new Corporate_Client__c();
    testClient.Company_Industry__c = 'Technology';
    testClient.Status__c = 'Active';
    
    System.debug('Test client object: ' + testClient);
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}

System.debug('Field test script completed!');
