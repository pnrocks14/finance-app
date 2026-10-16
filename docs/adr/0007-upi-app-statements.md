# 0007: UPI app statements, joined to bank rows by UPI reference

- Status: accepted
- Date: 2026-10-17

## Context

Kartick shared real exports: a Kotak CSV, a PhonePe CSV, a 39-page Google Pay
PDF and a card SMS. Most of his spending is UPI, paid from two bank accounts
and a RuPay credit card through Google Pay and PhonePe. The app statements
name the real payee in full ("SHARMA DAIRY"), give the exact time, and say
which account or card paid. Bank narrations cut names to 14 characters and
sometimes show the merchant's account holder instead of the shop. Both carry
the same 12-digit UPI reference.

## Decision

- **App statements are a source of their own** (`source_kind =
  upi_app_row`). One statement spans several accounts and cards, so each row
  goes to the account its instrument maps to ("Kotak Mahindra Bank 7890",
  "XXXXXXXX4321", "Unity Small Finance Bank Ltd XX65 | RuPay credit card").
  The preview suggests an account by last digits, then by bank name, and adds
  a new account for anything unmatched. You can change each mapping.
- **One payment, one transaction.** A new row whose UPI reference, direction
  and amount match a transaction from the other kind of source is joined to
  it instead of creating a second one. This works in either order. The bank
  statement decides the account; the app supplies the payee name and time.
- **Self transfers** that the app labels as such get `flow_reason =
  self_transfer`, which transfer detection leaves alone.
- **Transfer pairs** now need matching UPI references when both sides have
  one. Without this, two unrelated ₹20 payments on different accounts paired
  up in the real data.
- **Card bills:** a bank debit to the bank behind one of your credit cards
  (`UNITY SMALL FI`, `UNITY SMALL FINANCE BANK LIMITED`) or a "topup" to a
  bank is a card bill.
- **Google Pay PDFs** are read with PDFium (`pdfrx`) on the device. The
  parser finds each field by its shape inside each dated entry, because
  extractors order the text differently; it was checked against PDFium,
  poppler and pypdf output of the real file (346 entries, totals match). The
  totals printed on the statement are a checksum.
- **Bank charges and interest** (`CHRG:…`, `Int.Pd:…`) get readable names.
- **Accounts** may store 2 to 4 last digits, since Google Pay shows only two
  for cards.

## Consequences

- No schema change: the new enum values are stored as text.
- The counterpart of a self transfer (the credit in the receiving account) is
  not created from the app statement. It arrives with that account's own
  statement and pairs up then.
- Bank PDFs, password-protected PDFs and Excel exports are still to come.
