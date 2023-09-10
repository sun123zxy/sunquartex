# SunQuarTex

基于 Quarto 的自用中文学术写作模板库．

支持输出至 HTML、PDF/LaTeX、MS Word 等多种格式，覆盖交叉引用、插图绘制、定理系统等多种功能．

## Usage

请先安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)．测试 Quarto 版本为 1.3.340．

- `quarto render index-cnart.qmd --profile=cn,art,cnart`
- `quarto render index-enart.qmd --profile=en,art,enart`
- `quarto render index-cnpre.qmd --profile=cn,pre,cnpre`

请注意，`freeze` 功能可能已生效，为确保表格、图片等得到重新渲染，可能需要显式指定渲染文件 `quarto render index.qmd`．如成功运行，文件将输出至 `/output/` 文件夹下．

需要输出 PDF 时，请确保已安装 Quarto 支持的 LaTeX 发行版．若无，可使用 `quarto install tool tinytex` 安装．

可在输出 PDF 前自行对 LaTeX 文件（`*.tex`）做进一步修正，再自行使用 `tex2pdf.bat` 输出 PDF．

若文档中包含 Mermaid、Graphviz 等 diagram 且需输出 PDF，请确保已安装 Chrome 或 Chromium．若无，可使用 `quarto install tool chromium` 安装．（参见 [Quarto - Diagrams # Chrome Install](https://quarto.org/docs/authoring/diagrams.html#chrome-install)）

## Known Issues

- PDF / MS Word 中的 Graphviz 图像可能拉伸变形，设置合适的 `fig-height` 和 `fig-width` 可解决问题．其它 figure 同样可能遇到此问题．
  
  目前 PDF 格式中的问题应该已经修复．

- PDF 中的 Mermaid/Graphviz diagram 的 `figure` 环境在 LaTeX 中出现嵌套问题，导致自定义模板的元素定位出现异常．见 [Issue #3736](https://github.com/quarto-dev/quarto-cli/issues/3736)

- 同时输出 HTML 和 LaTeX 时二者的 `index_files` 会发生冲突．

- 见 [Discussion #4598](https://github.com/quarto-dev/quarto-cli/discussions/4598)，Pandoc 不支持 CSL-M 导致无有效方法处理 GB/T 7714-2015 中按语言切换“等”、`et al` 省略字样的规定．

- 表格与代码混排有时会使位置发生偏移，页面下部的代码块可能会溢出．

- 试图使用 Pandoc 的 template partial 嵌套，但路径找不到且 Quarto 没有实现指定 Pandoc `data-dir` 的功能，待填．