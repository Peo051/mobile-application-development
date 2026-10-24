from docx import Document
import sys

doc = Document(sys.argv[1])
for ti, table in enumerate(doc.tables):
    for ri, row in enumerate(table.rows):
        for ci, cell in enumerate(row.cells):
            text = cell.text
            if any(word in text.lower() for word in ('schema', 'sql server hoạt động', 'chưa được scaffold', 'http 500')):
                print(ti, ri, ci, repr(text))
