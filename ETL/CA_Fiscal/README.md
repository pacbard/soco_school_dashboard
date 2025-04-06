# Data

- [Annual Fiancial Data](https://www.cde.ca.gov/ds/fd/fd/)
- [J90 Data - Salaries](https://www.cde.ca.gov/ds/fd/cs/)
- [SACS Data Viwer](https://www.cde.ca.gov/ds/fd/dv/)

# Requirements

- `brew install mdbtools`

# Build Data
- `python download.py`
- `python etl.py  --output-dir data/<database>/processed data/<database>/raw`
- `find queries/ -name "*.sql" -exec duckdb -f {} \;`

# Database
- **UserGL**: General ledger. Size: 181M
- **UserGLTotals**: General ledger totals. Size: 113M
- **LEAs**: Local Education Agency database with ADA totals. Size: 155K
- **Object**: Object code to description tables. Size: 13K