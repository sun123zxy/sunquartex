# SunQuarTex

使用 Quarto Markdown 语法，支持输出至 HTML、PDF/LaTeX 等多种格式的中文学术写作工具，覆盖交叉引用、插图绘制、定理系统等多种功能。

## Usage

请先安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)。

修改项目根目录下 `index.qmd` 和 `index.bib` 为你需要的内容即可。

使用命令行 `quarto render --to html` 或 `quarto render --to latex` 进行渲染，如成功运行，文件将输出至 `/output/` 文件夹下。

你可在输出 PDF 前自行对输出的 LaTeX 文件（`*.tex`）做进一步修正，而后自行使用 `tex2pdf.bat` 完成 PDF 输出。输出前请确保已安装包含 XeLaTeX 和 Biber 的 LaTeX 发行版，且 `suncnart.cls` 和欲转换的 LaTeX 文件位于合适工作目录下。

## Reference

- `index.qmd`, `index.bib`, `quarto.png`: 示例文件相关资源。
- `suncnart.cls`: 对[CTeX 宏包](https://ctan.org/pkg/ctex) 的 `ctexart` 文档类的自定义包装，符合基本的中文论文格式。
- `suntemp.tex`: Pandoc 格式的自定义 LaTeX 模板文件，用于 Quarto 的 PDF/LaTeX 输出。
- `gb-numeric.csl`: 来自[此处](https://www.zotero.org/styles/china-national-standard-gb-t-7714-2015-numeric)，用于对 HTML 输出应用 GB/T 7714-2015 数字编号引用格式。若需其他引用格式，也可在 [Zotero Style Repository](https://www.zotero.org/styles) 自行寻找 csl 文件。
- `custom.scss`: 用于 Quarto HTML 输出的自定义 SCSS 样式文件。
- `tex2pdf.bat`: 用于将 LaTeX 文件转化为 PDF 文件。
- `clear.bat`: 用于清除生成 PDF 过程中产生的中间文件。