const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    supportFile: 'tests/cypress/support/e2e.js',
    specPattern: 'tests/cypress/e2e/api*.cy.js',
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
