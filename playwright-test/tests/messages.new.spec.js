const { test, expect } = require('@playwright/test');

test.describe('Message API Tests', () => {
  const baseUrl = 'http://localhost:3000';
  let applicationId;
  let chatId;

  test.beforeAll(async ({ request }) => {
    // Create an application first
    const appResponse = await request.post(`${baseUrl}/applications`, {
      data: {
        application: {
          name: 'test-app-for-messages'
        }
      },
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    expect(appResponse.ok()).toBeTruthy();
    const appData = await appResponse.json();
    applicationId = appData.id;

    // Create a chat to use for messages
    const chatResponse = await request.post(
      `${baseUrl}/applications/${applicationId}/chats`,
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );
    
    expect(chatResponse.ok()).toBeTruthy();
    const chatData = await chatResponse.json();
    chatId = chatData.id;
  });

  test('should create a new message', async ({ request }) => {
    const messageText = 'This is my test message';
    const response = await request.post(
      `${baseUrl}/applications/${applicationId}/chats/${chatId}/messages`,
      {
        data: {
          body: messageText
        },
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(data).toHaveProperty('id');
    expect(data.body).toBe(messageText);
    expect(data).toHaveProperty('chat_id', chatId);
  });

  test('should get all messages for a chat', async ({ request }) => {
    const response = await request.get(
      `${baseUrl}/applications/${applicationId}/chats/${chatId}/messages`
    );
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
  });

  test('should return 404 for non-existent chat messages', async ({ request }) => {
    const response = await request.get(
      `${baseUrl}/applications/${applicationId}/chats/99999/messages`
    );
    
    expect(response.status()).toBe(404);
  });
});
