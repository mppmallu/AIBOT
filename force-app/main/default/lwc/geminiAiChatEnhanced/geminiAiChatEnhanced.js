import { LightningElement, track } from 'lwc';
import getGeminiResponse from '@salesforce/apex/GeminiController.getGeminiResponse';

export default class GeminiAiChatEnhanced extends LightningElement {
    @track userInput = '';
    @track messages = [];
    @track isLoading = false;
    @track username ='';
    @track accessHandle=false;

    
    handleUsernameChange(event) {
        this.username = event.target.value;
    }

    handleSubmit() {
        let today = new Date();

        let day = String(today.getDate()).padStart(2, '0');
        let month = String(today.getMonth() + 1).padStart(2, '0'); // Months are 0-indexed
        let year = today.getFullYear();

        let formattedDate = `${day}${month}${year}`;
        if(this.username === formattedDate+"dwrun"){
            this.accessHandle = true;
        }else {
            this.accessHandle = false;
        }
        // You can dispatch an event or call Apex here if needed
    }


    handleInputChange(event) {
        this.userInput = event.target.value;
    }

    async handleSend() {
        if (this.userInput.trim() === '') return;
        this.isLoading = true;

        const userMessage = {
            id: Date.now(),
            sender: 'User',
            text: this.userInput,
            alignment: 'right',
            isCode: false
        };
        this.messages = [...this.messages, userMessage];

        try {
            const response = await getGeminiResponse({ inputText: this.userInput });
            const formatted = this.formatResponse(response);
            const aiMessage = {
                id: Date.now() + 1,
                sender: 'AI',
                text: formatted.text,
                alignment: 'left',
                isCode: formatted.isCode
            };
            this.messages = [...this.messages, aiMessage];
        } catch (error) {
            console.error('Error:', error);
            this.messages = [...this.messages, {
                id: Date.now() + 2,
                sender: 'AI',
                text: 'An error occurred. Please check logs.',
                alignment: 'left',
                isCode: false
            }];
        }

        this.userInput = '';
        this.isLoading = false;
    }

    formatResponse(responseText) {
        const trimmed = responseText?.trim() || '';
        const isLikelyCode = /(\bfunction\b|\bclass\b|\bif\b|\belse\b|[{}`])/i.test(trimmed) || trimmed.includes('\n');

        return {
            text: trimmed,
            isCode: isLikelyCode
        };
    }
}