import { projects } from '../data/projects'

export default function Projects() {
  return (
    <section className="projects reveal" id="projects">
      <div className="section-head">
        <p className="section-head__kicker">Portfolio</p>
        <h2>Cloud and DevOps projects built for production reality</h2>
      </div>
      <div className="project-grid">
        {projects.map((project) => (
          <article className="project-card" key={project.title}>
            <img src={project.image} alt={project.title} loading="lazy" className="project-card__image" />
            <div className="project-card__body">
              <h3>{project.title}</h3>
              <p>{project.description}</p>
              <div className="project-card__actions">
                <a href={project.github} target="_blank" rel="noopener noreferrer" className="btn btn--solid btn--small">
                  GitHub
                </a>
                {project.live ? (
                  <a href={project.live} target="_blank" rel="noopener noreferrer" className="btn btn--ghost btn--small">
                    Live
                  </a>
                ) : null}
              </div>
            </div>
          </article>
        ))}
      </div>
    </section>
  )
}
