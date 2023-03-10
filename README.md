# SunQuarTex

使用 Quarto Markdown 语法，支持输出至 HTML、PDF/LaTeX 等多种格式的中文学术写作工具，覆盖交叉引用、插图绘制、定理系统等多种功能。

## Usage

请先安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)。

修改项目根目录下 `index.qmd` 为你的内容即可。

使用命令行 `quarto render` 进行渲染，可添加参数 `--to=html` 或 `--to=pdf` 指定输出格式。请注意，`freeze` 功能可能已生效，为确保表格、图片等得到重新渲染，可能需要显式指定渲染文件 `quarto render index.qmd`。如成功运行，文件将输出至 `/output/` 文件夹下。

需要输出 PDF 时，请确保已安装 Quarto 支持的 LaTeX 发行版。若无，可使用 `quarto install tool tinytex` 安装。

可在输出 PDF 前自行对 LaTeX 文件（`*.tex`）做进一步修正，再自行使用 `tex2pdf.bat` 输出 PDF。

若文档中包含 Mermaid、Graphviz 等 diagram 且需输出 PDF，请确保已安装 Chrome 或 Chromium。若无，可使用 `quarto install tool chromium` 安装。（参见 [Quarto - Diagrams # Chrome Install](https://quarto.org/docs/authoring/diagrams.html#chrome-install)）

## Known Issues

- PDF 中的 Graphviz 图像可能拉伸变形，设置合适的 `fig-height` 和 `fig-width` 可解决问题。
- PDF 中的 Mermaid/Graphviz diagram 的 `figure` 环境在 LaTeX 中出现嵌套问题，导致自定义模板的元素定位出现异常。见 [Issue #3736](https://github.com/quarto-dev/quarto-cli/issues/3736)
- 同时输出 HTML 和 LaTeX 时二者的 `index_files` 会发生冲突。

## Reference

- `index.qmd`, `index.bib`, `quarto.png`: 示例文件相关资源。
- `_suncnart.cls`: 对[CTeX 宏包](https://ctan.org/pkg/ctex) 的 `ctexart` 文档类的自定义包装，符合基本的中文论文格式。
- `suntemp.tex`: Pandoc 格式的自定义 LaTeX 模板文件，用于 Quarto 的 PDF/LaTeX 输出。
- `gb-numeric.csl`: 来自[此处](https://www.zotero.org/styles/china-national-standard-gb-t-7714-2015-numeric)，用于对 HTML 输出应用 GB/T 7714-2015 数字编号引用格式。若需其他引用格式，也可在 [Zotero Style Repository](https://www.zotero.org/styles) 自行寻找 csl 文件。
- `custom.scss`: 用于 Quarto HTML 输出的自定义 SCSS 样式文件。
- `tex2pdf.bat`: 用于将 LaTeX 文件转化为 PDF 文件。
- `clear.bat`: 用于清除生成 PDF 过程中产生的中间文件。