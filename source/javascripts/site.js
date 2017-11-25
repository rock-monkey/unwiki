"use strict"; // ES6

document.querySelector('body').classList.add('js');

// Random link support
document.querySelectorAll('.randomlink').forEach(r => {
  const links = r.querySelectorAll('a');
  r.innerHTML = links[Math.floor(Math.random() * links.length)].outerHTML;
})

// Raw source viewer
document.querySelector('.show-raw').addEventListener('click', (e)=>{
  e.preventDefault();
  document.querySelector('.show-raw').innerHTML = '';
  document.querySelector('article section').innerHTML = '<pre style="white-space: pre-wrap;">' + document.getElementById('raw').innerText + '</pre>';
});
