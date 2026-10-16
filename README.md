SwiftCart WhatsApp Customer Support Agent

An AI-powered customer support agent for a fictional online gadget store (SwiftCart Electronics), built with n8n. WhatsApp is simulated with a webhook; no real customers, CRM or production systems are used.

The agent receives a customer message, identifies the customer, keeps the conversation history, answers only from a fictional knowledge base, creates a prioritised support ticket when a human is needed, emails the support team, holds the conversation while a human works on the ticket, and resumes automatic answers when the ticket is resolved.

Features
Customer lookup or creation by phone number
Conversation history (last 6 messages) used for follow-up questions
Knowledge base answers (products, policies, FAQ) with no invented facts
English and Roman Urdu replies
AI intent, category and urgency for every message
Human escalation: complaints, refund disputes, sensitive account issues, unclear questions, explicit requests for a person
Support tickets with an auto ID, AI summary, AI priority (General Inquiry, Normal, Important, Urgent) and a simulated assignment
Escalation email to a test inbox and a Human Review hold that stops automatic replies
Retry, fallback and an Error Handler workflow that writes failures to an Error Log sheet
Architecture
WhatsApp (simulated webhook)
        |
  [01 Support Pipeline]
   extract fields -> find/create customer -> hold check (Human Review?)
        |                                          |
        |                                   save message, no reply
        v
   history + knowledge base -> AI (Groq) -> parse and safety rules
        |                                   |
        |                                   +-> ticket branch -> AI priority -> ticket -> email
        v
   save messages -> update customer -> send reply
        |
  [02 Mock WhatsApp Send]        [03 Update Ticket] (human resolves a ticket)
  [04 Error Handler] (any failed run -> Error Log + email)

Data is stored in two Google Sheets: customer support database (customers, conversations, Support Tickets, Error Log) and SwiftCart Knowledge Base (products, policies, FAQ).

Tech stack

n8n (self-hosted, local), Groq (openai/gpt-oss-20b), Google Sheets, SMTP email, PowerShell and curl for test messages.

Repository structure
README.md
docs/          project documentation and testing report
workflows/     exported n8n workflows (JSON)
screenshots/   canvas, sheets, executions, email, error log
test/          final-tests.ps1, retest.ps1, demo.ps1, payload.json
Workflows
File	Purpose
01-support-pipeline.json	Main pipeline (webhook path support-agent-p8)
02-mock-whatsapp-send.json	Simulated WhatsApp send endpoint
03-update-ticket.json	Resolve or update a ticket and the customer record
04-error-handler.json	Error workflow: Error Log sheet and email
Setup
Run n8n locally and create credentials for Google Sheets (OAuth), Groq (header authentication with your own API key) and SMTP (an app password).
Create the Google Sheets with the tabs and columns described in docs/.
Import the four JSON files, reconnect the credentials, publish the workflows and set 04 Error Handler as the Error Workflow of the other three (workflow menu, Settings).
Send test messages with test/final-tests.ps1 or test/demo.ps1. Production webhook runs appear in the Executions tab.
Testing

30 fictional scenarios (product, pricing, delivery, refund, warranty, complaint, technical, unclear, human request, information that is not in the knowledge base; new and returning customers; multi-message conversations). The first run found five problems, which are documented with their fixes in docs/ instead of being hidden.

Limitations
WhatsApp is simulated; the real Meta Cloud API is not connected.
Google Sheets is the database (60 reads per minute, no locking), so messages need spacing.
Ticket priority and escalation are decided by AI without a human check.
A held customer receives no reply, and resolving a ticket does not message the customer.
Safety

All names, orders and conversations are fictional. API keys, client secrets and real email addresses are not part of this repository.

Author

RanaHamed34
