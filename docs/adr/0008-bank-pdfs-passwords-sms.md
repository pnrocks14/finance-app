# 0008: Bank PDFs, statement passwords and the SMS parser

- Status: accepted
- Date: 2026-10-18

## Context

Many banks email statements only as password-protected PDFs, and some apps
(SBI YONO) download password-protected Excel files. Each bank builds the
password from a different mix of name, date of birth, mobile number,
customer ID and card digits. The published rules disagree with each other
between sources and change over time. Kartick also wants SMS to fill gaps
later, and bank SMS layouts vary as much as statements do.

## Decision

- **Read text PDFs** with PDFium and a generic row parser that relies on the
  balance column for direction rather than per-bank layouts. Scanned PDFs
  are not supported; there is no OCR.
- **Try every rule, don't guess the bank.** The password step accepts a
  typed password, or details from which `statementPasswordCandidates` builds
  about twenty candidates. Details are never stored. Only a password that
  worked is stored, in the secure store, when the user ticks Remember, and
  at most 8 are kept.
- **No Excel import for now.** XLS/XLSX needs a parser and, for YONO, a
  decryptor. Users are asked to choose CSV or PDF.
- **Parse SMS now, read the inbox in phase 5.** The parser is pure Dart and
  tested against made-up messages in each bank's layout. It is conservative:
  anything that isn't plainly a completed transaction returns null.

## Consequences

- A new bank's PDF usually works without code changes; one that doesn't
  shows its rows in the import report.
- A bank with an unusual password rule needs one more line in the candidate
  generator and the hints list.
- SMS templates will need upkeep as banks change wording; the tests list the
  layouts known so far in knowledge/formats/README.md.
