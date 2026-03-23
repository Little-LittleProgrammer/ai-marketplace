---
name: feishu-docx
description: 下载飞书文档为 docx / pdf 格式。通过飞书 API 获取租户访问令牌、文档信息，创建导出任务并下载文件。当用户需要从飞书下载文档、导出飞书文档为 docx / pdf，或处理飞书文档相关任务时使用。
---

# 下载飞书文档为 docx / pdf 格式

> 默认导出为 pdf

## 总览

本指南介绍了使用 shell 脚本，通过飞书 API 获取租户访问令牌、文档信息，创建导出任务并下载文件。当用户需要获取飞书文档、导出飞书文档为 docx / pdf，或处理飞书文档相关任务时使用。可以让 AI 方便的获取飞书文档的全部内容，包含文字、图片、画板、表格等。

## 与 QM-AI Workflow 集成

当通过 `/qm-ai:start <飞书文档链接>` 调用时，解析后的文件将保存到需求目录：

```
context/requirement/RE-xxx-需求名称/
├── content.pdf      # PDF文件副本
├── content.md       # 提取的文字内容（Markdown格式）
└── images/          # 提取的图片目录
```

使用方式：在调用 `analyze_pdf.py` 时使用 `-b` 参数指定需求目录路径。

## 步骤

1. 获取飞书租户访问令牌，使用 `scripts/get_tenant_access_token.sh` 脚本
2. 获取文档信息，使用 `scripts/get_docx_info.sh` 脚本, 文档链接中包含 doc_token 和 doc_type
3. 创建导出任务，使用 `scripts/create_export_task.sh` 脚本
4. 轮询获取导出任务状态，使用 `scripts/get_export_task_status.sh` 脚本
5. 下载文件，使用 `scripts/download_file.sh` 脚本
6. 解析 pdf 内容（可能包含文字和图片），使用 `scripts/analyze_pdf.py` 脚本

## 参数说明

### 飞书 API 参数

| 参数 | 说明 | 来源 |
|------|------|------|
| `app_id` / `app_secret` | 飞书应用信息 | 飞书开放平台应用配置，已存在环境变量 |
| `access_token` | 租户访问令牌 | 步骤 1 获取 |
| `doc_token` | 文档 token | 飞书文档 URL 中提取 |
| `doc_type` | 文档类型（如 `docx` / `wiki`） | 文档类型 |
| `sub_id` | 文档子资源 ID | 步骤 2 返回 |
| `file_token` | 文档文件 token | 步骤 2 返回 |
| `file_extension` | 文件扩展名（如 `docx` / `pdf`），默认为 pdf | 用户指定 |
| `ticket` | 导出任务票据 | 步骤 3 返回 |
| `file_token` | 导出文件 token | 步骤 4 返回 |
| `export_file_token` | 导出文件的最终 token | 步骤 4 返回 |
| `output_path` | 下载保存路径（可选） | 用户指定 |

### analyze_pdf.py 参数

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `pdf_path` | 需要解析的 PDF 文件路径（必填） | 无 |
| `-t, --title` | 文档标题（可选，默认从PDF文件名提取） | 从文件名提取 |
| `-b, --base-dir` | 基础输出目录（QM-AI workflow 时为需求目录） | `${workspace}/specs` |
| `-q, --quiet` | 安静模式，减少输出信息 | 否 |

### 输出目录结构

解析后的文件将按照以下结构保存：

```
{base-dir}/
└── 文档标题/
    ├── content.pdf      # PDF文件副本
    ├── content.md       # 提取的文字内容（Markdown格式）
    └── images/          # 提取的图片目录
        ├── page_1_img_1.png
        ├── page_1_img_2.jpg
        └── ...
```

## 使用示例

### 完整流程

```bash
# 1. 获取租户 token
./scripts/get_tenant_access_token.sh "$FEISHU_APP_ID" "$FEISHU_APP_SECRET"

# 2. 获取文档信息
./scripts/get_docx_info.sh "$ACCESS_TOKEN" "$DOC_TOKEN" "$FILE_TYPE"

# 3. 创建导出任务（默认 pdf）
./scripts/create_export_task.sh "$ACCESS_TOKEN" "$SUB_ID" "$FILE_TOKEN" "$FILE_TYPE" "$FILE_EXTENSION"

# 4. 查询任务状态
./scripts/get_export_task_status.sh "$ACCESS_TOKEN" "$TICKET" "$FILE_TOKEN"

# 5. 下载文件
./scripts/download_file.sh "$ACCESS_TOKEN" "$EXPORT_FILE_TOKEN" "$OUTPUT_PATH"

# 6. 解析 PDF 内容
python3 ./scripts/analyze_pdf.py "$OUTPUT_PATH"
```

### QM-AI Workflow 集成示例

```bash
# 在 QM-AI workflow 中，解析到需求目录（假设 RE_NUM=001, RE_PATH=context/requirement/RE-001-用户认证系统）
python3 ./scripts/analyze_pdf.py "文档.pdf" \
    -t "需求文档" \
    -b "context/requirement/RE-001-用户认证系统"

# 输出到: context/requirement/RE-001-用户认证系统/
```

### PDF 内容解析

```bash
# 基本用法 - 解析指定 PDF 文件（自动从文件名提取标题）
# 如果文件名本身是 content.pdf，建议显式传 -t，避免输出到 specs/content/
python3 ./scripts/analyze_pdf.py "下载的文档.pdf"

# 指定文档标题（推荐）
python3 ./scripts/analyze_pdf.py "文档.pdf" -t "我的文档标题"

# 自定义基础输出目录（默认是 specs）
python3 ./scripts/analyze_pdf.py "文档.pdf" -b "output"

# 安静模式（减少输出）
python3 ./scripts/analyze_pdf.py "文档.pdf" --quiet

# 解析仓库内现有文档（推荐写法）
python3 ./scripts/analyze_pdf.py "specs/服务端/content.pdf" -t "服务端" -q
python3 ./scripts/analyze_pdf.py "specs/需求文档/content.pdf" -t "需求文档" -q

# 完整示例：指定标题和基础目录
python3 ./scripts/analyze_pdf.py "需求文档.pdf" -t "产品需求文档v1.0" -b "docs"
# 输出到: docs/产品需求文档v1.0/
```

## 注意事项

1. **API 频率限制**：飞书 API 有调用频率限制，避免短时间内大量请求
2. **文件命名**：下载文件时建议包含时间戳以避免覆盖
3. **PDF 解析**：大型 PDF 文件解析可能需要较长时间，请耐心等待
4. **图片提取**：提取的图片按页码和顺序命名（`page_N_img_M.ext`）
5. **字符编码**：提取的文字内容保存为 UTF-8 编码的 Markdown 文件
6. **输出目录结构**：所有解析结果统一保存到 `{base-dir}/文档标题/` 目录，包含：
   - `content.pdf` - PDF文件副本
   - `content.md` - 提取的文字内容
   - `images/` - 提取的图片目录
7. **文档标题处理**：如果文档标题包含特殊字符（如 `/`、`\`、`:` 等），会自动替换为下划线以确保目录名合法
8. **表格与代码块**：脚本会尽量识别代码块、普通表格和部分跨页表格，但复杂跨页表格仍可能需要人工复核
9. **quiet 模式说明**：`-q/--quiet` 只会减少脚本自身日志，`pdfplumber/pdfminer` 的底层字体告警仍可能输出到终端
10. **QM-AI Workflow 集成**：使用 `-b` 参数指定需求目录路径，确保文件保存到 `context/requirement/RE-xxx-需求名称/` 下
