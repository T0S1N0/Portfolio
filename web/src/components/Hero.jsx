export default function Hero() {
  return (
    <section className="hero reveal" id="home">
      <div className="hero__backdrop" aria-hidden="true" />
      <div className="hero__content">
        <p className="hero__eyebrow">Cloud Engineer and DevOps Specialist</p>
        <h1>Designing resilient cloud platforms with automation first</h1>
        <p className="hero__lead">
          I build secure Azure and multi-cloud infrastructure with Terraform, CI/CD, and operational excellence.
        </p>
        <div className="hero__actions">
          <a className="btn btn--solid" href="#projects">
            See Projects
          </a>
          <a className="btn btn--ghost" href="https://www.linkedin.com/in/miquel-martin-leiva/" target="_blank" rel="noopener noreferrer">
            Connect on LinkedIn
          </a>
        </div>
      </div>
      <aside className="hero__socials" aria-label="Social links">
        <a href="https://github.com/T0S1N0" target="_blank" rel="noopener noreferrer" aria-label="GitHub profile">
          <img src="/assets/png/github-ico.png" alt="" aria-hidden="true" />
        </a>
        <a href="https://www.linkedin.com/in/miquel-martin-leiva/" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn profile">
          <img src="/assets/png/linkedin-ico.png" alt="" aria-hidden="true" />
        </a>
      </aside>
    </section>
  )
}
