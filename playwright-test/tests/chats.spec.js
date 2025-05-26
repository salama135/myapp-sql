const { test, expect } = require('@playwright/test');

test.describe('Chat API Tests', () => {
  const baseUrl = 'http://localhost:3000';
  let applicationId;
  let chatId;

  test.beforeAll(async ({ request }) => {
    // Create an application first
    const response = await request.post(`${baseUrl}/applications`, {
      data: {
        application: {
          name: 'test-app-for-chats'
        }
      },
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    applicationId = data.id;
  });

  test('should create a new chat', async ({ request }) => {
    const response = await request.post(`${baseUrl}/applications/${applicationId}/chats`);
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    chatId = data.id;
    expect(data).toBeTruthy();
  });

  test('should get all chats for an application', async ({ request }) => {
    const response = await request.get(`${baseUrl}/applications/${applicationId}/chats/`);
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
  });

  test('should get a specific chat', async ({ request }) => {
    const response = await request.get(`${baseUrl}/applications/${applicationId}/chats/${chatId}`);
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(data.id).toBe(chatId);
  });

  test('should get messages for a chat', async ({ request }) => {
    const response = await request.get(`${baseUrl}/applications/${applicationId}/chats/${chatId}/messages`);
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
  });
});
