# resume_order

Versioned LaTeX resume workflow: edit a draft, promote it to current (archiving the old one), build a PDF.

## Layout

```
current_resume/   draft.tex (work in progress) and spatham_resume.tex (current)
previous_resume/  archived resumes, named <name>_MM_DD_YYYY.tex
pdf/              built PDF output
yaml/             per-script path config (relative to repo root; ~ expanded)
```

## Scripts

- `promote_draft.sh [draft.tex]`: moves the current resume to `previous_resume/` with today's date, then moves the draft into its place. Refuses to overwrite an existing archive for the same day. Paths from `yaml/promote_draft.yaml`.
- `convert_to_pdf.sh [file.tex]`: compiles the current resume (or the given file) with `pdflatex` in a temp dir and writes the PDF to `pdf/`. On failure, keeps the build dir and prints the log path. Paths from `yaml/convert_to_pdf.yaml`.

## Typical flow

```
# edit current_resume/draft.tex
./promote_draft.sh
./convert_to_pdf.sh
```

## Requirements

`bash`, `python3` with PyYAML, `pdflatex`.
