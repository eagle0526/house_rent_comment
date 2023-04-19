export function dispatchAction(action) {
  const evt = new CustomEvent(action)
  window.dispatchEvent(evt)     
}


