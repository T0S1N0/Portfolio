// ---
const hamMenuBtn = document.querySelector('.header__main-ham-menu-cont')
const smallMenu = document.querySelector('.header__sm-menu')
const headerHamMenuBtn = document.querySelector('.header__main-ham-menu')
const headerHamMenuCloseBtn = document.querySelector(
  '.header__main-ham-menu-close'
)
const headerSmallMenuLinks = document.querySelectorAll('.header__sm-menu-link')

hamMenuBtn.addEventListener('click', () => {
  const isOpen = smallMenu.classList.contains('header__sm-menu--active')
  if (isOpen) {
    smallMenu.classList.remove('header__sm-menu--active')
    headerHamMenuBtn.classList.remove('d-none')
    headerHamMenuCloseBtn.classList.add('d-none')
    hamMenuBtn.setAttribute('aria-expanded', 'false')
    hamMenuBtn.setAttribute('aria-label', 'Open menu')
  } else {
    smallMenu.classList.add('header__sm-menu--active')
    headerHamMenuBtn.classList.add('d-none')
    headerHamMenuCloseBtn.classList.remove('d-none')
    hamMenuBtn.setAttribute('aria-expanded', 'true')
    hamMenuBtn.setAttribute('aria-label', 'Close menu')
  }
})

for (let i = 0; i < headerSmallMenuLinks.length; i++) {
  headerSmallMenuLinks[i].addEventListener('click', () => {
    smallMenu.classList.remove('header__sm-menu--active')
    headerHamMenuBtn.classList.remove('d-none')
    headerHamMenuCloseBtn.classList.add('d-none')
  })
}

// ---
const headerLogoContainer = document.querySelector('.header__logo-container')

headerLogoContainer.addEventListener('click', () => {
  location.href = 'index.html'
})
