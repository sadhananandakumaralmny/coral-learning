import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getStudents from '@salesforce/apex/StudentController.getStudents';
import getCorporateClients from '@salesforce/apex/CorporateClientController.getCorporateClients';

export default class CoralStudents extends NavigationMixin(LightningElement) {
    @track students = [];
    @track filteredStudents = [];
    @track showNewStudentModal = false;
    @track searchTerm = '';
    @track error;
    @track isLoading = true;
    @track currentPage = 1;
    @track pageSize = 6;
    @track viewMode = 'list';
    
    // Available corporate clients for dropdowns
    @track clients = [];
    
    newStudent = {
        First_Name__c: '',
        Last_Name__c: '',
        Email__c: '',
        Phone__c: '',
        Corporate_Client__c: '',
        Department__c: '',
        Job_Title__c: '',
        Status__c: 'Active'
    };

    @wire(getStudents)
    wiredStudents({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.students = data.map(student => ({
                ...student,
                // Add computed properties
                fullName: `${student.First_Name__c || ''} ${student.Last_Name__c || ''}`.trim(),
                clientName: student.Corporate_Client__r?.Name || 'No Client Assigned',
                formattedCreatedDate: this.formatDate(student.CreatedDate)
            }));
            this.filteredStudents = this.students;
            this.currentPage = 1;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.students = [];
            this.filteredStudents = [];
        }
    }

    @wire(getCorporateClients)
    wiredClients({ error, data }) {
        if (data) {
            this.clients = data.map(client => ({
                label: client.Name,
                value: client.Id
            }));
        }
    }

    handleNewStudent() {
        this.showNewStudentModal = true;
    }

    handleCloseModal() {
        this.showNewStudentModal = false;
        this.resetNewStudent();
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this.newStudent[name] = value;
    }

    handleSaveStudent() {
        // TODO: Implement save functionality with Apex
        this.showNewStudentModal = false;
        this.resetNewStudent();
    }

    resetNewStudent() {
        this.newStudent = {
            First_Name__c: '',
            Last_Name__c: '',
            Email__c: '',
            Phone__c: '',
            Corporate_Client__c: '',
            Department__c: '',
            Job_Title__c: '',
            Status__c: 'Active'
        };
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.currentPage = 1;
        this.filterStudents();
    }

    filterStudents() {
        if (!this.searchTerm) {
            this.filteredStudents = this.students;
        } else {
            this.filteredStudents = this.students.filter(student => {
                const searchLower = this.searchTerm.toLowerCase();
                
                // Search by name
                const fullName = student.fullName || '';
                if (fullName.toLowerCase().includes(searchLower)) return true;
                
                // Search by email
                const email = student.Email__c || '';
                if (email.toLowerCase().includes(searchLower)) return true;
                
                // Search by client
                const clientName = student.clientName || '';
                if (clientName.toLowerCase().includes(searchLower)) return true;
                
                return false;
            });
        }
    }



    // Pagination functionality
    get totalPages() {
        return Math.ceil(this.filteredStudents.length / this.pageSize);
    }

    get paginatedStudents() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.filteredStudents.slice(start, end);
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
        const end = Math.min(this.currentPage * this.pageSize, this.filteredStudents.length);
        const total = this.filteredStudents.length;
        return `Showing ${start}-${end} of ${total} students`;
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
        if (this.hasPreviousPage) {
            this.currentPage--;
        }
    }

    handleNextPage() {
        if (this.hasNextPage) {
            this.currentPage++;
        }
    }

    handlePageChange(event) {
        const page = parseInt(event.target.value);
        if (page >= 1 && page <= this.totalPages) {
            this.currentPage = page;
        }
    }

    handleStudentClick(event) {
        const studentId = event.currentTarget.dataset.id;
        if (studentId) {
            console.log('✅ Navigating to student:', studentId);
            
            // Navigate to the student record detail page
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: studentId,
                    objectApiName: 'Student__c',
                    actionName: 'view'
                }
            });
        }
    }

    get hasStudents() {
        return this.filteredStudents && this.filteredStudents.length > 0;
    }

    get studentCount() {
        return this.filteredStudents ? this.filteredStudents.length : 0;
    }

    get searchResultsInfo() {
        if (this.searchTerm && this.students.length !== this.filteredStudents.length) {
            return `Showing ${this.filteredStudents.length} of ${this.students.length} students`;
        }
        return '';
    }

    get statusOptions() {
        return [
            { label: 'Active', value: 'Active' },
            { label: 'Inactive', value: 'Inactive' },
            { label: 'Graduated', value: 'Graduated' }
        ];
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString();
    }
}
