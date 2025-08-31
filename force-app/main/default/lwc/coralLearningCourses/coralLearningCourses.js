import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getLearningCourses from '@salesforce/apex/LearningCourseController.getLearningCourses';
import createLearningCourse from '@salesforce/apex/LearningCourseController.createLearningCourse';

export default class CoralLearningCourses extends NavigationMixin(LightningElement) {
    @track courses = [];
    @track filteredCourses = [];
    @track showNewCourseModal = false;
    @track newCourse = {
        Course_Description__c: '',
        Course_Duration__c: '',
        Course_Level__c: 'Beginner',
        Course_Status__c: 'Active'
    };
    @track isLoading = false;
    @track error;
    @track searchTerm = '';
    @track currentPage = 1;
    @track pageSize = 6; // Show 6 courses per page (2 rows of 3)

    @wire(getLearningCourses)
    wiredCourses({ error, data }) {
        if (data) {
            this.courses = data.map(course => ({
                ...course,
                displayName: this.getCourseDisplayName(course.Name),
                courseDescription: this.getCourseDescription(course.Name),
                courseLevel: this.getCourseLevel(course.Name),
                courseDuration: this.getCourseDuration(course.Name),
                formattedCreatedDate: this.formatDate(course.CreatedDate)
            }));
            this.filteredCourses = [...this.courses];
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.courses = [];
            this.filteredCourses = [];
        }
    }

    // Search functionality
    handleSearchChange(event) {
        this.searchTerm = event.target.value.toLowerCase();
        this.currentPage = 1; // Reset to first page when searching
        this.filterCourses();
    }

    filterCourses() {
        if (!this.searchTerm) {
            this.filteredCourses = [...this.courses];
        } else {
            this.filteredCourses = this.courses.filter(course => 
                course.displayName.toLowerCase().includes(this.searchTerm) ||
                course.courseDescription.toLowerCase().includes(this.searchTerm) ||
                course.courseLevel.toLowerCase().includes(this.searchTerm) ||
                course.Course_Status__c.toLowerCase().includes(this.searchTerm)
            );
        }
    }

    // Pagination functionality
    get totalPages() {
        return Math.ceil(this.filteredCourses.length / this.pageSize);
    }

    get paginatedCourses() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.filteredCourses.slice(start, end);
    }

    get hasNextPage() {
        return this.currentPage < this.totalPages;
    }

    get hasPreviousPage() {
        return this.currentPage > 1;
    }

    get isPreviousDisabled() {
        return !this.hasPreviousPage;
    }

    get isNextDisabled() {
        return !this.hasNextPage;
    }

    get pageInfo() {
        const start = (this.currentPage - 1) * this.pageSize + 1;
        const end = Math.min(this.currentPage * this.pageSize, this.filteredCourses.length);
        const total = this.filteredCourses.length;
        return `Showing ${start}-${end} of ${total} courses`;
    }

    get pageOptions() {
        const options = [];
        for (let i = 1; i <= this.totalPages; i++) {
            options.push({
                label: `Page ${i}`,
                value: i
            });
        }
        return options;
    }

    handlePreviousPage() {
        console.log('Previous clicked. Current page:', this.currentPage, 'Has previous:', this.hasPreviousPage);
        if (this.hasPreviousPage) {
            this.currentPage--;
            console.log('Moved to page:', this.currentPage);
        }
    }

    handleNextPage() {
        console.log('Next clicked. Current page:', this.currentPage, 'Total pages:', this.totalPages, 'Has next:', this.hasNextPage);
        if (this.hasNextPage) {
            this.currentPage++;
            console.log('Moved to page:', this.currentPage);
        }
    }

    handlePageChange(event) {
        const page = parseInt(event.target.value);
        console.log('Page change requested to:', page, 'Total pages:', this.totalPages);
        if (page >= 1 && page <= this.totalPages) {
            this.currentPage = page;
            console.log('Changed to page:', this.currentPage);
        }
    }

    getCourseDisplayName(courseName) {
        const courseMap = {
            'COURSE-0000': 'Machine Learning Fundamentals',
            'COURSE-0001': 'Deep Learning with Neural Networks',
            'COURSE-0002': 'Natural Language Processing',
            'COURSE-0003': 'Computer Vision & Image Recognition',
            'COURSE-0004': 'Data Science & Analytics',
            'COURSE-0005': 'AI Ethics & Responsible AI',
            'COURSE-0006': 'Predictive Analytics',
            'COURSE-0007': 'Reinforcement Learning',
            'COURSE-0008': 'AI for Business Applications',
            'COURSE-0009': 'AI-Powered Chatbots',
            'COURSE-0010': 'Machine Learning Operations (MLOps)'
        };
        return courseMap[courseName] || 'AI & Machine Learning Course';
    }

    getCourseDescription(courseName) {
        const descriptionMap = {
            'COURSE-0000': 'Learn the fundamentals of machine learning algorithms, statistical modeling, and data preprocessing techniques.',
            'COURSE-0001': 'Master deep learning concepts including neural networks, backpropagation, and advanced architectures.',
            'COURSE-0002': 'Explore natural language processing techniques for text analysis, sentiment analysis, and language understanding.',
            'COURSE-0003': 'Develop computer vision skills for image recognition, object detection, and visual AI applications.',
            'COURSE-0004': 'Master data science methodologies including data cleaning, exploratory analysis, and statistical modeling.',
            'COURSE-0005': 'Understand the ethical implications of AI and learn to build responsible, fair, and transparent systems.',
            'COURSE-0006': 'Learn predictive modeling techniques to forecast trends and make data-driven business decisions.',
            'COURSE-0007': 'Explore reinforcement learning algorithms for autonomous decision-making and optimization.',
            'COURSE-0008': 'Apply AI technologies to solve real-world business problems and drive innovation.',
            'COURSE-0009': 'Build intelligent chatbot systems using AI and natural language processing technologies.',
            'COURSE-0010': 'Learn to deploy, monitor, and maintain machine learning models in production environments.'
        };
        return descriptionMap[courseName] || 'Comprehensive AI and machine learning course covering essential concepts and practical applications.';
    }

    getCourseLevel(courseName) {
        const levelMap = {
            'COURSE-0000': 'Beginner',
            'COURSE-0001': 'Advanced',
            'COURSE-0002': 'Intermediate',
            'COURSE-0003': 'Advanced',
            'COURSE-0004': 'Intermediate',
            'COURSE-0005': 'Intermediate',
            'COURSE-0006': 'Intermediate',
            'COURSE-0007': 'Advanced',
            'COURSE-0008': 'Intermediate',
            'COURSE-0009': 'Advanced',
            'COURSE-0010': 'Intermediate'
        };
        return levelMap[courseName] || 'Intermediate';
    }

    getCourseDuration(courseName) {
        const durationMap = {
            'COURSE-0000': 8.0,
            'COURSE-0001': 12.0,
            'COURSE-0002': 6.0,
            'COURSE-0003': 10.0,
            'COURSE-0004': 7.0,
            'COURSE-0005': 5.0,
            'COURSE-0006': 8.0,
            'COURSE-0007': 9.0,
            'COURSE-0008': 6.5,
            'COURSE-0009': 8.5,
            'COURSE-0010': 7.5
        };
        return durationMap[courseName] || 6.0;
    }

    handleCourseClick(event) {
        const courseId = event.currentTarget.dataset.courseId;
        console.log('Course clicked! Course ID:', courseId);
        
        if (courseId) {
            console.log('Attempting to navigate to course:', courseId);
            
            // Navigate to the record detail page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: courseId,
                    objectApiName: 'Learning_Course__c',
                    actionName: 'view'
                }
            }, false);
        } else {
            console.error('No course ID found in click event');
        }
    }

    handleNewCourse() {
        this.showNewCourseModal = true;
    }

    handleCloseModal() {
        this.showNewCourseModal = false;
        this.resetNewCourse();
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this.newCourse[name] = value;
    }

    async handleSaveCourse() {
        this.isLoading = true;
        try {
            await createLearningCourse({ courseData: JSON.stringify(this.newCourse) });
            this.showNewCourseModal = false;
            this.resetNewCourse();
            // Refresh the data
            this.dispatchEvent(new CustomEvent('refresh'));
        } catch (error) {
            this.error = error;
        } finally {
            this.isLoading = false;
        }
    }

    resetNewCourse() {
        this.newCourse = {
            Course_Description__c: '',
            Course_Duration__c: '',
            Course_Level__c: 'Beginner',
            Course_Status__c: 'Active'
        };
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString();
    }

    get courseStatusOptions() {
        return [
            { label: 'Active', value: 'Active' },
            { label: 'Draft', value: 'Draft' },
            { label: 'Inactive', value: 'Inactive' },
            { label: 'Archived', value: 'Archived' }
        ];
    }

    get courseLevelOptions() {
        return [
            { label: 'Beginner', value: 'Beginner' },
            { label: 'Intermediate', value: 'Intermediate' },
            { label: 'Advanced', value: 'Advanced' },
            { label: 'Expert', value: 'Expert' }
        ];
    }
}
