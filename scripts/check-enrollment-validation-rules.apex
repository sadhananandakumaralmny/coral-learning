// Check for validation rules on Course_Enrollment__c
System.debug('Checking Course_Enrollment__c validation rules...');

try {
    Schema.DescribeSObjectResult describeResult = Course_Enrollment__c.SObjectType.getDescribe();
    
    System.debug('Object: ' + describeResult.getName());
    System.debug('Label: ' + describeResult.getLabel());
    System.debug('Is createable: ' + describeResult.isCreateable());
    System.debug('Is updateable: ' + describeResult.isUpdateable());
    
    // Check if there are validation rules
    List<ValidationRule> validationRules = [
        SELECT Id, Name, Active, Description, ErrorMessage, ErrorDisplayField
        FROM ValidationRule 
        WHERE EntityDefinition.QualifiedApiName = 'Course_Enrollment__c'
    ];
    
    System.debug('Found ' + validationRules.size() + ' validation rules:');
    for (ValidationRule rule : validationRules) {
        System.debug('Rule: ' + rule.Name + ' - Active: ' + rule.Active + ' - Description: ' + rule.Description);
    }
    
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
