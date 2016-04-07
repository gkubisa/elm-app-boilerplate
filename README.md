# Elm App Boilerplate

Provides an efficient development workflow and a starting point for building Elm applications.

## Features

- easy to use npm scripts
- automated build of all application resources
- JavaScript and CSS minification
- automatic rebuild and reload on source change
- automatic re-execution of tests on source change
- [Semantic UI](http://semantic-ui.com/) integration

## Getting Started

Fork and clone this repo.

```
npm install
npm start
```

Open `http://localhost:3000/` in a browser.

Start coding! :-)

The application files are automatically rebuilt on code change and stored in `./dist`. That directory is then served by `browser-sync`, which also reloads the browser on any file change.

## Preparing for Deployment

```
npm run build
```

The application code ready for deployment will be stored in `./dist`.

## Testing

Once off

```
npm test
```

Restart the tests on code change

```
npm run tdd
```

## Updating version

Use the standard `npm version` command. This project contains npm scripts which also:

- update the version in `elm-package.json`
- push the branch on which the version change was made
- push the created tag

## Common Elm Commands

- `elm make` - use `npm run build` instead
- `elm reactor` - use `npm start` instead
- `elm test` - use `npm test` or `npm run tdd` instead
- `elm repl` - exposed through `npm run elm-repl`
- `elm package` - exposed through `npm run elm-package`
- `elm package install -y` - use `npm install` instead

## Directory Structure

### General

- `package.json` - defines dependencies and scripts for building and running the application
- `dist/` - built application artifacts, used by both `npm start` and `npm run build`

### Elm

- `elm-package.json` - describes the Elm application and its dependencies
- `src/` - Elm source files
- `src/Main.elm` - Elm application entry point
- `src/App/` - the namespace for all application Elm modules
- `test/` - directory containing all the tests
- `test/TestRunner.elm` - the entry point for executing tests and bootstrapping the actual test runner
- `test/Tests.elm` - the main file loading and exposing all the test suites

### Semantic UI

- `semantic.json` - the main Semantic UI configuration file
- `styles/` - the Semantic UI component definitions, themes, variables and style overrides
- `gulpfile.js` - defines high level tasks for building Semantic UI
- `tasks/` - gulp task definitions for building Semantic UI

### JavaScript

- `scripts/` - contains all application JavaScript code
- `scripts/main.js` - entry point to the application JavaScript code

### HTML

- `html/index.html` - overall application entry point
- `html-minifier.conf` - config file for the html-minifier module


## Integration with Semantic UI

Semantic UI provides a lot of ready-made, customizable UI components and helps to implement the design of the application quickly and consistently. It was included in `elm-app-boilerplate` because it integrates nicely with Elm.

The main idea behind the integration is that Elm handles all the application logic, integration with the backend and rendering of the HTML. Semantic UI on the other hand is responsible for making the application look nice on the screen.

Semantic UI `globals`, `views`, `collections` and `elements` are defined using LESS only, so they work seamlessly with Elm out of the box.

The `modules` require some JavaScript to work and must be initialized by the application. However, some (if not all) `modules` can be automatically managed in JavaScript in a way that is completely transparent to the Elm code. The demo page of `elm-app-boilerplate` contains some examples of that technique. _Pull requests with examples for other `modules` welcome!_

The `behaviors` would certainly be the most difficult to integrate, however, they are probably also the least likely to be useful to an Elm application. Specifically, the interaction with the backend (`API` behaviour) is better handled in Elm. `Form validation` could be useful, however, [Elm validation](https://github.com/etaque/elm-simple-form) is also available. The `visibility` behaviour is the one which cannot be easily done in Elm, so the integration might be worth the effort.

**`elm-app-boilerplate` is currently configured to include all Semantic UI components. Make sure you remove the unnecessary components before deploying your application to production.**
