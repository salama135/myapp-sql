const { test, expect } = require('@playwright/test');

test.describe('Application API Tests', () => {
  const baseUrl = 'http://localhost:3000';
  let applicationId;
  let applicationToken;

  test('should create a new application', async ({ request }) => {
    const appName = 'test-app-' + Date.now();
    const response = await request.post(`${baseUrl}/applications`, {
      data: {
        application: {
          name: appName
        }
      },
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    expect(response.status()).toBe(201);
    const data = await response.json();
    applicationId = data.id; // Store the ID for subsequent tests
    applicationToken = data.token;
    expect(data.name).toBe(appName);
    expect(data).toHaveProperty('chats_count', 0);
  });

  test('should get all applications', async ({ request }) => {
    const response = await request.get(`${baseUrl}/applications/`);
    
    expect(response.status()).toBe(200);
    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
    // Verify our created application is in the list
    expect(data.some(app => app.id === applicationId)).toBeTruthy();
  });

  test('should get a specific application', async ({ request }) => {
    const response = await request.get(`${baseUrl}/applications/${applicationToken}`);
    
    expect(response.status()).toBe(200);
    const data = await response.json();
    expect(data.id).toBe(applicationId);
    expect(data).toHaveProperty('chats_count');
    expect(typeof data.chats_count).toBe('number');
  });

  test('should update an application', async ({ request }) => {
    const response = await request.put(`${baseUrl}/applications/${applicationToken}`, {
      data: {
        application: {
          name: 'updated-app-02'
        }
      },
      headers: {
        'Content-Type': 'application/json'
      }
    });
    
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    expect(data.name).toBe('updated-app-02');
  });
});
