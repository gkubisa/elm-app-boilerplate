require('../../../styles/definitions/modules/accordion')
require('../../../styles/definitions/modules/accordion.less')
const $ = require('jquery')

/**
 * Watches the DOM and initializes Semantic UI Accordion module on newly added
 * nodes.
 */
$(function () {
  $('.ui.accordion').accordion()

  new MutationObserver(function (changes) {
    changes.forEach(function (change) {
      if (change.addedNodes.length > 0) {
        $(change.addedNodes).find('.ui.accordion').accordion()
      }
    })
  }).observe(document.body, {
    childList: true,
    subtree: true
  })
})
