import '../../../styles/definitions/modules/checkbox'
import '../../../styles/definitions/modules/checkbox.less'
import $ from 'jquery'

/**
 * Watches the DOM and initializes Semantic UI Checkbox module on newly added
 * nodes.
 */
$(() => {
  $('.ui.checkbox').checkbox()

  new MutationObserver(changes => {
    changes.forEach(change => {
      if (change.addedNodes.length > 0) {
        $(change.addedNodes).find('.ui.checkbox').checkbox()
      }
    })
  }).observe(document.body, {
    childList: true,
    subtree: true
  })
})
