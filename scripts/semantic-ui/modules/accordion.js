import '../../../styles/definitions/modules/accordion'
import '../../../styles/definitions/modules/accordion.less'
import $ from 'jquery'

/**
 * Watches the DOM and initializes Semantic UI Accordion module on newly added
 * nodes.
 */
$(() => {
  $('.ui.accordion').accordion()

  new MutationObserver(changes => {
    changes.forEach(change => {
      if (change.addedNodes.length > 0) {
        $(change.addedNodes).find('.ui.accordion').accordion()
      }
    })
  }).observe(document.body, {
    childList: true,
    subtree: true
  })
})
