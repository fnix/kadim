addEventListener('resumable-upload:initialize', event => {
  const { target, detail } = event
  const { id, file } = detail
  target.insertAdjacentHTML('beforebegin', `
    <div id="resumable-upload-${id}" class="resumable-upload resumable-upload--pending">
      <div id="resumable-upload-progress-${id}" class="resumable-upload__progress" style="width: 0%"></div>
      <span class="resumable-upload__filename">${file.name}</span>
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
  progressElement.style.width = `${progress}%`
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
