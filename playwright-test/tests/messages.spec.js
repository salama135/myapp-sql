const { test, expect } = require('@playwright/test');

test.describe('Message API Tests', () => {
  const baseUrl = 'http://localhost:3000';
  let applicationId;
  let applicationToken;
  let chatNumber;

  test.beforeAll(async ({ request }) => {
    // Create an application first
    const appResponse = await request.post(`${baseUrl}/applications`, {
      data: {
        application: {
          name: `test-app-for-messages ${Date.now()}`
        }
      },
      headers: {
        'Content-Type': 'application/json'
      }
    });

    expect(appResponse.ok()).toBeTruthy();
    const appData = await appResponse.json();
    applicationId = appData.id;
    applicationToken = appData.token;

    // Create a chat to use for messages
    const chatResponse = await request.post(
      `${baseUrl}/applications/${applicationToken}/chats`,
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );
    
    expect(chatResponse.ok()).toBeTruthy();
    const chatData = await chatResponse.json();
    chatNumber = chatData.number;
  });

  test('should create a new message', async ({ request }) => {
    const messageText = `This is my test message ${Date.now()}`;
    const response = await request.post(
      `${baseUrl}/applications/${applicationToken}/chats/${chatNumber}/messages`,
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
    expect(data).toHaveProperty('number');
  });

  test('should get all messages for a chat', async ({ request }) => {
    const response = await request.get(
      `${baseUrl}/applications/${applicationToken}/chats/${chatNumber}/messages`
    );
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
  });

  test('should return 404 for non-existent chat messages', async ({ request }) => {
    const response = await request.get(
      `${baseUrl}/applications/${applicationToken}/chats/99999/messages`
    );
    
    expect(response.status()).toBe(404);
  });
});
