# resume_order

Versioned LaTeX resume workflow that stores previous versions of resumes, and converts latex to pdf formatting.

## Layout

```
current_resume/   draft.tex (work in progress) and spatham_resume.tex (current)
previous_resume/  archived resumes, named <name>_MM_DD_YYYY.tex
pdf/              built PDF output
yaml/             per-script path config (relative to repo root; ~ expanded)
```

## Scripts

- `promote_draft.sh <resume-name>`: moves the named current resume to `previous_resume/<resume-name>_MM_DD_YYYY.tex`, then moves `current_resume/draft.tex` into its place. The `.tex` extension is optional. If the named resume does not exist, the draft becomes its first version. Refuses to overwrite an existing archive for the same day. Paths come from `yaml/promote_draft.yaml`.
- `convert_to_pdf.sh [resume-name or file.tex]`: compiles the named resume from `current_resume/` (or an explicitly supplied file path) with `pdflatex` and overwrites `pdf/spatham_resume.pdf`. The `.tex` extension is optional for a resume name. With no argument, it uses the configured default. On failure, it keeps the build directory and prints the log path. Paths come from `yaml/convert_to_pdf.yaml`.

## Typical flow

```
# edit current_resume/draft.tex
./promote_draft.sh spatham_resume_embedded
./convert_to_pdf.sh spatham_resume_embedded
```

## Requirements

`bash`, `python3` with PyYAML, `pdflatex`.
