"use strict"; // ES6

document.querySelector('body').classList.add('js');

// Random link support
document.querySelectorAll('.randomlink').forEach(r => {
  const links = r.querySelectorAll('a');
  r.innerHTML = links[Math.floor(Math.random() * links.length)].outerHTML;
})

// Random page picker
document.querySelector('.random-page').addEventListener('click', (e)=>{
  e.preventDefault();
  fetch('/tag-index.json').then(res=>res.json().then(tags=>{
    const random_tag = tags[Math.floor(Math.random() * tags.length)];
    window.location.href = '/' + random_tag;
  }));
})

// Raw source viewer
document.querySelector('.show-raw').addEventListener('click', (e)=>{
  e.preventDefault();
  document.querySelector('.show-raw').innerHTML = '';
  document.querySelector('article section').innerHTML = '<pre style="white-space: pre-wrap;">' + document.getElementById('raw').innerText + '</pre>';
});

// Wanted pages list
document.querySelectorAll('#wanted-pages').forEach(ul => {
  fetch ('/missing-pages.json').then(res=>res.json().then(tags=>{
    ul.innerHTML = tags.map(tag => `<li><a href="/${tag}" class="internal broken">${tag}</a></li>`).join('')
  }));
});
