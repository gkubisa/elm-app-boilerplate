/**
 * Watches the DOM and initializes Semantic UI Checkbox module on newly added
 * nodes.
 */
$(function () {
  $('.ui.checkbox').checkbox()

  new MutationObserver(function (changes) {
    changes.forEach(function (change) {
      if (change.addedNodes.length > 0) {
        $(change.addedNodes).find('.ui.checkbox').checkbox()
      }
    })
  }).observe(document.body, {
    childList: true,
    subtree: true
  })
})
