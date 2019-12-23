//= require rails-ujs
//= require activestorage
//= require activestorage-resumable
//= require_tree .
//= require_tree ../bulma

(function () {
  var burger = document.querySelector('.burger')
  var menu = document.querySelector('#' + burger.dataset.target)
  burger.addEventListener('click', function () {
    burger.classList.toggle('is-active')
    menu.classList.toggle('is-active')
  })
})()
