/* global require */

// Entry point for all JS tests, loaded by webpack.
// It recursively finds and `require`s all files which end with `.test.js`.
const context = require.context('.', true, /\.test\.js$/)
context.keys().forEach(context)
