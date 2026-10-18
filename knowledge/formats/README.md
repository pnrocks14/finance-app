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

## Other banks' CSV variants

- **Canara Bank:** `Txn Date, Value Date, Cheque No., Description, Branch
  Code, Debit, Credit, Balance`. Numbers are written as Excel formulas,
  `="000123"`, which the reader unwraps. The `Branch Code` column tells it
  apart from SBI.
- **HDFC "delimited" download:** headers cut to width (`Value Dat`,
  `Chq/Ref Number`), and `**Continue**` rows where a page broke.
- **Credit card CSVs** (ICICI and others): one amount column with a sign
  column (`Billing Amount Sign`, `Transaction Type`) that is `CR` for
  payments and empty for spends.
- **SBI YONO:** password-protected XLSX. Not supported; use net banking's
  CSV or PDF.
- Footers seen: `Legends Used`, `Branch Address`, `Statement Summary`.

## Statement PDF passwords

Published rules, as found in banks' help pages and community parsers in
October 2026. Sources disagree and banks change them, so the app tries them
all (`statementPasswordCandidates`). Examples use the made-up customer Asha
Kumar, born 05/01/1990, mobile 9876543210, customer ID 12345678, card 4321.

| Bank or issuer | Rule | Example |
| --- | --- | --- |
| Axis, Union, Federal, IndusInd, SBI Card | first 4 letters of name (caps) + DDMM | ASHA0501 |
| ICICI card, Bank of Baroda | first 4 letters (lower) + DDMM | asha0501 |
| Kotak, IDFC First | DOB DDMMYYYY (Kotak also uses the CRN) | 05011990 |
| HDFC account, Canara, AU | customer ID | 12345678 |
| HDFC card | first 4 letters (caps) + card last 4 | ASHA4321 |
| SBI e-statement | last 5 mobile digits + DDMMYY | 43210050190 |
| SBI Card (older) | DDMMYYYY + card last 4 | 050119904321 |
| Yes Bank | customer ID + DDMMYYYY | 1234567805011990 |
| India Post Payments Bank | first 4 letters (caps) + DDMMYY | ASHA050190 |
| PNB, SBI net banking | account number | (account number) |

## Bank SMS layouts

Placeholders in angle brackets. Senders are DLT headers `XX-NAME-S`; the
last letter is `S` (service), `T` (transactional), `G` (government) or `P`
(promotional, ignored).

| Sender | Layout |
| --- | --- |
| KOTAKD | `Sent Rs.<amt> from XXXXXX<4> to <payee> on <dd/mm/yyyy>. UPI ref no. <12>` |
| KOTAKB | `Received Rs. <amt> on <dd-mm-yy> in your Kotak Bank A/C x<4> by …` |
| HDFCBK | `Update! INR <amt> deposited in HDFC Bank A/c XX<4> on <dd-MON-yy> for <narration>.Avl bal INR <bal>` |
| ICICIT | `INR <amt> spent using ICICI Bank Card XX<4> on <dd-Mon-yy> on <merchant>. Avl Limit: INR <limit>` |
| SBICRD | `Rs.<amt> spent on your SBI Credit Card ending with <4> on <ddMonyy> at <merchant>.` (sometimes in bold Unicode letters) |
| AXISBK | `Spent INR <amt> / Axis Bank Card no. XX<4> / <dd-mm-yy hh:mm:ss> IST / <merchant> / Avl Limit: INR <limit>` |
| IDFCFB | `Your A/c XX<4> debited by Rs. <amt> on <dd/mm/yy>; <payee> credited. RRN <12>.` |
| INDUSB | `A/c *XX<4> debited by Rs <amt> towards <vpa>. RRN: <12>.` |
| PNBSMS | `Ac XX<4> Credited with Rs.<amt> <dd-mm-yyyy hh:mm:ss> thru UPI . … (UPI Ref ID:<12>)` |
| BOBTXN | `Rs.<amt> Dr. from A/c XX<6> on <dd-mm-yyyy>. AvlBal:Rs<bal>. Ref:<12>` |
| CANBNK | `Acct XXX<3> Dr. INR <amt> on <dd/mm/yy> to <payee>; UPI: <12>; Bal INR <bal>.` |
| FEDBNK | `Rs <amt> debited via UPI on <dd-mm-yyyy hh:mm:ss> to VPA <vpa>.Ref No <12>.` |
| JTEDGE | `Rs.<amt> debited to your Edge CSB Bank RuPay Credit Card ending <4> on <m/d/yy>, <time> - (UPI Ref no.<12>).` (US-style date) |
| DOPBNK | `Account No. XXXXXXXX<4> CREDIT with amount Rs. <amt> on <dd-mm-yyyy>.` |
