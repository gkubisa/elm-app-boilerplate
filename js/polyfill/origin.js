// window.location.origin polyfill for IE, see:
// http://stackoverflow.com/questions/22564167/window-location-origin-gives-wrong-value-when-using-ie
if (!window.location.origin) {
  window.location.origin = window.location.protocol + '//'
    + window.location.hostname
    + (window.location.port ? ':' + window.location.port : '')
}

// HTMLAnchorElement.prototype.origin polyfill for IE
if (!HTMLAnchorElement.prototype.hasOwnProperty('origin')) {
  Object.defineProperty(HTMLAnchorElement.prototype, 'origin', {
    get: function() {
      return this.protocol + '//'
        + this.hostname
        + (this.port ? ':' + this.port : '')
    },
    enumerable: true,
    configurable: true
  })
}
