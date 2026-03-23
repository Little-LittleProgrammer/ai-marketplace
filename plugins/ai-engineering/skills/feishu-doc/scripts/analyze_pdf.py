import argparse
import re
import shutil
import sys
import unicodedata
from pathlib import Path

import pdfplumber
import fitz  # PyMuPDF


WORKSPACE_ROOT = Path(__file__).resolve().parents[4]
DEFAULT_BASE_DIR = WORKSPACE_ROOT / "specs"


def parse_args():
    parser = argparse.ArgumentParser(
        description="Analyze a PDF file and export markdown plus extracted images."
    )
    parser.add_argument("pdf_path", help="Path to the source PDF file")
    parser.add_argument(
        "-t",
        "--title",
        help="Document title. Defaults to the PDF filename without extension.",
    )
    parser.add_argument(
        "-b",
        "--base-dir",
        default=str(DEFAULT_BASE_DIR),
        help=f"Base output directory. Defaults to {DEFAULT_BASE_DIR}",
    )
    parser.add_argument(
        "-q",
        "--quiet",
        action="store_true",
        help="Reduce console output",
    )
    return parser.parse_args()


def log(message, quiet=False):
    if not quiet:
        print(message)


def sanitize_title(title):
    sanitized = re.sub(r'[\\/:*?"<>|]+', "_", title.strip())
    sanitized = re.sub(r"\s+", " ", sanitized).strip(" .")
    return sanitized or "untitled"


def ensure_output_dirs(base_dir, title):
    output_dir = Path(base_dir).expanduser().resolve() / sanitize_title(title)
    images_dir = output_dir / "images"
    output_dir.mkdir(parents=True, exist_ok=True)
    if images_dir.exists():
        shutil.rmtree(images_dir)
    images_dir.mkdir(parents=True, exist_ok=True)
    return output_dir, images_dir


def copy_pdf(source_pdf, output_pdf, quiet=False):
    if source_pdf.resolve() == output_pdf.resolve():
        log(f"Skip copying PDF because source already matches: {output_pdf}", quiet)
        return
    shutil.copy2(source_pdf, output_pdf)
    log(f"Copied PDF to {output_pdf}", quiet)


def normalize_text(text):
    if not text:
        return ""
    text = unicodedata.normalize("NFKC", text)
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    text = "".join(
        ch for ch in text
        if ch in ("\n", "\t") or unicodedata.category(ch)[0] != "C"
    )
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n[ \t]+", "\n", text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def markdown_escape_table_cell(value):
    text = "" if value is None else normalize_text(str(value))
    text = text.replace("\n", "<br>")
    return text.replace("|", r"\|").strip()


def count_non_empty_cells(row):
    return sum(1 for cell in row if cell)


def trim_empty_edge_columns(rows):
    if not rows:
        return rows

    column_count = max(len(row) for row in rows)
    normalized_rows = [row + [""] * (column_count - len(row)) for row in rows]

    left = 0
    right = column_count - 1
    while left < column_count and all(not row[left] for row in normalized_rows):
        left += 1
    while right >= left and all(not row[right] for row in normalized_rows):
        right -= 1

    if left > right:
        return []
    return [row[left : right + 1] for row in normalized_rows]


def normalize_table_rows(table_rows):
    rows = [
        [normalize_text("" if cell is None else str(cell)) for cell in row]
        for row in (table_rows or [])
        if row
    ]
    rows = [row for row in rows if any(cell for cell in row)]
    rows = trim_empty_edge_columns(rows)
    return [row for row in rows if any(cell for cell in row)]


def row_contains_header_keywords(row):
    row_text = " ".join(cell for cell in row if cell)
    return any(keyword in row_text for keyword in ("字段", "说明", "是否筛选", "枚举", "示例"))


def find_header_row_index(rows):
    for idx, row in enumerate(rows[:3]):
        if count_non_empty_cells(row) >= 2 and row_contains_header_keywords(row):
            return idx
    for idx, row in enumerate(rows[:3]):
        if count_non_empty_cells(row) >= 2:
            return idx
    return None


def table_to_markdown(rows):
    if not rows:
        return ""

    column_count = max(len(row) for row in rows)
    normalized_rows = [row + [""] * (column_count - len(row)) for row in rows]
    header_index = find_header_row_index(normalized_rows) or 0
    header = normalized_rows[header_index]
    separator = ["---"] * column_count
    body = normalized_rows[header_index + 1 :] or [[""] * column_count]

    lines = [
        "| " + " | ".join(markdown_escape_table_cell(cell) for cell in header) + " |",
        "| " + " | ".join(separator) + " |",
    ]
    lines.extend(
        "| " + " | ".join(markdown_escape_table_cell(cell) for cell in row) + " |"
        for row in body
    )
    return "\n".join(lines)


def is_likely_real_table(rows):
    if len(rows) < 2:
        return False

    column_count = max(len(row) for row in rows)
    if column_count < 2:
        return False

    non_empty_counts = [count_non_empty_cells(row) for row in rows]
    if sum(1 for count in non_empty_counts if count >= 2) < 2:
        return False

    header_index = find_header_row_index(rows)
    if header_index is None:
        return False

    header = rows[header_index]
    long_cell_count = sum(
        1
        for row in rows
        for cell in row
        if len(cell) > 120 or cell.count("\n") > 6
    )
    if long_cell_count > max(2, len(rows)):
        return False

    numeric_only_cells = 0
    total_non_empty_cells = 0
    for row in rows:
        for cell in row:
            if not cell:
                continue
            total_non_empty_cells += 1
            if re.fullmatch(r"\d+", cell):
                numeric_only_cells += 1
    if total_non_empty_cells and numeric_only_cells / total_non_empty_cells > 0.5:
        return False

    return True


def extract_page_tables(page):
    tables = []
    for table in page.find_tables():
        rows = normalize_table_rows(table.extract())
        if is_likely_real_table(rows):
            tables.append({"bbox": table.bbox, "rows": rows})
    return tables


def merge_fragment_into_last_row(prev_rows, fragment):
    if not prev_rows or not fragment:
        return
    last_row = prev_rows[-1]
    for index in range(len(last_row) - 1, -1, -1):
        if last_row[index]:
            joiner = "" if last_row[index].endswith(("-", "_")) else "\n"
            last_row[index] = f"{last_row[index]}{joiner}{fragment}"
            return
    last_row[-1] = fragment


def rows_match_as_same_header(prev_row, curr_row):
    prev_tokens = [cell for cell in prev_row if cell]
    curr_tokens = [cell for cell in curr_row if cell]
    if not prev_tokens or not curr_tokens:
        return False
    overlap = sum(
        1 for prev_cell, curr_cell in zip(prev_row, curr_row)
        if prev_cell and curr_cell and (prev_cell == curr_cell or prev_cell in curr_cell or curr_cell in prev_cell)
    )
    return overlap >= max(2, min(len(prev_tokens), len(curr_tokens)) // 2)


def tables_are_continuation(prev_rows, curr_rows):
    if not prev_rows or not curr_rows:
        return False
    if max(len(row) for row in prev_rows) != max(len(row) for row in curr_rows):
        return False

    first_row_non_empty = count_non_empty_cells(curr_rows[0])
    if first_row_non_empty <= 1:
        return True

    prev_header_index = find_header_row_index(prev_rows)
    curr_header_index = find_header_row_index(curr_rows)
    if prev_header_index is None or curr_header_index is None:
        return False

    if rows_match_as_same_header(prev_rows[prev_header_index], curr_rows[curr_header_index]):
        return True

    return not row_contains_header_keywords(curr_rows[curr_header_index])


def merge_table_rows(prev_rows, curr_rows):
    merged_rows = [row[:] for row in prev_rows]
    remaining_rows = [row[:] for row in curr_rows]

    while remaining_rows and count_non_empty_cells(remaining_rows[0]) <= 1:
        fragment = next((cell for cell in remaining_rows[0] if cell), "")
        merge_fragment_into_last_row(merged_rows, fragment)
        remaining_rows.pop(0)

    if not remaining_rows:
        return merged_rows

    prev_header_index = find_header_row_index(merged_rows)
    curr_header_index = find_header_row_index(remaining_rows)
    if (
        prev_header_index is not None
        and curr_header_index is not None
        and rows_match_as_same_header(merged_rows[prev_header_index], remaining_rows[curr_header_index])
    ):
        remaining_rows = remaining_rows[curr_header_index + 1 :]

    merged_rows.extend(remaining_rows)
    return merged_rows


def bbox_overlaps(bbox1, bbox2):
    x0, top0, x1, bottom0 = bbox1
    x2, top2, x3, bottom2 = bbox2
    return not (x1 <= x2 or x3 <= x0 or bottom0 <= top2 or bottom2 <= top0)


def extract_page_text(page, accepted_tables):
    if not accepted_tables:
        return normalize_text(page.extract_text() or "")

    filtered_page = page.filter(
        lambda obj: not any(
            bbox_overlaps(
                (obj.get("x0", 0), obj.get("top", 0), obj.get("x1", 0), obj.get("bottom", 0)),
                table["bbox"],
            )
            for table in accepted_tables
        )
    )
    return normalize_text(filtered_page.extract_text() or "")


def split_code_line(line):
    match = re.match(r"^\s*(\d+)\s+(.*)$", line)
    if not match:
        return None
    return int(match.group(1)), match.group(2)


def is_line_number_only(line):
    return bool(re.fullmatch(r"\d+", line.strip()))


def strip_code_prefix(line):
    parsed = split_code_line(line)
    return parsed[1].rstrip() if parsed else line.rstrip()


def is_code_like_line(line):
    candidate = strip_code_prefix(line).strip()
    if not candidate:
        return False

    return bool(
        re.search(
            r"(^//|^--|^\{|\}$|^\]|\[$|^SELECT\b|^FROM\b|^WHERE\b|^AND\b|^OR\b|^LEFT JOIN\b|^RIGHT JOIN\b|^INNER JOIN\b|^UNION\b|^LIMIT\b|^ORDER BY\b|^CREATE\b|^UPDATE\b|^DELETE\b|^INSERT\b|[{}();=]|\bAS\b|:\w+|/\w[\w/-]*)",
            candidate,
            re.I,
        )
    )


def is_code_break_line(line):
    candidate = line.strip()
    if not candidate:
        return True
    if re.match(r"^[•◦▪]", candidate):
        return True

    return bool(
        re.match(
            r"^(参考[:：]|字段\b|说明\b|测试影响范围\b|上线前后checklist\b|其他同步或注意事项\b|[一二三四五六七八九十]+、)",
            candidate,
        )
    )


def format_code_block(lines):
    code_lines = [strip_code_prefix(line) for line in lines]
    return "\n".join(["```", *code_lines, "```"])


def postprocess_page_markdown(lines):
    processed = []
    code_buffer = []
    in_code_block = False

    def flush_code_buffer():
        nonlocal code_buffer, in_code_block
        if code_buffer:
            processed.append(format_code_block(code_buffer))
            code_buffer = []
        in_code_block = False

    for raw_line in lines:
        line = raw_line.strip()
        if not line:
            if in_code_block:
                flush_code_buffer()
            if processed and processed[-1] != "":
                processed.append("")
            continue

        if is_line_number_only(line):
            continue

        if "代码块" in line:
            if in_code_block:
                flush_code_buffer()
            in_code_block = True
            continue

        if in_code_block:
            if not is_code_break_line(line) and (is_code_like_line(line) or split_code_line(line)):
                code_buffer.append(line)
                continue
            flush_code_buffer()

        if split_code_line(line) and is_code_like_line(line):
                in_code_block = True
                code_buffer.append(line)
                continue

        if re.fullmatch(r"-{3,}\s*-*", line):
            continue

        processed.append(line)

    if in_code_block:
        flush_code_buffer()

    compact = []
    for line in processed:
        if line == "" and compact and compact[-1] == "":
            continue
        compact.append(line)
    return compact


def extract_images(pdf_path, images_dir, quiet=False):
    image_refs_by_page = {}
    document = fitz.open(pdf_path)
    try:
        for page_index in range(len(document)):
            page = document.load_page(page_index)
            image_refs = []
            for image_index, image_info in enumerate(page.get_images(full=True), start=1):
                xref = image_info[0]
                base_image = document.extract_image(xref)
                image_bytes = base_image["image"]
                extension = base_image.get("ext", "png")
                image_name = f"page_{page_index + 1}_img_{image_index}.{extension}"
                image_path = images_dir / image_name
                image_path.write_bytes(image_bytes)
                image_refs.append(f"![图片](images/{image_name})")
                log(f"Extracted image: {image_path}", quiet)
            image_refs_by_page[page_index + 1] = image_refs
    finally:
        document.close()
    return image_refs_by_page


def build_markdown(pdf_path, title, image_refs_by_page):
    lines = [f"# {title}", "", "来源文件: content.pdf", ""]

    pages = []
    with pdfplumber.open(str(pdf_path)) as pdf:
        for page_number, page in enumerate(pdf.pages, start=1):
            tables = extract_page_tables(page)
            text = extract_page_text(page, tables)
            text_lines = postprocess_page_markdown(text.splitlines()) if text else []
            pages.append(
                {
                    "page_number": page_number,
                    "images": image_refs_by_page.get(page_number, []),
                    "text_lines": text_lines,
                    "tables": tables,
                }
            )

    for index in range(1, len(pages)):
        previous_page = pages[index - 1]
        current_page = pages[index]
        if not previous_page["tables"] or not current_page["tables"]:
            continue
        if len([line for line in current_page["text_lines"] if line.strip()]) > 3:
            continue

        previous_rows = previous_page["tables"][-1]["rows"]
        current_rows = current_page["tables"][0]["rows"]
        if tables_are_continuation(previous_rows, current_rows):
            previous_page["tables"][-1]["rows"] = merge_table_rows(previous_rows, current_rows)
            current_page["tables"] = current_page["tables"][1:]

    for page in pages:
        has_content = bool(page["images"] or page["text_lines"] or page["tables"])
        if not has_content:
            continue

        lines.append(f"--- 第{page['page_number']}页 ---")
        lines.append("")

        for image_ref in page["images"]:
            lines.append(image_ref)
            lines.append("")

        if page["text_lines"]:
            lines.extend(page["text_lines"])
            if page["text_lines"][-1] != "":
                lines.append("")

        for table in page["tables"]:
            table_md = table_to_markdown(table["rows"])
            if table_md:
                lines.append(table_md)
                lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main():
    args = parse_args()
    source_pdf = Path(args.pdf_path).expanduser().resolve()
    if not source_pdf.exists():
        print(f"PDF file not found: {source_pdf}", file=sys.stderr)
        return 1
    if source_pdf.suffix.lower() != ".pdf":
        print(f"Expected a .pdf file, got: {source_pdf.name}", file=sys.stderr)
        return 1

    title = sanitize_title(args.title or source_pdf.stem)
    output_dir, images_dir = ensure_output_dirs(args.base_dir, title)
    output_pdf = output_dir / "content.pdf"
    output_md = output_dir / "content.md"

    log(f"Workspace root: {WORKSPACE_ROOT}", args.quiet)
    log(f"Output directory: {output_dir}", args.quiet)

    copy_pdf(source_pdf, output_pdf, args.quiet)
    image_refs_by_page = extract_images(str(source_pdf), images_dir, args.quiet)
    markdown = build_markdown(str(source_pdf), title, image_refs_by_page)
    output_md.write_text(markdown, encoding="utf-8")

    log(f"Generated markdown: {output_md}", args.quiet)
    log(f"Images directory: {images_dir}", args.quiet)
    return 0


if __name__ == "__main__":
    sys.exit(main())
