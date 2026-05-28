import { useEffect } from 'react'
import Header from './components/Header'
import Hero from './components/Hero'
import About from './components/About'
import Projects from './components/Projects'
import Footer from './components/Footer'

export default function App() {
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('reveal--visible')
          }
        })
      },
      { threshold: 0.2 }
    )

    const nodes = document.querySelectorAll('.reveal')
    nodes.forEach((node) => observer.observe(node))

    return () => observer.disconnect()
  }, [])

  return (
    <>
      <a className="skip-link" href="#home">
        Skip to content
      </a>
      <Header />
      <main>
        <Hero />
        <About />
        <Projects />
      </main>
      <Footer />
    </>
  )
}
