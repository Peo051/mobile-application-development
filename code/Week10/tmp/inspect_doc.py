from docx import Document
import sys

doc = Document(sys.argv[1])
for i, paragraph in enumerate(doc.paragraphs):
    if 'schema' in paragraph.text.lower() or 'SQL Server hoạt động' in paragraph.text:
        print(i, repr(paragraph.text))
