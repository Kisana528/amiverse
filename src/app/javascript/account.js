window.onload = () => {
  window.addEventListener('scroll', () => {
    let elem = document.getElementById('banner-container')
    let scrollY = window.scrollY/2000 + 1
    if(scrollY > 1.5) scrollY = 1.5
    elem.style.transform = 'scale(' + scrollY + ')'
  })

  const header = document.getElementById('name-container')
  const observer = new IntersectionObserver(entries => {
    for (const entry of entries) {
      if (entry.isIntersecting) {
        header.classList.remove('fixed')
      } else {
        header.classList.add('fixed')
      }
    }
  })
  observer.observe(document.getElementById('name-before'))
  document.getElementById('account-container').classList.add('loaded')
}