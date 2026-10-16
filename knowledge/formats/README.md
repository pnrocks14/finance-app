# Statement and SMS formats seen in real exports

Layouts only. Every name and number below is made up; the real files stay
on Kartick's phone and are never committed.

## Kotak Mahindra Bank, net banking CSV

- About 12 lines of account details (name, address, CRN, account number,
  IFSC) before the table. Skip them; never store them.
- Header: `Sl. No., Transaction Date, Value Date, Description, Chq /Ref No.,
  Amount, Dr / Cr, Balance, Dr / Cr` (two `Dr / Cr` columns: the first is the
  amount's, the second the balance's).
- Dates: `01-07-2026 09:46:50` (transaction), `01-07-2026` (value).
- Amounts: `2,000.00` with `DR`/`CR`.
- UPI narration: `UPI/<payee, cut to 14 chars>/<bank code>/<12-digit UPI
  ref>/<note>`, e.g. `UPI/TEA STALL OWN/FDRL/611122223333/Pay to Bhara`.
  Bank codes seen: KKBK, FDRL, UTIB, HDFC, BARB, YESB, ICIC, SBIN, UBIN,
  NSPB, IPOS (India Post Payments Bank), MAHG.
- The `Chq /Ref No.` column (`UPI-600000000001`) is not the UPI reference.
- Fees: `CHRG:SMS ALERT FEE FOR THE MONTH OF JUN26`. Interest:
  `Int.Pd:<account>:01-07-2026 to 30-09-2026`.
- Footer: `"Closing Balance","as on 30/09/2026 INR …"`, then "Important Note".

## PhonePe statement CSV

- Two preamble lines (`Transaction Statement for <phone>`, `Duration`).
- Header: `Date, Time, Transaction Details, Transaction ID, UTR, Transaction
  Type, Credit/debit instrument, Amount`.
- `Oct 14, 2026` + `05:39 pm`; `Paid to …` / `Received from …`; `T…` id; the
  UTR is the 12-digit UPI reference; `DEBIT`/`CREDIT`; `Paid by XXXXXXXX4321`
  or `Credited to XXXXXXXX4321`; amount without separators.
- A blank line, then a disclaimer.

## Google Pay statement PDF

- Header per page: "Transaction statement", phone, email. Page 1 adds the
  period and `Sent ₹… Received ₹…` totals (self transfers excluded).
- Each entry: `01 Jul, 2026`, `09:46 AM`, `Paid to …` / `Received from …` /
  `Self transfer to <bank> 4321`, `UPI Transaction ID: <12 digits>`,
  `Paid by <bank> 7890` (or `Paid to <bank> 7890` for money in, or
  `Paid by Unity Small Finance Bank Ltd XX65 | RuPay credit card`), `₹20`.
- Covers every account and card used in Google Pay, including a credit card.

## Card SMS (for phase 5)

Sender `VA-UNTYCC-S` (Roarbank card by Unity Small Finance Bank):

```
Rs. 220 spent at SOME PETROL DEPOT. Card: 1234 Time: 07/08/2026, 02:04pm.
Avl Limit: Rs. 640. Not you? Call <bank number>. -Roarbank by Unity SFB
```
