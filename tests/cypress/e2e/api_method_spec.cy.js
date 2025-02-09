import { apiUrl } from '../../../frontend/script/config.js';

describe('CRC API - Method not allowed', () => {
  it('should return 405 for unsupported HTTP methods', () => {
    cy.request({
      method: 'GET',
      url: apiUrl,
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(405);
      expect(response.body).to.have.property('error');
    });
  });
});
