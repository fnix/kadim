addEventListener('resumable-upload:initialize', event => {
  const { target, detail } = event
  const { id, file } = detail
  target.parentNode.parentNode.insertAdjacentHTML('beforebegin', `
    <div id="resumable-upload-${id}" class="resumable-upload resumable-upload--pending">
      <span>${file.name}</span>
      <progress id="resumable-upload-progress-${id}" class="progress" value="0" max="100"></progress>
    </div>
  `)
})

addEventListener('resumable-upload:start', event => {
  const { id } = event.detail
  const element = document.getElementById(`resumable-upload-${id}`)
  element.classList.remove('resumable-upload--pending')
})

addEventListener('resumable-upload:progress', event => {
  const { id, progress } = event.detail
  const progressElement = document.getElementById(`resumable-upload-progress-${id}`)
  progressElement.value = Math.round(progress)
})

addEventListener('resumable-upload:error', event => {
  event.preventDefault()
  const { id, error } = event.detail
  const element = document.getElementById(`resumable-upload-${id}`)
  element.classList.add('resumable-upload--error')
  element.setAttribute('title', error)
})

addEventListener('resumable-upload:end', event => {
  const { id } = event.detail
  const element = document.getElementById(`resumable-upload-${id}`)
  element.classList.add('resumable-upload--complete')
})
