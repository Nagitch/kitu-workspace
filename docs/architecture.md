# Architecture notes

This workspace coordinates three independently versioned repositories.

## Repositories

- `kitu/`: main logic processor and integration surface.
- `tanu-markdown/`: markdown-oriented parsing and document representation layer.
- `tsq1/`: query/runtime layer used by Kitu.

## Boundary rule

Keep shared behavior explicit at repository boundaries. When one repository depends on behavior from another, document the expected API, data format, or compatibility assumption in the relevant repository and, if it affects multiple projects, summarize it here.
