const skills = [
  'Azure',
  'Terraform',
  'CI/CD',
  'Kubernetes',
  'Ansible',
  'Bash',
  'PowerShell',
  'Monitoring',
  'Security',
  'Automation'
]

export default function About() {
  return (
    <section className="about reveal" id="about">
      <div className="section-head">
        <p className="section-head__kicker">About</p>
        <h2>Infrastructure strategy with hands-on engineering delivery</h2>
      </div>
      <div className="about__grid">
        <article>
          <p>
            I am Miquel Martin Leiva, a cloud engineer focused on infrastructure as code, reliability, and secure automation.
            I have delivered remote projects for startups and teams that need fast, repeatable, and scalable cloud operations.
          </p>
          <p>
            My work combines architecture, deployment pipelines, and operational visibility so systems remain stable while teams ship faster.
          </p>
        </article>
        <aside>
          <h3>Core strengths</h3>
          <ul className="skill-list">
            {skills.map((skill) => (
              <li key={skill}>{skill}</li>
            ))}
          </ul>
        </aside>
      </div>
    </section>
  )
}
