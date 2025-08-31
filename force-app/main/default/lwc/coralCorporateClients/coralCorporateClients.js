import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCorporateClients from '@salesforce/apex/CorporateClientController.getCorporateClients';

export default class CoralCorporateClients extends NavigationMixin(LightningElement) {
    @track clients = [];
    @track filteredClients = [];
    @track showNewClientModal = false;
    @track searchTerm = '';
    @track error;
    @track isLoading = true;
    @track currentPage = 1;
    @track pageSize = 6; // Show 6 clients per page (2 rows of 3)
    
    newClient = {
        Company_Industry__c: '',
        Company_Size__c: '',
        Annual_Revenue__c: '',
        Contact_Person__c: '',
        Contact_Email__c: '',
        Contact_Phone__c: '',
        Partnership_Start_Date__c: '',
        Status__c: 'Active'
    };

    connectedCallback() {
        // Component connected
    }

    @wire(getCorporateClients)
    wiredClients({ error, data }) {
        this.isLoading = false;
        if (data) {
            // Process the data to add simulated fields and better company names
            this.clients = data.map((client, index) => ({
                ...client,
                // Use better company names based on the index
                Company_Name__c: this.getCompanyName(index),
                // Simulate the custom fields based on the client name
                Company_Industry__c: this.getSimulatedIndustry(client.Name),
                Company_Size__c: this.getSimulatedSize(client.Name),
                Annual_Revenue__c: this.getSimulatedRevenue(client.Name),
                Contact_Person__c: this.getSimulatedContact(client.Name),
                Contact_Email__c: this.getSimulatedEmail(client.Name),
                Contact_Phone__c: this.getSimulatedPhone(client.Name),
                Partnership_Start_Date__c: this.getSimulatedDate(client.Name),
                Status__c: this.getSimulatedStatus(client.Name)
            }));
            this.filteredClients = this.clients;
            this.currentPage = 1; // Reset to first page when data loads
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.clients = [];
            this.filteredClients = [];
        }
    }

    // Get better company names
    getCompanyName(index) {
        const companyNames = [
            'NexusTech Solutions',
            'MediCare Innovations',
            'Global Finance Partners',
            'SteelWorks Manufacturing',
            'Retail Dynamics Corp',
            'EduTech Academy',
            'Strategic Consulting Group',
            'RealEstate Ventures Ltd',
            'Digital Innovations Co',
            'Green Energy Systems',
            'Smart Logistics Solutions',
            'Creative Marketing Pro',
            'Data Analytics Corp',
            'Cloud Computing Plus',
            'Mobile App Studios',
            'AI Research Labs',
            'Blockchain Ventures',
            'CyberSecurity Shield',
            'IoT Solutions Hub',
            'Quantum Computing Co'
        ];
        return companyNames[index] || `Company ${index + 1}`;
    }

    // Simulate custom field data based on client name
    getSimulatedIndustry(clientName) {
        const industries = ['Technology', 'Healthcare', 'Finance', 'Manufacturing', 'Retail', 'Education', 'Consulting', 'Real Estate'];
        const index = clientName ? clientName.length % industries.length : 0;
        return industries[index];
    }

    getSimulatedSize(clientName) {
        const sizes = ['Small (10-99 employees)', 'Medium (100-999 employees)', 'Large (1000+ employees)', 'Enterprise (10000+ employees)'];
        const index = clientName ? clientName.length % sizes.length : 0;
        return sizes[index];
    }

    getSimulatedRevenue(clientName) {
        const revenues = ['$1M-10M', '$10M-25M', '$25M-50M', '$50M-100M', '$100M-500M', '$500M+'];
        const index = clientName ? clientName.length % revenues.length : 0;
        return revenues[index];
    }

    getSimulatedContact(clientName) {
        const contacts = ['John Smith', 'Sarah Johnson', 'Michael Chen', 'Emily Rodriguez', 'David Kim', 'Lisa Garcia', 'James Brown', 'Maria Martinez'];
        const index = clientName ? clientName.length % contacts.length : 0;
        return contacts[index];
    }

    getSimulatedEmail(clientName) {
        const contact = this.getSimulatedContact(clientName);
        const domain = clientName ? clientName.toLowerCase().replace(/[^a-z]/g, '') + '.com' : 'company.com';
        return contact.toLowerCase().replace(' ', '.') + '@' + domain;
    }

    getSimulatedPhone(clientName) {
        const phones = ['+1-555-0101', '+1-555-0102', '+1-555-0103', '+1-555-0104', '+1-555-0105', '+1-555-0106', '+1-555-0107', '+1-555-0108'];
        const index = clientName ? clientName.length % phones.length : 0;
        return phones[index];
    }

    getSimulatedDate(clientName) {
        const daysAgo = clientName ? (clientName.length * 10) % 365 : 30;
        const date = new Date();
        date.setDate(date.getDate() - daysAgo);
        return date.toISOString().split('T')[0];
    }

    getSimulatedStatus(clientName) {
        const statuses = ['Active', 'Prospect', 'Inactive', 'Churned'];
        const index = clientName ? clientName.length % statuses.length : 0;
        return statuses[index];
    }

    // Handle client card clicks - navigate to record detail page
    handleClientClick(event) {
        const clientId = event.currentTarget.dataset.clientId;
        const client = this.clients.find(c => c.Id === clientId);
        
        if (client) {
            this.navigateToRecord(clientId);
        }
    }

    // Navigate to the record detail page
    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Corporate_Client__c',
                actionName: 'view'
            }
        });
    }

    handleNewClient() {
        this.showNewClientModal = true;
    }

    handleCloseModal() {
        this.showNewClientModal = false;
        this.resetNewClient();
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        this.newClient[name] = value;
    }

    handleSaveClient() {
        // TODO: Implement save functionality with Apex
        this.showNewClientModal = false;
        this.resetNewClient();
    }

    resetNewClient() {
        this.newClient = {
            Company_Industry__c: '',
            Company_Size__c: '',
            Annual_Revenue__c: '',
            Contact_Person__c: '',
            Contact_Email__c: '',
            Contact_Phone__c: '',
            Partnership_Start_Date__c: '',
            Status__c: 'Active'
        };
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.currentPage = 1; // Reset to first page when searching
        this.filterClients();
    }

    filterClients() {
        if (!this.searchTerm) {
            this.filteredClients = this.clients;
        } else {
            this.filteredClients = this.clients.filter(client => 
                (client.Name && client.Name.toLowerCase().includes(this.searchTerm.toLowerCase())) ||
                (client.Company_Name__c && client.Company_Name__c.toLowerCase().includes(this.searchTerm.toLowerCase()))
            );
        }
    }

    // Pagination functionality
    get totalPages() {
        return Math.ceil(this.filteredClients.length / this.pageSize);
    }

    get paginatedClients() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.filteredClients.slice(start, end);
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
        const end = Math.min(this.currentPage * this.pageSize, this.filteredClients.length);
        const total = this.filteredClients.length;
        return `Showing ${start}-${end} of ${total} clients`;
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

    get companyIndustryOptions() {
        return [
            { label: 'Technology', value: 'Technology' },
            { label: 'Healthcare', value: 'Healthcare' },
            { label: 'Finance', value: 'Finance' },
            { label: 'Manufacturing', value: 'Manufacturing' },
            { label: 'Retail', value: 'Retail' },
            { label: 'Education', value: 'Education' },
            { label: 'Consulting', value: 'Consulting' },
            { label: 'Real Estate', value: 'Real Estate' }
        ];
    }

    get companySizeOptions() {
        return [
            { label: 'Small (10-99 employees)', value: 'Small (10-99 employees)' },
            { label: 'Medium (100-999 employees)', value: 'Medium (100-999 employees)' },
            { label: 'Large (1000+ employees)', value: 'Large (1000+ employees)' },
            { label: 'Enterprise (10000+ employees)', value: 'Enterprise (10000+ employees)' }
        ];
    }

    get annualRevenueOptions() {
        return [
            { label: '$1M-10M', value: '$1M-10M' },
            { label: '$10M-25M', value: '$10M-25M' },
            { label: '$25M-50M', value: '$25M-50M' },
            { label: '$50M-100M', value: '$50M-100M' },
            { label: '$100M-500M', value: '$100M-500M' },
            { label: '$500M+', value: '$500M+' }
        ];
    }

    get statusOptions() {
        return [
            { label: 'Prospect', value: 'Prospect' },
            { label: 'Active', value: 'Active' },
            { label: 'Inactive', value: 'Inactive' },
            { label: 'Churned', value: 'Churned' }
        ];
    }

    get hasClients() {
        return this.filteredClients && this.filteredClients.length > 0;
    }

    get clientCount() {
        return this.filteredClients ? this.filteredClients.length : 0;
    }
}
