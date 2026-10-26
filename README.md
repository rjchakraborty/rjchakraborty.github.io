# Raja Chakraborty - portfolio and resume

Static, accessible portfolio hosted through GitHub Pages at
[rjchakraborty.github.io](https://rjchakraborty.github.io/).

The page presents professional positioning, delivery capabilities, recent
open-source work, selected production products, experience, and contact links.

## Local preview

```sh
python3 -m http.server 8000
```

Open `http://localhost:8000/`.

## Downloadable resume

The editable resume text is in `resume/content.json`. Install ReportLab with
`python3 -m pip install -r resume/requirements.txt`, then run `python3 resume/build_resume.py`.
The build uses `assets/images/profile.png` and updates the linked PDF in `assets/`.

## Deployment

GitHub Pages deploys the `main` branch. Keep project claims linked to public,
verifiable sources and update `sitemap.xml` when the canonical page changes.
