import { useState } from 'react'

const navItems = [
  { href: '#home', label: 'Home' },
  { href: '#about', label: 'About' },
  { href: '#projects', label: 'Projects' },
  { href: '#contact', label: 'Contact' }
]

export default function Header() {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <header className="site-header">
      <a href="#home" className="brand" aria-label="Go to top of page">
        <img src="/assets/png/profile.jpg" alt="Portrait of Miquel Martin Leiva" className="brand__image" />
        <span className="brand__text">Miquel Martin</span>
      </a>

      <button
        className="menu-toggle"
        type="button"
        aria-expanded={isOpen}
        aria-controls="primary-nav"
        aria-label={isOpen ? 'Close navigation menu' : 'Open navigation menu'}
        onClick={() => setIsOpen((prev) => !prev)}
      >
        <img
          src={isOpen ? '/assets/svg/ham-menu-close.svg' : '/assets/svg/ham-menu.svg'}
          alt=""
          aria-hidden="true"
        />
      </button>

      <nav id="primary-nav" className={`site-nav ${isOpen ? 'site-nav--open' : ''}`}>
        <ul>
          {navItems.map((item) => (
            <li key={item.href}>
              <a href={item.href} onClick={() => setIsOpen(false)}>
                {item.label}
              </a>
            </li>
          ))}
        </ul>
        <a className="cv-btn" href="/miquel-martin-cv.pdf" target="_blank" rel="noopener noreferrer">
          Download CV
        </a>
      </nav>
    </header>
  )
}
