"use strict"; // ES6

document.querySelector('body').classList.add('js');

document.querySelector('.show-raw').addEventListener('click', (e)=>{
  e.preventDefault();
  document.querySelector('.show-raw').innerHTML = '';
  document.querySelector('article section').innerHTML = '<pre style="white-space: pre-wrap;">' + document.getElementById('raw').innerText + '</pre>';
});
