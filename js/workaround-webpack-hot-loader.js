// window.location.origin polyfill for IE, see:
// http://stackoverflow.com/questions/22564167/window-location-origin-gives-wrong-value-when-using-ie
if (!window.location.origin) {
  window.location.origin = window.location.protocol + "//"
    + window.location.hostname
    + (window.location.port ? ':' + window.location.port : '');
}

// a workaround for https://github.com/webpack/webpack-dev-server/issues/216
const base = document.createElement('base')
base.href = window.location.origin
document.head.appendChild(base)
