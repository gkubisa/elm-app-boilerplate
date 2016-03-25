# Elm App Boilerplate

Provides an efficient development workflow and is a good starting point for building Elm applications. It offers a head start on the UI implementation by integrating with the [Semantic UI](http://semantic-ui.com/) framework.

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

## Directory Structure

- `package.json` - used mostly for build and deployment support
- `elm-package.json` - describes the Elm application and its dependencies
- `semantic.json` - the main Semantic UI configuration file
- `dist/` - built application artifacts, used by both `npm start` and `npm run build`
- `test/` - directory containing all the tests
- `test/TestRunner.elm` - the entry point for executing tests, bootstraps the actual test runner
- `test/Tests.elm` - the main file loading and exposing all the test suites
- `src/` - all source files
- `src/index.html` - overall application entry point
- `src/Main.elm` - Elm application entry point
- `src/ElmAppBoilerplate` - the namespace for all `elm-app-boilerplate` Elm modules
- `src/definitions/` - Semantic UI component definitions
- `src/themes/` - Semantic UI themes
- `src/site/` - Semantic UI variables and overrides for this application
- `src/theme.config` - defines which theme to use for each Semantic UI component
- `src/semantic.less` and `src/theme.less` - other Semantic UI files
- `tasks` and `gulpfile.js` - gulp scripts for building Semantic UI
