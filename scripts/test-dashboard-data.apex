// Test DashboardController methods
System.debug('🧪 Testing DashboardController methods...');

try {
    // Test 1: Enrollment Trends
    System.debug('📊 Testing getEnrollmentTrends...');
    List<Map<String, Object>> trends = DashboardController.getEnrollmentTrends();
    System.debug('✅ Enrollment Trends Result: ' + trends);
    System.debug('📈 Trends Count: ' + (trends != null ? String.valueOf(trends.size()) : 'NULL'));
    
    // Test 2: Course Performance
    System.debug('📊 Testing getCoursePerformance...');
    List<Map<String, Object>> performance = DashboardController.getCoursePerformance();
    System.debug('✅ Course Performance Result: ' + performance);
    System.debug('📈 Performance Count: ' + (performance != null ? String.valueOf(performance.size()) : 'NULL'));
    
    // Test 3: Student Demographics
    System.debug('📊 Testing getStudentDemographics...');
    Map<String, Integer> demographics = DashboardController.getStudentDemographics();
    System.debug('✅ Student Demographics Result: ' + demographics);
    System.debug('📈 Demographics Keys: ' + (demographics != null ? String.valueOf(demographics.keySet()) : 'NULL'));
    
    // Test 4: Client Engagement
    System.debug('📊 Testing getClientEngagement...');
    List<Map<String, Object>> engagement = DashboardController.getClientEngagement();
    System.debug('✅ Client Engagement Result: ' + engagement);
    System.debug('📈 Engagement Count: ' + (engagement != null ? String.valueOf(engagement.size()) : 'NULL'));
    
    System.debug('🎉 All tests completed successfully!');
    
} catch (Exception e) {
    System.debug('❌ Error testing DashboardController: ' + e.getMessage());
    System.debug('❌ Stack trace: ' + e.getStackTraceString());
}
