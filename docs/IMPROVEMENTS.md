# Portfolio – Improvement Proposals

Review of the portfolio project with concrete, prioritized improvements.

---

## High priority (content & correctness)

### 1. Replace placeholder content
- **About section**: The subheading still says *"Lorem ipsum dolor sit amet..."* — replace with a short, real tagline (e.g. focus on cloud, DevOps, automation).
- **Footer**: *"Lorem ipsum dolor sit amet..."* and *"Copyright 2021. Made by Ram Maheshwari"* — replace with your own short bio and credit: e.g. *"© 2026 Miquel Martin Leiva"*.

### 2. Contact form does nothing
- Form uses `action="#"` and has no backend. Options:
  - **mailto:** — `action="mailto:your@email.com"` (opens email client).
  - **Formspree / Netlify Forms** — free tier, no backend needed; add their `action` and optionally `method="POST"`.
  - Or remove the form and replace with a clear CTA: “Reach me on LinkedIn” / “Email me at …”.

### 3. Email input type
- Use `type="email"` (and optionally `inputmode="email"`) for the email field for validation and better mobile keyboards.

### 4. “Coming Soon” project link
- Third project uses `href="#"` with `target="_blank"` (opens new tab to same page). Prefer `href="./#projects"` or `javascript:void(0)` and remove `target="_blank"`, or make it a disabled/plain button so it’s clear there’s no external link.

---

## Accessibility & SEO

### 5. Social and icon `alt` text
- Icons use `alt="icon"`. Use descriptive text, e.g.:
  - `alt="LinkedIn profile of Miquel Martin Leiva"`
  - `alt="GitHub profile"`

### 6. Focus styles
- `outline: none` on `input`, `button`, `a`, `textarea` removes the focus ring and hurts keyboard users. Use `:focus-visible` with a visible outline (e.g. 2px solid brand color) instead of removing outline globally.

### 7. Skip link
- Add a “Skip to main content” link at the top (visible on focus) that targets `#about` or the first main section for screen reader and keyboard users.

### 8. CV visibility
- The CV (`miquel-martin-cv.pdf`) is in the repo and deployed but not linked. Add a clear “Download CV” or “Resume” link in the header and/or About/Contact so visitors can download it.

---

## Technical fixes

### 9. CSS background image path
- In `src/css/style.css`, hero/contact backgrounds use `url(../../assets/svg/common-bg.svg)`. From `src/css/`, one level up is `src/`, so the correct path is `../assets/svg/common-bg.svg`. Using `../` keeps paths correct when the site is served from `src/` as document root (e.g. local dev).

### 10. Typo in JavaScript
- In `index.js`, rename `headerLogoConatiner` to `headerLogoContainer`.

### 11. External links security
- All `target="_blank"` links should use `rel="noopener noreferrer"` to avoid tab-nabbing and unnecessary referrer leakage. Footer already has `rel="noreferrer"`; add `noopener` there and to hero/footer social links.

### 12. Deploy workflow – storage account name
- `deploy.yml` hardcodes the storage account name (`stportfolio21ecb97f`). If you recreate infrastructure, the name can change (e.g. different hash). Prefer passing the storage account name from Terraform output (e.g. from the plan/apply job) into the upload and validation steps so one source of truth.

### 13. Validation step
- In `validate-deployment`, the health check has a duplicate condition (`"200" || "200"`). Keep a single check and optionally use the URL from Terraform output (see above).

---

## Content & UX

### 14. Project images
- All three projects use the same image (`project-mockup-example.jpeg`). Use different screenshots or graphics per project (or clear “Coming soon” placeholders) so the section feels intentional.

### 15. Ham menu accessibility
- Hamburger control has no `aria-expanded` / `aria-controls` and no `aria-label`. Add `aria-label="Open menu"` / `"Close menu"` and toggle `aria-expanded` so screen readers know the state.

### 16. Form labels and validation
- Labels are correctly associated with inputs. Consider client-side validation (e.g. required, email format) and clear error messages; if you add Formspree/Netlify, they can handle server-side validation.

---

## Infrastructure & CI/CD (optional)

### 17. Terraform vs GitHub upload
- Terraform uploads `index.html` and CV via `azurerm_storage_blob`; the workflow then runs `az storage blob upload-batch` from `src/`. Both end up uploading the same files. Options: (a) rely only on the workflow for all uploads and remove blob resources from Terraform, or (b) document that the workflow is the source of truth for content and treat Terraform blobs as optional/legacy. Either way, avoid conflicting expectations.

### 18. Terraform state
- `main.tf` already has an `azurerm` backend block. If you use it, ensure the storage account and container exist and that CI has permissions; otherwise PRs that run `terraform init` may fail without backend config.

### 19. Lint workflow
- `lint.yml` uses `terraform init -backend=false` for validation, which is good when the backend is not available in PRs. Keep this so lint doesn’t depend on Azure state.

---

## Summary

| Area           | Count | Suggested order |
|----------------|-------|------------------|
| Content/copy   | 4     | Do first         |
| Accessibility  | 4     | Do early         |
| Technical      | 5     | Quick wins       |
| UX/content     | 2     | When refining    |
| Infra/CI       | 3     | As needed        |

Recommended next steps: apply the high-priority content and technical fixes (1–4, 9–11), then accessibility (5–8, 15), then workflow and infra (12–13, 17–18) if you want the pipeline to be robust and maintainable.
