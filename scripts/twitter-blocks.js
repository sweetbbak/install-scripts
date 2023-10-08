;(async () => {
  const waitSeconds = 0.8 // How long to wait in between blocking accounts, in
  // seconds. If you're getting rate limited or logged out, try increasing this
  // time span so that you're not making too many requests too quickly.
  const waitForElement = selector =>
    new Promise(resolve => {
      let element = document.querySelector(selector)
      if (element) {
        resolve(element)
        return
      }
      const observer = new MutationObserver(() => {
        element = document.querySelector(selector)
        if (element) {
          observer.disconnect()
          resolve(element)
        }
      })
      observer.observe(document.body, { childList: true, subtree: true })
    })
  const createVisualLog = () => {
    // Create a visual log to show what's happening
    let log = document.getElementById('visual-log')
    if (log) {
      return log
    }
    log = document.createElement('div')
    log.id = 'visual-log'
    log.style.position = 'fixed'
    log.style.bottom = '0'
    log.style.left = '0'
    log.style.zIndex = '9999'
    log.style.backgroundColor = 'white'
    log.style.padding = '1em'
    log.style.border = '1px solid black'
    log.style.borderRadius = '1em'
    log.style.margin = '1em'
    log.style.maxHeight = '50vh'
    log.style.maxWidth = '50vw'
    log.style.overflowY = 'scroll'
    log.style.fontFamily = 'monospace'
    document.body.appendChild(log)
    return log
  }
  const log = createVisualLog()
  const logMessage = message => {
    // add a message element that fades out and is removed after 5 seconds
    const messageElement = document.createElement('div')
    messageElement.innerText = message
    messageElement.style.opacity = '1'
    messageElement.style.transition = 'opacity 1s'
    messageElement.style.marginBottom = '0.5em'
    log.appendChild(messageElement)
    setTimeout(() => {
      messageElement.style.opacity = '0'
      setTimeout(() => {
        log.removeChild(messageElement)
      }, 1000)
    }, 4000)
  }
  let more
  while (
    (more = document.querySelector(
      '[role="article"]:has(> * > * > * > * > * > * > * > * > * > * > * > * > * > * > * > [aria-label="Verified account"] > g > path:not([clip-rule="evenodd"])) [aria-label="More"]'
    ))
  ) {
    const username = [
      ...more
        .closest('[role="article"]')
        .querySelector('[data-testid="User-Name"]')
        .querySelectorAll('[role="link"]:not(:has(time))')
    ]
      .map(el => el.innerText)
      .join(' ')
    more.click()
    ;(await waitForElement('[data-testid="block"]')).click()
    ;(await waitForElement('[data-testid="confirmationSheetConfirm"]')).click()
    logMessage(`Blocked ${username}`)
    await new Promise(resolve => setTimeout(resolve, waitSeconds * 1000))
  }
  logMessage('No more verified accounts to block')
})()
