addEventListener('direct-upload:initialize', event => {
  const { target, detail } = event
  const { id, file } = detail
  target.insertAdjacentHTML('beforebegin', `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <span>${file.name}</span>
      <progress id="direct-upload-progress-${id}" class="progress" value="0" max="100"></progress>
    </div>
  `)
})

addEventListener('direct-upload:start', event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.remove('direct-upload--pending')
})

addEventListener('direct-upload:progress', event => {
  const { id, progress } = event.detail
  const progressElement = document.getElementById(`direct-upload-progress-${id}`)
  progressElement.value = Math.round(progress)
})

addEventListener('direct-upload:error', event => {
  event.preventDefault()
  const { id, error } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add('direct-upload--error')
  element.setAttribute('title', error)
})

addEventListener('direct-upload:end', event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add('direct-upload--complete')
})
